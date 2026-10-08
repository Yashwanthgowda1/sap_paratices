# Interview Q&A — 5 Years Experience
## Python | Selenium | Robot Framework | Appium | API Testing | Playwright vs Selenium

---

# SECTION 1: PYTHON

---

## 1. What is the difference between deepcopy and shallow copy?

**Shallow copy** creates a new object but inserts references to the objects found in the original.
**Deep copy** creates a new object and recursively copies all nested objects.

```python
import copy

original = {"user": {"name": "John", "roles": ["admin", "user"]}}

shallow = copy.copy(original)
deep = copy.deepcopy(original)

original["user"]["name"] = "Jane"
print(shallow["user"]["name"])  # Jane  — shared reference
print(deep["user"]["name"])     # John  — independent copy
```

**In test frameworks:** Use deepcopy when passing test data dicts to tests so one test's mutation doesn't affect another.

---

## 2. Explain Python's GIL. How does it impact parallel test execution?

The **Global Interpreter Lock (GIL)** is a mutex in CPython that allows only one thread to execute Python bytecode at a time.

**Impact on pytest-xdist:**
- `pytest-xdist` uses **multiprocessing** (separate processes), not threads — so the GIL is irrelevant. Each worker is a separate Python interpreter with its own GIL.
- Thread-based parallelism (`threading`) is blocked by the GIL for CPU-bound tasks but works fine for I/O-bound tasks (like waiting for browser responses).

```bash
pytest -n 4   # spawns 4 separate worker processes — bypasses GIL
```

---

## 3. Write a retry decorator that retries a function n times on exception.

```python
import time
import functools

def retry(times=3, delay=1, exceptions=(Exception,)):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(1, times + 1):
                try:
                    return func(*args, **kwargs)
                except exceptions as e:
                    if attempt == times:
                        raise
                    time.sleep(delay)
            return None
        return wrapper
    return decorator

@retry(times=3, delay=2)
def click_button(driver, locator):
    driver.find_element(*locator).click()
```

---

## 4. Explain *args and **kwargs. How do you use them in fixture factories?

- `*args` — collects extra positional arguments as a tuple
- `**kwargs` — collects extra keyword arguments as a dict

```python
# Fixture factory using **kwargs
@pytest.fixture
def api_client_factory():
    def _factory(base_url, **kwargs):
        session = requests.Session()
        session.headers.update({"Content-Type": "application/json"})
        if "token" in kwargs:
            session.headers["Authorization"] = f"Bearer {kwargs['token']}"
        if "timeout" in kwargs:
            session.request = functools.partial(session.request, timeout=kwargs["timeout"])
        return session
    return _factory

def test_api(api_client_factory):
    client = api_client_factory("https://api.example.com", token="abc123", timeout=30)
```

---

## 5. Difference between @staticmethod, @classmethod, and instance methods?

| Type | Access to `self` | Access to `cls` | Use case |
|---|---|---|---|
| Instance method | Yes | Via `self.__class__` | Normal operations on object state |
| `@classmethod` | No | Yes | Alternative constructors, factory methods |
| `@staticmethod` | No | No | Utility functions logically grouped with class |

```python
class LoginPage:
    BASE_URL = "https://app.example.com"

    def __init__(self, driver):
        self.driver = driver

    def enter_password(self, pwd):          # instance method
        self.driver.find_element(*self.PASSWORD).send_keys(pwd)

    @classmethod
    def from_config(cls, driver, config):   # factory — creates LoginPage using config
        page = cls(driver)
        page.driver.get(config.base_url)
        return page

    @staticmethod
    def is_valid_email(email):              # utility — no state needed
        return "@" in email and "." in email.split("@")[-1]
```

---

## 6. How does Python's `with` statement work? What are __enter__ and __exit__?

The `with` statement calls `__enter__` on entry and `__exit__` on exit (even on exception).

```python
class BrowserSession:
    def __init__(self, browser="chrome"):
        self.browser = browser
        self.driver = None

    def __enter__(self):
        self.driver = webdriver.Chrome()
        return self.driver

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.driver.quit()
        return False  # don't suppress exceptions

# Usage
with BrowserSession() as driver:
    driver.get("https://example.com")
    # driver.quit() is called automatically
```

---

## 7. What are generators and yield? When would you use a generator for test data?

A generator function uses `yield` to produce values lazily — one at a time — without storing all in memory.

```python
# Eager — loads all 10,000 users into memory
def get_all_users_list():
    return [generate_user(i) for i in range(10000)]

# Lazy generator — produces one user at a time
def get_all_users_gen():
    for i in range(10000):
        yield generate_user(i)

# In tests — parametrize with generator for large datasets
def user_data_generator():
    for row in read_csv("users.csv"):
        yield row["email"], row["password"]

@pytest.mark.parametrize("email,password", user_data_generator())
def test_login(email, password): ...
```

---

## 8. List comprehensions vs generator expressions — memory difference?

```python
# List comprehension — builds full list in memory immediately
squares_list = [x**2 for x in range(1_000_000)]  # ~8MB

# Generator expression — lazy, produces one item at a time
squares_gen = (x**2 for x in range(1_000_000))    # ~120 bytes

# Use generator when you only need to iterate once:
total = sum(x**2 for x in range(1_000_000))
```

---

## 9. What is a lambda? How do you use it in sorted()?

```python
test_results = [
    {"name": "test_login", "duration": 2.5, "status": "passed"},
    {"name": "test_search", "duration": 0.8, "status": "failed"},
    {"name": "test_home", "duration": 1.2, "status": "passed"},
]

# Sort by duration descending
sorted_results = sorted(test_results, key=lambda x: x["duration"], reverse=True)

# Sort failed first, then by name
sorted_results = sorted(test_results, key=lambda x: (x["status"] != "failed", x["name"]))
```

---

## 10. Explain __init__, __str__, __repr__, __eq__ dunder methods.

```python
class TestResult:
    def __init__(self, name, status, duration):
        self.name = name
        self.status = status
        self.duration = duration

    def __str__(self):        # human-readable — used by print()
        return f"{self.name}: {self.status} ({self.duration}s)"

    def __repr__(self):       # developer-readable — used in debugger/logs
        return f"TestResult(name={self.name!r}, status={self.status!r})"

    def __eq__(self, other):  # equality comparison — used in assertions
        return self.name == other.name and self.status == other.status

result = TestResult("test_login", "passed", 1.5)
print(result)        # test_login: passed (1.5s)
repr(result)         # TestResult(name='test_login', status='passed')
```

---

