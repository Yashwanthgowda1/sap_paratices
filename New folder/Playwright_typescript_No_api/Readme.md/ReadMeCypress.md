# Cypress Complete Interview Guide — End to End with Code Examples

---

## 1. WHAT IS CYPRESS

Cypress is a JavaScript-based end-to-end testing framework that runs **inside the browser**.
Unlike Selenium which is external to the browser, Cypress runs in the same event loop as your app.

### Key Differences: Cypress vs Selenium vs Playwright

| Feature         | Cypress              | Selenium              | Playwright           |
|----------------|----------------------|-----------------------|----------------------|
| Language        | JavaScript/TypeScript | Multiple              | JS/TS/Python/Java    |
| Runs in browser | Yes (inside)         | No (external WebDriver)| No (external)       |
| Auto-wait       | Yes                  | No (manual waits)     | Yes                  |
| Network control | Yes (cy.intercept)   | Limited               | Yes                  |
| iFrame support  | Limited              | Good                  | Good                 |
| Speed           | Fast                 | Slower                | Fast                 |

---

## 2. INSTALLATION AND PROJECT SETUP

```bash
# Step 1: Create a new project
mkdir cypress-demo
cd cypress-demo
npm init -y

# Step 2: Install Cypress
npm install cypress --save-dev

# Step 3: Open Cypress (creates folder structure)
npx cypress open

# Step 4: Run headless (for CI/CD)
npx cypress run
```

### Folder Structure after setup:
```
cypress/
  e2e/           ← your test files go here
  fixtures/      ← test data (JSON files)
  support/
    commands.js  ← custom commands
    e2e.js       ← runs before all tests
cypress.config.js  ← configuration file
```

---

## 3. CYPRESS CONFIG FILE

```javascript
// cypress.config.js
const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: 'https://www.example.com',
    viewportWidth: 1280,
    viewportHeight: 720,
    defaultCommandTimeout: 5000,
    pageLoadTimeout: 30000,
    video: false,
    screenshotOnRunFailure: true,
    specPattern: 'cypress/e2e/**/*.cy.js',
  }
})
```

---

## 4. FIRST TEST — cy.visit, cy.get, cy.click, cy.type

```javascript
// cypress/e2e/first_test.cy.js

describe('Login Page Tests', () => {

  beforeEach(() => {
    cy.visit('/login')   // uses baseUrl from config
  })

  it('should load login page', () => {
    cy.url().should('include', '/login')
    cy.title().should('eq', 'Login - My App')
  })

  it('should login with valid credentials', () => {
    cy.get('#username').type('admin')
    cy.get('#password').type('password123')
    cy.get('button[type="submit"]').click()
    cy.url().should('include', '/dashboard')
  })

  it('should show error for invalid credentials', () => {
    cy.get('#username').type('wronguser')
    cy.get('#password').type('wrongpass')
    cy.get('button[type="submit"]').click()
    cy.get('.error-message').should('be.visible').and('contain', 'Invalid credentials')
  })

})
```

---

## 5. SELECTORS — How to Find Elements

```javascript
// By ID
cy.get('#username')

// By class
cy.get('.btn-primary')

// By attribute
cy.get('[data-testid="submit-btn"]')   // best practice for automation
cy.get('[type="email"]')
cy.get('[placeholder="Enter email"]')

// By text content
cy.contains('Login')
cy.contains('button', 'Submit')

// Chaining — find inside a parent
cy.get('.form-group').find('input')

// By CSS selector
cy.get('div.container > form input:first-child')

// nth element
cy.get('li').eq(0)   // first item (zero-indexed)
cy.get('li').eq(2)   // third item
cy.get('li').first()
cy.get('li').last()
```

---

## 6. ACTIONS — Interacting with Elements

```javascript
// Click
cy.get('button').click()
cy.get('button').dblclick()          // double click
cy.get('button').rightclick()        // right click

// Typing
cy.get('input').type('Hello World')
cy.get('input').type('{enter}')      // press Enter key
cy.get('input').type('{backspace}')  // backspace
cy.get('input').clear()              // clear existing text
cy.get('input').clear().type('new text')

// Checkbox and Radio
cy.get('#agree').check()
cy.get('#agree').uncheck()
cy.get('[value="option1"]').check()

// Dropdown
cy.get('select').select('Option Text')
cy.get('select').select('option_value')

// File upload
cy.get('input[type="file"]').selectFile('cypress/fixtures/test.pdf')

// Hover
cy.get('.menu-item').trigger('mouseover')

// Scroll
cy.scrollTo('bottom')
cy.get('.list').scrollTo('bottom')

// Focus / Blur
cy.get('input').focus()
cy.get('input').blur()
```

