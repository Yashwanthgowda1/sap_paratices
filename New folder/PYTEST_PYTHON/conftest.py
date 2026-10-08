import pytest
import allure
from datetime import datetime

from utilities.driver_factory import DriverFactory
from utilities.screenshot_util import ScreenshotUtil
from utilities.logger import get_logger
from config.config import Config

log = get_logger("conftest")


# ── CLI options ───────────────────────────────────────────────────────────────
def pytest_addoption(parser):
    parser.addoption("--browser", action="store", default=None, help="Browser: chrome|firefox|edge")
    parser.addoption("--headless", action="store_true", default=False, help="Run headless")
    parser.addoption("--env", action="store", default="staging", help="Environment: staging|production")


# ── Session-scoped driver fixture ─────────────────────────────────────────────
@pytest.fixture(scope="session")
def browser_name(request):
    return request.config.getoption("--browser") or Config.BROWSER


@pytest.fixture(scope="session")
def headless(request):
    return request.config.getoption("--headless") or Config.HEADLESS


# ── Function-scoped driver (fresh browser per test) ───────────────────────────
@pytest.fixture(scope="function")
def driver(browser_name, headless):
    log.info(f"[SETUP] Launching {browser_name} browser")
    drv = DriverFactory.get_driver(browser=browser_name, headless=headless)
    yield drv
    log.info("[TEARDOWN] Closing browser")
    drv.quit()


# ── Class-scoped driver (shared browser across test class) ────────────────────
@pytest.fixture(scope="class")
def driver_class(browser_name, headless):
    log.info(f"[SETUP CLASS] Launching {browser_name} browser")
    drv = DriverFactory.get_driver(browser=browser_name, headless=headless)
    yield drv
    log.info("[TEARDOWN CLASS] Closing browser")
    drv.quit()


# ── Page object fixtures ───────────────────────────────────────────────────────
@pytest.fixture
def login_page(driver):
    from pages.login_page import LoginPage
    return LoginPage(driver)


@pytest.fixture
def home_page(driver):
    from pages.home_page import HomePage
    return HomePage(driver)


@pytest.fixture
def search_page(driver):
    from pages.search_page import SearchPage
    return SearchPage(driver)


@pytest.fixture
def content_detail_page(driver):
    from pages.content_detail_page import ContentDetailPage
    return ContentDetailPage(driver)


@pytest.fixture
def player_page(driver):
    from pages.player_page import PlayerPage
    return PlayerPage(driver)


@pytest.fixture
def subscription_page(driver):
    from pages.subscription_page import SubscriptionPage
    return SubscriptionPage(driver)


@pytest.fixture
def watchlist_page(driver):
    from pages.watchlist_page import WatchlistPage
    return WatchlistPage(driver)


@pytest.fixture
def profile_page(driver):
    from pages.profile_page import ProfilePage
    return ProfilePage(driver)


# ── Authenticated session fixture ─────────────────────────────────────────────
@pytest.fixture
def logged_in_driver(driver):
    """Returns driver after logging in with valid credentials."""
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    page.open_login_page()
    page.login_with_email(Config.VALID_EMAIL, Config.VALID_PASSWORD)
    yield driver


@pytest.fixture
def premium_logged_in_driver(driver):
    """Returns driver after logging in with premium credentials."""
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    page.open_login_page()
    page.login_with_email(Config.PREMIUM_EMAIL, Config.PREMIUM_PASSWORD)
    yield driver


# ── Screenshot on failure ─────────────────────────────────────────────────────
@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    rep = outcome.get_result()

    if rep.when == "call" and rep.failed:
        driver = item.funcargs.get("driver") or item.funcargs.get("driver_class")
        if driver:
            sc = ScreenshotUtil(driver)
            path = sc.take_screenshot_on_failure(item.name)
            allure.attach.file(
                path,
                name=f"screenshot_{item.name}",
                attachment_type=allure.attachment_type.PNG
            )
            log.error(f"Test FAILED: {item.name} | Screenshot: {path}")
