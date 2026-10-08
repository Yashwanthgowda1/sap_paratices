import { Page } from '@playwright/test';
import { HotstarBasePage } from './HotstarBasePage';

export class HotstarLoginPage extends HotstarBasePage {
  private readonly signInBtn      = this.page.locator('[data-testid="login"], button:has-text("Sign In"), [aria-label*="Sign In"]').first();
  private readonly mobileInput    = this.page.locator('input[type="tel"], input[placeholder*="mobile"], input[name="loginId"]').first();
  private readonly emailInput     = this.page.locator('input[type="email"], input[placeholder*="email"]').first();
  private readonly continueBtn    = this.page.locator('button:has-text("Continue"), button[type="submit"]').first();
  private readonly otpInput       = this.page.locator('input[placeholder*="OTP"], input[data-testid="otp"]').first();
  private readonly verifyBtn      = this.page.locator('button:has-text("Verify"), button:has-text("Confirm")').first();
  private readonly userAvatar     = this.page.locator('[data-testid="user-avatar"], [aria-label*="Profile"], [class*="avatar"]').first();

  constructor(page: Page) {
    super(page);
  }

  async clickSignIn(): Promise<void> {
    await this.signInBtn.click();
  }

  async enterMobileNumber(mobile: string): Promise<void> {
    await this.mobileInput.fill(mobile);
    await this.continueBtn.click();
  }

  async enterOtp(otp: string): Promise<void> {
    await this.otpInput.fill(otp);
    await this.verifyBtn.click();
  }

  async isLoggedIn(): Promise<boolean> {
    return this.userAvatar.isVisible({ timeout: 10_000 }).catch(() => false);
  }
}
