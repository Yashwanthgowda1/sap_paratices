import {test as base, test, Page, expect, BrowserContext, Browser, Locator} from  "@playwright/test"
import { allure } from "allure-playwright";
import strict from "node:assert/strict";
// import { APIRequest } from "playwright";
import { request } from "@playwright/test";
import { loadEnvFile } from "node:process";
import { promise } from "zod";
// import { string } from "zod";

let context: BrowserContext;
let page: Page;
// let request: APIRequest





// export const test_values = base.extend({

//     appContext: async ({ browser }, use) => {

//         const context = await browser.newContext();

//         const page = await context.newPage();

//         await use({
//             context,
//             page
//         });

//         await context.close();
//     }

// });

// export { test_values };

test.describe.parallel("Homepage & Navigation", ()=>{
   
    test.beforeAll(async ({ browser }) => {
        context = await browser.newContext();
    });

    test.beforeEach(async () => {
        page = await context.newPage();
        await page.goto("https://www.policybazaar.com/");
    });

    test.afterEach(async () => {
        await page.close();
    });

    test.afterAll(async () => {
        await context.close();
    });

    test("Verify homepage loads correctly with all major sections", {tag : ["@smoke", "@sanity"]}, async()=>{
      
        const all_a_tags_headers=page.locator("[class='ruby-menu'] >li>a");
        // let const_links=await all_a_tags_headers.getAttribute("href")
        let toalfoudn=await all_a_tags_headers.count()
        const store_all_headers:string []=[]
        let values =page.locator("[class='links-payment-social-section']")
       await  expect(values).toBeVisible()
       await expect(page.locator("//div[text()='Group Brands']")).toContainText("Brands")
        for(let i=0;i<toalfoudn;i++){
              let const_links=await all_a_tags_headers.nth(i).innerText()
                store_all_headers.push(const_links);
               
        }
        //  JSON.stringify used to convert  array--->   json
        allure.attachment(
            "header values ",
            JSON.stringify(store_all_headers.map(el=>
                {return el.trim()}).filter(el => {return el.length >1 }), null, 2),
            "application/json"
        )  
              


        }
    );


   test("Verify all top navigation menu items navigate to correct pages",{tag: ["@PB_HOME_002", "@smoke", "@sanity"]
  },
  async ({request}) => {
        await page.getByText("View all products").click()
       await expect(page.locator("#homeIcons")).toBeVisible();
        const const_listod_values =page.locator("[class='left-block'] >p")
        const store_all_headers:string []=[]
        const total=await const_listod_values.count()
        for(let i=0; i< total;i++){
            const text = (await const_listod_values.nth(i).innerText()).trim();

                if (text.length > 0) {
                    store_all_headers.push(text);
                }
        }
        allure.attachment(
            "header values ",
            JSON.stringify(store_all_headers.map(el=>
                {return el.trim()}).filter(el => {return el.length >1 }), null, 2),
            "application/json"
        ) 
        // const ecah_setvalues:string[]=[]
       const map =new Map<String, Array<String>>();

      for (let i = 0; i < store_all_headers.length; i++) {

                        const actual_locator = page.locator(
                            `//p[normalize-space()='${store_all_headers[i]}']/following-sibling::ul[1]//a`
                        );

                      
                        const actula_thinks_present_in_ecah_conatiner = page.locator(`//p[normalize-space()='${store_all_headers[i]}']/following-sibling::ul[1]//span`);

                        let j = 0;
                        const totalLinks = await actual_locator.count();

                        while (j < totalLinks) {

                            const eachLink = await actual_locator.nth(j).getAttribute("href");
                            let ecahvalue=await actula_thinks_present_in_ecah_conatiner.nth(j).innerText()
                            if(!map.has(store_all_headers[i])){
                                map.set(store_all_headers[i], []);
                            }
                            map.get(store_all_headers[i])?.push(ecahvalue.trim());

                            console.log("Link:", eachLink);
                           if (
                                eachLink &&
                                (eachLink.startsWith("http://") ||
                                eachLink.startsWith("https://")) ) 
                                {
                                const response = await request.get(eachLink);
                                

                                console.log(`${eachLink} -> ${response.status()}`);

                                expect(response.status()).toBeLessThan(400);
                            }
                        

                            j++;
                        }
                    }
           
        allure.attachment(
    "product list values",
    JSON.stringify(Object.fromEntries(map), null, 2),
    "application/json"
);
const closeBtn = page.locator(".close.close-more-prd");

console.log("Count:", await closeBtn.count());

if (
    await closeBtn.count() > 0 &&
    (await closeBtn.first().isVisible())
) {
    await closeBtn.first().click({force: true });
}
        
            
  
});


test("Verify 404 page displays for invalid URL", {tag: ["@samoke", `@sanity`]}, async()=>{
        await page.goto("https://www.policybazaar.com/787879/")
        await expect(page).toHaveTitle(/404 Error Found/i)
            await expect( page.getByText(/we couldn’t find that page\./i)).toBeVisible();
            await page.goBack()
            await expect(page).toHaveTitle(/Insurance - Compare/i)
})





});
test.describe.parallel("Login", () => {

    test.beforeAll(async ({ browser }) => {
        context = await browser.newContext();
    });

    test.beforeEach(async () => {
        page = await context.newPage();
        await page.goto("https://www.policybazaar.com/");
    });

    test.afterEach(async () => {
        await page.close();
    });

    test(
        `Get health insurance quote for family floater (2 adults + 2 children) and family and compare`,
        async () => {

            // =========================================================
            // HEALTH INSURANCE
            // =========================================================

            const values = page.locator(
                "//div[@class='prd-icon add shadowHandler short']/descendant::p"
            );

            const count = await values.count();

            for (let i = 0; i < count; i++) {

                const text = await values.nth(i).innerText();

                console.log(i, text);

                if (text.toLowerCase().includes("health insurance")) {

                    console.log("Health Insurance found");

                    await Promise.all([
                        page.waitForNavigation(),
                        values.nth(i).click()
                    ]);

                    break;
                }
            }

            // =========================================================
            // VERIFY MALE / FEMALE SELECTION
            // =========================================================

            const maleRadio = page.locator(
                "//input[@type='radio' and @value='Male']"
            );

            if (await maleRadio.count() > 0) {

                const eachValuesText = page.locator(
                    ".radio_box_wrapper.memberNoIconExp > .radio_box_inner > label > p"
                );

                const whenMaleIsSelected = (
                    await eachValuesText.nth(1).innerText()
                ).trim();

                console.log(
                    `The total male contents: ${await eachValuesText.count()}`
                );

                const femaleRadio = page.locator(
                    "[class='memberSelection__block']>[for='female']"
                );

                await femaleRadio.check();

                const whenFemaleIsSelected = (
                    await eachValuesText.nth(1).innerText()
                ).trim();

                if (whenMaleIsSelected === whenFemaleIsSelected) {

                    throw new Error(
                        `Male and Female selected text should be different. ` +
                        `Male: "${whenMaleIsSelected}", ` +
                        `Female: "${whenFemaleIsSelected}"`
                    );
                }
            }

            // =========================================================
            // TYPES
            // =========================================================

            type Coverage = {
                monthly: string;
            };

            type Insurance = {
                coverage: Coverage;
            };

            const insuranceData = new Map<
                string,
                Map<string, Insurance>
            >();

            // =========================================================
            // MORE MEMBERS
            // =========================================================

            await page.locator(
                "//a[text()='More members ']"
            ).click();

            const maleRadio_after = page.locator(
                "//div[@class='radio_box_wrapper memberNoIconExp']" +
                "//descendant::input[@type='checkbox']"
            );

            const eca = await maleRadio_after.count();

            console.log(
                `The total number of members: ${eca}`
            );

            if (eca < 16) {

                throw new Error(
                    `Male and Female selected text should be different ` +
                    `and view more value is less. ` +
                    `count members: "${eca}"`
                );
            }

            // =========================================================
            // VALID MEMBERS
            // =========================================================

            const validMembers = [
                "male",
                "wife",
                "son",
                "mother",
                "father",
                "daughter"
            ];

            // =========================================================
            // MEMBER LOCATOR
            // IMPORTANT:
            // Use your working locator instead of label[@for='0']
            // =========================================================

            const eachMemberText = page.locator(
                ".radio_box_wrapper.memberNoIconExp > " +
                ".radio_box_inner > label > p"
            );

            // =========================================================
            // MEMBER LOOP
            // =========================================================

            for (
                let memberIndex = 0;
                memberIndex < eca;
                memberIndex++
            ) {

                // -----------------------------------------------------
                // GET MEMBER NAME
                // -----------------------------------------------------

                const ecah_itaems_presnets = (
                    await eachMemberText
                        .nth(memberIndex)
                        .innerText()
                )
                    .trim()
                    .toLowerCase();

                console.log(
                    `------------------------------------------`
                );

                console.log(
                    `Member Index: ${memberIndex}`
                );

                console.log(
                    `Member: ${ecah_itaems_presnets}`
                );

                // -----------------------------------------------------
                // IGNORE INVALID MEMBERS
                // -----------------------------------------------------

                if (
                    !validMembers.includes(
                        ecah_itaems_presnets
                    )
                ) {
                    continue;
                }

                // -----------------------------------------------------
                // SELECT MEMBER
                // -----------------------------------------------------

                await maleRadio_after
                    .nth(memberIndex)
                    .check();

                console.log(
                    `Selected member: ${ecah_itaems_presnets}`
                );

                // -----------------------------------------------------
                // SCROLL TO PLAN SECTION
                // -----------------------------------------------------

                const ecah_time = page.locator(
                    "//ul[@class='_topPlansWrapper__tabContainer__tabItem_z7wpt_95']"
                );

                await scroll_elemntrefernce(
                    ecah_time,
                    page
                );

                await page.screenshot({
                    path:
                        `after-scroll-${ecah_itaems_presnets}.png`
                });
               await page.waitForTimeout(1000)

                // =====================================================
                // INSURANCE POLICY LOCATOR
                // =====================================================

                const ecah_time_type_insurance =
                    page.locator(
                        "//article[contains(@class,'__planCard__quote_19jyy_31')]"
                    );

                // =====================================================
                // KEEP TRACK OF PROCESSED POLICIES
                // =====================================================

                let processedPolicyCount = 0;

                // =====================================================
                // POLICY LOOP
                // =====================================================

                while (true) {

                    const currentPolicyCount =
                        await ecah_time_type_insurance.count();

                    console.log(
                        `Current policy count: ${currentPolicyCount}`
                    );

                    // -------------------------------------------------
                    // PROCESS POLICIES
                    // -------------------------------------------------

                    for (
                        let policyIndex = processedPolicyCount;
                        policyIndex < currentPolicyCount;
                        policyIndex++
                    ) {

                        const actual_ecah_detail_and_price_compare =
                            ecah_time_type_insurance
                                .nth(policyIndex)
                                .locator("p");

                        // ------------------------------------------------
                        // POLICY NAME
                        // ------------------------------------------------

                        const policyName = (
                            await actual_ecah_detail_and_price_compare
                                .nth(1)
                                .innerText()
                        ).trim();

                        // ------------------------------------------------
                        // MONTHLY PRICE
                        // ------------------------------------------------

                        const monthly = (
                            await actual_ecah_detail_and_price_compare
                                .nth(2)
                                .innerText()
                        ).trim();

                        console.log(
                            `Member  : ${ecah_itaems_presnets}`
                        );

                        console.log(
                            `Policy  : ${policyName}`
                        );

                        console.log(
                            `Monthly : ${monthly}`
                        );

                        // =================================================
                        // CREATE MEMBER MAP
                        // =================================================

                        if (
                            !insuranceData.has(
                                ecah_itaems_presnets
                            )
                        ) {

                            insuranceData.set(
                                ecah_itaems_presnets,
                                new Map<string, Insurance>()
                            );
                        }

                        const map_nested_val =
                            insuranceData.get(
                                ecah_itaems_presnets
                            )!;

                        // =================================================
                        // CREATE POLICY
                        // =================================================

                        if (
                            !map_nested_val.has(
                                policyName
                            )
                        ) {

                            map_nested_val.set(
                                policyName,
                                {
                                    coverage: {
                                        monthly: monthly
                                    }
                                }
                            );

                        } else {

                            // =================================================
                            // UPDATE EXISTING POLICY
                            // =================================================

                            const policy =
                                map_nested_val.get(
                                    policyName
                                )!;

                            policy.coverage.monthly =
                                monthly;
                        }
                    }

                    // -------------------------------------------------
                    // MARK CURRENT POLICIES AS PROCESSED
                    // -------------------------------------------------

                    processedPolicyCount =
                        currentPolicyCount;

                    // =================================================
                    // SHOW MORE
                    // =================================================

                    const show_more = page.locator(
                        "//button[text()='Show more plans']"
                    );

                    const showMoreCount =
                        await show_more.count();

                    // -------------------------------------------------
                    // NO SHOW MORE BUTTON
                    // -------------------------------------------------

                    if (showMoreCount === 0) {

                        console.log(
                            "Show more button not found."
                        );

                        break;
                    }

                    // -------------------------------------------------
                    // SHOW MORE NOT VISIBLE
                    // -------------------------------------------------

                    if (!(await show_more.isVisible())) {

                        console.log(
                            "Show more button is not visible."
                        );

                        break;
                    }

                    // -------------------------------------------------
                    // SCROLL TO SHOW MORE
                    // -------------------------------------------------

                    await scroll_elemntrefernce(
                        show_more,
                        page
                    );

                    // -------------------------------------------------
                    // CLICK SHOW MORE
                    // -------------------------------------------------

                    await show_more.click();

                    console.log(
                        "Clicked Show More Plans"
                    );

                    // -------------------------------------------------
                    // WAIT FOR NEW POLICIES
                    // -------------------------------------------------

                    await page.waitForTimeout(1000);

                    // =================================================
                    // WHILE LOOP RESTARTS
                    //
                    // Example:
                    //
                    // First count = 5
                    // processed = 0
                    // process 0-4
                    //
                    // Show More
                    //
                    // New count = 10
                    // processed = 5
                    // process 5-9
                    //
                    // Show More
                    //
                    // New count = 15
                    // processed = 10
                    // process 10-14
                    // =================================================
                }

                console.log(
                    `Finished member: ${ecah_itaems_presnets}`
                );
            }

            // =========================================================
            // FINAL DATA
            // =========================================================

            console.log(
                "=========================================="
            );

            console.log(
                "FINAL INSURANCE DATA"
            );

            console.log(
                JSON.stringify(
                    Object.fromEntries(
                        Array.from(
                            insuranceData.entries()
                        ).map(
                            ([member, policies]) => [
                                member,
                                Object.fromEntries(
                                    policies.entries()
                                )
                            ]
                        )
                    ),
                    null,
                    2
                )
            );
        }
    );
});



