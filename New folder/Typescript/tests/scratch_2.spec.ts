// all the basic and end to end in type script in datials 


import { faker } from "@faker-js/faker"
import {test , chromium, Page, expect} from "@playwright/test"
import { url } from "node:inspector";

test(`launch the browser `, {tag:  ['@sanity', '@regression']}, async ({ }, testinfo) => {
    const browser=await chromium.launch({slowMo:100, env:{Env: "qa"} })
    const browser2=await chromium.launch({slowMo:100, env:{Env: "qa"} });

const context = await browser.newContext({
  viewport: { width: 1280, height: 720 },

  permissions: ['geolocation', 'notifications'],

  geolocation: { latitude: 12.97, longitude: 77.59 }
});
const context1 = await browser2.newContext({
  viewport: { width: 1280, height: 720 },

  permissions: ['geolocation', 'notifications'],

  geolocation: { latitude: 12.97, longitude: 77.59 }
});

const page:Page=await context.newPage()
const page1:Page=await context.newPage()

await page.goto("https://www.snapdeal.com/")

await page.locator("#search-box-input").fill("innerwear women");
await page.locator("#search-box-input").press("Enter");

// await page.waitForSelector("div[class*='AutoSuggestionsEle']", { timeout: 5000 });

// const eachInnerTextIndex = page.locator("div[class*='AutoSuggestionsEle']");



// const count = await eachInnerTextIndex.count();


// for (let i = 0; i < count; i++) {
//     const text = await eachInnerTextIndex.nth(i).innerText();

//     if (text?.includes("women")) {
//         await eachInnerTextIndex.nth(i).click();
//         break;
//     }
// }

    let contstectxx=page.locator("[class='search-result-txt-section  marT12']")
    expect(await contstectxx.nth(1).innerText()).toContain("innerwear women")
    const all_loacter_reach_size=page.locator("//div[@class='filter-type-name lfloat']")
    
    for(let i=0;i<await all_loacter_reach_size.count();i++){
        const text = await all_loacter_reach_size.nth(i).textContent();

   if (text?.includes('Size')) {
        const elemnt=all_loacter_reach_size.nth(i)
        const visible = await all_loacter_reach_size.nth(i).isVisible();
        if(!visible){
            // scroll u to elmnet refernce
            elemnt.evaluate(el=>{
                el.scrollIntoView(true)
            })
            
        }
        const  brandloacter=page.locator("[class='filter-name-section filter-type clearfix']")
        const eaxctplusegrageting=brandloacter.nth(6).locator("[class='filter-accordian'] [class*='sd-icon sd-icon']")
        let attributevalues=await eaxctplusegrageting.getAttribute('class')
        console.log("the calss values "+ attributevalues )
        if(!attributevalues?.includes('minus')){
            console.log("the size elent is hideed ")
            await eaxctplusegrageting.click()

        }

        console.log("now comes to + icon clicnking ")
        page.waitForTimeout(1000)
        // brandloacter.nth(6).locator('button[class*="view-more"]').click()
        // await page.getByRole('button', {name:"View More "}).click()
        const numberofcheckbox=page.locator("[class*='filters-list'] label[for*='Size_s']")
        const eachcheckbox=await numberofcheckbox.count()
        for(let i=0;i<10;i++){
            await numberofcheckbox.nth(i).click()
            page.waitForTimeout(10)

        }
        const mousehove=page.locator('//*[text()="Sign In"]')
        await mousehove.hover()
        await mousehove.click({button:"right"})
        await mousehove.dblclick()
        mousehove.dragTo(mousehove)

        // slecetr frameswitch
       const frame = page.frameLocator("#iframeResult");  //or url
       page.frames()


        await frame.locator("button").click();

        // index:
        const frames = page.frames()[0];
        page.frame({ name: "authFrame" })  //or  {url : "urls"}

        const mainparemtfarme=page.mainFrame()
       let allframesinthehtml= page.mainFrame().childFrames()

       mousehove.selectOption({ value: "name1" });
       { label: "Option 1" }
       { index: 1 }
    //    if mutipal value slect measn 
    await page.locator("#dropdown").selectOption([
                                                    { value: "name1" },
                                                    { value: "name2" }
                                                    ]);



// if mutipal slect :
// slect by values
await page.locator("#fruits").selectOption(["apple", "banana"]);


       const returnchokingmultipal=await mousehove.evaluate(el =>{

       const multi=el as HTMLSelectElement;
        return multi.multiple



       })
       if(returnchokingmultipal){
        // perform multoipal or else single slect 
       }

       const returnchokingmultipal=await mousehove.evaluate(el =>{


        // deslct
       const multi=el as HTMLSelectElement;
       for (const option of multi.options) {
        if (option.text === 'orange') {
            // click that elent
        }

// chekc the ereaming
return Array.from(multi.selectedOptions).map(o => o.text);  //then print existing valies

page.on("dialog", async (dialog)=>{
    console.log(dialog.message())
    console.log(dialog.type())
      expect(dialog.type()).toBe("prompt");
       expect(dialog.type()).toBe("alert");
        expect(dialog.type()).toBe("prompt");


})




if (testinfo.expectedStatus===testinfo.status){
    console.log(`the conosl log ${testinfo.status} and the snapshotpath ${testinfo.snapshotSuffix}`)
}
}

// in playwright we use liek getwindowhandles  and window and tabs
const allPages = context.pages();  



}
);