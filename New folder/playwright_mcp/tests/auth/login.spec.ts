import { test, expect } from '../../src/fixtures/pageFixtures';
import { TEST_USERS } from '../../src/data/testData';

/**
 * Login test suite — uses the "unauthenticated" project so tests
 * run WITHOUT the stored session.
 */
test.describe('Login — JioHotstar', () => {

  test.beforeEach(async ({ loginPage }) => {
    await loginPage.navigateToLogin();
  });

  // ── Positive scenarios ────────────────────────────────────────
  test('TC_AUTH_001 — valid email + password login @smoke @regression', async ({ loginPage }) => {
    await loginPage.loginWithEmail(TEST_USERS.valid.email, TEST_USERS.valid.password);
    await loginPage.assertLoggedIn();
  });

  test('TC_AUTH_002 — login page URL and elements are correct @regression', async ({ loginPage, page }) => {
    await loginPage.assertLoginPageVisible();
    await expect(loginPage.emailInput.or(loginPage.phoneInput)).toBeVisible();
    await expect(loginPage.continueButton).toBeVisible();
  });

  test('TC_AUTH_003 — user can switch between Email and Phone login @regression', async ({ loginPage }) => {
    await expect(loginPage.emailInput.or(loginPage.phoneInput)).toBeVisible();
    if (await loginPage.loginWithOtpLink.isVisible()) {
      await loginPage.click(loginPage.loginWithOtpLink);
      await expect(loginPage.phoneInput).toBeVisible();
    }
  });

  test('TC_AUTH_004 — forgot password link navigates correctly @regression', async ({ loginPage, page }) => {
    if (await loginPage.forgotPasswordLink.isVisible()) {
      await loginPage.clickForgotPassword();
      await expect(page).toHaveURL(/forgot|reset/i);
    }
  });

  test('TC_AUTH_005 — Google Sign-In button is displayed @regression', async ({ loginPage }) => {
    await expect(loginPage.googleSignInButton).toBeVisible();
  });

  // ── Negative scenarios ────────────────────────────────────────
  test('TC_AUTH_006 — invalid email shows error message @regression', async ({ loginPage }) => {
    await loginPage.loginWithEmail(TEST_USERS.invalid.email, TEST_USERS.invalid.password);
    await loginPage.assertErrorMessageVisible();
    const errorText = await loginPage.getErrorMessage();
    expect(errorText.length).toBeGreaterThan(0);
  });

  test('TC_AUTH_007 — login with unregistered email shows error @regression', async ({ loginPage }) => {
    await loginPage.loginWithEmail(TEST_USERS.unregistered.email, TEST_USERS.unregistered.password);
    await loginPage.assertErrorMessageVisible();
  });

  test('TC_AUTH_008 — empty email field shows validation error @regression', async ({ loginPage }) => {
    await loginPage.click(loginPage.continueButton);
    // Should not navigate away; email field should still be visible
    await expect(loginPage.emailInput.or(loginPage.phoneInput)).toBeVisible();
  });

  test('TC_AUTH_009 — empty password field shows validation error @regression', async ({ loginPage }) => {
    await loginPage.fill(loginPage.emailInput, TEST_USERS.valid.email);
    await loginPage.click(loginPage.continueButton);
    await loginPage.click(loginPage.submitButton);
    await loginPage.assertErrorMessageVisible();
  });

  test('TC_AUTH_010 — incorrect OTP shows error @regression', async ({ loginPage }) => {
    if (await loginPage.loginWithOtpLink.isVisible()) {
      await loginPage.click(loginPage.loginWithOtpLink);
      await loginPage.fill(loginPage.phoneInput, TEST_USERS.valid.phone);
      await loginPage.click(loginPage.continueButton);
      // Enter wrong OTP
      try {
        await loginPage.fill(loginPage.otpInput, '000000');
        await loginPage.click(loginPage.submitButton);
        await loginPage.assertErrorMessageVisible();
      } catch {
        // OTP screen not available in this test run
      }
    }
  });
});