---

## 7. ASSERTIONS — should() and expect()

```javascript
// Visibility
cy.get('.modal').should('be.visible')
cy.get('.tooltip').should('not.be.visible')
cy.get('.spinner').should('exist')
cy.get('.error').should('not.exist')

// Text content
cy.get('h1').should('have.text', 'Welcome')
cy.get('p').should('contain', 'partial text match')
cy.get('p').should('not.contain', 'error')

// Value in input
cy.get('input').should('have.value', 'admin@test.com')

// CSS class
cy.get('button').should('have.class', 'active')
cy.get('button').should('not.have.class', 'disabled')

// Attribute
cy.get('a').should('have.attr', 'href', '/home')
cy.get('input').should('have.attr', 'disabled')

// Length / count
cy.get('li').should('have.length', 5)
cy.get('.item').should('have.length.greaterThan', 2)

// URL and Title
cy.url().should('include', '/dashboard')
cy.url().should('eq', 'https://example.com/home')
cy.title().should('include', 'Dashboard')

// Multiple assertions chained
cy.get('.btn')
  .should('be.visible')
  .and('have.text', 'Submit')
  .and('not.be.disabled')

// Numeric value assertions
cy.get('.price').invoke('text').then((text) => {
  const price = parseFloat(text.replace('$', ''))
  expect(price).to.be.greaterThan(0)
  expect(price).to.be.lessThan(1000)
})
```

---

## 8. FIXTURES — Test Data from JSON Files

```json
// cypress/fixtures/user.json
{
  "validUser": {
    "username": "admin@test.com",
    "password": "Admin@123"
  },
  "invalidUser": {
    "username": "wrong@test.com",
    "password": "wrongpass"
  }
}
```

```javascript
// cypress/e2e/login_with_fixture.cy.js

describe('Login using fixture data', () => {

  it('should login with valid user from fixture', () => {
    cy.fixture('user').then((data) => {
      cy.visit('/login')
      cy.get('#email').type(data.validUser.username)
      cy.get('#password').type(data.validUser.password)
      cy.get('button[type="submit"]').click()
      cy.url().should('include', '/dashboard')
    })
  })

  // OR — load fixture in beforeEach using alias
  beforeEach(() => {
    cy.fixture('user').as('userData')
  })

  it('should show error with invalid user', function () {
    // use function() not arrow => to access this.userData
    cy.visit('/login')
    cy.get('#email').type(this.userData.invalidUser.username)
    cy.get('#password').type(this.userData.invalidUser.password)
    cy.get('button[type="submit"]').click()
    cy.get('.error').should('contain', 'Invalid')
  })

})
```

---

## 9. cy.intercept() — Mock API Calls (VERY IMPORTANT)

```javascript
// cypress/e2e/intercept_demo.cy.js

describe('Network Intercept Examples', () => {

  // Stub — replace API response with fake data
  it('should stub API response', () => {
    cy.intercept('GET', '/api/users', {
      statusCode: 200,
      body: [
        { id: 1, name: 'John Doe', email: 'john@test.com' },
        { id: 2, name: 'Jane Doe', email: 'jane@test.com' }
      ]
    }).as('getUsers')

    cy.visit('/users')
    cy.wait('@getUsers')
    cy.get('.user-card').should('have.length', 2)
  })

  // Spy — let real request go but observe it
  it('should spy on real API request', () => {
    cy.intercept('POST', '/api/login').as('loginRequest')

    cy.visit('/login')
    cy.get('#email').type('admin@test.com')
    cy.get('#password').type('pass123')
    cy.get('button').click()

    cy.wait('@loginRequest').then((interception) => {
      expect(interception.request.body.email).to.eq('admin@test.com')
      expect(interception.response.statusCode).to.eq(200)
    })
  })

  // Simulate API failure
  it('should handle API error gracefully', () => {
    cy.intercept('GET', '/api/products', {
      statusCode: 500,
      body: { error: 'Internal Server Error' }
    }).as('failedRequest')

    cy.visit('/products')
    cy.wait('@failedRequest')
    cy.get('.error-banner').should('contain', 'Something went wrong')
  })

  // Intercept with fixture file
  it('should use fixture as API response', () => {
    cy.intercept('GET', '/api/users', { fixture: 'users.json' }).as('getUsers')
    cy.visit('/users')
    cy.wait('@getUsers')
  })

})
```

---

## 10. cy.request() — API Testing in Cypress

