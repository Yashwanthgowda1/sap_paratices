import { test as base, expect } from '@playwright/test';
import { HotstarLoginPage } from '../pages/hotstar/HotstarLoginPage';
import { HotstarHomePage } from '../pages/hotstar/HotstarHomePage';
import { HotstarSearchPage } from '../pages/hotstar/HotstarSearchPage';
import { HotstarContentDetailPage } from '../pages/hotstar/HotstarContentDetailPage';

type HotstarFixtures = {
  loginPage: HotstarLoginPage;
  homePage: HotstarHomePage;
  searchPage: HotstarSearchPage;
  contentDetailPage: HotstarContentDetailPage;
  authenticatedHome: void;
};

export const test = base.extend<HotstarFixtures>({
  loginPage: async ({ page }, use) => {
    await use(new HotstarLoginPage(page));
  },

  homePage: async ({ page }, use) => {
    await use(new HotstarHomePage(page));
  },

  searchPage: async ({ page }, use) => {
    await use(new HotstarSearchPage(page));
  },

  contentDetailPage: async ({ page }, use) => {
    await use(new HotstarContentDetailPage(page));
  },

  // Navigates to Hotstar home — login is via OTP so cannot be fully automated
  // without a real OTP; fixture lands on home page ready for tests.
  authenticatedHome: async ({ page }, use) => {
    const home = new HotstarHomePage(page);
    await home.goto();
    await home.waitForPageReady();
    await home.dismissAdsOrModals();
    await use();
  },
});

export { expect } from '@playwright/test';
