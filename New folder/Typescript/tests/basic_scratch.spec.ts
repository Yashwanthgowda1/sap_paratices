import { Page , Locator, expect , test, chromium} from "@playwright/test";
import { promises } from "node:dns";
import { execPath } from "node:process";
import { text } from "node:stream/consumers";


// test("lanuch the snapdeal appliaction ", async ({page})=>{

    
//     await page.goto("https://www.snapdeal.com/")
//     const locater=page.getByText("Login")
//    expect( await locater.innerText()).toContain("Login")
// await page.locator('input#search-box-input').fill("t shirts")
// let list_values_inised=page.locator('div[class*="AutoSuggestionsEle"]')
//  console.log(await list_values_inised.nth(5).innerText())
//  let list:Array<string>=[]



// for(let i=0;i<await list_values_inised.count();i++){
// let ecah=( await list_values_inised.nth(i).innerText());
// console.log(ecah)
// list.push(ecah)
// }
// console.log(list)
// let searchTerm:string='t shirt'


// for(let i=0;i<await list_values_inised.count();i++){
//       const text = (await list_values_inised.nth(i).innerText()).trim().toLowerCase();
// if(text.includes(searchTerm.replace(' ', '').toLowerCase())){
// await list_values_inised.nth(i).click()
// break
// }
// }

// const noResults = page.locator('#searchMessageContainer').getByText(/We've got/i);
// const text = await noResults.textContent();
// console.log(text);
// const  login=page.getByText('Sign In')
// const barnloacter=page.locator("(//div[normalize-space(text()='Brand')   and @class='filter-type-name lfloat'])[6]")
// await barnloacter.scrollIntoViewIfNeeded()
// const isenabledorwhat=page.locator('[data-displayname="Brand"]')
// const atributevalues=await isenabledorwhat.getAttribute('style')
// if (!atributevalues?.includes('auto')){
//    await isenabledorwhat.click()
      
// }
// const viewall=page.locator('[data-name="Brand"]+*')
// // if(! await viewall.isVisible()){
// //     viewall.scrollIntoViewIfNeeded()
    


// // }
// // await viewall.click()
// await page.waitForTimeout(100)
// const allcheckboxs = page.locator('[data-name="Brand"] input[type="checkbox"]');
// const numberofbrands:number=await allcheckboxs.count()
// console.log("the number of the check box ----> "+ numberofbrands)
// let list_tovalidate_clicked:string[]=[]

// console.log("adding the selected optioon")
// for(let i=0;i<numberofbrands;i++){
//    const checkbox = allcheckboxs.nth(i);

//     if(!await checkbox.isChecked()){ // only if not already selected
//         await checkbox.check();
//         await expect(checkbox).toBeChecked();

//         const text = await checkbox.locator('..').innerText(); // get label text
//         list_tovalidate_clicked.push(text.trim());
//     }
// }
// await page.locator('[class="btn applyFilters lfloat"]').click()

// await barnloacter.scrollIntoViewIfNeeded()

// if (!atributevalues?.includes('auto')){
//    await isenabledorwhat.click()
      
// }
// const listvalueafterselection:string[]=[]
// const multipalselctedafter=page.locator('[data-displayname="Brand"] a[class="filter-name"]')
// for(let i=0;i<await multipalselctedafter.count();i++){
    
// listvalueafterselection.push(await multipalselctedafter.nth(i).innerText())
// }
// console.log("the slected options ---> "+ list_tovalidate_clicked)
// console.log("the brand after slection----> "+listvalueafterselection)


// })

// test("HERKUCHECKBOXS", async({page})=>{
//     page.goto("https://the-internet.herokuapp.com/checkboxes")
//     let visbleity=page.getByRole('heading', {name:"Checkboxes"})
//     await expect(visbleity).toBeVisible()
//     let checkbox=page.locator("//input[@type='checkbox']")
//     let numbers=await checkbox.count()
//     let values=1000
//     while(values>=0){
//     if(!await checkbox.nth(0).isChecked()){

//        await checkbox.nth(0).check()
//     }
//     else{
//          await checkbox.nth(0).uncheck()
//     }
//      if(await checkbox.nth(0).isChecked()){
//         await checkbox.nth(1).uncheck();
//     } else {
//         await checkbox.nth(1).check();
//     }

//     values--;
//     }



// })
// test("dynaically loading lemnst ", async({page})=>{
//     // page.goto("https://the-internet.herokuapp.com/dynamic_loading/1")
//     // await page.getByRole('button', {name:"Start"}).click()
//     // const headings=page.getByRole("heading", {name:"Hello World!"})
//     // await headings.waitFor({state:"visible"})
//     //   await expect(headings).toBeVisible();
//     // await expect(headings).toHaveText("Hello World!");
// //    page.goto("https://the-internet.herokuapp.com/javascript_alerts")
// //    page.on("dialog", async(dialog) =>{
// //      console.log("the dilog box message ",dialog.message())
// //     console.log("the ty0pe of the dilogbox things ", dialog.type())
// //         expect(dialog.type()).toBe("alert")
// //         expect(dialog.message()).toContain("I am a JS Alert")
// //         await dialog.accept()
// //    })
// //     await page.locator('//*[text()="Click for JS Alert"]').click()
// //     let texts=page.locator('#result')
// //     await expect(texts).toContainText("You successfully clicked an alert")
// //     expect(await texts.innerText()).toBe("You successfully clicked an alert")



