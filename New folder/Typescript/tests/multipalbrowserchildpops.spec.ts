import { Page, test, Locator, chromium} from "@playwright/test"
import { scrollbypixel } from "../typescripts/scrollablemetjods"
import { waitForDebugger } from "node:inspector"

test("to handel the multiple browser child popups", async ()=>{
const browser=await chromium.launch(
    {
        headless:false,
        slowMo:500

    }
)
const context=await browser.newContext({
    viewport:{width:1280, height:720},
    permissions: ['geolocation', 'notifications', 'camera', 'microphone'],
    geolocation: { latitude: 12.97, longitude: 77.59 }
})

const page:Page= await context.newPage()
await page.goto("https://amazon.in/")

await page.getByPlaceholder("Search Amazon.in").fill("laptops")
  const parentPageLocator = page.locator('input#nav-search-submit-button')
  const parentPageURL = page.url()

  await parentPageLocator.click()
  await page.waitForTimeout(2000) 

const [values_child]=await Promise.all([
    page.waitForEvent("popup"),  // new tabor window openpop is apper in buit mtehod it is popup
  page.locator("[target='_blank']").first().click()

])
await values_child.waitForLoadState()
console.log("the child page url is ", values_child.url())
if (parentPageURL!== values_child.url())
{
    console.log("the parent and child page urls are different")
}
else{
    console.log("the parent and child page urls are same")
}
await values_child.close()




}
)

// drag and drop a
//  scroll by pixel
//  child browser pops

test.only("keyboard cation realted to the elemnt", async ({page})=>{
await page.goto("https://vercel.com/login?next=%2Fyashwanths-projects-7a956bf7")

await page.waitForLoadState()
 const emailInput = page.getByPlaceholder("Email Address")
    await emailInput.focus();   
await page.keyboard.insertText("yashwanthmhg@gmail.com")
await page.waitForTimeout(1000)
await page.keyboard.press("Tab")
await page.keyboard.press("Enter")
await page.waitForLoadState()



})


test("multipal window pops 5+"){
    const [childPage] = await Promise.all([
  context.waitForEvent('page'),
  page.click('#openPopup')
]);

await childPage.waitForLoadState();

// switch focus to child

// inbuit kwyword buildTofront
await childPage.bringToFront();

console.log(await childPage.title());

// go back to parent
await page.bringToFront();

}

// drag and drop

const source = page.locator('#source');
const target = page.locator('#target');

const sourceBox = await source.boundingBox();
const targetBox = await target.boundingBox();

if (sourceBox && targetBox) {

  await page.mouse.move(sourceBox.x + sourceBox.width / 2, sourceBox.y + sourceBox.height / 2);

  await page.mouse.down();

  await page.mouse.move(targetBox.x + targetBox.width / 2, targetBox.y + targetBox.height / 2);

  await page.mouse.up();
}