## 11. What are the four pillars of OOP with test automation examples?

1. **Encapsulation** — Page object hides locators and raw Selenium calls; test only calls `login_page.login(email, password)`.
2. **Inheritance** — `LoginPage` extends `BasePage` which holds common `find`, `click`, `wait` methods.
3. **Polymorphism** — `BasePage.navigate()` is overridden in `LoginPage` to also accept a path parameter.
4. **Abstraction** — `BasePage` is an abstract class; you never instantiate it directly.

---

## 12. What is MRO (Method Resolution Order) in Python?

Python uses **C3 linearization** to determine the order in which base classes are searched.

```python
class A:
    def hello(self): print("A")

class B(A):
    def hello(self): print("B")

class C(A):
    def hello(self): print("C")

class D(B, C): pass  # MRO: D -> B -> C -> A

D().hello()          # prints "B"
print(D.__mro__)     # (<class 'D'>, <class 'B'>, <class 'C'>, <class 'A'>, <class 'object'>)
```

---

## 13. Difference between `is` and `==`?

- `==` checks **value equality** (calls `__eq__`)
- `is` checks **identity** — same object in memory

```python
a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(a == b)   # True  — same values
print(a is b)   # False — different objects
print(a is c)   # True  — same object

# Common bug: never use `is` to compare strings/ints in general code
status = "passed"
if status == "passed": ...   # correct
if status is "passed": ...   # WRONG — may work by coincidence due to string interning
```

---

## 14. What is @property? How does it help in page objects?

```python
class SearchPage(BasePage):
    _SEARCH_INPUT = (By.ID, "search-input")
    _RESULTS = (By.CSS_SELECTOR, ".result-item")

    @property
    def search_input(self):
        return self.wait.until(EC.visibility_of_element_located(self._SEARCH_INPUT))

    @property
    def result_count(self):
        return len(self.driver.find_elements(*self._RESULTS))

# Test reads naturally:
search_page.search_input.send_keys("Avengers")
assert search_page.result_count > 0
```

---

## 15. Abstract class vs interface using abc module?

```python
from abc import ABC, abstractmethod

class BasePage(ABC):
    def __init__(self, driver):
        self.driver = driver

    @abstractmethod
    def is_loaded(self) -> bool:
        """Each page must implement its own loaded check."""
        ...

    def wait_for_load(self):
        WebDriverWait(self.driver, 10).until(lambda d: self.is_loaded())

class LoginPage(BasePage):
    def is_loaded(self) -> bool:
        return self.driver.find_element(By.ID, "login-form").is_displayed()
```

---

## 16. Custom context manager for WebDriver lifecycle?

```python
from contextlib import contextmanager

@contextmanager
def browser_session(browser="chrome", headless=False):
    options = ChromeOptions()
    if headless:
        options.add_argument("--headless")
    driver = webdriver.Chrome(options=options)
    try:
        yield driver
    finally:
        driver.quit()

def test_homepage():
    with browser_session(headless=True) as driver:
        driver.get("https://example.com")
        assert "Home" in driver.title
```

---

## 17. threading vs multiprocessing vs asyncio — which for parallel API tests?

| | threading | multiprocessing | asyncio |
|---|---|---|---|
| GIL | Limited by GIL | No GIL (separate processes) | Single thread, event loop |
| Best for | I/O-bound tasks | CPU-bound tasks | High-concurrency I/O |
| API testing | Good | Overkill | Best for 100s of concurrent requests |

**For parallel API tests:** `asyncio` + `aiohttp` is best for high concurrency. `threading` is fine for moderate parallelism. Use `pytest-xdist` with multiprocessing for test isolation.

```python
import asyncio, aiohttp

async def fetch(session, url):
    async with session.get(url) as resp:
        return await resp.json()

async def run_parallel_api_tests():
    async with aiohttp.ClientSession() as session:
        tasks = [fetch(session, f"/api/item/{i}") for i in range(100)]
        results = await asyncio.gather(*tasks)
```

---

## 18. What are dataclasses? How do they replace plain dicts for test data?

```python
from dataclasses import dataclass, field
from typing import List

@dataclass
class User:
    email: str
    password: str
    role: str = "standard"
    permissions: List[str] = field(default_factory=list)

    def is_admin(self) -> bool:
        return self.role == "admin"

# Usage — type-safe, IDE autocomplete, no KeyError
user = User(email="test@example.com", password="Secret123")
user.role = "admin"
assert user.is_admin()
```

---

## 19. What is conftest.py scope — root vs nested?

- **Root conftest.py** — fixtures available to ALL tests in the project
- **Nested conftest.py** (e.g., `tests/ui/conftest.py`) — fixtures available only to tests in that directory and below

This allows you to have a global `driver` fixture at root while a `player_page` fixture only exists in `tests/ui/player/`.

---

## 20. Explain fixture scope trade-offs for WebDriver?

```python
# function scope — new browser per test (isolated, slow)
@pytest.fixture(scope="function")
def driver():
    d = webdriver.Chrome()
    yield d
    d.quit()

# class scope — shared browser across all tests in a class (faster, less isolated)
@pytest.fixture(scope="class")
def driver_class():
    d = webdriver.Chrome()
    yield d
    d.quit()

# session scope — one browser for all tests (fastest, high coupling risk)
@pytest.fixture(scope="session")
def driver_session():
    d = webdriver.Chrome()
    yield d
    d.quit()
```

**Best practice:** Use `function` scope for isolation. Use `class` scope for flows that logically share state (e.g., login once, run several profile tests).

---

## 21. How does pytest.mark.parametrize work with indirect?

```python
@pytest.fixture
def user(request):
    users = {
        "admin": User("admin@test.com", "Admin123"),
        "premium": User("premium@test.com", "Premium123"),
        "free": User("free@test.com", "Free123"),
    }
    return users[request.param]

@pytest.mark.parametrize("user", ["admin", "premium", "free"], indirect=True)
def test_profile_access(user, logged_in_driver):
    # user fixture receives the param value via request.param
    assert user.role in logged_in_driver.get_accessible_sections()
```

---

## 22. What is monkeypatch? How do you use it for env variables?

```python
def test_config_reads_env(monkeypatch):
    monkeypatch.setenv("BASE_URL", "https://staging.example.com")
    monkeypatch.setenv("BROWSER", "firefox")

    config = Config()  # reads from env inside

    assert config.base_url == "https://staging.example.com"
    assert config.browser == "firefox"

# monkeypatch also patches attributes and functions:
monkeypatch.setattr(LoginPage, "submit", lambda self: None)  # mock submit
```