```javascript
// cypress/e2e/api_test.cy.js

describe('API Tests using cy.request()', () => {

  it('GET request', () => {
    cy.request('GET', 'https://jsonplaceholder.typicode.com/posts/1')
      .then((response) => {
        expect(response.status).to.eq(200)
        expect(response.body).to.have.property('title')
        expect(response.body.id).to.eq(1)
      })
  })

  it('POST request', () => {
    cy.request({
      method: 'POST',
      url: 'https://jsonplaceholder.typicode.com/posts',
      body: {
        title: 'Test Post',
        body: 'Test Body',
        userId: 1
      },
      headers: {
        'Content-Type': 'application/json'
      }
    }).then((response) => {
      expect(response.status).to.eq(201)
      expect(response.body.title).to.eq('Test Post')
    })
  })

  it('Login via API then visit protected page', () => {
    cy.request({
      method: 'POST',
      url: '/api/login',
      body: { email: 'admin@test.com', password: 'pass123' }
    }).then((response) => {
      window.localStorage.setItem('token', response.body.token)
    })
    cy.visit('/dashboard')
    cy.get('.welcome').should('contain', 'Welcome')
  })

})
```

---

## 11. HOOKS — beforeEach, afterEach, before, after

```javascript
// cypress/e2e/hooks_demo.cy.js

describe('Hooks Example', () => {

  before(() => {
    // runs once before ALL tests in this describe block
    cy.log('Starting test suite')
  })

  after(() => {
    // runs once after ALL tests
    cy.log('Test suite finished')
  })

  beforeEach(() => {
    // runs before EACH test
    cy.visit('/login')
    cy.get('#email').type('admin@test.com')
    cy.get('#password').type('pass123')
    cy.get('button[type="submit"]').click()
  })

  afterEach(() => {
    // runs after EACH test
    cy.clearCookies()
    cy.clearLocalStorage()
  })

  it('should see dashboard', () => {
    cy.url().should('include', '/dashboard')
  })

  it('should see profile link', () => {
    cy.get('nav').contains('Profile').should('be.visible')
  })

})
```

---

## 12. CUSTOM COMMANDS — Reusable Functions

```javascript
// cypress/support/commands.js

// Custom login command
Cypress.Commands.add('login', (email, password) => {
  cy.visit('/login')
  cy.get('#email').type(email)
  cy.get('#password').type(password)
  cy.get('button[type="submit"]').click()
})

// Login via API (faster — skips UI)
Cypress.Commands.add('loginViaApi', (email, password) => {
  cy.request({
    method: 'POST',
    url: '/api/login',
    body: { email, password }
  }).then((response) => {
    window.localStorage.setItem('authToken', response.body.token)
  })
})

// Custom assertion
Cypress.Commands.add('shouldBeLoggedIn', () => {
  cy.get('.user-menu').should('be.visible')
  cy.url().should('include', '/dashboard')
})
```

```javascript
// Using custom commands in tests
// cypress/e2e/using_custom_commands.cy.js

describe('Using Custom Commands', () => {

  it('should login and see dashboard', () => {
    cy.login('admin@test.com', 'pass123')
    cy.shouldBeLoggedIn()
  })

  it('should login via API and visit protected page', () => {
    cy.loginViaApi('admin@test.com', 'pass123')
    cy.visit('/dashboard')
    cy.get('h1').should('contain', 'Dashboard')
  })

})
```

---

## 13. ALIASES — Store References

```javascript
// cypress/e2e/aliases.cy.js

describe('Alias Examples', () => {

  it('alias for element', () => {
    cy.get('button[type="submit"]').as('submitBtn')
    cy.get('@submitBtn').click()
    cy.get('@submitBtn').should('be.disabled')
  })

  it('alias for intercept', () => {
    cy.intercept('GET', '/api/users').as('getUsers')
    cy.visit('/users')
    cy.wait('@getUsers')
    cy.get('.user-list').should('be.visible')
  })

  it('alias for fixture', () => {
    cy.fixture('user').as('userData')
    cy.get('@userData').then((data) => {
      cy.get('#email').type(data.validUser.username)
    })
  })

})
```

---

## 14. HOW CYPRESS HANDLES ASYNC (Key Interview Topic)

Cypress commands are **asynchronous but auto-queued** — do NOT use async/await.

