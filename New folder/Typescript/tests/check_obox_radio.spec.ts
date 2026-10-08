import {test, Page, Locator, expect } from "@playwright/test";
import { exitCode } from "node:process";

test("radiobutton and check box", async ({page})=>{
    await page.goto("https://the-internet.herokuapp.com/checkboxes")
    await expect(page).toHaveURL("https://the-internet.herokuapp.com/checkboxes")
    const titlevalue:string= await page.title()
    console.log(titlevalue)
    console.log(page.url())
    await expect(page).toHaveTitle("The Internet")
    const heading:Locator=page.getByRole("heading", {name:"Checkboxes"})
    await expect(heading).toBeVisible()
    await expect(heading).toHaveText("Checkboxes")
    const multipalselectoption:Locator =page.locator("[id='checkboxes'] input")
    for(let i=0 ;i<3;i++){
        if(await multipalselectoption.nth(0).isChecked()){
            await multipalselectoption.nth(0).uncheck()

        }
        else{
             await multipalselectoption.nth(0).check()

        }
        if(await multipalselectoption.nth(1).isChecked()){
            await multipalselectoption.nth(1).uncheck()
        }
        else{
                 await multipalselectoption.nth(1).check()

        }


    }

    await expect(multipalselectoption.first()).toBeChecked()




    
})