---

---

# SECTION 2: SELENIUM

---

## 1. Selenium WebDriver architecture — how does it communicate with the browser?

```
Test Script (Python)
      |
      | HTTP (W3C WebDriver Protocol)
      v
WebDriver Server (chromedriver.exe / geckodriver)
      |
      | CDP / browser automation protocol
      v
Browser (Chrome / Firefox / Edge)
```

1. Your Python code calls `driver.find_element()`
2. Selenium sends a JSON HTTP request to the local WebDriver server
3. The WebDriver translates this to browser-specific commands
4. Browser executes the command and returns the result as JSON

**Selenium 4** added direct CDP support, eliminating some round-trips.

---

## 2. find_element vs find_elements — exceptions?

```python
driver.find_element(By.ID, "login-btn")
# Returns: single WebElement
# Raises:  NoSuchElementException if not found

driver.find_elements(By.CLASS_NAME, "result-item")
# Returns: list of WebElements (empty list [] if none found — NO exception)

# Best practice: use find_elements to check existence
elements = driver.find_elements(By.ID, "modal")
if elements:
    elements[0].click()
```

---

## 3. Implicit wait vs explicit wait vs fluent wait?

```python
# Implicit wait — global, applies to every find_element call
driver.implicitly_wait(10)  # polls for 10s before raising NoSuchElementException

# Explicit wait — waits for a specific condition on a specific element
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

wait = WebDriverWait(driver, 10)
element = wait.until(EC.visibility_of_element_located((By.ID, "submit-btn")))

# Fluent wait — explicit wait with custom polling interval and ignored exceptions
from selenium.webdriver.support.ui import WebDriverWait

wait = WebDriverWait(driver, timeout=10, poll_frequency=0.5,
                     ignored_exceptions=[StaleElementReferenceException])
element = wait.until(EC.element_to_be_clickable((By.ID, "submit-btn")))
```

**Prefer explicit wait.** Never mix implicit and explicit waits — they interact unpredictably.

---

## 4. What is StaleElementReferenceException? How do you handle it?

Thrown when a reference to a DOM element is no longer valid — the page was refreshed, navigated, or the element was re-rendered.

```python
def safe_click(driver, locator, retries=3):
    for _ in range(retries):
        try:
            WebDriverWait(driver, 10).until(
                EC.element_to_be_clickable(locator)
            ).click()
            return
        except StaleElementReferenceException:
            pass

# Or use fluent wait with ignored exceptions:
wait = WebDriverWait(driver, 10, ignored_exceptions=[StaleElementReferenceException])
wait.until(EC.element_to_be_clickable(locator)).click()
```

---

## 5. driver.close() vs driver.quit()?

```python
driver.close()   # closes the CURRENT tab/window only; WebDriver session stays alive
driver.quit()    # closes ALL windows and kills the WebDriver process entirely
```

Always use `driver.quit()` in teardown to prevent orphaned chromedriver processes.

---

## 6. Handling multiple windows/tabs?

```python
# Open new tab via JS
driver.execute_script("window.open('https://example.com', '_blank');")

original_window = driver.current_window_handle
all_windows = driver.window_handles

# Switch to new tab
for window in all_windows:
    if window != original_window:
        driver.switch_to.window(window)
        break

# Do work in new tab...
driver.close()  # close new tab

# Switch back to original
driver.switch_to.window(original_window)
```

---

## 7. How do you handle iframes?

```python
# Switch by index
driver.switch_to.frame(0)

# Switch by name or id
driver.switch_to.frame("payment-iframe")

# Switch by WebElement
iframe = driver.find_element(By.CSS_SELECTOR, "iframe.video-player")
driver.switch_to.frame(iframe)

# Go back to main content
driver.switch_to.default_content()

# Go up one level (nested iframes)
driver.switch_to.parent_frame()
```

---

## 8. How do you handle alerts?

```python
from selenium.webdriver.support import expected_conditions as EC

# Wait for alert
alert = WebDriverWait(driver, 5).until(EC.alert_is_present())

# Read text
print(alert.text)

# Accept (OK)
alert.accept()

# Dismiss (Cancel)
alert.dismiss()

# Send text (prompt)
alert.send_keys("my input")
alert.accept()
```

---

## 9. XPath vs CSS Selector — when to prefer which?

| | XPath | CSS Selector |
|---|---|---|
| Speed | Slightly slower | Faster |
| Readability | Verbose | Cleaner |
| Traversal | Can go up (parent axis) | Cannot go to parent |
| Text matching | `//button[text()='Login']` | Not natively supported |
| Attribute | `//input[@placeholder='Email']` | `input[placeholder='Email']` |

**Prefer CSS Selector** for speed and readability. **Use XPath** when you need parent traversal or text-based matching.

```python
# CSS
driver.find_element(By.CSS_SELECTOR, "button[data-testid='login-btn']")

# XPath — text match
driver.find_element(By.XPATH, "//button[normalize-space()='Sign In']")

# XPath — parent traversal
driver.find_element(By.XPATH, "//input[@id='email']/ancestor::form")
```

---

## 10. What is ActionChains? Examples?

```python
from selenium.webdriver import ActionChains

actions = ActionChains(driver)

# Hover over menu to reveal submenu
actions.move_to_element(menu_item).perform()

# Drag and drop
actions.drag_and_drop(source, target).perform()

# Right-click
actions.context_click(element).perform()

# Double-click
actions.double_click(element).perform()

# Key combination: Ctrl+A, then Delete
actions.key_down(Keys.CONTROL).send_keys("a").key_up(Keys.CONTROL).send_keys(Keys.DELETE).perform()

# Chain multiple actions
actions.move_to_element(menu).click().pause(0.5).move_to_element(submenu).click().perform()
```

---

## 11. How do you upload a file?

```python
# Standard file input
file_input = driver.find_element(By.CSS_SELECTOR, "input[type='file']")
file_input.send_keys("/absolute/path/to/file.pdf")

# Hidden file input — make it visible first via JS
driver.execute_script("arguments[0].style.display = 'block';", file_input)
file_input.send_keys("/path/to/file.pdf")

# Using pyautogui for OS-level file dialog (last resort)
import pyautogui, time
upload_btn.click()
time.sleep(1)
pyautogui.typewrite("/path/to/file.pdf")
pyautogui.press("enter")
```

---

## 12. JavaScript execution — 3 real-world use cases?

