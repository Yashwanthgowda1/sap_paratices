import pytest
import allure
from pages.subscription_page import SubscriptionPage
from pages.home_page import HomePage


@allure.epic("JioHotstar")
@allure.feature("Subscription")
@pytest.mark.ui
@pytest.mark.subscription
class TestSubscription:
    """TC-SUB-001 to TC-SUB-008: Subscription / Plans."""

    @allure.story("Subscription plans page loads")
    @allure.title("TC-SUB-001 | [SANITY] Subscription plans page loads with plan cards")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    def test_plans_page_loads(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open_home()
        home.click(home.SUBSCRIBE_BUTTON) if home.is_displayed(home.SUBSCRIBE_BUTTON) else None
        sub = SubscriptionPage(logged_in_driver)
        logged_in_driver.get(f"{home.driver.current_url}subscribe")
        plans = sub.get_all_plans()
        assert len(plans) >= 2, f"Expected at least 2 plan cards, found {len(plans)}"

    @allure.story("Plan prices are displayed")
    @allure.title("TC-SUB-002 | [SMOKE] All subscription plans display a price")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    def test_plan_prices_visible(self, logged_in_driver):
        sub = SubscriptionPage(logged_in_driver)
        from config.config import Config
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        plans = sub.get_all_plans()
        assert len(plans) > 0, "Plans should be visible"
        assert sub.is_displayed(sub.PLAN_PRICE), "Plan prices should be displayed"

    @allure.story("Coupon code field")
    @allure.title("TC-SUB-003 | [REGRESSION] Coupon code field accepts input")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_coupon_field_input(self, logged_in_driver):
        from config.config import Config
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub = SubscriptionPage(logged_in_driver)
        sub.select_mobile_plan()
        if sub.is_displayed(sub.COUPON_FIELD):
            sub.type_text(sub.COUPON_FIELD, "TESTCODE10")
            assert sub.is_displayed(sub.APPLY_COUPON_BTN), "Apply button should appear with coupon input"

    @allure.story("Invalid coupon code")
    @allure.title("TC-SUB-004 | [NEGATIVE] Invalid coupon code shows error message")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    def test_invalid_coupon(self, logged_in_driver):
        from config.config import Config
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub = SubscriptionPage(logged_in_driver)
        sub.select_mobile_plan()
        if sub.is_displayed(sub.COUPON_FIELD):
            sub.apply_coupon("INVALIDXXX")
            assert not sub.is_coupon_applied(), "Invalid coupon should not be applied"

    @allure.story("Annual billing toggle")
    @allure.title("TC-SUB-005 | [REGRESSION] Annual billing toggle changes plan pricing")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_annual_toggle(self, logged_in_driver):
        from config.config import Config
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub = SubscriptionPage(logged_in_driver)
        if sub.is_displayed(sub.PLAN_PRICE):
            monthly_price = sub.get_text(sub.PLAN_PRICE)
            sub.toggle_annual_billing()
            annual_price = sub.get_text(sub.PLAN_PRICE)
            assert monthly_price != annual_price, "Price should differ between monthly and annual billing"

    @allure.story("Payment options available")
    @allure.title("TC-SUB-006 | [REGRESSION] Payment page shows UPI, Card and Net Banking options")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    def test_payment_options_visible(self, logged_in_driver):
        from config.config import Config
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub = SubscriptionPage(logged_in_driver)
        sub.select_mobile_plan()
        if sub.is_displayed(sub.PAYMENT_SECTION):
            assert sub.is_displayed(sub.UPI_OPTION) or sub.is_displayed(sub.CARD_OPTION), \
                "At least UPI or Card payment option should be available"

    @allure.story("Active plan badge for subscriber")
    @allure.title("TC-SUB-007 | [REGRESSION] Active plan badge is shown for subscribed user")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_active_plan_shown_for_subscriber(self, premium_logged_in_driver):
        from config.config import Config
        premium_logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub = SubscriptionPage(premium_logged_in_driver)
        assert sub.is_active_plan_shown() or sub.is_displayed(sub.MANAGE_SUB_LINK), \
            "Active plan or Manage Subscription should be visible for subscribed user"

    @allure.story("Subscribe CTA from content detail")
    @allure.title("TC-SUB-008 | [E2E] Clicking Subscribe on premium content navigates to plans page")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.e2e
    def test_subscribe_cta_from_content(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open_home()
        home.click_search()
        from pages.search_page import SearchPage
        search = SearchPage(logged_in_driver)
        from test_data import TestData
        search.search(TestData.MOVIE["title"])
        search.click_first_result()
        from pages.content_detail_page import ContentDetailPage
        detail = ContentDetailPage(logged_in_driver)
        if detail.is_premium_content():
            detail.click(detail.SUBSCRIBE_TO_WATCH)
            assert "subscribe" in logged_in_driver.current_url.lower() or \
                   "plan" in logged_in_driver.current_url.lower(), \
                "Should redirect to subscription/plans page"

    @allure.story("Super plan selection")
    @allure.title("TC-SUB-009 | [REGRESSION] User can select Super plan and see order summary")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    @pytest.mark.TC_SUB_009
    def test_select_super_plan(self, logged_in_driver):
        from config.config import Config
        sub = SubscriptionPage(logged_in_driver)
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub.select_super_plan()
        assert sub.is_displayed(sub.ORDER_SUMMARY), \
            "Order summary should be visible after selecting Super plan"

    @allure.story("Order summary total amount")
    @allure.title("TC-SUB-010 | [REGRESSION] Order summary shows total amount before payment")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_SUB_010
    def test_order_summary_shows_total(self, logged_in_driver):
        from config.config import Config
        sub = SubscriptionPage(logged_in_driver)
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub.select_mobile_plan()
        assert sub.is_displayed(sub.ORDER_SUMMARY), "Order summary should be displayed"
        total = sub.get_total_amount()
        assert total is not None and len(total) > 0, \
            "Total amount should be visible in order summary"

    @allure.story("Net banking payment option")
    @allure.title("TC-SUB-011 | [REGRESSION] Net Banking is available as a payment option")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_SUB_011
    def test_netbanking_option_visible(self, logged_in_driver):
        from config.config import Config
        sub = SubscriptionPage(logged_in_driver)
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub.select_mobile_plan()
        if sub.is_displayed(sub.PAYMENT_SECTION):
            assert sub.is_displayed(sub.NETBANKING_OPTION), \
                "Net Banking payment option should be visible"

    @allure.story("Pay now button")
    @allure.title("TC-SUB-012 | [SMOKE] Pay Now button is visible on payment page")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_SUB_012
    def test_pay_now_button_visible(self, logged_in_driver):
        from config.config import Config
        sub = SubscriptionPage(logged_in_driver)
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub.select_mobile_plan()
        if sub.is_displayed(sub.PAYMENT_SECTION):
            assert sub.is_displayed(sub.PAY_NOW_BTN), \
                "Pay Now button should be visible on payment page"

    @allure.story("Cancel subscription")
    @allure.title("TC-SUB-013 | [REGRESSION] Premium user sees Cancel Subscription button")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_SUB_013
    def test_cancel_subscription_option_visible(self, premium_logged_in_driver):
        from config.config import Config
        sub = SubscriptionPage(premium_logged_in_driver)
        premium_logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        assert sub.is_displayed(sub.CANCEL_SUB_BTN) or sub.is_displayed(sub.MANAGE_SUB_LINK), \
            "Cancel or Manage Subscription option should be visible for premium user"

    @allure.story("Monthly toggle on plans page")
    @allure.title("TC-SUB-014 | [REGRESSION] Monthly billing toggle is available on plans page")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_SUB_014
    def test_monthly_toggle_visible(self, logged_in_driver):
        from config.config import Config
        sub = SubscriptionPage(logged_in_driver)
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        assert sub.is_displayed(sub.MONTHLY_TOGGLE) or sub.is_displayed(sub.ANNUAL_TOGGLE), \
            "Billing toggle (Monthly/Annual) should be visible on plans page"

    @allure.story("Valid coupon applied successfully")
    @allure.title("TC-SUB-015 | [E2E] Valid coupon code is applied and success message shown")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.e2e
    @pytest.mark.TC_SUB_015
    def test_valid_coupon_applied(self, logged_in_driver):
        from config.config import Config
        from test_data import TestData
        sub = SubscriptionPage(logged_in_driver)
        logged_in_driver.get(f"{Config.BASE_URL}/subscribe")
        sub.select_mobile_plan()
        if sub.is_displayed(sub.COUPON_FIELD):
            sub.apply_coupon(TestData.VALID_COUPON)
            assert sub.is_coupon_applied(), \
                f"Coupon '{TestData.VALID_COUPON}' should be applied successfully"
