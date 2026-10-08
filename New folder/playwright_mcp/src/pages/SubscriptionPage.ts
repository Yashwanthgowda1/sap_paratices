import { Page, Locator, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class SubscriptionPage extends BasePage {
  // ── Locators ─────────────────────────────────────────────────
  readonly subscribeButton: Locator;
  readonly plansContainer: Locator;
  readonly mobilePlanCard: Locator;
  readonly superPlanCard: Locator;
  readonly premiumPlanCard: Locator;
  readonly monthlyToggle: Locator;
  readonly annuallyToggle: Locator;
  readonly planPrice: Locator;
  readonly planFeatures: Locator;
  readonly selectPlanButton: Locator;
  readonly paymentSection: Locator;
  readonly upiOption: Locator;
  readonly cardOption: Locator;
  readonly netBankingOption: Locator;
  readonly walletOption: Locator;
  readonly upiIdInput: Locator;
  readonly cardNumberInput: Locator;
  readonly cardExpiryInput: Locator;
  readonly cardCvvInput: Locator;
  readonly cardHolderNameInput: Locator;
  readonly payNowButton: Locator;
  readonly orderSummary: Locator;
  readonly applyCouponInput: Locator;
  readonly applyCouponButton: Locator;
  readonly couponSuccessMessage: Locator;
  readonly couponErrorMessage: Locator;
  readonly currentPlanBadge: Locator;
  readonly cancelSubscriptionLink: Locator;
  readonly renewButton: Locator;

  constructor(page: Page) {
    super(page);
    this.subscribeButton      = page.getByRole('button', { name: /subscribe|get plan/i }).first();
    this.plansContainer       = page.locator('[class*="plans"], [data-testid="subscription-plans"]').first();
    this.mobilePlanCard       = page.locator('[data-plan="mobile"], [class*="mobile-plan"]').first();
    this.superPlanCard        = page.locator('[data-plan="super"], [class*="super-plan"]').first();
    this.premiumPlanCard      = page.locator('[data-plan="premium"], [class*="premium-plan"]').first();
    this.monthlyToggle        = page.getByRole('button', { name: /monthly/i });
    this.annuallyToggle       = page.getByRole('button', { name: /annual|yearly/i });
    this.planPrice            = page.locator('[class*="plan-price"], [data-testid="price"]');
    this.planFeatures         = page.locator('[class*="plan-feature"], [class*="feature-list"]');
    this.selectPlanButton     = page.getByRole('button', { name: /select plan|buy now|get started/i }).first();
    this.paymentSection       = page.locator('[class*="payment"], [data-testid="payment"]').first();
    this.upiOption            = page.getByLabel(/upi/i).first();
    this.cardOption           = page.getByLabel(/credit|debit card/i).first();
    this.netBankingOption     = page.getByLabel(/net banking/i).first();
    this.walletOption         = page.getByLabel(/wallet/i).first();
    this.upiIdInput           = page.getByPlaceholder(/upi id/i);
    this.cardNumberInput      = page.getByPlaceholder(/card number/i);
    this.cardExpiryInput      = page.getByPlaceholder(/expiry|mm\/yy/i);
    this.cardCvvInput         = page.getByPlaceholder(/cvv|cvc/i);
    this.cardHolderNameInput  = page.getByPlaceholder(/name on card|card holder/i);
    this.payNowButton         = page.getByRole('button', { name: /pay now|proceed to pay/i });
    this.orderSummary         = page.locator('[class*="order-summary"], [data-testid="order-summary"]').first();
    this.applyCouponInput     = page.getByPlaceholder(/coupon code|promo code/i);
    this.applyCouponButton    = page.getByRole('button', { name: /apply/i }).first();
    this.couponSuccessMessage = page.getByText(/coupon applied|discount applied/i);
    this.couponErrorMessage   = page.getByText(/invalid coupon|coupon expired/i);
    this.currentPlanBadge     = page.getByText(/current plan|active plan/i);
    this.cancelSubscriptionLink = page.getByRole('link', { name: /cancel subscription/i });
    this.renewButton          = page.getByRole('button', { name: /renew/i });
  }

  // ── Actions ──────────────────────────────────────────────────
  async navigateToSubscriptionPlans(): Promise<void> {
    await this.navigateTo('/subscribe');
    await this.waitForPageLoad();
  }

  async selectMonthlyBilling(): Promise<void> {
    await this.click(this.monthlyToggle);
  }

  async selectAnnualBilling(): Promise<void> {
    await this.click(this.annuallyToggle);
  }

  async selectMobilePlan(): Promise<void> {
    await this.click(this.mobilePlanCard);
    await this.click(this.selectPlanButton);
    await this.waitForPageLoad();
  }

  async selectPremiumPlan(): Promise<void> {
    await this.click(this.premiumPlanCard);
    await this.click(this.selectPlanButton);
    await this.waitForPageLoad();
  }

  async selectSuperPlan(): Promise<void> {
    await this.click(this.superPlanCard);
    await this.click(this.selectPlanButton);
    await this.waitForPageLoad();
  }

  async selectUpiPayment(): Promise<void> {
    await this.click(this.upiOption);
  }

  async fillUpiId(upiId: string): Promise<void> {
    await this.fill(this.upiIdInput, upiId);
  }

  async selectCardPayment(): Promise<void> {
    await this.click(this.cardOption);
  }

  async fillCardDetails(cardNumber: string, expiry: string, cvv: string, name: string): Promise<void> {
    await this.fill(this.cardNumberInput, cardNumber);
    await this.fill(this.cardExpiryInput, expiry);
    await this.fill(this.cardCvvInput, cvv);
    await this.fill(this.cardHolderNameInput, name);
  }

  async applyCoupon(code: string): Promise<void> {
    await this.fill(this.applyCouponInput, code);
    await this.click(this.applyCouponButton);
  }

  async getPlanPrices(): Promise<string[]> {
    return this.planPrice.allTextContents();
  }

  async getPlanFeatures(): Promise<string[]> {
    return this.planFeatures.allTextContents();
  }

  // ── Assertions ───────────────────────────────────────────────
  async assertPlansVisible(): Promise<void> {
    await expect(this.plansContainer).toBeVisible({ timeout: 10_000 });
  }

  async assertPaymentSectionVisible(): Promise<void> {
    await expect(this.paymentSection).toBeVisible({ timeout: 10_000 });
  }

  async assertCouponApplied(): Promise<void> {
    await expect(this.couponSuccessMessage).toBeVisible({ timeout: 5_000 });
  }

  async assertInvalidCoupon(): Promise<void> {
    await expect(this.couponErrorMessage).toBeVisible({ timeout: 5_000 });
  }

  async assertCurrentPlanHighlighted(): Promise<void> {
    await expect(this.currentPlanBadge).toBeVisible();
  }
}