```python
# 1. Scroll element into view
driver.execute_script("arguments[0].scrollIntoView({block: 'center'});", element)

# 2. Click an element that is obscured/covered by another element
driver.execute_script("arguments[0].click();", element)

# 3. Set input value directly (bypasses React/Angular onChange issues)
driver.execute_script("arguments[0].value = arguments[1];", input_el, "test@example.com")

# 4. Scroll to bottom of page
driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

# 5. Get computed style
color = driver.execute_script(
    "return window.getComputedStyle(arguments[0]).backgroundColor;", element
)
```

---

## 13. Page Object Model (POM) — implementation?

```python
# pages/base_page.py
class BasePage:
    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10)

    def find(self, locator):
        return self.wait.until(EC.presence_of_element_located(locator))

    def click(self, locator):
        self.wait.until(EC.element_to_be_clickable(locator)).click()

    def type(self, locator, text):
        el = self.find(locator)
        el.clear()
        el.send_keys(text)

# pages/login_page.py
class LoginPage(BasePage):
    EMAIL    = (By.ID, "email")
    PASSWORD = (By.ID, "password")
    SUBMIT   = (By.CSS_SELECTOR, "button[type='submit']")
    ERROR    = (By.CLASS_NAME, "error-message")

    def login(self, email, password):
        self.type(self.EMAIL, email)
        self.type(self.PASSWORD, password)
        self.click(self.SUBMIT)

    def get_error(self):
        return self.find(self.ERROR).text
```

---

## 14. Selenium Grid for cross-browser parallel execution?

```bash
# Start Hub
java -jar selenium-server.jar hub

# Register Chrome Node
java -jar selenium-server.jar node --hub http://localhost:4444

# In Python — point to Grid
from selenium.webdriver.remote.webdriver import RemoteWebDriver

options = ChromeOptions()
driver = RemoteWebDriver(
    command_executor="http://grid-host:4444/wd/hub",
    options=options
)
```

With **pytest-xdist** + Grid: each worker process creates its own RemoteWebDriver session pointing to the Grid hub.

---

## 15. Chrome DevTools Protocol (CDP) in Selenium 4?

```python
# Intercept network requests
driver.execute_cdp_cmd("Network.enable", {})
driver.execute_cdp_cmd("Network.setExtraHTTPHeaders", {"headers": {"X-Test-Header": "true"}})

# Mock geolocation
driver.execute_cdp_cmd("Emulation.setGeolocationOverride", {
    "latitude": 37.7749, "longitude": -122.4194, "accuracy": 100
})

# Capture console logs
driver.execute_cdp_cmd("Runtime.enable", {})

# Emulate slow network
driver.execute_cdp_cmd("Network.emulateNetworkConditions", {
    "offline": False,
    "downloadThroughput": 500 * 1024 / 8,
    "uploadThroughput": 500 * 1024 / 8,
    "latency": 200
})
```

---

## 16. Debugging a test that fails in CI but passes locally?

**Systematic approach:**
1. **Screenshot on failure** — capture the browser state at point of failure
2. **Headless differences** — some elements behave differently headless; check window size: `driver.set_window_size(1920, 1080)`
3. **Timing issues** — CI is slower; increase explicit wait timeouts for CI
4. **Environment variables** — verify credentials, URLs, feature flags in CI match expectations
5. **Browser version** — CI may have a different Chrome version; pin chromedriver version
6. **Page load speed** — add `driver.implicitly_wait(0)` and rely on explicit waits only
7. **Video recording** — use `pytest-video` or Allure video attachment in CI

---

---

# SECTION 3: ROBOT FRAMEWORK

---

## 1. What is Robot Framework? Architecture?

Robot Framework is a **keyword-driven, data-driven test automation framework** with a plain-text syntax (`.robot` files).

**Architecture:**
```
.robot files (Test Cases + Keywords)
        |
  Robot Framework Core
        |
   +---------+---------+
   |                   |
Libraries          Resource Files
(SeleniumLibrary,  (custom keywords)
 RequestsLibrary,
 BuiltIn, etc.)
        |
  Browser/API/System
```

---

## 2. Four sections of a Robot Framework file?

```robot
*** Settings ***
Library           SeleniumLibrary
Resource          resources/common.resource
Suite Setup       Open Browser    ${URL}    chrome
Suite Teardown    Close Browser
Test Timeout      2 minutes

*** Variables ***
${URL}            https://example.com
${VALID_USER}     testuser@example.com
${VALID_PASS}     Secret123

*** Test Cases ***
TC-AUTH-001 Valid Login
    [Tags]    sanity    auth
    [Documentation]    User logs in with valid credentials
    Navigate To Login Page
    Enter Credentials    ${VALID_USER}    ${VALID_PASS}
    Click Login Button
    Home Page Should Be Displayed

*** Keywords ***
Enter Credentials
    [Arguments]    ${email}    ${password}
    Input Text    id=email    ${email}
    Input Text    id=password    ${password}
```

---

## 3. Resource file vs Library?

- **Resource file** (`.resource` or `.robot`) — contains custom keywords written in Robot Framework syntax; reusable across test suites
- **Library** — a Python module (`.py`) that provides keywords as Python methods; used for complex logic that can't be expressed in RF syntax

```robot
# Resource file
*** Keywords ***
Navigate To Login Page
    Go To    ${LOGIN_URL}
    Wait Until Element Is Visible    id=login-form
```

```python
# Python Library
class CustomLibrary:
    def generate_otp(self, length=6):
        """Generates a random OTP."""
        return ''.join([str(random.randint(0, 9)) for _ in range(length)])
```

---

## 4. Writing a custom Python library for Robot Framework?

```python
# libraries/DatabaseLibrary.py
class DatabaseLibrary:
    ROBOT_LIBRARY_SCOPE = "SUITE"   # or TEST, GLOBAL

    def __init__(self, host, port=5432):
        self.conn = None
        self.host = host
        self.port = port

    def connect_to_database(self, user, password, database):
        """Connects to PostgreSQL database."""
        import psycopg2
        self.conn = psycopg2.connect(
            host=self.host, port=self.port,
            user=user, password=password, database=database
        )

    def query_should_return_rows(self, sql):
        """Fails if SQL query returns no rows."""
        cursor = self.conn.cursor()
        cursor.execute(sql)
        rows = cursor.fetchall()
        assert len(rows) > 0, f"Query returned no rows: {sql}"
        return rows
```

```robot
*** Settings ***
Library    libraries/DatabaseLibrary.py    host=localhost

*** Test Cases ***
TC-DB-001 Verify User Created
    Connect To Database    admin    secret    testdb
    Query Should Return Rows    SELECT * FROM users WHERE email='test@example.com'
```

