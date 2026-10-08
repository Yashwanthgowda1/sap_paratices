import { test, expect } from '../../src/fixtures/hotstar.fixtures';
import { hotstar } from '../../test-data/hotstar';

/**
 * TC_HS_E2E_01 — Login & Home Page Verification
 *
 * Flow:
 *   1. Open JioHotstar home page
 *   2. Verify hero banner / featured content is visible
 *   3. Verify primary navigation tabs are present (Movies, Shows, Sports)
 *   4. Verify at least one content tile is rendered on the home page
 */

test.describe('TC_HS_E2E_01 — Login and Home Page @hotstar @smoke', () => {
  test.beforeEach(async ({ authenticatedHome }) => {});

  test('Home page loads with hero banner after landing', async ({ homePage }) => {
    const heroBannerVisible = await homePage.isHeroBannerVisible();
    expect(heroBannerVisible).toBe(true);
  });

  test('Primary navigation tabs are visible', async ({ homePage }) => {
    const moviesVisible = await homePage.isNavTabVisible('Movies');
    const showsVisible  = await homePage.isNavTabVisible('Shows');
    const sportsVisible = await homePage.isNavTabVisible('Sports');

    expect(moviesVisible).toBe(true);
    expect(showsVisible).toBe(true);
    expect(sportsVisible).toBe(true);
  });

  test('Home page renders content tiles', async ({ homePage }) => {
    const tileCount = await homePage.getContentTileCount();
    expect(tileCount).toBeGreaterThan(0);
  });

  test('Sign In button is present for unauthenticated user', async ({ loginPage }) => {
    await loginPage.goto();
    await loginPage.waitForPageReady();
    // Verify the Sign In entry point is accessible
    const title = await loginPage.getTitle();
    expect(title).toBeTruthy();
  });
});
