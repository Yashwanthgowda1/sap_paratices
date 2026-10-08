import { test } from '@playwright/test';
import { allure } from 'allure-playwright';

test.afterEach(async ({ page }, testInfo) => {
  // Screenshot on failure
  if (testInfo.status !== testInfo.expectedStatus) {
    const screenshot = await page.screenshot({ fullPage: true });
    allure.attachment('Screenshot on failure', screenshot, 'image/png');

    // Video on failure
    const video = page.video();
    if (video) {
      const path = `videos/${testInfo.title.replace(/ /g, "_")}.webm`;
      await video.saveAs(path);
      allure.attachment('Test Video', path, 'video/webm');
    }
  }
});

test("Launch Snapdeal and search", async ({ page }) => {
  // Launch site
  await page.goto("https://www.snapdeal.com/");

  // Perform a search
  const searchBox = page.getByRole("textbox", { name: "keyword" }); // Snapdeal uses 'keyword' for the search box
  await searchBox.fill("laptop");
  await searchBox.press("Enter");

  // Wait for results
  await page.waitForSelector(".product-tuple-listing"); // example selector
});
