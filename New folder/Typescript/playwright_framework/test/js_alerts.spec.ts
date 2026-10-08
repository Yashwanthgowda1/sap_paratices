import { test, expect  } from "../src/ficture/pageficture";

const URL = "https://the-internet.herokuapp.com/javascript_alerts";

test.describe("JavaScript Alerts", () => {
/***
 * Before()
After()
BeforeStep()
AfterStep()
 * 
 */


// in cucmber we ythis

// beforstep afterstep and after before

    test.beforeEach(async ({ page }) => {
        await page.goto(URL);
    });

    test("JS Alert - accept and verify result", async ({ page, loginPage }) => {
        await loginPage.click_and_handel_js_alert("I am a JS Alert");
        await expect(page.locator("#result")).toHaveText("You successfully clicked an alert");
    });

    test("JS Confirm - accept and verify result", async ({ page, loginPage }) => {
        await loginPage.click_and_handel_js_confirm("I am a JS Confirm", "accept");
        await expect(page.locator("#result")).toHaveText("You clicked: Ok");
    });

    test("JS Confirm - dismiss and verify result", async ({ page, loginPage }) => {
        await loginPage.click_and_handel_js_confirm("I am a JS Confirm", "dismiss");
        await expect(page.locator("#result")).toHaveText("You clicked: Cancel");
    });

    test("JS Prompt - accept with text and verify result", async ({ page, loginPage }) => {
        await loginPage.click_and_handel_js_prompt("I am a JS prompt", "accept");
        await expect(page.locator("#result")).toHaveText("You entered: I am a JS prompt");
    });

    test("JS Prompt - dismiss and verify result", async ({ page, loginPage }) => {
        await loginPage.click_and_handel_js_prompt("I am a JS prompt", "dismiss");
        await expect(page.locator("#result")).toHaveText("You entered: null");
    });
    // test("Tc 08 basicfromscrathc performing " ,   tag: ["@smoke", "@regression"], async (browser) )
});
