import { test, expect, Locator , chromium} from "@playwright/test";
test.only("promis all in diffrent browsers",async () => {
    const browser1 = await chromium.launch({ headless: false });
    const browser2 = await chromium.launch({ headless: false });

    const context1 = await browser1.newContext();
    const context2 = await browser2.newContext();

    const page1 = await context1.newPage();
    const page2 = await context2.newPage();

    // Navigate both browsers simultaneously
    await Promise.all([
        page1.goto('https://www.amazon.in/'),
        page2.goto('https://www.snapdeal.com/')
    ]);

    // Perform actions simultaneously
    await Promise.all([
        page1.locator('#searchDropdownBox').selectOption({ label: 'Amazon Devices' }),
        page2.locator('#someDropdown').selectOption({ value: 'some-value' })
    ]);

    console.log("Actions done on two browsers simultaneously.");

})
