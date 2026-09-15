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

        # Neue Runde
        await page.click("#btn-new-round")
        await page.wait_for_timeout(200)
        await page.screenshot(path="test_02_main.png")

        # Loch 5 auswählen
        await page.click(".hole-btn >> text='5'")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_03_hole5.png")

        # Loch 11 (hintere Neun, Taste '2' im rechten Kreis) auswählen
        back_buttons = await page.query_selector_all("#col-back .hole-btn")
        await back_buttons[1].click()
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_04_hole11.png")

        # Schläger-Screen
        await page.click(".screen.active [data-nav='screen-clubs']")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_05_clubs.png")

        # Schläger auswählen (nur visuell, kein Modal)
        await page.click(".list-item")
        await page.wait_for_timeout(150)
        selected = await page.query_selector(".list-item.selected")
        assert selected is not None, "Schläger wurde nicht als ausgewählt markiert"
        await page.screenshot(path="test_06_club_selected.png")

        # Bearbeiten-Modus starten
        await page.click("#btn-edit-clubs")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_07_clubs_edit_mode.png")

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
        await page.screenshot(path="test_08_clubs_edit_filled.png")

        # Einen Schläger entfernen (letzten Eintrag, den Putter, NICHT entfernen -> zweiten Eintrag entfernen)
        await page.click(".club-edit-row >> nth=1 >> .btn-remove-row")
        await page.wait_for_timeout(100)

        # Speichern
        await page.click("#btn-save-clubs-edit")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_09_clubs_saved.png")

        # Abbrechen-Pfad kurz prüfen: erneut in Bearbeitungsmodus, Änderung machen, abbrechen
        await page.click("#btn-edit-clubs")
        await page.wait_for_timeout(100)
        await page.fill(".club-edit-row >> nth=0 >> .edit-name", "SOLLTE NICHT GESPEICHERT WERDEN")
        await page.click("#btn-cancel-clubs-edit")
        await page.wait_for_timeout(100)
        first_name = await page.text_content(".list-item .name")
        assert "SOLLTE NICHT" not in (first_name or ""), "Abbrechen hat Änderung trotzdem gespeichert"

        # Scorecard
        await page.click(".screen.active [data-nav='screen-scorecard']")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_10_scorecard.png")
        score_inputs = await page.query_selector_all(".score-input")
        await score_inputs[1].fill("6")
        await score_inputs[1].dispatch_event("change")
        await page.wait_for_timeout(150)

        await page.click("#btn-back-nine")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_11_scorecard_back.png")

        # Sonstiges + Sprache
        await page.click(".screen.active [data-nav='screen-more']")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_12_more.png")

        await page.click(".lang-btn >> nth=1")  # englisch
        await page.wait_for_timeout(200)
        await page.screenshot(path="test_13_english.png")

        await page.click(".screen.active [data-nav='screen-main']")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_14_main_en.png")

        # Zurück auf deutsch wechseln für konsistenten Ausgangszustand
        await page.click(".screen.active [data-nav='screen-more']")
        await page.click(".lang-btn >> nth=0")
        await page.wait_for_timeout(150)

        # Bestehende Runden pruefen
        await page.evaluate("showScreen('screen-start')")
        await page.wait_for_timeout(100)
        await page.click("#btn-existing-rounds")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_15_rounds.png")

        print("JS ERRORS:", errors if errors else "keine")
        await browser.close()

asyncio.run(main())
