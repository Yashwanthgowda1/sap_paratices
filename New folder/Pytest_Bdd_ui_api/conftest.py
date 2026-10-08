import pytest
import allure
from utilities.driver_factory import DriverFactory
from utilities.screenshot_util import ScreenshotUtil
from utilities.api_client import APIClient
from utilities.soft_assert import SoftAssert
from utilities.logger import get_logger
from config.config import Config

log = get_logger("conftest")


# ── CLI options ────────────────────────────────────────────────────────────────
def pytest_addoption(parser):
    parser.addoption("--browser",   action="store", default=None,      help="chrome|firefox|edge")
    parser.addoption("--headless",  action="store_true", default=False, help="Run headless")
    parser.addoption("--env",       action="store", default="staging",  help="staging|production")


# ── Session fixtures ──────────────────────────────────────────────────────────
@pytest.fixture(scope="session")
def browser_name(request):
    return request.config.getoption("--browser") or Config.BROWSER


@pytest.fixture(scope="session")
def headless(request):
    return request.config.getoption("--headless") or Config.HEADLESS


# ── Function-scoped browser (fresh per scenario) ──────────────────────────────
@pytest.fixture(scope="function")
def driver(browser_name, headless):
    log.info(f"[SETUP] Launching {browser_name} browser")
    drv = DriverFactory.get_driver(browser=browser_name, headless=headless)
    yield drv
    log.info("[TEARDOWN] Closing browser")
    drv.quit()


# ── Page object fixtures ──────────────────────────────────────────────────────
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
def watchlist_page(driver):
    from pages.watchlist_page import WatchlistPage
    return WatchlistPage(driver)


# ── Pre-authenticated driver fixture ─────────────────────────────────────────
@pytest.fixture
def logged_in_driver(driver):
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    page.open_login_page()
    page.login_with_email(Config.VALID_EMAIL, Config.VALID_PASSWORD)
    yield driver


# ── API client fixtures ────────────────────────────────────────────────────────
@pytest.fixture(scope="function")
def api_client():
    return APIClient()


# ── Soft assert fixture ────────────────────────────────────────────────────────
@pytest.fixture
def soft_assert():
    # fresh SoftAssert per scenario — collects failures instead of stopping
    sa = SoftAssert()
    yield sa
    sa.assert_all()     # raises ONE combined error at end of scenario if any failed


@pytest.fixture(scope="function")
def authenticated_api_client():
    client = APIClient()
    resp = client.post("/auth/login", {
        "email": Config.VALID_EMAIL,
        "password": Config.VALID_PASSWORD,
    })
    if resp.status_code == 200:
        token = resp.json().get("token", "")
        client.set_auth_header(token)
    return client

# iteam will automaticaly pass by pytest injected inbuit function also
# ── Screenshot on failure (works for BDD scenarios too) ───────────────────────
@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    rep = outcome.get_result()

    if rep.when == "call" and rep.failed:
        drv = item.funcargs.get("driver")
        if drv:
            sc = ScreenshotUtil(drv)
            path = sc.take_screenshot_on_failure(item.name)
            allure.attach.file(
                path,
                name=f"screenshot_{item.name}",
                attachment_type=allure.attachment_type.PNG,
            )
            log.error(f"Test FAILED: {item.name} | Screenshot: {path}")
