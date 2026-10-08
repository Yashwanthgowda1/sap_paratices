import { el } from "@faker-js/faker/.";
import { test, expect, chromium, request } from "@playwright/test"
import { json } from "zod";

import fs from "fs"



test("scratich the test from fisrt", async()=>{
   let browser= await chromium.launch({slowMo:500});
   let context=await browser.newContext();
   let page=await context.newPage();
   await page.goto("https://selectorshub.com/xpath-practice-page/")
    let titles=await page.title()
    expect(titles).toContain("Xpath Practice Page")
   let actulahover=page.locator("//span[normalize-space()='Products']")
//    do the mouse over
    await actulahover.hover();
   let val= page.locator("[data-id='e28c8e2']")
await expect(val).toBeVisible();
 const apiContext = await request.newContext(); 
    const lsitof_allocaters=val.locator("a")
    let total=await lsitof_allocaters.count();
    // for(let i=0;i<total;i++){
    //     let each_lins_browkenor_not = await lsitof_allocaters.nth(i).getAttribute("href");
    //     if (each_lins_browkenor_not) {
    //         const response = await apiContext.get(`https://selectorshub.com/${each_lins_browkenor_not}`);
    //         expect(response.status()).toBeLessThan(400);
    //     }
    // }
    // after remove the mouse move some where
    await page.mouse.move(100,10);






//         await lsitof_allocaters.dblclick();
//        await lsitof_allocaters.click({button:"right"})
//         page.dragAndDrop("src", "dst");
//     //   unlike java moveoffest here we need to do
//     const el = page.locator("#drag-element");

// // get element position first
// const box = await el.boundingBox();  // gives x, y, width, height

// if (box) {
//     // start from center of element
//     await page.mouse.move(box.x + box.width/2, box.y + box.height/2);
//     await page.mouse.down();
    
//     // move by offset (200px right, 100px down)
//     await page.mouse.move(box.x + box.width/2 + 200, box.y + box.height/2 + 100);
//     await page.mouse.up();
// }

    
//     }



// scroll elemnt visble using java script
let loactions=page.locator("[data-id='29a5307']")
const box = await loactions.boundingBox();
if(box){
await page.evaluate(({x, y})=>{
        window.scrollBy(x, y);



}, {
    x:box.x,
    y:box.y
}
)
};

let valq=page.locator("//table[@id='resultTable']")
if(await valq.isVisible()){
let ischekedval=valq.locator("thead tr th.checkbox-col input[type='checkbox']")
    if(!(await ischekedval.isChecked())){
       await ischekedval.check();

    }
   let all=page.locator("//tbody/tr/td/input[contains( @id,'ohrmList')]")
  let to= await all.count();
  for(let i=0;i<to;i++){
        await expect(all.nth(i)).toBeChecked();
  }

}

let timedat=page.locator("[type='date']");

const box1 = await timedat.boundingBox();
if(box1){
await page.evaluate(({x, y})=>{
        window.scrollBy(x, y);



}, {
    x:box.x,
    y:box.y
}
)
};





// iside the pixel sxroll

// alert and confimr same
    page.on("dialog", async (dialog) => {
    console.log(dialog.type());      // "alert"
    console.log(dialog.message());   // alert text
    await dialog.accept();           // click OK
});

await page.click("#trigger-alert");


// input one
page.on("dialog", async (dialog) => {
    console.log(dialog.type());           // "prompt"
    console.log(dialog.defaultValue());   // default text in input

    await dialog.accept("my typed text"); // type value and click OK
    // or
    await dialog.dismiss();               // click Cancel
});



// new winodw open
const [popup] = await Promise.all([
    page.waitForEvent("popup"),
    page.click("#open-window")
]);
await popup.waitForLoadState();
// oe 
// domcontentloaded
console.log(await popup.title());

// file upload
const [fileChooser] = await Promise.all([
    page.waitForEvent("filechooser"),
    page.click("#upload-btn")
]);

await fileChooser.setFiles("C:/path/to/file.pdf");
//    download
const [download] = await Promise.all([
    page.waitForEvent("download"),
    page.click("#download-btn")
]);

const path = await download.path();

// const allOptions = await dropdown.locator("option").allTextContents();  equla to getoptin in java

// drop down 



const data =JSON.parse(fs.readFileSync("filepathofthe.json", "utf-8"));
data.get("name")


const csv: string = fs.readFileSync("tests/config.csv", "utf-8");
console.log(csv[1]);
}
)

