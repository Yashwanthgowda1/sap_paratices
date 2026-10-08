import { el } from "@faker-js/faker";
import {test, expect, chromium, Page} from "@playwright/test"
;


test("the ecah set size", async () =>{
const browser=await chromium.launch({
  
      headless:false,
        slowMo:500

})
   const context =await browser.newContext({
     viewport: {
        width: 1920,
        height: 1080
    },


   });
   const page:Page=await context.newPage();
  await page.goto("https://amazon.in/")     
    expect(page.title()).toBe("values")
  let webserach=  page.locator("search values")
  await webserach.fill("the values")
    await expect(webserach).toHaveValue("");

    page.on("dialog" , async (dilog) =>{
        dilog.type()
        dilog.message()
        dilog.accept()
        dilog.accept("values")
        dilog.dismiss()
        
    })

// frame   we use frame but best waue ftramelocter

const frame = page.mainFrame();

// get all child frames
let child_frames =
    frame.childFrames();

for (let each of child_frames) {

    if (each.name() === "middle") {

        // perform actions
        await each.locator("#username")
            .fill("Yash");

        await each.locator("#submit")
            .click();
    }
}

// in franmelocatre we can pass the locatre not in just frame 
let elemnt=page.locator("")

elemnt.dblclick()
elemnt.dblclick()
elemnt.hover()
elemnt.click({button: "right"})
elemnt.dragTo(dst)
await page.keyboard.press(
    "Control+A"
);
await page.mouse.move(100, 200);

// File Upload
await elemnt.setInputFiles(
    "test.pdf"
);


// taking screen shot and attching
await page.screenshot({
    path: "screenshots/test.png",
    fullPage: true
});





});
