from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class SubscriptionPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    PLANS_CONTAINER  = (By.CSS_SELECTOR, "[class*='plans'], [data-testid='subscription-plans']")
    PLAN_CARDS       = (By.CSS_SELECTOR, "[class*='plan-card'], [data-testid*='plan']")
    PLAN_PRICES      = (By.CSS_SELECTOR, "[class*='plan-price'], [class*='price']")
    COUPON_FIELD     = (By.CSS_SELECTOR, "input[name='coupon'], input[placeholder*='coupon'], input[placeholder*='Coupon']")
    APPLY_COUPON_BTN = (By.XPATH, "//button[contains(text(),'Apply')]")
    COUPON_ERROR     = (By.CSS_SELECTOR, "[class*='coupon-error'], [data-testid='coupon-error']")
    ANNUAL_TOGGLE    = (By.CSS_SELECTOR, "[data-testid='billing-toggle'], input[type='checkbox'][class*='toggle']")
    PAYMENT_OPTIONS  = (By.CSS_SELECTOR, "[class*='payment-option'], [data-testid*='payment']")
    ACTIVE_PLAN_BADGE = (By.CSS_SELECTOR, "[class*='active-plan'], [data-testid='active-plan']")
    SUBSCRIBE_CTA    = (By.CSS_SELECTOR, "[data-testid='subscribe-cta'], [class*='subscribe-cta']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def is_plans_page_loaded(self) -> bool:
        return self.is_displayed(self.PLANS_CONTAINER)

    def get_plan_cards(self) -> list:
        try:
            return self.get_all_elements(self.PLAN_CARDS)
        except Exception:
            return []

    def get_plan_prices(self) -> list[str]:
        try:
            return [el.text for el in self.get_all_elements(self.PLAN_PRICES)]
        except Exception:
            return []

    def enter_coupon(self, code: str):
        self.type_text(self.COUPON_FIELD, code)
        self.click(self.APPLY_COUPON_BTN)

    def get_coupon_error(self) -> str:
        return self.get_text(self.COUPON_ERROR)

    def toggle_annual_billing(self):
        self.click(self.ANNUAL_TOGGLE)

    def get_payment_options(self) -> list:
        try:
            return self.get_all_elements(self.PAYMENT_OPTIONS)
        except Exception:
            return []

    def is_active_plan_shown(self) -> bool:
        return self.is_displayed(self.ACTIVE_PLAN_BADGE)
