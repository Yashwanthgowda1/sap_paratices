import { Page, test, Locator, expect, Browser} from "@playwright/test";
import fs from "fs" 

import * as dotenv from "dotenv";
import { chromium } from "playwright";
import { time } from "console";
import { scroll_by_refernce_elemnt } from "./scrolling";
import { request } from "http";




// async function scroll_untilElementReference(
//   page: Page,
//   element: Locator
// ): Promise<void> {

//   const locationAndSize = await element.boundingBox();

//   if (locationAndSize) {
//     await page.evaluate(({ x, y }) => {
//       window.scrollTo(x, y);
//     }, {
//       x: locationAndSize.x,
//       y: locationAndSize.y
//     });
//   }
// }



test.describe("the all maintest case grouping ", ()=>{
test("TC01 the first test case", {tag:["@smoke", "@sanity"]}, async ({page},     testinfo)=>{
    
        //    let browser =await chromium.launch({slowMo: 100 ,headless: false})
        //    let context =await  browser.newContext({
        //     viewport:{width: 1200, height: 720},
        //     permissions:["notifications", "geolocation", "camera", "microphone"],
        //     geolocation: {latitude: 12.9, longitude: 77.6}

        //    })
        //   let page=await context.newPage();
          let driver=await page.goto("https://www.amazon.in/")
         await page.getByRole("searchbox", {name:"Search Amazon.in"}).fill("laptops")
       await page.locator("#nav-search-submit-button").click();
        const locaters=page.locator("#searchDropdownBox")
        await locaters.selectOption({label:"Amazon Fashion"})
       await page.waitForLoadState("domcontentloaded")
         await locaters.selectOption({value:"search-alias=appliances"})
        //  await locaters.selectOption([{index: 1}, {index:4}])
        //    known the which slected option
           
        // delsct the option or get what re this slected
       await locaters.evaluate((el, indexs)=>{
            const dom=el as HTMLSelectElement
          
    if (dom.multiple) {
        return
    }

            for( let i =0;i<dom.options.length;i++){
                if(indexs.optionNames.includes(dom.options[i].value)){
                    dom.options[i].selected=false
                }
                if(indexs.optionNames.includes(dom.options[i].text)){
                    dom.options[i].selected=false
                }
                
            }
            dom.dispatchEvent(new Event("change", {bubbles: true}))
         
        
            
           }, {
                 optionNames: ["Amazon Fashion", "Books"]

           }
        );
        //    sleect the frames and switch the frames
       
})

test("TC2 franehandel using frams and using frameloacter ", async({page})=>{
await page.goto("https://www.snapdeal.com/")
expect(await page.locator("[class*='HeaderLeftContent']").isVisible()).toBeTruthy()
const values_pass=page.locator("#search-box-input")
await values_pass.fill("laptops");

const list_values = page.locator(
  "div[class*='SuggestionContainer'] div[class*='AutoSuggestionsEle'] ~ *"
);

await page.waitForTimeout(1000);

const count = await list_values.count();
console.log("Suggestion count:", count);
if(count==0){
    return
}

for (let i = 0; i < count; i++) {
  const text = await list_values.nth(i).innerText();
  console.log(i, text);

  if (text.toLowerCase().includes("table")) {
    await list_values.nth(i).click();
    break;
  }
}
// console.log("the all the aiable suaggestion is "+ emptylist)
expect(page.locator("[class*='icon-search-under']").nth(0)).toBeTruthy()
const before = await page.screenshot({path:"./screenshot/before.png"});


await page.waitForTimeout();
await page.locator("[class='cartTextSpan']").isVisible()


// await expect(page.getByText("Browse Categories")).toBeVisible()
// await page.getByText("START SHOPPING NOW").click()

let after=await page.screenshot({
    path: "screenshots/after.png"
});
// expect(before).not.toEqual(after);
// await page.waitForLoadState("domcontentloaded")
let elemnt=page.locator("[class='accountInner']")
await elemnt.hover();
//* this for double clis

// elemnt.click({button:"right", clickCount:2})
// // or need to do the doubleclidk

// const box = await element.boundingBox();

// if (box) {
//     await page.mouse.move(
//         box.x + box.width / 2,
//         box.y + box.height / 2
//     );

//     await page.mouse.down();

//     await page.mouse.move(
//         box.x + 200,
//         box.y
//     );

//     await page.mouse.up();
// }
// */
await page.locator("[class='accountBtn btn rippleWhite']").click()
const frameLocator=page.frameLocator("#loginIframe")
console.log(await frameLocator.getByText("login/sign up on snapdeal").innerText())
expect(
    await frameLocator.locator("#checkUser").isVisible()
).toBeTruthy()
await frameLocator.locator("[class='sd-icon sd-icon-delete-sign fnt-22']").click()
const all_scollsides = page.locator("[class='filter-type-name lfloat']");

let locatorCollection: Locator | null = null;

for (let i = 0; i < await all_scollsides.count(); i++) {
    const text = await all_scollsides.nth(i).innerText();

    if (text.includes("Discount")) {
        locatorCollection = all_scollsides.nth(i);
        break;
    }
}
if(locatorCollection){
    await scroll_by_refernce_elemnt(locatorCollection)
    
}
const discountSelector =
  "[data-displayname='Discount %'] .filters-list.sdCheckbox";

const loader = page.locator(".filterLoader");

let each = 0;

while (each < await page.locator(discountSelector).count()) {
  await loader.waitFor({ state: "hidden", timeout: 10000 });

  const option = page.locator(discountSelector).nth(each);

  await option.scrollIntoViewIfNeeded();

  // click visible checkbox label/text area
  await option.locator("label, .filter-name, span").first().click();

  await loader.waitFor({ state: "hidden", timeout: 10000 });

  each++;
}






})

test.only("Tc3 handleing alerts and childbrowserpops ", async({page})=>{

    await page.goto("https://the-internet.herokuapp.com/checkboxes");

const checkboxes = page.locator("#checkboxes input[type='checkbox']");

for (let i = 0; i < 10; i++) {

    if (await checkboxes.nth(0).isChecked()) {
        await checkboxes.nth(0).uncheck();
        await checkboxes.nth(1).check();
    } else {
        await checkboxes.nth(0).check();
        await checkboxes.nth(1).uncheck();
    }

    console.log(
        await checkboxes.nth(0).isChecked(),
        await checkboxes.nth(1).isChecked()
    );


    }

await page.goto("https://the-internet.herokuapp.com/javascript_alerts")

page.on("dialog", (dialog)=> {
     expect(dialog.type()).toBe("alert") 
    expect(dialog.message()).toContain("I am a JS Alert")
    dialog.accept()
})
await page.locator("[onclick='jsAlert()']").click()

page.on("dialog", (dialog)=> {
     expect(dialog.type()).toBe("confirm") 
    expect(dialog.message()).toContain("I am a confim Alert")
    dialog.dismiss()
})

page.on("dialog", async (dialog) => {
    expect(dialog.type()).toBe("prompt");
    await dialog.accept("sendsome keys");
});

await page.locator("[onclick='jsPrompt()']").click();


// childbrowser by tabs

const childPages: Page[] = [];

for (let i = 0; i < 3; i++) {
  const [newPage] = await Promise.all([
    page.waitForEvent("popup"),
    page.locator(".open-tab").nth(i).click()
  ]);

  await newPage.waitForLoadState();
  childPages.push(newPage);
}

for (const child of childPages) {
  console.log(await child.title());
}

})

test.only("the api related all cure operation and file uplad ", async({})=>{
        request
})





});