---

## 5. Data-Driven Testing in Robot Framework?

```robot
*** Test Cases ***
TC-AUTH Login With Multiple Users
    [Template]    Verify Login
    valid@test.com       Secret123     Home Page
    admin@test.com       Admin456      Admin Dashboard
    premium@test.com     Premium789    Premium Home

*** Keywords ***
Verify Login
    [Arguments]    ${email}    ${password}    ${expected_page}
    Navigate To Login Page
    Input Text     id=email       ${email}
    Input Text     id=password    ${password}
    Click Button   id=login-btn
    Page Should Contain    ${expected_page}
```

---

## 6. Robot Framework Listener — capture results programmatically?

```python
# listeners/MyListener.py
class MyListener:
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self):
        self.results = []

    def end_test(self, data, result):
        self.results.append({
            "name": result.name,
            "status": result.status,
            "message": result.message,
            "duration": result.elapsed_time.total_seconds()
        })

    def close(self):
        import json
        with open("test_results.json", "w") as f:
            json.dump(self.results, f, indent=2)
```

```bash
robot --listener listeners/MyListener.py tests/
```

---

## 7. Parallel execution with pabot?

```bash
pip install robotframework-pabot

# Run in parallel with 4 processes
pabot --processes 4 tests/

# Shard by suite
pabot --processes 4 --shard 1/4 tests/   # worker 1
pabot --processes 4 --shard 2/4 tests/   # worker 2
```

**Caution:** Shared state (browser sessions, test data) must be isolated per process.

---

---

# SECTION 4: APPIUM

---

## 1. Appium architecture — how it differs from Selenium?

```
Test Script (Python/Java)
        |
   HTTP (W3C WebDriver)
        |
   Appium Server (Node.js)
        |
   +----------+----------+
   |                     |
UiAutomator2          XCUITest
(Android)             (iOS)
   |                     |
Android Device/       iOS Simulator/
Emulator              Real Device
```

**Key difference from Selenium:** Appium sits between the client and the platform-specific driver (UiAutomator2 / XCUITest). It translates WebDriver commands into platform-native automation commands.

---

## 2. Key desired_capabilities / AppiumOptions?

```python
from appium.options import UiAutomator2Options

# Android
options = UiAutomator2Options()
options.platform_name = "Android"
options.device_name = "Pixel_6_API_33"
options.app = "/path/to/app.apk"
options.app_package = "com.jiohotstar.android"
options.app_activity = ".MainActivity"
options.automation_name = "UiAutomator2"
options.no_reset = False          # clear app data before session
options.full_reset = False        # uninstall + reinstall
options.auto_grant_permissions = True  # auto-grant all permissions

# iOS
from appium.options import XCUITestOptions
ios_options = XCUITestOptions()
ios_options.platform_name = "iOS"
ios_options.device_name = "iPhone 15"
ios_options.platform_version = "17.0"
ios_options.bundle_id = "com.jiohotstar.ios"
ios_options.automation_name = "XCUITest"
ios_options.wda_local_port = 8100
```

---

## 3. Locator strategies in Appium?

```python
from appium.webdriver.common.appiumby import AppiumBy

# Best — fastest, most reliable
driver.find_element(AppiumBy.ACCESSIBILITY_ID, "search-button")

# Android specific — uses UiSelector
driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR,
    'new UiSelector().text("Search").className("android.widget.Button")')

# iOS specific
driver.find_element(AppiumBy.IOS_CLASS_CHAIN, "**/XCUIElementTypeButton[`label == 'Search'`]")
driver.find_element(AppiumBy.IOS_PREDICATE, "type == 'XCUIElementTypeButton' AND label == 'Search'")

# Cross-platform
driver.find_element(AppiumBy.XPATH, "//android.widget.Button[@text='Search']")
driver.find_element(AppiumBy.ID, "com.example:id/search_btn")   # Android resource-id
```

---

## 4. Handling gestures with W3C Actions (Appium 2.x)?

```python
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.actions.wheel_input import ScrollOrigin
from selenium.webdriver.common.actions import interaction
from selenium.webdriver.common.actions.action_builder import ActionBuilder
from selenium.webdriver.common.actions.pointer_input import PointerInput

# Swipe up (scroll)
def swipe_up(driver):
    size = driver.get_window_size()
    start_x = size["width"] // 2
    start_y = int(size["height"] * 0.8)
    end_y = int(size["height"] * 0.2)

    finger = PointerInput(interaction.POINTER_TOUCH, "finger")
    actions = ActionBuilder(driver, mouse=finger)
    actions.pointer_action.move_to_location(start_x, start_y)
    actions.pointer_action.pointer_down()
    actions.pointer_action.move_to_location(start_x, end_y)
    actions.pointer_action.pointer_up()
    actions.perform()

# Long press
def long_press(driver, element):
    actions = ActionChains(driver)
    actions.click_and_hold(element).pause(2).release().perform()
```

---

## 5. Switching context in hybrid apps (Native + WebView)?

```python
# List available contexts
contexts = driver.contexts
print(contexts)
# ['NATIVE_APP', 'WEBVIEW_com.example.app', 'WEBVIEW_chrome']

# Switch to WebView
driver.switch_to.context("WEBVIEW_com.example.app")

# Now use Selenium-style locators for web content
driver.find_element(By.CSS_SELECTOR, "#login-form input[type='email']").send_keys("test@example.com")

# Switch back to native
driver.switch_to.context("NATIVE_APP")
```

**Important:** For WebView to be inspectable, the app must have `setWebContentsDebuggingEnabled(true)` (Android) or the device must allow web inspector (iOS).

---

## 6. Appium 1.x vs Appium 2.x differences?

| Aspect | Appium 1.x | Appium 2.x |
|---|---|---|
| Drivers | Bundled with server | Installed separately as plugins |
| Architecture | Monolith | Modular, plugin-based |
| Installation | `npm install -g appium` | `npm install -g appium` + `appium driver install uiautomator2` |
| Desired Caps | `desiredCapabilities` | `AppiumOptions` with `appium:` prefix |
| Plugins | Limited | Rich ecosystem (images, relaxed-caps, gestures) |

```bash
# Appium 2 setup
npm install -g appium@next
appium driver install uiautomator2
appium driver install xcuitest
appium plugin install images
```

---

## 7. Handling permission dialogs?

