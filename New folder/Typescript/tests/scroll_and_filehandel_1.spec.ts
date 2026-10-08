import { ElementHandle, Page , test, chromium, Locator} from "@playwright/test";
import { log } from "node:console";


async function scrollHardcode(page: Page, x: number, y: number) {
  await page.evaluate(([sx, sy]) => {
    window.scrollBy(sx, sy);
  }, [x, y]);
}

async function scroll_untillelmntrefernce(page:Page, element:Locator): Promise<void>{
// inbuit
    const location_andsize=await element.boundingBox()
    if(location_andsize){
page.evaluate(({x,y})=>{
    window.scrollTo(x,y)
}, element.elementHandle())
}
    }



// loactreis taken 
    export async function scroll_untilElementReference(
  page: Page,
  element: Locator
): Promise<void> {

  const locationAndSize = await element.boundingBox();

  if (locationAndSize) {
    await page.evaluate(({ x, y }) => {
      window.scrollTo(x, y);
    }, {
      x: locationAndSize.x,
      y: locationAndSize.y
    });
  }
}

// scroll inide th tales   


async function scroll_table_inside(page:Page, elemnt:ElementHandle<Element>): Promise<void>{
  await  page.evaluate((el)=>{
       el.scrollTop = el.scrollHeight;
    }, elemnt)

}

async function scroll_table_inside1(
    page: Page,
    elemnt: Locator
): Promise<void> {

    const elementHandle =
        await elemnt.elementHandle();

    await page.evaluate((el1) => {

        el1.scrollTop = el1.scrollHeight;

    }, elementHandle);
}


// scrollby pixesl  no need the this beacuse lemnt is aredy evaluated and async function
async function scroll_table_inside_pixel(page:Page, elemnt:ElementHandle<Element>){
    await page.evaluate((el)=>{
       el.scrollTop +200;
    },
 elemnt)
}


async function  scroll_full_bottom(page:Page){
     await page.evaluate(()=>{
        window.scrollBy(0, document.body.scrollHeight)

})
}


test("running the table in all conditions", async()=>{
    const browser=await chromium.launch({
        slowMo:200,
        headless: false
    })
const context=await  browser.newContext({
    viewport:{width:1280, height:720},
    permissions: ['geolocation', 'notifications', 'camera', 'microphone'],
    geolocation: { latitude: 12.97, longitude: 77.59 }
})

const page=await  context.newPage();

 await   page.goto("https://datatables.net/examples/data_sources/ajax.html")

await scrollHardcode(page, 0,800)
await page.waitForTimeout(1000)
const values=page.locator("#dt-length-0")
await values.selectOption({"label" : "100"})
await page.waitForTimeout(1000)
await values.selectOption({"index" : 2})
await values.selectOption({"value" : "25"})
const visblerefs=page.locator("#example_info")
await scroll_untillelmntrefernce(page, visblerefs)

const header=page.locator("[id='example']")
let all_innetrvalues=await header.locator("thead [class='dt-column-header']").allInnerTexts()
const data_body=header.locator("tbody tr")


const loacterpagination=page.locator("[data-dt-idx='next']")
const values1: string[] = [];
while(true){
    let firstrow=await data_body.locator("td:nth-child(1)").allInnerTexts()
    // push all the values to the list
    firstrow.forEach(el=>values1.push(el))
    console.log(values1)
const className = await loacterpagination.getAttribute("class")
     if (className?.includes("disabled")) {
    break;   // stop loop on last page
  }
    await loacterpagination.click()

}
console.log(values1.length)

});

test("upload file", async ({ page }) => {

  await page.goto("https://blueimp.github.io/jQuery-File-Upload/")

  await page.locator("[name='files[]']")
    .setInputFiles("C:\\Users\\C5403671\\Downloads\\SCTASK2939104.txt")

//   await page.locator("#file-submit").click()

})


// if the file uplaod is submit the use the file choices not setinputfile
test("upload file using dialog", async ({ page }) => {

  await page.goto("https://example.com");

  const fileChooserPromise =page.waitForEvent('filechooser');

  await page.click("#uploadBtn");

  const fileChooser = await fileChooserPromise;

  await fileChooser.setFiles("C:\\Users\\C5403671\\Downloads\\SCTASK2939104.txt");

});


// eplict wait for elmnt load
     // await page.getByRole('button', {name:"Start"}).click()
//     // const headings=page.getByRole("heading", {name:"Hello World!"})
//     // await headings.waitFor({state:"visible"})


test.only("dowload the file", async({page})=>{
   await page.goto("https://file-examples.com/index.php/sample-documents-download/sample-pdf-download/")

   const [download] = await Promise.all([
  page.waitForEvent('download'),
  page.getByText('Download sample pdf file').nth(1).click()
]);

        const path = `downloads/${download.suggestedFilename()}`;

        await download.saveAs(path);

        console.log("Downloaded:", path);
        })


        
// directry not exist

        import fs from "fs";

if (!fs.existsSync("downloads")) {
  fs.mkdirSync("downloads");
}