```javascript
// WRONG — do not use async/await with cy commands
it('wrong way', async () => {
  await cy.get('button').click()  // DON'T DO THIS
})

// CORRECT — just chain commands, Cypress queues them automatically
it('correct way', () => {
  cy.visit('/page')
  cy.get('button').click()
  cy.get('.result').should('be.visible')
})

// When you need a value — use .then()
it('using then() for values', () => {
  cy.get('.price').invoke('text').then((text) => {
    const price = parseFloat(text)
    expect(price).to.be.gt(0)
  })
})
```

---

## 15. ENVIRONMENT VARIABLES

```javascript
// cypress.config.js
module.exports = defineConfig({
  e2e: {
    baseUrl: 'https://staging.example.com',
    env: {
      username: 'admin',
      password: 'pass123',
      apiUrl: 'https://api.example.com'
    }
  }
})
```

```javascript
// Using env vars in tests
cy.visit(Cypress.env('apiUrl'))
cy.get('#user').type(Cypress.env('username'))

// Pass from command line (overrides config)
// npx cypress run --env username=newuser,password=newpass
```

---

## 16. RUNNING IN CI/CD — GitHub Actions

```yaml
# .github/workflows/cypress.yml

name: Cypress E2E Tests

on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main]

jobs:
  cypress-tests:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Run Cypress tests
        run: npx cypress run --headless --browser chrome

      - name: Upload screenshots on failure
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: cypress-screenshots
          path: cypress/screenshots
```

---

## 17. RUNNING IN JENKINS (Jenkinsfile)

```groovy
pipeline {
  agent any

  stages {
    stage('Install') {
      steps {
        sh 'npm ci'
      }
    }

    stage('Run Cypress Tests') {
      steps {
        sh 'npx cypress run --headless --browser chrome'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'cypress/screenshots/**/*', allowEmptyArchive: true
      junit 'cypress/results/*.xml'
    }
  }
}
```

---

## 18. PARALLEL TEST EXECUTION

```bash
# Using Cypress Cloud (official)
npx cypress run --record --key YOUR_RECORD_KEY --parallel

# Using cypress-parallel (open source)
npm install cypress-parallel --save-dev
npx cypress-parallel -s cy:run -t 4 -d cypress/e2e
```

---

## 19. PAGE OBJECT MODEL (POM) in Cypress

```javascript
// cypress/pages/LoginPage.js

class LoginPage {
  visit() {
    cy.visit('/login')
  }

  enterEmail(email) {
    cy.get('#email').clear().type(email)
  }

  enterPassword(password) {
    cy.get('#password').clear().type(password)
  }

  clickSubmit() {
    cy.get('button[type="submit"]').click()
  }

  getErrorMessage() {
    return cy.get('.error-message')
  }

  login(email, password) {
    this.visit()
    this.enterEmail(email)
    this.enterPassword(password)
    this.clickSubmit()
  }
}

export default new LoginPage()
```

```javascript
// cypress/e2e/login_pom.cy.js
import LoginPage from '../pages/LoginPage'

describe('Login Tests with POM', () => {

  it('should login successfully', () => {
    LoginPage.login('admin@test.com', 'pass123')
    cy.url().should('include', '/dashboard')
  })

  it('should show error for wrong password', () => {
    LoginPage.login('admin@test.com', 'wrongpass')
    LoginPage.getErrorMessage().should('contain', 'Invalid')
  })

})
```

---

## 20. RETRY-ABILITY (Key Interview Topic)

Cypress automatically retries DOM assertions until they pass or timeout.

```javascript
// Cypress keeps retrying .should() until it passes or defaultCommandTimeout expires
cy.get('.spinner').should('not.exist')      // waits for spinner to disappear
cy.get('.data-loaded').should('be.visible') // waits for element to appear

// cy.get() retries finding the element too
cy.get('.dynamic-element').should('contain', 'Loaded')

// Only queries and assertions retry — actions like .click() do NOT retry
```

---

## 21. IFRAME HANDLING

```bash
npm install cypress-iframe --save-dev
```

```javascript
// cypress/support/e2e.js
import 'cypress-iframe'

// In test:
it('should interact with iframe', () => {
  cy.visit('/page-with-iframe')
  cy.frameLoaded('#my-iframe')
  cy.iframe('#my-iframe').find('button').click()
  cy.iframe('#my-iframe').find('.result').should('contain', 'Success')
})
```

---

## 22. SCREENSHOTS AND VIDEOS

```javascript
// Take manual screenshot
cy.screenshot('login-page')
cy.screenshot('after-click', { capture: 'viewport' })

// Auto screenshots on failure — enabled by default
// screenshotOnRunFailure: true  (in cypress.config.js)

// Disable video recording to speed up tests
// video: false  (in cypress.config.js)
```