```python
# Android — auto-grant via capability
options.auto_grant_permissions = True

# Android — manually handle via UiAutomator
driver.find_element(AppiumBy.ID, "com.android.packageinstaller:id/permission_allow_button").click()

# iOS — using mobile: alert
driver.execute_script("mobile: alert", {"action": "accept"})

# Cross-platform helper
def handle_permission_dialog(driver, action="allow"):
    try:
        if driver.capabilities["platformName"].lower() == "android":
            btn_id = "com.android.packageinstaller:id/permission_allow_button" if action == "allow" \
                     else "com.android.packageinstaller:id/permission_deny_button"
            driver.find_element(AppiumBy.ID, btn_id).click()
        else:
            driver.execute_script("mobile: alert", {"action": "accept" if action == "allow" else "dismiss"})
    except Exception:
        pass  # no dialog present
```

---

---

# SECTION 5: API TESTING

---

## 1. REST vs SOAP?

| | REST | SOAP |
|---|---|---|
| Protocol | HTTP | HTTP, SMTP, TCP |
| Format | JSON, XML, plain text | XML only |
| Standards | Informal (OpenAPI/Swagger) | Strict (WSDL, XSD) |
| State | Stateless | Can be stateful |
| Overhead | Light | Heavy |
| When to use | Modern web/mobile APIs | Enterprise, banking, legacy systems |

---

## 2. HTTP methods and idempotency?

| Method | Purpose | Idempotent | Safe |
|---|---|---|---|
| GET | Retrieve | Yes | Yes |
| POST | Create | No | No |
| PUT | Replace (full update) | Yes | No |
| PATCH | Partial update | No (usually) | No |
| DELETE | Delete | Yes | No |

**Idempotent** = calling it N times produces the same result as calling it once.
**Testing implication:** You can safely retry GET, PUT, DELETE. Retrying POST creates duplicates.

---

## 3. Common HTTP status codes?

| Code | Meaning | Test scenario |
|---|---|---|
| 200 | OK | Successful GET/PUT/PATCH |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Missing required field, invalid format |
| 401 | Unauthorized | Missing or invalid token |
| 403 | Forbidden | Valid token but insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate resource |
| 422 | Unprocessable Entity | Validation errors |
| 429 | Too Many Requests | Rate limiting |
| 500 | Internal Server Error | Server-side bug |

---

## 4. OAuth 2.0 flows — how to test them?

```python
# Client Credentials Flow (service-to-service)
def get_access_token(client_id, client_secret, token_url):
    response = requests.post(token_url, data={
        "grant_type": "client_credentials",
        "client_id": client_id,
        "client_secret": client_secret,
    })
    assert response.status_code == 200
    token = response.json()["access_token"]
    assert token is not None
    return token

# Test token expiry
def test_expired_token_returns_401(api_client):
    api_client.headers["Authorization"] = "Bearer expired_or_invalid_token"
    response = api_client.get("/api/profile")
    assert response.status_code == 401
    assert response.json()["error"] == "token_expired"
```

---

## 5. JSON Schema validation?

```python
import jsonschema

user_schema = {
    "type": "object",
    "required": ["id", "email", "name", "created_at"],
    "properties": {
        "id":         {"type": "integer"},
        "email":      {"type": "string", "format": "email"},
        "name":       {"type": "string", "minLength": 1},
        "created_at": {"type": "string", "format": "date-time"},
        "role":       {"type": "string", "enum": ["admin", "premium", "standard"]}
    },
    "additionalProperties": False
}

def test_get_user_response_schema(api_client):
    response = api_client.get("/api/users/1")
    assert response.status_code == 200
    jsonschema.validate(instance=response.json(), schema=user_schema)
```

---

## 6. Chaining API calls (create → use → verify)?

```python
def test_end_to_end_booking_flow(api_client):
    # Step 1: Create user
    user_resp = api_client.post("/api/users", json={
        "email": "test@example.com", "password": "Test123"
    })
    assert user_resp.status_code == 201
    user_id = user_resp.json()["id"]

    # Step 2: Login
    token_resp = api_client.post("/api/auth/login", json={
        "email": "test@example.com", "password": "Test123"
    })
    assert token_resp.status_code == 200
    api_client.headers["Authorization"] = f"Bearer {token_resp.json()['access_token']}"

    # Step 3: Create booking
    booking_resp = api_client.post("/api/bookings", json={
        "content_id": "movie_123", "user_id": user_id
    })
    assert booking_resp.status_code == 201
    booking_id = booking_resp.json()["id"]

    # Step 4: Verify
    get_resp = api_client.get(f"/api/bookings/{booking_id}")
    assert get_resp.status_code == 200
    assert get_resp.json()["status"] == "confirmed"

    # Cleanup
    api_client.delete(f"/api/users/{user_id}")
```

---

## 7. Testing rate limiting?

```python
def test_rate_limit_returns_429(api_client):
    responses = []
    for _ in range(101):  # exceed limit of 100/min
        r = api_client.get("/api/search?q=avengers")
        responses.append(r.status_code)

    rate_limited = [r for r in responses if r == 429]
    assert len(rate_limited) > 0, "Rate limiting not enforced"

    # Check Retry-After header
    last_429 = api_client.get("/api/search?q=avengers")
    if last_429.status_code == 429:
        assert "Retry-After" in last_429.headers
        retry_after = int(last_429.headers["Retry-After"])
        assert retry_after > 0
```

---

## 8. Contract testing with Pact?

```python
# Consumer side — defines the contract
import pact

provider = pact.Consumer("StreamingApp").has_pact_with(pact.Provider("UserService"))

def test_get_user_contract():
    expected_user = {"id": 1, "email": "test@example.com", "name": "Test User"}

    (provider
     .given("user 1 exists")
     .upon_receiving("a request for user 1")
     .with_request("GET", "/api/users/1")
     .will_respond_with(200, body=expected_user))

    with provider:
        response = requests.get(f"{provider.uri}/api/users/1")
        assert response.json() == expected_user
```

**Consumer-driven contract tests** ensure that when the provider changes its API, the consumer's tests catch the breaking change — without needing the real provider to be running.

---

---

# SECTION 6: SELENIUM vs PLAYWRIGHT — IN-DEPTH

---

## 1. Architecture comparison?

| Aspect | Selenium | Playwright |
|---|---|---|
| Protocol | W3C WebDriver over HTTP | Chrome DevTools Protocol (CDP) + browser pipe |
| Driver | External (chromedriver, geckodriver) | Bundled browser binaries |
| Communication | HTTP request per command | Persistent WebSocket — lower latency |
| Browser support | Chrome, Firefox, Edge, Safari, IE | Chromium, Firefox, WebKit |
| Auto-waiting | No — manual explicit waits required | Yes — built into every action |
| Network interception | Via CDP (Selenium 4) | Native, built-in (`page.route()`) |