test.describe.only("veroify the user able tosee the amount and max and set the values and caluate the comparions", ()=>{
test.beforeAll(async ({ browser }) => {
        context = await browser.newContext();
    });

    test.beforeEach(async () => {
        page = await context.newPage();
        await page.goto("https://www.policybazaar.com/");
    });

    test.afterEach(async () => {
        await page.close();
    });
   test(
    "Calculate term insurance premium for 30-year-old male, 1 Crore cover",
    { tag: ["@sanity"] },
    async ({ request }) => {

        const actual_mousehover = page.locator(
            "//a[text()='Insurance Products ']"
        );

        await actual_mousehover.hover();

        // Check Health Insurance is visible in the hover menu
        const actual_match_visble = page.locator(
            "//div[contains(@class,'ruby-col-3')]//a[normalize-space()='Health Insurance']"
        );

        if (await actual_match_visble.isVisible()) {

            const actual_matching_inisethe_helat_terms = page.locator(
                "//a[normalize-space()='Health Insurance']" +
                "//ancestor::div[contains(@class,'ruby-col-3')]" +
                "//h3[@class='ruby-list-heading']" +
                "//following-sibling::ul//li//a"
            );

            const totalLinks =
                await actual_matching_inisethe_helat_terms.count();

            let collect_that_locatre: Locator | null = null;

            const let_all_the_information: string[] = [];

            for (let i = 0; i < totalLinks; i++) {

                const currentLink =
                    actual_matching_inisethe_helat_terms.nth(i);

                // Get href
                const href = await currentLink.getAttribute("href");

                // Validate link
                if (href) {
                    const response = await request.get(href);

                    expect(response.status()).toBeLessThan(400);
                }

                // Get text
                const text = (
                    await currentLink.locator("span").innerText()
                ).trim();

                // Store text
                let_all_the_information.push(text);

                // Find calculator
                if (text.toLowerCase().includes("calculator")) {

                    collect_that_locatre =
                        currentLink.locator("span");
                }
            }

            // Click calculator
            if (collect_that_locatre) {

                await Promise.all([
                    page.waitForNavigation(),
                    collect_that_locatre.click()
                ]);

               await expect(page).toHaveURL(/premium-calculator/i);
            }

            // Find member labels
            const actual = page.locator(
                "//li[contains(@class,'form-group')]//label"
            );

            const letvalues = await actual.count();

            for (let i = 0; i < letvalues; i++) {

                const dataId =
                    await actual.nth(i).getAttribute("data-id");

                if (dataId === "self") {

                    await actual.nth(i).click();

                    break;
                }
            }

            // Continue from Step 1
        const step1Button = page.locator(
    "//div[@class='button btnHealthStep1']"
);

await step1Button.click();

await expect(page).toHaveURL(/health-insurance/);

            // Age selection
            const age_selection =
                page.locator("[data-id='Self']");

            await age_selection.click();

            const actual_multiple =
                await age_selection.evaluate(el => {
                    return (el as HTMLSelectElement).multiple;
                });

            if (!actual_multiple) {

                await age_selection.selectOption({
                    value: "25"
                });
            }

            // Step 2
            await page.locator(
                "[class='button btnHealthStep2']"
            ).click();

            await expect(
                page.locator("//div[text()=' Select your city ']")
            ).toBeVisible();

           await page.locator("//span[text()='Bengaluru']").click()

            // Step 3
            // await page.locator(
            //     "[class='button btnHealthStep3']"
            // ).click();
// await page.waitForSelector("//input[@class='fullWidht txtName labelshow']", {
//     state: "attached",
//     timeout: 10000
// });

           const nameInput = page.locator(
    "//div[@id='name_feild']//input[contains(@class,'txtName')]"
);


console.log("count:", await nameInput.count());
console.log("visible:", await nameInput.first().isVisible());
// console.log("enabled:", await nameInput.first().isEnabled());
// console.log("editable:", await nameInput.first().isEditable());

          await nameInput.fill("yashwanth");

            const values= page.locator("[id='name5']")
            await values.click();
            await values.fill("8989882212")

            // Step 4
            // await page.locator(
            //     "[class='button btnHealthStep4']"
            // ).click();

            // Pre-existing disease checkboxes
            const check_box =
                page.locator("label[for*='pedsub']");

            const NUMBER_CHEKC_BOX =
                await check_box.count();

            for (let i = 0; i < Math.min(3, NUMBER_CHEKC_BOX); i++) {

                await expect(
                    check_box.nth(i)
                ).not.toBeChecked();

                await check_box.nth(i).check();

                await expect(
                    check_box.nth(i)
                ).toBeChecked();
            }

            // Step 5
    //    await page.locator("#btnHealthStep5").click();
    // do manual click
   await  page.waitForTimeout(6000);


    //    or we have  page.waitForEvent("download");
    const verify_commoent =page.locator("[class='exitIntentInnerNew']")
    if(await verify_commoent.isVisible()){
       if(await page.locator("[id='exit-intent-popup-close']").isVisible()){
               await page.locator("[id='exit-intent-popup-close']").click();
       }
    }


// await page.waitForLoadState("networkidle");

            // Verify Self
            const each_values = await page
                .locator(
                    "[class='qv2_sidebar__profile__item --members'] strong"
                )
                .innerText();

            const expectedSelf = "self";

            const actualMember =
                each_values
                    .trim()
                    .split(/\s+/)[0]
                    .toLowerCase();

            expect(actualMember).toBe(
                expectedSelf
            );

            // Edit profile
            await page.locator(
                "//button[text()='Edit ›']"
            ).click();

            await expect(
                page.locator(
                    "[class='qv2_editProfileModal__title']"
                )
            ).toBeVisible();

            // Select Self
            await page.locator(
                "//p[text()='Self(25 yrs)']"
            ).click();

            // Actual checkbox input
            const selfCheckbox = page.locator(
                "//label[.//span[normalize-space()='Self']]//input"
            );

            if (await selfCheckbox.isChecked()) {

                // Uncheck Self
                await selfCheckbox.uncheck();

                // Verify at least one member is required
                await expect(
                    page.locator(
                        "//p[text()='Please select one member']"
                    )
                ).toBeVisible();

                // Select Spouse
                await page.locator(
                    "//span[normalize-space()='Spouse']"
                ).click();

                // Error should disappear
                await expect(
                    page.locator(
                        "//p[text()='Please select one member']"
                    )
                ).not.toBeVisible();

                // Select spouse age
                await page.locator(
                    "[name='spouse-age']"
                ).selectOption({
                    value: "22"
                });

                // Continue
                await page.locator(
                    "//button[text()='Continue']"
                ).click();

                // View updated plans
                await page.locator(
                    "//button[text()='View updated plans']"
                ).click();

                // Verify updated member is Spouse
                const updated_values = await page
                    .locator(
                        "[class='qv2_sidebar__profile__item --members'] strong"
                    )
                    .innerText();

                const expectedSpouse = "spouse";

                const updatedMember =
                    updated_values
                        .trim()
                        .split(/\s+/)[0]
                        .toLowerCase();

                expect(updatedMember).toBe(
                    expectedSpouse
                );
            }
        }
    }
);

})




test.describe("hit the diffent url and verify the mock api is working or not", ()=>{
test("verify usr new can able to add and genarte the api user id and verify the tocken", async({request})=>{

/***
 * here just we use the from for login api reming json same as python  (in python aso at login we use data)
 * 
 */
    const response = await request.post(
    "http://127.0.0.1:8000/login", {
            form:{
                 "username": "admin@insurance.com",
                "password": "admin123"
    }
}

)
        const body = await response.json();
            console.log(body.access_token);
            expect(body.user_id).toBeGreaterThan(0);

}
)}
)








async function scroll_elemntrefernce(elemnt:Locator, page:Page){
    const locations=await elemnt.boundingBox()
if (!locations) {
    throw new Error("Element is not visible");
}
   await page.evaluate(({x, y})=>{
          window.scrollTo(x, y);


},{ x:locations?.x,
    y: locations?.y
} 
)
}
 