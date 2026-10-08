import {test, expect} from "@playwright/test"



//div[@class="mid-viewport" and @role="presentation"]
test("powerbi automation", async( {page}) =>{

    page.goto("https://playground.powerbi.com/sampleReportEmbed")
const frame = page.frameLocator("iframe[src*='powerbi']");
    const category_breakdown = frame.locator("xpath=//div[@class='interactive-grid innerContainer']");

await page.waitForTimeout(20000)

   
        const first_coulm_product_values=frame.locator("//div[@class='interactive-grid innerContainer']/descendant::div[@columnlevel='0']")
        const second_column_total_catogerylist=frame.locator("(//div[@class='interactive-grid innerContainer']/descendant::div[@column-index='1'])[1]")
      
        const grid = frame.locator("//div[contains(@class,'interactive-grid')]");


       const firstColumnValues = frame.locator("//div[@column-index='0' and @role='rowheader']");
const secondColumnValues = frame.locator("//div[@column-index='1']/div[contains(@class,'pivotTableCellNoWrap')]");

const count = await firstColumnValues.count();

console.log("Number of rows:", count);

for (let i = 0; i < count; i++) {

    const firstText = await firstColumnValues.nth(i).innerText();
    const secondText = await secondColumnValues.nth(i).innerText();

    console.log(firstText + "      " + secondText);
}
     
    })
  

