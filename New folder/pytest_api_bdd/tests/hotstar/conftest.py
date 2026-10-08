"""
tests/hotstar/conftest.py
--------------------------
Browser fixtures for Hotstar UI tests.
Scoped separately from the API conftest.py at project root.

Fixtures here are available ONLY to tests inside tests/hotstar/.
"""

import pytest
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

from tests.hotstar.pages.home_page import HomePage
from tests.hotstar.pages.search_page import SearchPage


# ── Browser options ──────────────────────────────────────────────────────────

def _chrome_options() -> Options:
    options = Options()
    options.add_argument("--start-maximized")
    options.add_argument("--disable-notifications")
    options.add_argument("--disable-popup-blocking")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    # options.add_argument("--headless")   # uncomment to run without browser window
    return options


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE: driver  (scope=function)
#
#  Creates a fresh Chrome browser for EACH test.
#  Closes it automatically after the test — yield handles teardown.
# ─────────────────────────────────────────────────────────────────────────────

@pytest.fixture(scope="function")
def driver():
    service = Service(ChromeDriverManager().install())
    browser = webdriver.Chrome(service=service, options=_chrome_options())
    browser.implicitly_wait(5)

    yield browser          # ← test runs here with the browser

    browser.quit()         # ← always runs after test, even if test fails


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE: home_page
#
#  Opens Hotstar home page and returns a HomePage object.
#  Tests get a ready-to-use page — no setup code inside tests.
# ─────────────────────────────────────────────────────────────────────────────

@pytest.fixture
def home_page(driver) -> HomePage:
    page = HomePage(driver)
    page.load()            # opens https://www.hotstar.com/in
    return page


# ─────────────────────────────────────────────────────────────────────────────
#  FIXTURE: search_page
#
#  Returns SearchPage object bound to the same driver.
#  Used in tests that navigate to search results.
# ─────────────────────────────────────────────────────────────────────────────

@pytest.fixture
def search_page(driver) -> SearchPage:
    return SearchPage(driver)
