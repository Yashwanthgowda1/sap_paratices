import { BaseScreen } from '../BaseScreen';

export class HotstarLoginScreen extends BaseScreen {
  // Resource IDs for JioHotstar Android app (in.startv.hotstar)
  private readonly mobileInput   = 'in.startv.hotstar:id/et_mobile_number';
  private readonly continueBtn   = 'in.startv.hotstar:id/btn_continue';
  private readonly otpInput      = 'in.startv.hotstar:id/et_otp';
  private readonly verifyBtn     = 'in.startv.hotstar:id/btn_verify';
  private readonly skipBtn       = 'in.startv.hotstar:id/tv_skip';
  private readonly profileIcon   = 'in.startv.hotstar:id/iv_profile';

  async enterMobileNumber(mobile: string): Promise<void> {
    await this.typeText(this.mobileInput, mobile);
    await this.tap(this.continueBtn);
  }

  async enterOtp(otp: string): Promise<void> {
    await this.typeText(this.otpInput, otp);
    await this.tap(this.verifyBtn);
  }

  async skipIfVisible(): Promise<void> {
    const visible = await this.isDisplayed(this.skipBtn).catch(() => false);
    if (visible) await this.tap(this.skipBtn);
  }

  async isLoggedIn(): Promise<boolean> {
    return this.isDisplayed(this.profileIcon).catch(() => false);
  }

  async waitForLoginScreen(): Promise<void> {
    await this.waitForDisplayed(this.mobileInput, 15_000);
  }
}
