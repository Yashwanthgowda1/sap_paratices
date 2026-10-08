import  {Page, test, expect, Locator, chromium} from  "@playwright/test"
import { text } from "node:stream/consumers";
import { promiseHooks } from "node:v8";


test("to handel the alert popus they jave multipaltypes alert , confirm by prompt", async ()=>{
 const browser = await chromium.launch({ slowMo: 500 });
  const context = await browser.newContext({

    viewport:{width:1280, height:720}


  });
  
 const page:Page=await context.newPage();

 await page.goto("https://the-internet.herokuapp.com/javascript_alerts")


 page.on("dialog", async (dialog)=>{
    console.log("the dilog box message ",dialog.message())
    console.log("the ty0pe of the dilogbox things ", dialog.type())
    expect(dialog.type()).toBe("alert") 
    expect(dialog.message()).toContain("I am a JS Alert")
    dialog.accept()
 })
  await page.getByText("Click for JS Alert").click()  

})


test("to handel the confirm or prompt", async ({page})=>{

  await page.goto("https://the-internet.herokuapp.com/javascript_alerts")
  // playwright automatically handel the thing neew to listen the dialog box and then handel it
  page.on("dialog", async (dialog)=>{
  expect(dialog.type()).toContain("confirm")
  expect(dialog.message()).toContain("I am a JS Confirm")
  await dialog.dismiss()   // or dialog.accept()  for confirm box
    
  })
  await page.getByText("Click for JS Confirm").click()
    const textvalues:Locator=page.getByText("You clicked: Cancel")
// If you want to use regex:

 await expect(textvalues).toHaveText(/You clicked/);
 const string_values:any =await textvalues.textContent()
  console.log("the text value is ", string_values)
  expect(string_values).toContain("Cancel")
        
  


  })










  
test("to by promot ", async ({page})=>{

  await page.goto("https://the-internet.herokuapp.com/javascript_alerts");

  page.on("dialog", async (dialog) =>{

    expect(dialog.type()).toBe("prompt");

  expect(dialog.message()).toContain("I am a JS prompt")
  await dialog.accept("the yashwnath")   // or dialog.accept()  for confirm bo

  })
  
  await  page.getByRole("button", { name: "Click for JS Prompt" }).click()
  
  const result = page.locator("#result");

  await expect(result).toContainText(/the yashwnath/

  );

});


// frame and types to handels

test("the frame to handel the things ", async ({page})=>{
  // await page.goto("https://the-internet.herokuapp.com/nested_frames")
  // const frames=page.frames()
  // if (frames){
  //   // const numberofframe:Locator=frame.locator("[name='frameset-middle']")
  //   console.log("the number of frame length is ", frames.length)
  // }
  // for(const frame of frames){

  //   // default consider 6 because of main frame can start the arry index from 1 and the main frame is also consider as 1 and the other 3 frames are also consider as 1 so total 6 frames are there
  //   console.log("the frame name is ", frame.name())

  // }
await page.goto("https://the-internet.herokuapp.com/nested_frames")
const mainframe=page.frame({name:"frame-top"})

console.log("the mian frma inside number chile frame presnet ", mainframe?.childFrames().length)
const childFrames =mainframe?.childFrames()
for (const frame of childFrames!) {
   console.log("enter to the  frame", frame.name())
  if(frame.name()==="frame-middle"){
    console.log("enter to the middel frame")
    const loc:Locator=frame.locator("#content")
   await expect(loc).toHaveText("MIDDLE")

  }
}
  // ther is no concept of siwtvh back just call the frame name 
const chilenode=page.frameLocator("frame-top")
// dirctely handel by attribute vaues without any confusion 


})

//  mouse action in hover and drag and drop and mouse move and mouse click
test("hove action and frag na ddrop right click and double click", async ({page})=>{

await page.goto("https://the-internet.herokuapp.com/hovers")
const avtar:Locator=page.locator(".figure")

// await avtar.all()    it will collect all the elments in the array and we can use the loop to handel each element



console.log("the number of avtar is ", await avtar.locator("[alt='User Avatar']").count(), " and " ,await avtar.all() )
const numberofhovers=avtar.locator("[alt='User Avatar']")
for(const eachavtr of await avtar.all()){
  await eachavtr.hover()
  const eachavtertext:Locator = eachavtr.locator("h5")

console.log("each text content in the hover is ", await eachavtertext.innerText())
await eachavtertext.click({button :"right"})
await page.waitForTimeout(1000)


}
})


test("the doucble click the elemnt add to cart", async ({page})=>{

await page.goto("https://demo.guru99.com/test/simple_context_menu.html")
const rightclickfield=page.locator("[class*='context-menu-one']")
await rightclickfield.click({button : "right"})


page.once("dialog", async(dialog)=>{
console.log("the dilogmessg is editoption will be ", dialog.message())
expect(dialog.type()).toBe("alert")
dialog.accept()

})
const collectallrightoptions=page.locator("[class^='context-menu-list']")
console.log("printing all the innertext contains optionn ", await collectallrightoptions.allInnerTexts())
 await collectallrightoptions.first().click()

//  handel the double click  
const doubleclick:Locator=page.getByRole("button", {name:"Double-Click Me To See Alert"})


 page.once("dialog", async (dialog) => {
    console.log("Double click alert message:", dialog.message())
    expect(dialog.type()).toBe("alert")
    await dialog.accept()
  })

  await doubleclick.dblclick() 


  // some time html is not worked for drag and drop 
// page.goto("https://the-internet.herokuapp.com/drag_and_drop")
// const scr=page.locator("#column-a")
// const dst=page.locator("#column-b")
// await page.waitForTimeout(10000)
// await scr.dragTo(dst)

})



import { dragAndDropJS } from './draganddropcustom'  // import the helper

test.only('drag column A to column B', async ({ page }) => {
  await page.goto('https://the-internet.herokuapp.com/drag_and_drop')

  await dragAndDropJS(page, '#column-a', '#column-b')  // call helper

  // Verify the swap
  const headerA = await page.locator('#column-a header').textContent()
  expect(headerA).toBe('B')
  
 
})