---

## 23. TOP INTERVIEW QUESTIONS AND ANSWERS

**Q1: How does Cypress differ from Selenium?**
Cypress runs inside the browser; Selenium is external via WebDriver. Cypress auto-waits; Selenium needs explicit waits. Cypress is JS/TS only; Selenium supports multiple languages.

**Q2: What is retry-ability in Cypress?**
Cypress automatically retries assertions and queries until they pass or `defaultCommandTimeout` expires. Actions like `.click()` do NOT retry, but `.get()` + `.should()` do.

**Q3: How do you handle async operations?**
Cypress is inherently async — all commands are queued automatically. Do NOT use async/await. Use `.then()` when you need to work with a value from a command.

**Q4: What is cy.intercept() used for?**
To stub (mock) API responses for isolated testing, to spy on real requests and assert request/response data, and to simulate network failures.

**Q5: How do you run Cypress in CI/CD?**
`npx cypress run --headless --browser chrome` — integrate with GitHub Actions or Jenkins. Use `--record` with Cypress Cloud for parallel runs.

**Q6: Difference between cy.get() and cy.contains()?**
`cy.get()` selects by CSS selector. `cy.contains()` selects by text content. `cy.contains('button', 'Login')` combines element type and text.

**Q7: How do you handle multiple tabs in Cypress?**
Cypress does NOT support multiple tabs natively. Workaround: remove `target="_blank"` attribute or test the URL directly with `cy.request()`.

**Q8: What is cy.wrap() used for?**
Wraps a value so you can use Cypress commands (like `.should()`) on non-Cypress objects.
```javascript
cy.wrap({ name: 'John' }).should('have.property', 'name', 'John')
```

---

## 24. COMPLETE REAL-WORLD TEST EXAMPLE

```javascript
// cypress/e2e/e2e_full_example.cy.js

describe('E2E: Product Purchase Flow', () => {

  beforeEach(() => {
    cy.request({
      method: 'POST',
      url: '/api/auth/login',
      body: { email: 'user@test.com', password: 'Test@123' }
    }).then((res) => {
      window.localStorage.setItem('token', res.body.token)
    })
  })

  it('should complete purchase flow end to end', () => {
    cy.intercept('POST', '/api/cart/add').as('addToCart')
    cy.intercept('POST', '/api/orders').as('placeOrder')

    cy.visit('/products')
    cy.get('[data-testid="product-card"]').first().as('firstProduct')

    cy.get('@firstProduct').find('.product-name').invoke('text').as('productName')

    cy.get('@firstProduct').find('[data-testid="add-to-cart"]').click()
    cy.wait('@addToCart').its('response.statusCode').should('eq', 200)

    cy.get('[data-testid="cart-icon"]').click()
    cy.url().should('include', '/cart')

    cy.get('@productName').then((name) => {
      cy.get('.cart-item-name').should('contain', name)
    })

    cy.get('[data-testid="checkout-btn"]').click()
    cy.get('#card-number').type('4111111111111111')
    cy.get('#expiry').type('12/26')
    cy.get('#cvv').type('123')
    cy.get('[data-testid="place-order-btn"]').click()

    cy.wait('@placeOrder').then((interception) => {
      expect(interception.response.statusCode).to.eq(201)
    })

    cy.url().should('include', '/order-success')
    cy.get('.confirmation-msg').should('contain', 'Order placed successfully')
  })

})
```

---

## QUICK COMMAND REFERENCE CARD

```
cy.visit(url)                    → navigate to URL
cy.get(selector)                 → find element by CSS
cy.contains(text)                → find by text content
cy.click()                       → click element
cy.type('text')                  → type into input
cy.clear()                       → clear input field
cy.check() / cy.uncheck()        → checkbox toggle
cy.select('value')               → select dropdown option
cy.should('assertion')           → assert on element
cy.intercept(method, url)        → mock or spy on API call
cy.request(method, url)          → make direct HTTP call
cy.fixture('file')               → load test data from JSON
cy.wait('@alias')                → wait for aliased intercept
cy.screenshot()                  → take screenshot
cy.scrollTo('bottom')            → scroll page
cy.invoke('text')                → get property/attribute value
cy.wrap(value)                   → wrap value for assertions
cy.log('message')                → print to Cypress log
cy.clearCookies()                → clear all cookies
cy.clearLocalStorage()           → clear local storage
cy.url()                         → get current URL
cy.title()                       → get page title
cy.reload()                      → reload page
cy.go('back')                    → browser back
cy.go('forward')                 → browser forward
```
