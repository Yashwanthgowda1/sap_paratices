import { Page, test ,expect, Locator, FrameLocator } from "@playwright/test";
import { error } from "node:console";
import { scrollByhardcode } from "../typescripts/scrollablemetjods";
import { allowedNodeEnvironmentFlags } from "node:process";


test ("the table fixed values" , async ({page})=>{
    await page.goto("https://www.w3schools.com/css/tryit.asp?filename=trycss_table_fancy")
    //    const frame = page.frame({name :"iframeResult"})

    //    if(!frame){
    //     throw new Error ("not frame have")
        
    //    }


    const frame:FrameLocator =page.frameLocator("#iframeResult")     //id or url can also use 
    const values:Locator=frame.locator("table tbody tr")
    console.log(await values.allTextContents())
    console.log(await values.allInnerTexts())
    const all_tables:Locator=values.locator("th:first-child")
   const all_tables1:Locator=values.locator("th:nth-child(2)")
console.log(await all_tables.textContent())
console.log(await all_tables1.innerText())

// get all the first row deatils from the table
 const all_tbale_row_values:Locator=frame.locator("table tbody tr:nth-child(n+2) td:nth-child(3)")  //or table tbody tr td:first-child
    console.log(await all_tbale_row_values.allInnerTexts())
        const returnvalue:string[] =await all_tbale_row_values.allTextContents()
        console.log("the 6thindex value is " ,returnvalue[6])


//  take the sibbling values of each first rows      
const all_siblings_nextcoloumn_row_values:string[]=await frame.locator("table tbody tr:nth-child(n+2) td:nth-child(1)~*").allTextContents()
// table tbody tr:nth-child(n+2) td:nth-child(1)+*   ---> immediate next sibling 
console.log(all_siblings_nextcoloumn_row_values)





})

test.only("dynamic table and pagination re;ated table handeling"  , async ({page})=>{
    await page.goto("https://datatables.net/examples/data_sources/ajax.html")
await scrollByhardcode(page, 100, 800)
await page.waitForTimeout(1000)
// await page.selectOption('#dt-length-0', "25")

// or
const otherwayslectdropdown:Locator= page.locator("#dt-length-0")
await otherwayslectdropdown.selectOption({value:"10"})
if(await otherwayslectdropdown.inputValue()=='10'){
    console.log("teh 10 option is slected ")
}
// lasttag of > chekc it is diabled
const isenabled:Locator=page.locator("[aria-label='pagination'] button:nth-child(9)")




const allthetext: string[] = [];

while (!((await isenabled.getAttribute("class"))?.includes("disabled"))) {
    const rows = page.locator("tbody tr");
    const rowCount = await rows.count();

    for (let i = 0; i < rowCount; i++) {
        const cellsText:string[] = await rows.nth(i).locator("td:first-child").allTextContents();
        allthetext.push(...cellsText);
    }

    await isenabled.click();
    await page.waitForTimeout(10);
}

// filter only non-numeric values
const namesOnly = allthetext.filter(value => isNaN(Number(value)));
namesOnly.forEach(v => console.log(v));

})