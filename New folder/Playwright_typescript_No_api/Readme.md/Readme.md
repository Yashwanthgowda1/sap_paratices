# Playwright TypeScript — Interview Q&A Notes

---

## Hooks / Lifecycle Methods

| Playwright | Mocha (WebdriverIO) | When runs |
|---|---|---|
| `test.beforeAll()` | `before()` | Once before ALL tests in suite |
| `test.beforeEach()` | `beforeEach()` | Before EACH test |
| `test.afterEach()` | `afterEach()` | After EACH test |
| `test.afterAll()` | `after()` | Once after ALL tests in suite |

### Java Cucumber BDD hooks (annotations):
```java
@Before         void beforeScenario() { }   // before each Scenario
@After          void afterScenario()  { }   // after each Scenario
@BeforeAll      void beforeAll()      { }   // before all scenarios
@AfterAll       void afterAll()       { }   // after all scenarios
```

### TestNG hooks (annotations):
```java
@BeforeSuite    @BeforeClass    @BeforeMethod    @Test
@AfterMethod    @AfterClass     @AfterSuite
```

### pytest (Python) — fixture scopes instead of annotations:
```python
@pytest.fixture(scope="function")   # before+after each test  → like @BeforeMethod
@pytest.fixture(scope="class")      # before+after each class → like @BeforeClass
@pytest.fixture(scope="session")    # before+after entire run → like @BeforeSuite
```

---

## What is a Fixture in Playwright?

**Interview Answer:**
> A fixture is where we maintain reusable setup — initialization of POM page objects, browser/driver setup, and any shared state. Playwright automatically injects fixture dependencies during test execution without us creating objects manually in each test.

```typescript
// src/fixtures/hotstar.fixtures.ts
export const test = base.extend<HotstarFixtures>({

  // Playwright injects 'page' automatically — we wrap it in our POM
  loginPage: async ({ page }, use) => {
    await use(new HotstarLoginPage(page));   // ← POM initialized here
  },

  homePage: async ({ page }, use) => {
    await use(new HotstarHomePage(page));
  },

  // Reusable setup — navigate to home, dismiss modals
  authenticatedHome: async ({ page }, use) => {
    const home = new HotstarHomePage(page);
    await home.goto();
    await home.dismissAdsOrModals();
    await use();                            // ← test runs here
  },
});

// In test — Playwright injects loginPage and homePage automatically
test('hero banner visible', async ({ homePage }) => {
  expect(await homePage.isHeroBannerVisible()).toBe(true);
});
```

**Key points:**
- No `new LoginPage()` in tests — fixture does it
- `page` (browser tab) is injected by Playwright automatically
- `{ page }` in fixture = Playwright's built-in fixture
- Everything before `await use()` = setup (beforeEach)
- Everything after `await use()` = teardown (afterEach)

---


### When NOT to parallelize — use serial for dependent steps:
```typescript
test.describe.serial('Login flow', () => {
  test('step 1 — open login page', ...)   // must run first
  test('step 2 — enter OTP', ...)         // needs step 1
  test('step 3 — verify home', ...)       // needs step 2
});
```

**Interview Answer:**
> "Three ways: `fullyParallel: true` in config runs everything in parallel globally. `test.describe.parallel()` enables parallel execution for a specific group. `--workers=N` in CLI overrides at runtime. For dependent test steps, `test.describe.serial()` forces sequential order within that group."

---

## Locator Strategies — WebdriverIO (Android)

| Format passed to `$()` | Strategy | Example |
|---|---|---|
| `~text` | Accessibility ID | `$('~Movies')` |
| `in.pkg:id/view` | Resource ID | `$('in.startv.hotstar:id/btn_login')` |
| `//android.widget...` | XPath | `$('//android.widget.TextView[@text="Login"]')` |
| `android=new UiSelector()...` | UIAutomator2 | `$('android=new UiSelector().text("Login")')` |

---

## Hybrid App Context Switching (Appium)

```typescript
await this.switchTo('WEBVIEW');    // native → WebView (player, catalog)
await this.switchTo('NATIVE_APP'); // WebView → native (nav, buttons)
await this.isInWebView();          // boolean check
```

what is sect and loacter:

A selector is just a string — CSS, XPath, ID — that tells the framework WHERE to find the element. A locator is the object created from that selector. The locator has action methods like .click(), .getText(), .isVisible(). In Playwright, page.locator(selector) creates a locator. In Selenium, driver.findElement(By.id(...)) creates a WebElement. In WebdriverIO, $(selector) creates a ChainablePromiseElement. The selector is the address, the locator is the object you interact with."

Hnadel the hidden elemnts :
Playwright by default waits for elements to be visible before interacting. For hidden elements: use isVisible()/isHidden() to check state, waitFor({ state: 'visible' }) to wait for it to appear, { force: true } to bypass visibility and interact anyway, or page.evaluate() to manipulate via JavaScript when the element is truly hidden from Playwright's action layer."