---

## 2. Playwright's auto-waiting vs Selenium's explicit waits?

**Selenium:** You must write explicit waits for every interaction.
```python
wait = WebDriverWait(driver, 10)
btn = wait.until(EC.element_to_be_clickable((By.ID, "submit")))
btn.click()
```

**Playwright:** Every action automatically waits for the element to be:
- Attached to DOM
- Visible
- Stable (not animating)
- Receives events
- Enabled

```python
page.click("#submit")  # auto-waits for all conditions above — no explicit wait needed
```

---

## 3. Playwright Locator vs Selenium WebElement?

**Selenium WebElement** is resolved immediately and can become stale:
```python
element = driver.find_element(By.ID, "btn")  # resolved NOW
# If page re-renders:
element.click()  # StaleElementReferenceException!
```

**Playwright Locator** is lazy — it finds the element at the time of action:
```python
locator = page.locator("#btn")  # NOT resolved yet — just a description
locator.click()   # resolved HERE — never stale
```

---

## 4. Network interception comparison?

**Selenium 4 (CDP):**
```python
driver.execute_cdp_cmd("Network.enable", {})
driver.execute_cdp_cmd("Network.setBlockedURLs", {"urls": ["*.ads.com*"]})
```

**Playwright:**
```python
# Intercept and mock
page.route("**/api/users/**", lambda route: route.fulfill(
    status=200,
    content_type="application/json",
    body='{"id": 1, "name": "Mock User"}'
))

# Block requests
page.route("**/*.{png,jpg,gif}", lambda route: route.abort())

# Modify request headers
def add_header(route):
    headers = {**route.request.headers, "X-Test": "true"}
    route.continue_(headers=headers)
page.route("**/api/**", add_header)
```

Playwright's network interception is far more powerful and expressive.

---

## 5. BrowserContext in Playwright vs Selenium WebDriver?

**Playwright BrowserContext** is like an incognito window — isolated cookies, storage, auth state — but multiple pages can share one context.

```python
browser = playwright.chromium.launch()

# Context 1 — Admin user session
admin_ctx = browser.new_context(storage_state="admin_auth.json")
admin_page = admin_ctx.new_page()

# Context 2 — Regular user session
user_ctx = browser.new_context(storage_state="user_auth.json")
user_page = user_ctx.new_page()

# Both run in parallel — no interference
```

In Selenium, each WebDriver instance is a full browser — heavier. Playwright contexts are lightweight, sharing the same browser process.

---

## 6. Parallel test execution — Playwright vs Selenium?

**Playwright:**
- Built-in parallelism at file level with `pytest-playwright`
- Workers share the browser process but use isolated contexts
- `playwright.config.ts` → `workers: 4`

**Selenium:**
- Requires `pytest-xdist` with separate processes
- Each worker spawns its own browser instance
- Heavier resource consumption

```python
# pytest.ini — Playwright parallel
# pytest -n 4 works with both

# Playwright conftest — multiple contexts
@pytest.fixture(scope="session")
def browser_context_args(browser_context_args):
    return {**browser_context_args, "viewport": {"width": 1920, "height": 1080}}
```

---

## 7. Authentication state management?

**Playwright — save and reuse auth state:**
```python
# setup_auth.py — run once
def test_save_auth_state(page):
    page.goto("https://app.example.com/login")
    page.fill("#email", "test@example.com")
    page.fill("#password", "Secret123")
    page.click("button[type='submit']")
    page.wait_for_url("**/home")
    page.context.storage_state(path="auth_state.json")

# conftest.py — reuse in all tests
@pytest.fixture
def authenticated_page(browser):
    context = browser.new_context(storage_state="auth_state.json")
    page = context.new_page()
    yield page
    context.close()
```

**Selenium equivalent:** No native storage state. You must re-login each time OR manually save/inject cookies:
```python
# Save cookies after login
cookies = driver.get_cookies()
pickle.dump(cookies, open("cookies.pkl", "wb"))

# Load cookies in next session
for cookie in pickle.load(open("cookies.pkl", "rb")):
    driver.add_cookie(cookie)
```

---

## 8. Playwright expect() with auto-retry vs assert?

```python
# Normal assert — fails immediately if condition not met
assert page.locator("#status").text_content() == "Success"  # may fail if DOM not updated yet

# Playwright expect — retries until timeout
from playwright.sync_api import expect
expect(page.locator("#status")).to_have_text("Success")             # retries for 5s default
expect(page.locator("#status")).to_have_text("Success", timeout=10000)  # custom timeout
expect(page.locator(".toast")).to_be_visible()
expect(page.locator("input#email")).to_have_value("test@example.com")
expect(page.locator(".error")).not_to_be_visible()
```

---

## 9. When to choose Playwright over Selenium?

**Choose Playwright when:**
- Starting a new project with no legacy constraints
- You need fast, reliable tests out of the box (auto-waiting eliminates most flakiness)
- You need powerful network interception, mocking, or API testing within UI tests
- You need parallel execution without heavyweight infrastructure
- Your team uses TypeScript/JavaScript as primary language
- You need Chromium, Firefox, and WebKit coverage (Safari engine)

