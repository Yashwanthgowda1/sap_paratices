import { Page , Locator} from "@playwright/test"
export async function scrollbyhardcodevalue(page:Page, x:number , y: number){
    page.evaluate(([x, y])=>{
        window.scrollBy(x,y);
    }, [x, y])
}
export async function scrollbyhardcodevalue_end(page:Page){
    page.evaluate((el)=>{
        window.scrollBy(0, document.body.scrollHeight)
    })
}
    

export async function scroll_by_refernce_elemnt(elemnt:Locator) {
        await elemnt.evaluate((el) => {
        el.scrollIntoView(true);
        
    })}

export async  function croll_location_ofelemnt(page:Page, element:Locator){
   let element_in_dom= await element.boundingBox()
   if(element_in_dom){
  await page.evaluate(({x, y})=>{
    window.scrollBy(x, y)
   },{
        x: element_in_dom.x,
            y: element_in_dom.y
   })}
}    


export async function scrollInsideTable(element: Locator, pixel: number ): Promise<void> {

    await element.evaluate((el, pixel) => {
        el.scrollTop += pixel;
    }, pixel);

}

export async function scroll_inside_elemnt_appera(targetElement:Locator) {
    while (!(await targetElement.isVisible())) {
    await scrollInsideTable(targetElement, 100);
}
    
}
