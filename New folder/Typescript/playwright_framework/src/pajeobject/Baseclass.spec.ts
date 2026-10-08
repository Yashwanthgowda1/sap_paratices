import {test, Page, Locator, expect } from "@playwright/test";
import { compose } from "node:stream";


export class Baseclass{
    readonly  page:Page;

    constructor(page:Page){
        this.page=page

    }

   async  function alert_accept(page:Page,text:String, type_action:string="accept"){
        page.on("dialog",async(dialog) =>{
            console.log("the accept dilog is stared")
            
            
            if(dialog.type()=="alert"){
                expect(dialog.message()).toContain(text)


            }
          if(type_action==="accept"){
            dialog.accept()
          }
          else if(type_action==="dismiss"){
            dialog.dismiss()
          }

        } )

    }

    async  function confirm_accept(page:Page,text:String, type_action:string="accept"){
        page.on("dialog",async(dialog) =>{
            console.log("the accept dilog is stared")
            
            
            if(dialog.type()=="confirm"){
                expect(dialog.message()).toContain(text)
            }

          if(type_action==="accept"){
            dialog.accept()
          }
          else if(type_action==="dismiss"){
            dialog.dismiss()
          }
         

        } )

     async   function prompt_accept(page:Page,text:String, type_action:string="accept"){
        page.on("dialog",async(dialog) =>{
            console.log("the accept dilog is stared")
            
            
            if(dialog.type().toLowerCase()=="prompt"){
                expect(dialog.message()).toContain(text)
            }

          if(type_action==="accept"){
            dialog.accept(text)
          }
          else if(type_action==="dismiss"){
            dialog.dismiss()
          }
       
          

        } )
    }

// ── Element Interactions 
        async function click(click:Locator): Promise<void>
 {
           await click.waitFor({state: "visible", timeout:30})
            await click.click()
            
        }
        async function get_Text(get_text:Locator) : Promise<String>
        {                   
             await get_text.waitFor({state: "visible", timeout:30})
                    return  get_text.innerText()
        }

        async function vaidate_type_dropdown(dropd_down:Locator) : Promise<boolean> {
            let mutipal=await dropd_down.evaluate((evalulate) => {
                let dropdown=evalulate as HTMLSelectElement
                return dropdown.multiple
            })
            return mutipal
        
        }

        // select_by_values_index_dropdown("locatre", [{value: "ammma", index: 1, lable:"vibletext"}])
        type SelectInput = {
            type: "value" | "label" | "index";
            data: string | number;
        };
        async function select_by_values_index_dropdown(drop_down_parent:Locator,...each_values:SelectInput[]):Promise<void>{
           let option= each_values.map(each=>{
                if(each.type==="index"){
                    // then need to pass like index:1
                    return {index: each}
                }
                  else if (each.type === "label") {
            return { label: each.data as string };
        }

        else {
            return { value: each.data as string };
        }
            })
          

/***
 * Playwright Supports
Type	Example
by value	"volvo"
by label	{ label: "Volvo" }
by index	{ index: 1 }

only tree type Supports
 * 
 */

        }
                type SingleDropDown = {
            value?: string;
            label?: string;
            index?: number;
        };

        async function slect_single_drop_down(
            drop_down_parent: Locator,
            each_values: SingleDropDown
        ): Promise<void> {

            await drop_down_parent.selectOption(each_values);
        }


        
      async function deselect_values_index_label(
    locator: Locator,
    params: SelectInput[]
): Promise<void> {

    await locator.evaluate((el, params) => {

        const select = el as HTMLSelectElement;

        for (let each of params) {

            for (let option of select.options) {

                if (each.type === "value" && option.value === each.data) {
                    option.selected = false;
                }

                else if (each.type === "label" && option.text === each.data) {
                    option.selected = false;
                }

                else if (each.type === "index" && option.index === each.data) {
                    option.selected = false;
                }
            }
        }

        select.dispatchEvent(
            new Event("change", { bubbles: true })
        );

    }, params);
}

    }

                
    


