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

        # Schläger bearbeiten: ersten Eintrag anklicken
        await page.click(".list-item")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_06_club_modal.png")
        await page.fill("#field-min", "180")
        await page.fill("#field-max", "205")
        await page.click("#btn-save-club")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_07_club_saved.png")

        # Neuen Schläger hinzufügen
        await page.click(".add-btn")
        await page.fill("#field-name", "Chipper")
        await page.fill("#field-min", "20")
        await page.fill("#field-max", "35")
        await page.click("#btn-save-club")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_08_club_added.png")

        # Scorecard
        await page.click(".screen.active [data-nav='screen-scorecard']")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_09_scorecard.png")
        score_inputs = await page.query_selector_all(".score-input")
        await score_inputs[1].fill("6")
        await score_inputs[1].dispatch_event("change")
        await page.wait_for_timeout(150)

        await page.click("#btn-back-nine")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_10_scorecard_back.png")

        # Sonstiges + Sprache
        await page.click(".screen.active [data-nav='screen-more']")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_11_more.png")

        await page.click(".lang-btn >> nth=1")  # englisch
        await page.wait_for_timeout(200)
        await page.screenshot(path="test_12_english.png")

        await page.click(".screen.active [data-nav='screen-main']")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_13_main_en.png")

        # Zurück auf deutsch wechseln für konsistenten Ausgangszustand
        await page.click(".screen.active [data-nav='screen-more']")
        await page.click(".lang-btn >> nth=0")
        await page.wait_for_timeout(150)

        # Bestehende Runden pruefen
        await page.evaluate("showScreen('screen-start')")
        await page.wait_for_timeout(100)
        await page.click("#btn-existing-rounds")
        await page.wait_for_timeout(150)
        await page.screenshot(path="test_14_rounds.png")

        print("JS ERRORS:", errors if errors else "keine")
        await browser.close()

asyncio.run(main())
