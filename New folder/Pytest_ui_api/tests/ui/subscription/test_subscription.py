import pytest
import allure
from pages.home_page import HomePage
from pages.subscription_page import SubscriptionPage
from config.config import Config
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Subscription - UI")
@pytest.mark.ui
@pytest.mark.subscription
class TestSubscription:
    """TC-SUB-001 to TC-SUB-008: Subscription and payment UI tests."""

    PLANS_URL = f"{Config.BASE_URL}/in/subscription"

    @allure.story("Plans page loads")
    @allure.title("TC-SUB-001 | [SANITY] Subscription plans page loads successfully")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_SUB_001
    def test_plans_page_loads(self, driver):
        sub = SubscriptionPage(driver)
        sub.open(self.PLANS_URL)
        assert sub.is_plans_page_loaded(), "Subscription plans page should load"

    @allure.story("Plan prices displayed")
    @allure.title("TC-SUB-002 | [SMOKE] All subscription plans display a price")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_SUB_002
    def test_all_plans_show_price(self, driver):
        sub = SubscriptionPage(driver)
        sub.open(self.PLANS_URL)
        prices = sub.get_plan_prices()
        assert len(prices) > 0, "At least one plan price should be visible"
        assert all(p.strip() for p in prices), "All visible plan prices should have non-empty text"

    @allure.story("Coupon code field")
    @allure.title("TC-SUB-003 | [REGRESSION] Coupon code field accepts input")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_SUB_003
    def test_coupon_field_accepts_input(self, driver):
        sub = SubscriptionPage(driver)
        sub.open(self.PLANS_URL)
        sub.type_text(sub.COUPON_FIELD, "TESTCOUPON")
        assert sub.get_attribute(sub.COUPON_FIELD, "value") == "TESTCOUPON", \
            "Coupon field should accept the entered text"

    @allure.story("Invalid coupon error")
    @allure.title("TC-SUB-004 | [NEGATIVE] Invalid coupon code shows error message")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_SUB_004
    def test_invalid_coupon_shows_error(self, driver):
        sub = SubscriptionPage(driver)
        sub.open(self.PLANS_URL)
        sub.enter_coupon(TestData.INVALID_COUPON)
        error = sub.get_coupon_error()
        assert error, "Error message should appear for invalid coupon code"

    @allure.story("Annual billing toggle")
    @allure.title("TC-SUB-005 | [REGRESSION] Annual billing toggle changes plan pricing")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_SUB_005
    def test_annual_billing_toggle(self, driver):
        sub = SubscriptionPage(driver)
        sub.open(self.PLANS_URL)
        prices_before = sub.get_plan_prices()
        sub.toggle_annual_billing()
        prices_after = sub.get_plan_prices()
        assert prices_before != prices_after, "Prices should change when toggling annual billing"

    @allure.story("Payment options visible")
    @allure.title("TC-SUB-006 | [SMOKE] Payment options are visible on plans page")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_SUB_006
    def test_payment_options_visible(self, driver):
        sub = SubscriptionPage(driver)
        sub.open(self.PLANS_URL)
        options = sub.get_payment_options()
        assert len(options) > 0, "At least one payment option should be visible"

    @allure.story("Active plan badge for subscribed user")
    @allure.title("TC-SUB-007 | [REGRESSION] Active plan badge shown for subscribed user")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_SUB_007
    def test_active_plan_badge_subscribed_user(self, premium_logged_in_driver):
        sub = SubscriptionPage(premium_logged_in_driver)
        sub.open(self.PLANS_URL)
        assert sub.is_active_plan_shown(), "Active plan badge should appear for subscribed user"

    @allure.story("Subscribe CTA navigates to plans")
    @allure.title("TC-SUB-008 | [E2E] Subscribe CTA on content detail navigates to plans page")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.e2e
    @pytest.mark.TC_SUB_008
    def test_subscribe_cta_navigates_to_plans(self, driver):
        from pages.content_detail_page import ContentDetailPage
        home = HomePage(driver)
        home.open(f"{Config.BASE_URL}/in/watch/{Config.PREMIUM_CONTENT_ID}")
        detail = ContentDetailPage(driver)
        detail.click(detail.SUBSCRIBE_CTA)
        sub = SubscriptionPage(driver)
        assert sub.is_plans_page_loaded(), "Plans page should load after clicking Subscribe CTA"
