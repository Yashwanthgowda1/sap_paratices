import { test, expect, Locator } from "@playwright/test";
import { execPath } from "node:process";




test("demo", async ({ page }) => {
  await page.goto("https://www.amazon.in/");
  let textfield:Locator=page.getByRole("searchbox", {name:"Search Amazon.in"})
  await textfield.fill("laptops")
  const string_textvalues:(string | null)=await textfield.inputValue()
  await page.waitForTimeout(1000)
  console.log(string_textvalues)
  await page.getByRole("button", {name: "Go"}).first().click()
  const  image_values:Locator=page.locator("#nav-logo-sprites")
   await expect(image_values).toBeVisible()
   const  dropdownbox:Locator=page.locator("#searchDropdownBox")
   await dropdownbox.selectOption("Alexa Skills")
   await dropdownbox.selectOption({value: "search-alias=fashion"})
   await dropdownbox.selectOption({label :"Appliances"})
   await dropdownbox.selectOption({index : 5})

   await page.waitForTimeout(100)
  
    const all_innertext :Locator= dropdownbox.locator("option")

// await expect(all_innertext).toHaveText("Amazon Fashion")

    await expect(all_innertext).toContainText("Amazon Fashion")
    await expect(all_innertext).toBeVisible()
    // const alltexts=await all_innertext.allInnerTexts()
    // extracting the elemnt
    const alltexts=await all_innertext.allTextContents()
    

  
    console.log("the all the inner text " , alltexts)

// here what happening is toconatinttext playwright think how many time nee dtoto matvh so it will fail if more matches is thetre 
// best pratice is use the varibalevalues and compre 

    expect(alltexts).toContain("Amazon Fashion")  
    
        //  it is matchinh the multipal elemnt if use to havethe text
    expect(alltexts).toContain("Audible Audiobooks")
    console.log("the total count value of the slect dropd down is the " ,await all_innertext.count())
    expect(await all_innertext.count()).toBeGreaterThan(6)
    // all_innertext.



// ifmultipaldrpddown



// page.goto("https://semantic-ui.com/modules/dropdown.html#/definition")
// page.selectOption("#idvalue",[{value: "vallu1"}, {value:"value2"}])
// page.selectOption("idvalues",[{index:1}, {index: 2}])
// page.selectOption("#idvalues",[{ label:"text1"}, {label:"text"}])



// deslecting elsmnts 

await page.locator('#fruits').evaluate((el) => {
      const select = el as HTMLSelectElement;

    //   in typescript need to htmlslectelent case and deslect singleslected elemnt
    for (const option of select.options) {
        if (option.text === 'orange') {
            option.selected = false;  // deselect only orange
        }
    }



    // print reaming lsect emelnts is
});

// const selectedTexts = await page.locator('#fruits').evaluate((el) => {
//     const select = el as HTMLSelectElement;
//     return Array.from(select.selectedOptions).map(o => o.text); // use .text here
// });

// console.log(selectedTexts); // prints the visible text of selected options

 
 
});