// //     let loacterconfirm=page.locator("//*[text()='Click for JS Confirm']")
// //      page.on("dialog", async(dialog) =>{
// //      console.log("the dilog box message ",dialog.message())
// //     console.log("the ty0pe of the dilogbox things ", dialog.type())
// //         expect(dialog.type()).toBe("confirm")
// //         expect(dialog.message()).toContain("I am a JS Confirm")
// //         await dialog.dismiss()
// //    })
// //    await loacterconfirm.click()
// //    let texts_confirm=page.locator('#result')
// //    await expect(texts_confirm).toContainText("Cancel")


// // console.log("this is the promting------------------------")
// //     const loacterprompt=page.locator("//*[text()='Click for JS Prompt']")
// //    page.on("dialog", async (dialog) => {
// //     console.log("Dialog message:", dialog.message());
// //     console.log("Dialog type:", dialog.type());

// //     expect(dialog.type()).toBe("prompt");
// //     expect(dialog.message()).toContain("Click for JS Prompt");

// //     await dialog.dismiss() // <-- pass the text to prompt
// // });

// // await loacterprompt.click();

// // const loacter_prompt1 = page.locator("#result");
// // await expect(loacter_prompt1).toHaveText(/Playwright/i); // check the text is updated

// // console.log("Successfully executed");









// // farne andeling 

// })
// test("slowmonation the exicution ", async()=>{
// const browser=chromium.launch({
//     headless:false,
//     slowMo:500
//     });
//    const context= (await browser).newContext({
//        viewport:{width:1280, height:720},
//     permissions: ['geolocation', 'notifications', 'camera', 'microphone'],
//     geolocation: { latitude: 12.97, longitude: 77.59 }
//     })

//     const page=await (await context).newPage();





// page.goto("https://www.snapdeal.com/search?keyword=tshirt&santizedKeyword=t+shirts&catId=0&categoryId=0&suggested=false&vertical=p&noOfResults=20&searchState=&clickSrc=go_header&lastKeyword=&prodCatId=&changeBackToAll=false&foundInAll=false&categoryIdSearched=&cityPageUrl=&categoryUrl=&url=&utmContent=&dealDetail=&sort=rlvncy&q=Brand%3A3Mads%7C")
// let hover=page.locator('//span[text()="Sign In"]')

//     hover.hover(),
//     page.locator('//a[text()="login"]').click()


// // You know the iframe’s name attribute or URL.

// // if wanth to slect the frane by webelemnt or any index or loacter
// const farme=page.frameLocator("#loginIframe")

// console.log("switched to frame")
// let awiting=farme.locator("(//button[text()='continue'])[1]")

// await farme.getByPlaceholder("Mobile Number/ Email").fill("6363750475")
// await expect(awiting).toBeVisible()
// let doubleclick=farme.locator("#close-pop")
// doubleclick.dblclick()
// doubleclick.click({button:"right"})
// doubleclick.dragTo(page.locator(""))
// })
// //    --------------------------------------------------------------------

//      page.on("dialog", async(dialog) =>{
//      console.log("the dilog box message ",dialog.message())
//     console.log("the ty0pe of the dilogbox things ", dialog.type())
//         expect(dialog.type()).toBe("prompt")
//         expect(dialog.message()).toContain("Click for JS Prompt")
//         await dialog.accept("yashewanthhhhhh")
//         // does not show any text
//    })
//    await loacterprompt.click()
//    let loacter_prompt2=page.locator('#result')
//    await expect(loacter_prompt2).toContainText("yashewanthhhhhh")



test.only("dropdown singleelect and mutislect ", async()=>{

const browser=await chromium.launch({
    slowMo:500,
    headless:false
})

const context = await browser.newContext({
    viewport: { width: 1280, height: 720 }
});
const page1=await context.newPage();
const page2=await context.newPage();

await Promise.all([
        page1.goto("https://www.amazon.in/"),
        page2.goto("https://demo.mobiscroll.com/select/multiple-select")
    ]);

    // Define dropdown locators
    const dropdown_inPage1 = page1.locator("#searchDropdownBox");
    const dropdown_inPage2 = page2.getByPlaceholder("Please select...");

dropdown_inPage1.evaluate(((slectedopt)=>{


}))


    // Perform dropdown selections simultaneously using Promise.all
    await Promise.all([
        dropdown_inPage1.selectOption({ value: "search-alias=amazon-devices" }),
        dropdown_inPage1.selectOption({ label: "Amazon Fresh" }),
        dropdown_inPage1.selectOption({ index: 10 }),

       
    

// deslecet



})