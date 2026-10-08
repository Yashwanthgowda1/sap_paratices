import { Page , ElementHandle} from "@playwright/test";


export async function scrollByhardcode(page: Page, x: number, y: number): Promise<void> {
  await page.evaluate(([scrollX, scrollY]) => {
    // standerdfunction
    window.scrollBy(scrollX, scrollY);
  }, [x, y]);
}

// scroll up to the bottone
export async function scrollbybottom(page:Page): Promise<void> {
    page.evaluate(() =>{
        window.scrollBy(0, document.body.scrollHeight);

    })
    
}

export async function scrollElementIntoView(element: ElementHandle<Element>): Promise<void> {
 while(!element.isVisible){
    await element.scrollIntoViewIfNeeded();
}
}

// some time elmnt will not scroll webpage will scroll or winows will scroll
export async function scrollbypixel(page:Page, id :string, pixel:number) {

     // 1️⃣ Get element reference
   const element=await page.$(`#${id}`)
   if (element){
    // 2️⃣ Scroll down 50 pixels
    element.evaluate(el=>{
        el.scrollTop+=pixel
    })}
    else{
        console.log('Element not found');
    }
    
   }

 
// await scrollElementById(page, 'scrollable-div', 100);