import { test, expect } from '../../src/fixtures/pageFixtures';

test.describe('Logout — JioHotstar', () => {

  test.beforeEach(async ({ homePage }) => {
    await homePage.navigateToHome();
  });

  test('TC_LOGOUT_001 — user can logout successfully @smoke @regression', async ({ loginPage, page }) => {
    // Ensure we're logged in first
    const isLoggedIn = await loginPage.isLoggedIn();
    if (!isLoggedIn) {
      test.skip(true, 'Requires authenticated session');
    }
    await loginPage.logout();
    await loginPage.assertLoggedOut();
  });

  test('TC_LOGOUT_002 — after logout, accessing protected page redirects to login @regression', async ({ loginPage, page }) => {
    const isLoggedIn = await loginPage.isLoggedIn();
    if (!isLoggedIn) {
      test.skip(true, 'Requires authenticated session');
    }
    await loginPage.logout();
    await page.goto('/account/profile');
    await expect(page).toHaveURL(/login|signin|auth/i);
  });

  test('TC_LOGOUT_003 — login button is visible after logout @regression', async ({ loginPage }) => {
    const isLoggedIn = await loginPage.isLoggedIn();
    if (!isLoggedIn) {
      test.skip(true, 'Requires authenticated session');
    }
    await loginPage.logout();
    await expect(loginPage.loginButton).toBeVisible();
  });

  test('TC_LOGOUT_004 — session cleared after logout (no cookies for auth) @regression', async ({ loginPage, page }) => {
    const isLoggedIn = await loginPage.isLoggedIn();
    if (!isLoggedIn) {
      test.skip(true, 'Requires authenticated session');
    }
    await loginPage.logout();
    // Check that auth cookies are absent
    const cookies = await page.context().cookies();
    const authCookies = cookies.filter((c) =>
      c.name.toLowerCase().includes('auth') || c.name.toLowerCase().includes('token')
    );
    expect(authCookies.length).toBe(0);
  });
});
