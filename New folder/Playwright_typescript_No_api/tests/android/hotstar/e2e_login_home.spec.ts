import { expect } from '@wdio/globals';
import { screens } from '../../../src/screens';

/**
 * TC_AND_HS_E2E_01 — Login and Home Page Verification (Android)
 *
 * Flow:
 *   1. Launch JioHotstar app
 *   2. Enter mobile number and OTP to log in
 *   3. Verify home screen loads with hero banner
 *   4. Verify primary navigation tabs visible (Movies, Shows, Sports)
 */

describe('TC_AND_HS_E2E_01 — Android Login and Home @android @smoke', () => {

  it('Login screen is displayed on app launch', async () => {
    await screens.login.waitForLoginScreen();
    const visible = await screens.login.isDisplayed('in.startv.hotstar:id/et_mobile_number');
    expect(visible).toBe(true);
  });

  it('Entering mobile number proceeds to OTP screen', async () => {
    await screens.login.enterMobileNumber(process.env['HOTSTAR_MOBILE'] ?? '9999999999');
    const otpVisible = await screens.login.isDisplayed('in.startv.hotstar:id/et_otp');
    expect(otpVisible).toBe(true);
  });

  it('Home screen loads with hero banner after login', async () => {
    await screens.login.enterOtp(process.env['HOTSTAR_OTP'] ?? '123456');
    await screens.login.skipIfVisible();
    await screens.home.waitForHomeScreen();
    const heroBanner = await screens.home.isHeroBannerVisible();
    expect(heroBanner).toBe(true);
  });

  it('Primary nav tabs are visible on home screen', async () => {
    const tabs: string[] = ['Movies', 'Shows', 'Sports'];
    for (const tab of tabs) {
      const isVisible = await screens.home.isDisplayed(`~${tab}`);
      expect(isVisible).toBe(true);
    }
  });
});
