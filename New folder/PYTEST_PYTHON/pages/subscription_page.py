from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class SubscriptionPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    PLANS_CONTAINER     = (By.CSS_SELECTOR, "[class*='plans'], [data-testid='subscription-plans']")
    PLAN_CARD           = (By.CSS_SELECTOR, "[class*='plan-card'], [data-testid='plan']")
    PLAN_NAME           = (By.CSS_SELECTOR, "[class*='plan-name'], [data-testid='plan-name']")
    PLAN_PRICE          = (By.CSS_SELECTOR, "[class*='plan-price'], [data-testid='plan-price']")
    SELECT_PLAN_BTN     = (By.CSS_SELECTOR, "[data-testid='select-plan'], button[class*='plan-cta']")
    MOBILE_PLAN         = (By.XPATH, "//div[contains(@class,'plan') and contains(.,'Mobile')]")
    SUPER_PLAN          = (By.XPATH, "//div[contains(@class,'plan') and contains(.,'Super')]")
    PREMIUM_PLAN        = (By.XPATH, "//div[contains(@class,'plan') and contains(.,'Premium')]")
    ANNUAL_TOGGLE       = (By.CSS_SELECTOR, "[data-testid='annual-toggle'], [aria-label='Annual']")
    MONTHLY_TOGGLE      = (By.CSS_SELECTOR, "[data-testid='monthly-toggle'], [aria-label='Monthly']")
    PAYMENT_SECTION     = (By.CSS_SELECTOR, "[class*='payment'], [data-testid='payment']")
    UPI_OPTION          = (By.XPATH, "//label[contains(text(),'UPI')]")
    CARD_OPTION         = (By.XPATH, "//label[contains(text(),'Card') or contains(text(),'Debit')]")
    NETBANKING_OPTION   = (By.XPATH, "//label[contains(text(),'Net Banking')]")
    COUPON_FIELD        = (By.CSS_SELECTOR, "input[placeholder*='coupon'], input[name='coupon']")
    APPLY_COUPON_BTN    = (By.XPATH, "//button[contains(text(),'Apply')]")
    COUPON_SUCCESS_MSG  = (By.CSS_SELECTOR, "[class*='coupon-success'], [data-testid='coupon-success']")
    ORDER_SUMMARY       = (By.CSS_SELECTOR, "[class*='order-summary'], [data-testid='order-summary']")
    TOTAL_AMOUNT        = (By.CSS_SELECTOR, "[class*='total'], [data-testid='total-amount']")
    PAY_NOW_BTN         = (By.XPATH, "//button[contains(text(),'Pay') or contains(text(),'Subscribe')]")
    ACTIVE_PLAN_BADGE   = (By.CSS_SELECTOR, "[class*='active'], [data-testid='active-plan']")
    MANAGE_SUB_LINK     = (By.XPATH, "//a[contains(text(),'Manage')]")
    CANCEL_SUB_BTN      = (By.XPATH, "//button[contains(text(),'Cancel')]")

    # ── Actions ───────────────────────────────────────────────────────────────
    def get_all_plans(self) -> list:
        return self.get_all_elements(self.PLAN_CARD)

    def select_mobile_plan(self):
        log.info("Selecting Mobile plan")
        self.click(self.MOBILE_PLAN)
        self.click(self.SELECT_PLAN_BTN)

    def select_super_plan(self):
        log.info("Selecting Super plan")
        self.click(self.SUPER_PLAN)
        self.click(self.SELECT_PLAN_BTN)

    def apply_coupon(self, code: str):
        log.info(f"Applying coupon: {code}")
        self.type_text(self.COUPON_FIELD, code)
        self.click(self.APPLY_COUPON_BTN)

    def is_coupon_applied(self) -> bool:
        return self.is_displayed(self.COUPON_SUCCESS_MSG)

    def get_total_amount(self) -> str:
        return self.get_text(self.TOTAL_AMOUNT)

    def select_upi_payment(self):
        self.click(self.UPI_OPTION)

    def click_pay_now(self):
        self.click(self.PAY_NOW_BTN)

    def is_active_plan_shown(self) -> bool:
        return self.is_displayed(self.ACTIVE_PLAN_BADGE)

    def toggle_annual_billing(self):
        self.click(self.ANNUAL_TOGGLE)