**Stick with Selenium when:**
- Large existing Selenium test suite (migration cost too high)
- You need Safari on real macOS (Playwright's WebKit ≠ real Safari)
- You need Internet Explorer support
- Team expertise and tooling is deep in Selenium
- Your Grid infrastructure is already set up
- You need Java/.NET ecosystem with mature Selenium libraries

---

## 10. Shadow DOM handling — Playwright vs Selenium?

**Selenium — shadow DOM is hard:**
```python
# Must use JavaScript to pierce shadow DOM
shadow_host = driver.find_element(By.CSS_SELECTOR, "my-component")
shadow_root = driver.execute_script("return arguments[0].shadowRoot", shadow_host)
inner_element = shadow_root.find_element(By.CSS_SELECTOR, "input")
```

**Playwright — automatic shadow DOM piercing:**
```python
# CSS selectors automatically pierce shadow DOM
page.fill("my-component >> css=input", "test value")

# Or using locator
page.locator("input").fill("test value")  # finds input inside shadow DOM automatically
```

---

## 11. Playwright APIRequestContext — API testing within UI tests?

```python
# playwright conftest.py
@pytest.fixture
def api_request_context(playwright):
    context = playwright.request.new_context(base_url="https://api.example.com")
    yield context
    context.dispose()

def test_ui_reflects_api_data(page, api_request_context):
    # Create data via API
    response = api_request_context.post("/users", data={"name": "John", "email": "j@test.com"})
    assert response.ok
    user_id = response.json()["id"]

    # Verify via UI
    page.goto(f"https://app.example.com/users/{user_id}")
    expect(page.locator("h1")).to_have_text("John")

    # Cleanup via API
    api_request_context.delete(f"/users/{user_id}")
```

---

---

# SECTION 7: SCENARIO-BASED QUESTIONS

---

## 1. 2000 UI tests take 4 hours. How do you bring this under 30 minutes?

**Strategy:**
1. **Parallel execution** — `pytest-xdist -n auto` or Selenium Grid. 4 workers → ~1 hour
2. **Test classification** — Run only `sanity`/`smoke` (top 5%) in PR pipelines; full regression nightly
3. **Headless execution** — 2-3x faster than headed browsers
4. **Session-scoped fixtures** — Avoid re-login for every test; use `logged_in_driver` session fixture
5. **API setup instead of UI** — Use API calls to create test data instead of UI flows
6. **Remove redundant tests** — Identify duplicate coverage, merge or delete
7. **Browser reuse within class** — `scope="class"` for related tests
8. **CI hardware upgrade** — More cores → more parallel workers

**Target:** 4 parallel workers + headless + API setup → ~30-40 minutes achievable.

---

## 2. Test passes locally but fails in CI?

**Systematic debug:**
1. **Capture screenshot + page source** on failure in CI
2. **Check headless mode** — set window size: `options.add_argument("--window-size=1920,1080")`
3. **Check timing** — CI is slower; increase all explicit wait timeouts for CI using env variable
4. **Check environment** — different base URL, feature flags, credentials in CI
5. **Check browser version** — pin chromium version in requirements
6. **Check fonts/rendering** — some visual tests fail in headless due to missing fonts
7. **Add video recording** — `pytest-video` plugin

```python
# Adaptive timeout based on environment
import os
WAIT_TIMEOUT = int(os.getenv("SELENIUM_TIMEOUT", 10))
wait = WebDriverWait(driver, WAIT_TIMEOUT)
```

---

## 3. Design a test automation framework from scratch for an OTT app?

**Stack recommendation:**
- **Language:** Python 3.11+
- **UI Testing:** Selenium 4 + pytest (or Playwright for new projects)
- **API Testing:** requests + pytest
- **Mobile:** Appium 2 + pytest
- **Reporting:** Allure
- **Parallelism:** pytest-xdist
- **CI:** GitHub Actions

**Key design decisions:**
1. **POM** for all pages — encapsulate locators and interactions
2. **Fixture hierarchy** — session driver, class logged_in_driver, function-level page objects
3. **Centralized config** — .env for credentials, config.json for environment URLs
4. **Test data management** — Faker for generated data, JSON for static data, API for setup
5. **Tagging strategy** — sanity/smoke/regression/e2e markers for selective runs
6. **Parallel-safe** — no shared mutable state between tests

---

## 4. How do you implement retry logic without masking real failures?

```python
# pytest.ini
# --reruns 2 --reruns-delay 1 --only-rerun "TimeoutException|StaleElement"

# Only retry on known flaky exceptions
@pytest.mark.flaky(reruns=2, reruns_delay=1)
def test_video_player_loads():
    ...

# Track flaky tests — fail if test needed retries more than threshold in CI
# Use Allure's flaky test detection to identify patterns

# NEVER retry on AssertionError — that's a real test failure
```

**Rule:** Only retry on infrastructure/timing exceptions (TimeoutException, StaleElementReferenceException). Never retry on AssertionError or application-logic failures.

---

## 5. CI/CD integration with GitHub Actions?

```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        browser: [chrome, firefox]

    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with: {python-version: "3.11"}

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Run sanity tests
        run: pytest -m sanity --browser=${{ matrix.browser }} --headless
             --alluredir=reports/allure-results -n 4

      - name: Upload Allure results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: allure-results-${{ matrix.browser }}
          path: reports/allure-results
```

---

---

# SECTION 8: BEHAVIORAL QUESTIONS (5 YEAR LEVEL)

---

## 1. Describe the most complex framework you built from scratch?

**Sample answer structure:**
- **Context:** 300+ test cases for a fintech app across Web, Android, iOS, and API
- **Challenge:** Teams used different stacks (Java Selenium, Python Robot Framework) — test results inconsistent
- **Decision:** Unified Python pytest framework with Selenium for web, Appium for mobile, requests for API
- **Key design choices:**
  - Shared `BasePage` and `BaseTest` across web and mobile
  - Single `conftest.py` hierarchy for all environments
  - Allure for unified reporting across all test types
  - `pytest-xdist` for 4x parallel execution
- **Outcome:** Test execution time reduced from 6 hours to 40 minutes; defect detection rate improved 35%

---

## 2. How have you reduced test execution time significantly?

**Example answer:**
- Identified that 60% of tests were re-logging in via UI for each test
- Created a session-scoped `logged_in_driver` fixture that logs in once and shares the browser session within a class
- Moved all test data creation from UI to API calls
- Added `pytest-xdist` with 8 parallel workers in CI
- Result: 2-hour suite reduced to 18 minutes

---

## 3. How do you stay updated with testing tools?

- Follow **Test Automation University** (Applitools), **Ministry of Testing**, **TestProject** blogs
- Track Selenium, Playwright, Appium GitHub repositories
- Attend **PyCon** and **SeleniumConf** (recordings on YouTube)
- Experiment with new tools in side projects before introducing at work
- Review weekly changelogs of key dependencies in `requirements.txt`

---

## 4. How do you mentor junior automation engineers?

**Approach:**
1. **Pair programming** on first 2-3 test cases together
2. **Code review** with detailed comments explaining the "why" not just "what"
3. **Checklist** of framework conventions they must follow (locator naming, wait strategy, fixture usage)
4. **Ownership** — assign them a full feature test suite to own, not just individual tests
5. **Regular 1:1** — review their test code, identify patterns, give targeted feedback

---

## 5. Describe pushing back on unrealistic test automation scope?

**Example:**
- Manager asked for 100% UI automation coverage of all 500 screens in 2 months
- Pushed back with data: average 4 hours per test case for complex flows → 2000 hours = not feasible
- Proposed alternative: automate the top 20% highest-risk flows covering 80% of user journeys
- Agreed on 100 automated tests covering critical paths + manual exploratory for the rest
- Result: delivered on time, caught 3 critical regressions in first sprint

---

*End of Interview Q&A*
