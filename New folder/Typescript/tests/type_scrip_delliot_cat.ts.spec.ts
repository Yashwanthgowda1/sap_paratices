import { test, expect, Locator, Page } from "@playwright/test";
import { chromium } from "playwright";

/* ---------------- Helpers ---------------- */

async function scroll_by_elemntrefrence(page: Page, elemnt: Locator) {
  const elementHandle = await elemnt.elementHandle();
  if (!elementHandle) return;

  await page.evaluate((el) => {
    (el as HTMLElement).scrollIntoView({
      behavior: "auto",
      block: "center",
    });
  }, elementHandle);
}

/* ---------------- Snapdeal Test ---------------- */

test.describe("Snapdeal automation", () => {

  test("search and validate", async () => {

    const browser = await chromium.launch({ headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();

    await page.goto("https://www.snapdeal.com/");

    await page.locator("#search-box-input").fill("watch");

    await page.waitForTimeout(1500);

    const suggestions = page.locator("[class*=SuggestionContainer] div");

    const count = await suggestions.count();

    for (let i = 0; i < count; i++) {
      const text = await suggestions.nth(i).innerText();

      if (text.toLowerCase().includes("watch men")) {
        await suggestions.nth(i).click();
        break;
      }
    }

    const resultText = page.locator("[class*='search-result-txt-section']");

    await expect(resultText.first()).toContainText("items for");

    const brandHeader = page.locator("[data-displayname='Brand'] .filter-type-name.lfloat");

    await scroll_by_elemntrefrence(page, brandHeader);

    await expect(brandHeader.first()).toContainText("Brand");
  });

  /* ---------------- Alert Test ---------------- */

  test("handle javascript alert", async ({ page }) => {

    await page.goto("https://the-internet.herokuapp.com/javascript_alerts");

    const button = page.locator("[onclick='jsPrompt()']");
    const result = page.locator("#result");

    page.once("dialog", async (dialog) => {
      console.log("Alert type:", dialog.type());
      console.log("Message:", dialog.message());
      await dialog.accept("yashwanth");
    });

    await button.click();

    await expect(result).toContainText("yashwanth");
  });

  test.only("the mouse action handeling", async({page})=>{
    await page.goto("https://the-internet.herokuapp.com/hovers")
  
  const avatars = page.locator("[alt='User Avatar']");

  const count = await avatars.count();

  for (let i = 0; i < count; i++) {

    const element = avatars.nth(i);

    await element.hover();
    if(i===2){
      await element.click({button: "right"})
        await page.screenshot({
      path: `screens/hover_${i+1}.png`
    });
    await element.dblclick()

    }

    await page.waitForTimeout(800); // gives visible UI delay

    await page.screenshot({
      path: `screens/hover_${i}.png`
    });
  }
});


test.only("now handeling the frames things ", async ({page})=>{
  const list_of_multipalframe=page.frame({url: ""})
  list_of_multipalframe?.childFrames()
  list_of_multipalframe?.parentFrame()


  await list_of_multipalframe?.selectOption({ value: "option" });

await list_of_multipalframe?.selectOption({ label: "visible text" });



})


});