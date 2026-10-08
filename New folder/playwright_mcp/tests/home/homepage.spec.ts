import { test, expect } from '../../src/fixtures/pageFixtures';

test.describe('Home Page — JioHotstar', () => {

  test.beforeEach(async ({ homePage }) => {
    await homePage.navigateToHome();
  });

  // ── Page Load ─────────────────────────────────────────────────
  test('TC_HOME_001 — home page loads with correct URL and title @smoke @regression', async ({ homePage, page }) => {
    await homePage.assertHomePageLoaded();
    const title = await page.title();
    expect(title.toLowerCase()).toMatch(/hotstar|jio/i);
  });

  test('TC_HOME_002 — navigation bar is visible with all tabs @smoke @regression', async ({ homePage }) => {
    await homePage.assertNavbarVisible();
    await expect(homePage.moviesTab).toBeVisible();
    await expect(homePage.tvShowsTab).toBeVisible();
    await expect(homePage.sportsTab).toBeVisible();
  });

  test('TC_HOME_003 — hero banner is visible and has play button @regression', async ({ homePage }) => {
    await homePage.assertHeroSectionVisible();
    await expect(homePage.heroBanner).toBeVisible();
  });

  test('TC_HOME_004 — logo is visible and clickable @regression', async ({ homePage, page }) => {
    await expect(homePage.logo).toBeVisible();
    await homePage.click(homePage.logo);
    await expect(page).toHaveURL(/jiohotstar\.com|hotstar\.com/);
  });

  // ── Navigation Tabs ───────────────────────────────────────────
  test('TC_HOME_005 — Movies tab navigates to movies page @regression', async ({ homePage, page }) => {
    await homePage.clickMoviesTab();
    await expect(page).toHaveURL(/movies/i);
  });

  test('TC_HOME_006 — TV Shows tab navigates to shows page @regression', async ({ homePage, page }) => {
    await homePage.clickTvShowsTab();
    await expect(page).toHaveURL(/shows|series/i);
  });

  test('TC_HOME_007 — Sports tab navigates to sports page @regression', {tag:[ '@smoke', '@sanity']}, async ({ homePage, page }) => {
    await homePage.clickSportsTab();
    await expect(page).toHaveURL(/sports/i);
  });

  test('TC_HOME_008 — Kids tab navigates to kids page @regression', async ({ homePage, page }) => {
    if (await homePage.kidsTab.isVisible()) {
      await homePage.clickKidsTab();
      await expect(page).toHaveURL(/kids/i);
    }
  });

  // ── Content Sections ──────────────────────────────────────────
  test('TC_HOME_009 — content cards are loaded on the home page @smoke @regression', async ({ homePage }) => {
    const count = await homePage.getContentCardCount();
    expect(count).toBeGreaterThan(0);
  });

  test('TC_HOME_010 — trending section is displayed @regression', async ({ homePage }) => {
    await homePage.assertTrendingSectionVisible();
  });

  test('TC_HOME_011 — clicking a content card opens the detail page @regression', async ({ homePage, page }) => {
    const initialUrl = page.url();
    await homePage.clickFirstContentCard();
    expect(page.url()).not.toBe(initialUrl);
  });

  // ── Search ────────────────────────────────────────────────────
  test('TC_HOME_012 — search icon is visible and clickable @smoke @regression', async ({ homePage, searchPage, page }) => {
    await expect(homePage.searchIcon).toBeVisible();
    await homePage.clickSearchIcon();
    await expect(page).toHaveURL(/search/i);
  });

  // ── Carousel ──────────────────────────────────────────────────
  test('TC_HOME_013 — carousel next button advances to next slide @regression', async ({ homePage }) => {
    if (await homePage.carouselNextBtn.isVisible()) {
      const heroBefore = await homePage.heroBanner.screenshot();
      await homePage.navigateCarouselNext();
      await homePage.page.waitForTimeout(500);
      const heroAfter = await homePage.heroBanner.screenshot();
      expect(heroBefore.toString()).not.toBe(heroAfter.toString());
    }
  });

  // ── Footer ────────────────────────────────────────────────────
  test('TC_HOME_014 — footer section is accessible by scrolling @regression', async ({ homePage }) => {
    await homePage.scrollToFooter();
    await expect(homePage.footerSection).toBeInViewport();
  });

  // ── Responsiveness ────────────────────────────────────────────
  test('TC_HOME_015 — home page is responsive on mobile viewport @regression', async ({ homePage, page }) => {
    await page.setViewportSize({ width: 390, height: 844 });
    await homePage.navigateToHome();
    await homePage.assertHomePageLoaded();
    await expect(homePage.logo).toBeVisible();
  });

  // ── Performance ───────────────────────────────────────────────
  test('TC_HOME_016 — home page loads within acceptable time @regression', async ({ page }) => {
    const start = Date.now();
    await page.goto('/');
    await page.waitForLoadState('domcontentloaded');
    const loadTime = Date.now() - start;
    expect(loadTime).toBeLessThan(10_000); // 10 seconds threshold
  });
});