js:
await page.evaluate(() => {
  (document.querySelector('#hidden-btn') as HTMLElement).click();
});


1. What is auto-waiting in Playwright?
Playwright automatically waits for elements to be visible, enabled, stable before acting — no manual sleep or WebDriverWait needed.

2. What is BrowserContext vs Page?
BrowserContext = isolated session (own cookies/localStorage). Page = single tab inside a context. Use multiple contexts to test multi-user scenarios.

3. How do you handle iFrames?
page.frameLocator('#iframe-id').locator('#element').click()

4. How do you handle multiple tabs/windows?
const [newPage] = await Promise.all([page.context().waitForEvent('page'), page.click('#link')])

5. How do you intercept/mock API calls?
page.route('**/api/**', route => route.fulfill({ body: mockData }))

6. What is soft assertion?
expect.soft() — collects all failures instead of stopping at first. Reports all at end.

7. How do you handle file upload/download?
Upload: locator.setInputFiles('./file.pdf') — Download: page.waitForEvent('download')

8. What is Playwright Trace Viewer?
Records every step with screenshots, DOM snapshots, network calls. View with npx playwright show-trace trace.zip. Used for debugging failures.

9. test.only / test.skip / test.fixme — difference?
only = run only this. skip = skip this. fixme = known bug, expected to fail.

10. What is waitForLoadState?
domcontentloaded → DOM ready. load → all resources. networkidle → no network for 500ms.

11. Playwright vs Selenium vs Cypress — key difference?
Playwright: multi-browser, multi-language, auto-wait, built-in parallel, network intercept, iFrames, multi-tab. Selenium: all languages, slow, no auto-wait. Cypress: JS only, no multi-tab, fastest for Chrome.

12. How to run specific tests?
--grep @smoke by tag, --project=chromium by browser, --workers=4 for parallel.

1. What is storageState / How do you handle authentication?
Save login session to a file, reuse across all tests — avoids logging in before every test.


// Save session once
await page.context().storageState({ path: 'auth.json' });
// Reuse in config
use: { storageState: 'auth.json' }
2. How do you do API testing in Playwright?
Playwright has a built-in request fixture — no Axios/fetch needed.


const response = await request.get('https://api.hotstar.com/content');
expect(response.status()).toBe(200);

3. How do you handle alerts/dialogs?


page.on('dialog', dialog => dialog.accept());   // auto-accept
page.on('dialog', dialog => dialog.dismiss());  // auto-dismiss

4. How do you debug Playwright tests?
Three ways: --debug flag opens inspector, await page.pause() pauses at that line, VS Code Playwright extension has breakpoints.

5. What is Playwright Codegen?
npx playwright codegen https://hotstar.com — opens browser and records your actions, generates test code automatically.

6. Data-driven testing — how to run same test with multiple data?


const testData = ['Loki', 'Avengers', 'WandaVision'];
for (const query of testData) {
  test(`Search: ${query}`, async ({ page }) => {
    await searchPage.searchFor(query);
  });
}

7. How do you handle cookies in Playwright?


await page.context().addCookies([{ name: 'token', value: 'abc', url: 'https://hotstar.com' }]);
const cookies = await page.context().cookies();
await page.context().clearCookies();

8. waitForResponse — how to verify API calls in UI tests?


const [response] = await Promise.all([
  page.waitForResponse('**/api/content**'),
  page.locator('#search').fill('Loki'),
]);
expect(response.status()).toBe(200);

9. What is test.use()?
Override config for specific tests — set viewport, locale, timezone, storageState at test level.


test.use({ viewport: { width: 375, height: 812 } });  // iPhone size for this file only

10. How do you run Playwright on CI/CD?


# GitHub Actions
- run: npx playwright install --with-deps
- run: npx playwright test
  env:
    CI: true
On CI: retries: 2, workers: 2, headless: true automatically from config.

11. Element-level screenshot?


await page.locator('#hero-banner').screenshot({ path: 'banner.png' });

12. What is page.waitForResponse vs page.waitForRequest?
waitForResponse — waits for server to respond. waitForRequest — waits for browser to send request. Used to sync UI actions with API calls.


13. How to handle captcha in tests?
Three approaches:

Disable captcha in test environment via env flag
Mock the captcha API call with page.route()
Use a test account with captcha bypass token

14. how to otp
"OTP handling has 4 approaches: use a test phone number with fixed OTP configured by the dev team, mock the OTP verification API using page.route() to always return success, read OTP from SMS via a gateway API like Twilio, or use storageState to save the session after one-time login and reuse it across all tests — which completely avoids OTP in the test run."


15. in playwight we handel sahow root elemnt using the playwright pierces  shadow root 
await page.locator('my-component').locator('input#username').fill('test');