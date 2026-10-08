import { test, expect, Locator } from '@playwright/test';
import console, { time } from 'node:console';

test('has title', async ({ page }) => {
  await page.goto('https://www.flipkart.com/');
  await page.waitForTimeout(100)
  page.getByAltText('Image')
// can use the title over here it will comes from the priority from lable / title / placeholder
  // const searchBox = page.getByRole('textbox', {name: /search for products, brands and more/i});
  const searchBox=page.getByPlaceholder(/Search\s+for Products, Brands and More/i)
    
   await searchBox.fill("laptops")
   await searchBox.press('Enter');
   await page.waitForTimeout(3000);
   await expect(page.getByText('Electronics')).toBeVisible()

// When there is NO label, text, or role  or When element has a stable tooltip title
  //  <span title="More options">⋮</span>   ot <button title="Close">✕</button>
  const  locaters_clear= page.getByTitle("Search for products, brands and more")


await locaters_clear.clear();        // clear existing text
await locaters_clear.fill('phones');
await locaters_clear.press('Enter');
await page.waitForTimeout(3000);


  






  

});

