import { test } from '@playwright/test';

test('Login test @smoke @regression', async ({ page }) => {
  await page.goto('https://example.com');
});

// or adding by tags
test('Login functionality', { tag: ['@smoke', '@regression']}, async ({ page }, testinfo) => {
if(testinfo.status!==testinfo.expectedStatus){
    
}
})

// Used when a test is expected to fail due to a bug.
test.fixme('Checkout test', async ({ page }) => {
});

// or  to fail the test case expected
test.fail('Negative login test', async ({ page }) => {
});
test.slow('Negative login test', async ({ page }) => {
});


// describe when it used

/***
 * // describe when it used

 * 1. when it required tags need to add
 * 2. group of test cases
 * 3. particular test case setups required
 * Example: run tests in parallel  ->test.describe.parallel('Search Tests', () => {})
 * 
 * we can use test.describe.configure({ mode: 'serial' });  eighter parrell exicution or serial exicution we can do worker node and parrele=true in config
 */

