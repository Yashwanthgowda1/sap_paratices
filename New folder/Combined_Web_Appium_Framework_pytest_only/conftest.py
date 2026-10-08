import pytest
import allure
from drivers.web_driver_factory import WebDriverFactory
from drivers.mobile_driver_factory import MobileDriverFactory
from utilities.screenshot_util import ScreenshotUtil
from utilities.soft_assert import SoftAssert
from utilities.api_client import APIClient
from utilities.logger import get_logger
from config.config import WebConfig, MobileConfig

log = get_logger("conftest")


# ══════════════════════════════════════════════════════════════════════════════
# CLI OPTIONS
# Run tests with:
#   pytest --browser=firefox --headless --env=production
#   pytest --platform=mobile
# ══════════════════════════════════════════════════════════════════════════════

def pytest_addoption(parser):
    parser.addoption("--browser",  action="store", default=None,
                     help="Web browser: chrome | firefox | edge")
    parser.addoption("--headless", action="store_true", default=False,
                     help="Run web browser in headless mode")
    parser.addoption("--env",      action="store", default="staging",
                     help="Test environment: staging | production")
    parser.addoption("--platform", action="store", default="web",
                     help="Platform to test: web | mobile")


# ══════════════════════════════════════════════════════════════════════════════
# SESSION-SCOPED FIXTURES  (created once per test session — shared across all tests)
# ══════════════════════════════════════════════════════════════════════════════

@pytest.fixture(scope="session")
def browser_name(request):
    """Reads --browser from CLI or falls back to config.json value."""
    return request.config.getoption("--browser") or WebConfig.BROWSER

@pytest.fixture(scope="session")
def headless(request):
    """Reads --headless flag from CLI or config."""
    return request.config.getoption("--headless") or WebConfig.HEADLESS


# ══════════════════════════════════════════════════════════════════════════════
# WEB FIXTURES  (function scope = fresh browser per test)
# ══════════════════════════════════════════════════════════════════════════════

@pytest.fixture(scope="function")
def driver(browser_name, headless):
    """
    Creates a fresh Selenium WebDriver before each test.
    Quits it after test completes (pass or fail).
    scope="function" = one browser per test = test isolation
    """
    log.info(f"[SETUP] Launching web browser: {browser_name}")
    drv = WebDriverFactory.get_driver(browser=browser_name, headless=headless)
    yield drv
    log.info("[TEARDOWN] Closing web browser")
    drv.quit()


# ── Web Page Object Fixtures ──────────────────────────────────────────────────
# Each fixture returns a page object initialized with the driver.
# Tests declare them as parameters — pytest injects automatically.

@pytest.fixture
def login_page(driver):
    from pages.web.login_page import LoginPage
    return LoginPage(driver)

@pytest.fixture
def home_page(driver):
    from pages.web.home_page import HomePage
    return HomePage(driver)

@pytest.fixture
def search_page(driver):
    from pages.web.search_page import SearchPage
    return SearchPage(driver)


# ── Pre-authenticated web fixture ─────────────────────────────────────────────

@pytest.fixture
def logged_in_driver(driver):
    """Driver already logged in — use for tests that need authenticated state."""
    from pages.web.login_page import LoginPage
    page = LoginPage(driver)
    page.open_login_page()
    page.login(WebConfig.VALID_EMAIL, WebConfig.VALID_PASSWORD)
    yield driver


# ══════════════════════════════════════════════════════════════════════════════
# MOBILE FIXTURES  (function scope = fresh Appium session per test)
# ══════════════════════════════════════════════════════════════════════════════

@pytest.fixture(scope="function")
def mobile_driver():
    """
    Starts Appium session (installs/launches app on device).
    Quits session after test — ensures clean app state for next test.
    Requires: Appium server running at MobileConfig.APPIUM_URL
    """
    log.info("[SETUP] Starting Appium mobile session")
    drv = MobileDriverFactory.get_driver()
    yield drv
    log.info("[TEARDOWN] Closing Appium session")
    drv.quit()


# ── Mobile Page Object Fixtures ───────────────────────────────────────────────

@pytest.fixture
def mobile_login_page(mobile_driver):
    from pages.mobile.mobile_login_page import MobileLoginPage
    return MobileLoginPage(mobile_driver)

@pytest.fixture
def mobile_home_page(mobile_driver):
    from pages.mobile.mobile_home_page import MobileHomePage
    return MobileHomePage(mobile_driver)

@pytest.fixture
def mobile_search_page(mobile_driver):
    from pages.mobile.mobile_search_page import MobileSearchPage
    return MobileSearchPage(mobile_driver)


# ── Pre-authenticated mobile fixture ─────────────────────────────────────────

@pytest.fixture
def mobile_logged_in(mobile_driver):
    """Mobile driver with user already logged in."""
    from pages.mobile.mobile_login_page import MobileLoginPage
    page = MobileLoginPage(mobile_driver)
    page.login(MobileConfig.VALID_USERNAME, MobileConfig.VALID_PASSWORD)
    yield mobile_driver


# ══════════════════════════════════════════════════════════════════════════════
# SHARED FIXTURES  (work for both web and mobile)
# ══════════════════════════════════════════════════════════════════════════════

@pytest.fixture
def soft_assert():
    """
    Fresh SoftAssert per test.
    Collects failures during test, raises ONE combined error at the end.
    pytest calls assert_all() automatically via yield.
    """
    sa = SoftAssert()
    yield sa
    sa.assert_all()

@pytest.fixture(scope="function")
def api_client():
    return APIClient()

@pytest.fixture(scope="function")
def authenticated_api_client():
    """API client with auth token pre-set."""
    client = APIClient()
    resp = client.post("/auth/login", {
        "email":    WebConfig.VALID_EMAIL,
        "password": WebConfig.VALID_PASSWORD,
    })
    if resp.status_code == 200:
        token = resp.json().get("token", "")
        client.set_auth_header(token)
    return client


# ══════════════════════════════════════════════════════════════════════════════
# AUTOMATIC SCREENSHOT ON FAILURE
# pytest hook — runs after every test, captures screenshot if test failed
# Attaches screenshot to Allure report automatically
# ══════════════════════════════════════════════════════════════════════════════

@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    rep     = outcome.get_result()

    if rep.when == "call" and rep.failed:
        # Try web driver first, then mobile driver
        drv = item.funcargs.get("driver") or item.funcargs.get("mobile_driver")
        if drv:
            sc   = ScreenshotUtil(drv)
            path = sc.take_screenshot_on_failure(item.name)
            allure.attach.file(
                path,
                name=f"screenshot_{item.name}",
                attachment_type=allure.attachment_type.PNG,
            )
            log.error(f"Test FAILED: {item.name} | Screenshot: {path}")
