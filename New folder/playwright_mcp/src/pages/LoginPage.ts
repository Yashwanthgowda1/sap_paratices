import { Page, Locator, expect } from "@playwright/test";
import { BasePage } from './BasePage';

export class LoginPage extends BasePage {
  // ── Locators ─────────────────────────────────────────────────
  readonly loginButton: Locator;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly phoneInput: Locator;
  readonly otpInput: Locator;
  readonly continueButton: Locator;
  readonly submitButton: Locator;
  readonly loginWithPasswordLink: Locator;
  readonly loginWithOtpLink: Locator;
  readonly forgotPasswordLink: Locator;
  readonly googleSignInButton: Locator;
  readonly errorMessage: Locator;
  readonly otpErrorMessage: Locator;
  readonly resendOtpButton: Locator;
  readonly logoutButton: Locator;
  readonly profileIcon: Locator;
  readonly profileMenu: Locator;
  readonly termsCheckbox: Locator;
  readonly countryCodeSelector: Locator;
  readonly pageTitle: Locator;

  constructor(page: Page) {
    super(page);
    this.loginButton          = page.getByRole('button', { name: /sign in|log in/i }).first();
    this.emailInput           = page.getByPlaceholder(/email|email address/i);
    this.passwordInput        = page.getByPlaceholder(/password/i);
    this.phoneInput           = page.getByPlaceholder(/mobile number|phone/i);
    this.otpInput             = page.getByPlaceholder(/otp|one time password/i);
    this.continueButton       = page.getByRole('button', { name: /continue/i });
    this.submitButton         = page.getByRole('button', { name: /log in|sign in|submit/i });
    this.loginWithPasswordLink = page.getByText(/login with password/i);
    this.loginWithOtpLink     = page.getByText(/login with otp/i);
    this.forgotPasswordLink   = page.getByText(/forgot password/i);
    this.googleSignInButton   = page.getByRole('button', { name: /google/i });
    this.errorMessage         = page.locator('[class*="error"], [data-testid*="error"]').first();
    this.otpErrorMessage      = page.getByText(/invalid otp|incorrect otp/i);
    this.resendOtpButton      = page.getByRole('button', { name: /resend/i });
    this.logoutButton         = page.getByRole('menuitem', { name: /logout|sign out/i });
    this.profileIcon          = page.locator('[data-testid="profile-icon"], [aria-label="profile"]').first();
    this.profileMenu          = page.locator('[data-testid="profile-menu"]');
    this.termsCheckbox        = page.locator('input[type="checkbox"]').first();
    this.countryCodeSelector  = page.locator('[class*="country-code"]').first();
    this.pageTitle            = page.locator('h1, [class*="title"]').first();
  }

  // ── Actions ──────────────────────────────────────────────────
  async navigateToLogin(): Promise<void> {
    await this.navigateTo('/');
    await this.waitForPageLoad();
    await this.click(this.loginButton);
    await this.waitForPageLoad();
  }

  async loginWithEmail(email: string, password: string): Promise<void> {
    await this.fill(this.emailInput, email);
    await this.click(this.continueButton);
    await this.fill(this.passwordInput, password);
    await this.click(this.submitButton);
    await this.waitForPageLoad();
  }

  async loginWithPhone(phone: string, otp: string): Promise<void> {
    await this.fill(this.phoneInput, phone);
    await this.click(this.continueButton);
    await this.page.waitForSelector('[placeholder*="OTP"], [placeholder*="otp"]');
    await this.fill(this.otpInput, otp);
    await this.click(this.submitButton);
    await this.waitForPageLoad();
  }

  async logout(): Promise<void> {
    await this.click(this.profileIcon);
    await this.waitForElement(this.profileMenu);
    await this.click(this.logoutButton);
    await this.waitForPageLoad();
  }

  async clickForgotPassword(): Promise<void> {
    await this.click(this.forgotPasswordLink);
    await this.waitForPageLoad();
  }

  async getErrorMessage(): Promise<string> {
    await this.waitForElement(this.errorMessage, 5_000);
    return this.getText(this.errorMessage);
  }

  async isLoggedIn(): Promise<boolean> {
    return this.profileIcon.isVisible();
  }

  async clickResendOtp(): Promise<void> {
    await this.waitForElement(this.resendOtpButton);
    await this.click(this.resendOtpButton);
  }

  // ── Assertions ───────────────────────────────────────────────
  async assertLoginPageVisible(): Promise<void> {
    await expect(this.page).toHaveURL(/login|signin|auth/i);
  }

  async assertLoggedIn(): Promise<void> {
    await expect(this.profileIcon).toBeVisible({ timeout: 15_000 });
  }

  async assertLoggedOut(): Promise<void> {
    await expect(this.loginButton).toBeVisible({ timeout: 10_000 });
  }

  async assertErrorMessageVisible(): Promise<void> {
    await expect(this.errorMessage).toBeVisible({ timeout: 5_000 });
  }
}
