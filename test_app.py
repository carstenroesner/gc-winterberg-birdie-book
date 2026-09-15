import asyncio
from playwright.async_api import async_playwright

BASE = "http://127.0.0.1:8811/index.html"

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch(executable_path="/opt/pw-browsers/chromium")
        page = await browser.new_page(viewport={"width": 390, "height": 844}, device_scale_factor=2)
        errors = []
        page.on("pageerror", lambda e: errors.append(str(e)))
        page.on("console", lambda m: errors.append(f"console.{m.type}: {m.text}") if m.type == "error" else None)

        await page.goto(BASE)
        await page.wait_for_timeout(400)
        await page.screenshot(path="test_01_start.png")
        start_lang_row = await page.query_selector("#screen-start .start-lang-row #lang-row, #screen-start #lang-row")
        assert start_lang_row is not None, "Sprachauswahl fehlt auf der Startseite"
        start_lang_btns = await page.query_selector_all("#screen-start #lang-row .lang-btn")
        assert len(start_lang_btns) == 3, "Sprachauswahl auf der Startseite zeigt nicht alle drei Sprachen"

        # Neue Runde -> landet auf Rundeneinstellungen (Pager-Seite 0)
        await page.click("#btn-new-round")
        await page.wait_for_timeout(300)
        await page.screenshot(path="test_02_settings.png")
        settings_visible = await page.query_selector(".settings-page h2")
        assert settings_visible is not None, "Rundeneinstellungen-Seite wurde nicht angezeigt"

        # Auf 9-Loch-Runde umschalten -> rechte Spalte muss verschwinden
        await page.click(".round-type-btn[data-hc='9']")
        await page.wait_for_timeout(250)
        await page.screenshot(path="test_03_nine_hole.png")
        back_col_hidden = await page.eval_on_selector("#col-back", "el => el.classList.contains('hidden-col')")
        assert back_col_hidden, "Hintere Spalte wurde im 9-Loch-Modus nicht ausgeblendet"

        # Zurück auf 18-Loch-Runde
        await page.click(".round-type-btn[data-hc='18']")
        await page.wait_for_timeout(250)
        back_col_hidden_2 = await page.eval_on_selector("#col-back", "el => el.classList.contains('hidden-col')")
        assert not back_col_hidden_2, "Hintere Spalte blieb im 18-Loch-Modus ausgeblendet"
        await page.screenshot(path="test_04_eighteen_hole.png")

        # Einstellungen-Reiter (Position 1 in der linken Spalte, über Loch 1) pruefen
        settings_tab_active = await page.eval_on_selector(
            "#col-front .hole-list-item[data-page='0']", "el => el.classList.contains('active')"
        )
        assert settings_tab_active, "Einstellungen-Reiter wurde nicht als aktiv markiert"

        # Loch 5 über die vordere Liste auswählen (Reiter-Direktsprung; Reiter 1 ist Einstellungen, daher +1)
        await page.click("#col-front .hole-list-item:nth-child(6)")
        await page.wait_for_timeout(400)
        await page.screenshot(path="test_05_hole5.png")
        hole5_active = await page.eval_on_selector(
            "#col-front .hole-list-item[data-page='5']", "el => el.classList.contains('active')"
        )
        assert hole5_active, "Loch 5 wurde in der Liste nicht als aktiv markiert"

        # Loch 11 über die hintere Liste auswählen (zweiter Eintrag: 10, 11, ...)
        await page.click("#col-back .hole-list-item:nth-child(2)")
        await page.wait_for_timeout(400)
        await page.screenshot(path="test_06_hole11.png")

        # Wisch-Navigation simulieren: horizontal weiterscrollen (eine Loch-Breite)
        pager_width = await page.eval_on_selector("#pager", "el => el.clientWidth")
        await page.eval_on_selector("#pager", f"el => el.scrollBy({{left: {pager_width}, behavior: 'auto'}})")
        await page.wait_for_timeout(300)
        await page.screenshot(path="test_07_swipe_next.png")

        # Schläger jetzt über Kopfzeilen-Menü (Drei-Punkte) -> Sonstiges -> Schläger erreichbar (kein Fußmenü mehr)
        await page.click(".screen.active [data-nav='screen-more']")
        await page.wait_for_timeout(150)
        await page.click(".screen.active [data-nav='screen-clubs']")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_08_clubs.png")
        clubs_back_btn = await page.query_selector("#screen-clubs [data-back='screen-main']")
        assert clubs_back_btn is not None, "Zurück-Button auf dem Schläger-Bildschirm fehlt"

        # Schläger auswählen (nur visuell, kein Modal)
        await page.click(".list-item")
        await page.wait_for_timeout(150)
        selected = await page.query_selector(".list-item.selected")
        assert selected is not None, "Schläger wurde nicht als ausgewählt markiert"
        await page.screenshot(path="test_09_club_selected.png")

        # Bearbeiten-Modus starten
        await page.click("#btn-edit-clubs")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_10_clubs_edit_mode.png")

        # Ersten Schläger bearbeiten (Distanz ändern)
        await page.fill(".club-edit-row >> nth=0 >> .edit-min", "180")
        await page.fill(".club-edit-row >> nth=0 >> .edit-max", "205")

        # Neuen Schläger hinzufügen
        await page.click("#clubs-list .add-btn")
        await page.wait_for_timeout(100)
        new_rows = await page.query_selector_all(".club-edit-row .edit-name")
        await new_rows[-1].fill("Chipper")
        last_row_idx = len(new_rows) - 1
        await page.fill(f".club-edit-row >> nth={last_row_idx} >> .edit-min", "20")
        await page.fill(f".club-edit-row >> nth={last_row_idx} >> .edit-max", "35")
        await page.screenshot(path="test_11_clubs_edit_filled.png")

        # Einen Schläger entfernen (zweiten Eintrag)
        await page.click(".club-edit-row >> nth=1 >> .btn-remove-row")
        await page.wait_for_timeout(100)

        # Speichern
        await page.click("#btn-save-clubs-edit")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_12_clubs_saved.png")

        # Abbrechen-Pfad kurz prüfen
        await page.click("#btn-edit-clubs")
        await page.wait_for_timeout(100)
        await page.fill(".club-edit-row >> nth=0 >> .edit-name", "SOLLTE NICHT GESPEICHERT WERDEN")
        await page.click("#btn-cancel-clubs-edit")
        await page.wait_for_timeout(100)
        first_name = await page.text_content(".list-item .name")
        assert "SOLLTE NICHT" not in (first_name or ""), "Abbrechen hat Änderung trotzdem gespeichert"

        # Zurück zum Hauptbildschirm, dann Scorecard-Reiter (letzter Reiter der rechten Spalte bei 18-Loch-Runde)
        await page.click("#screen-clubs [data-back='screen-main']")
        await page.wait_for_timeout(200)
        await page.click("#col-back .hole-list-item:last-child")
        await page.wait_for_timeout(400)
        await page.screenshot(path="test_13_scorecard.png")
        score_inputs = await page.query_selector_all(".score-input")
        assert len(score_inputs) > 0, "Scorecard-Seite wurde nicht gerendert"
        await score_inputs[1].fill("6")
        await score_inputs[1].dispatch_event("change")
        await page.wait_for_timeout(150)

        back_nine_btn = await page.query_selector("#pager-nine-toggle button[data-nine='back']")
        assert back_nine_btn is not None, "Vorne/Hinten-Umschalter fehlt auf der Scorecard-Seite (18-Loch-Runde)"
        await back_nine_btn.click()
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_14_scorecard_back.png")

        # Einstellungen-Reiter -> zurück zur ersten Pager-Seite
        await page.click("#col-front .hole-list-item[data-page='0']")
        await page.wait_for_timeout(400)
        await page.screenshot(path="test_15_back_to_hole1.png")

        # Sonstiges (ohne Sprachauswahl, die jetzt auf der Startseite liegt)
        await page.click(".screen.active [data-nav='screen-more']")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_16_more.png")
        more_lang_row = await page.query_selector("#screen-more #lang-row")
        assert more_lang_row is None, "Sprachauswahl ist noch auf der Sonstiges-Seite vorhanden"
        await page.click(".screen.active [data-back='screen-main']")
        await page.wait_for_timeout(150)

        # Sprache jetzt über die Startseite wechseln
        await page.evaluate("showScreen('screen-start')")
        await page.wait_for_timeout(150)
        await page.click("#screen-start .lang-btn >> nth=1")  # englisch
        await page.wait_for_timeout(250)
        await page.screenshot(path="test_17_english.png")

        # Zurück auf deutsch wechseln für konsistenten Ausgangszustand
        await page.click("#screen-start .lang-btn >> nth=0")
        await page.wait_for_timeout(150)

        # Kontakt: Problem melden -> Dialog öffnen, ausfüllen, abbrechen
        await page.evaluate("showScreen('screen-main')")
        await page.wait_for_timeout(100)
        await page.click(".screen.active [data-nav='screen-more']")
        await page.wait_for_timeout(150)
        await page.click(".screen.active [data-nav='screen-contact']")
        await page.wait_for_timeout(150)
        await page.click("#btn-open-report")
        await page.wait_for_timeout(150)
        modal_open = await page.eval_on_selector("#report-modal", "el => el.classList.contains('open')")
        assert modal_open, "Problem-melden-Dialog hat sich nicht geöffnet"
        await page.screenshot(path="test_18_report_modal.png")
        await page.click("#btn-cancel-report")
        await page.wait_for_timeout(150)
        modal_closed = await page.eval_on_selector("#report-modal", "el => !el.classList.contains('open')")
        assert modal_closed, "Problem-melden-Dialog hat sich nach Abbrechen nicht geschlossen"

        # Erneut öffnen, ausfüllen und tatsächlich absenden -> prüft die GitHub-Issue-URL (kein Token!)
        await page.click("#btn-open-report")
        await page.wait_for_timeout(150)
        await page.click("#btn-report-idea")
        await page.fill("#report-title", "Testvorschlag aus dem Smoke-Test")
        await page.fill("#report-desc", "Automatisierte Prüfung der Issue-URL-Konstruktion.")
        async with page.expect_popup() as popup_info:
            await page.click("#btn-submit-report")
        popup = await popup_info.value
        await popup.wait_for_load_state("domcontentloaded", timeout=15000)
        popup_url = popup.url
        assert "github.com/carstenroesner/gc-winterberg-birdie-book/issues/new" in popup_url, f"Unerwartete Issue-URL: {popup_url}"
        assert "title=" in popup_url and "labels=enhancement" in popup_url, f"Issue-URL unvollständig: {popup_url}"
        assert "ghp_" not in popup_url and "token" not in popup_url.lower(), "Token-Leck in der Issue-URL!"
        await popup.close()

        # Bestehende Runden pruefen
        await page.evaluate("showScreen('screen-start')")
        await page.wait_for_timeout(100)
        await page.click("#btn-existing-rounds")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_19_rounds.png")

        print("JS ERRORS:", errors if errors else "keine")
        await browser.close()

asyncio.run(main())
