import { test as base, Page } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';
import { HomePage } from '../pages/HomePage';
import { SearchPage } from '../pages/SearchPage';
import { VideoPlayerPage } from '../pages/VideoPlayerPage';
import { ProfilePage } from '../pages/ProfilePage';
import { SubscriptionPage } from '../pages/SubscriptionPage';
import { Logger } from '../utils/logger';

// All pages available as test fixtures
type PageObjects = {
  loginPage: LoginPage;
  homePage: HomePage;
  searchPage: SearchPage;
  videoPlayerPage: VideoPlayerPage;
  profilePage: ProfilePage;
  subscriptionPage: SubscriptionPage;
};

export const test = base.extend<PageObjects>({
  // ── Page Object fixtures ──────────────────────────────────────
  // use is call back function used for async the function 
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },

  homePage: async ({ page }, use) => {
    await use(new HomePage(page));
  },

  searchPage: async ({ page }, use) => {
    await use(new SearchPage(page));
  },

  videoPlayerPage: async ({ page }, use) => {
    await use(new VideoPlayerPage(page));
  },

  profilePage: async ({ page }, use) => {
    await use(new ProfilePage(page));
  },

  subscriptionPage: async ({ page }, use) => {
    await use(new SubscriptionPage(page));
  },

  // ── Global page hook: runs BEFORE every test ──────────────────
  page: async ({ page }, use, testInfo) => {
    const logger = new Logger(testInfo.title);

    // BEFORE: log test start
    logger.info(`▶ START — ${testInfo.title}`);
    logger.info(`  Project : ${testInfo.project.name}`);
    logger.info(`  File    : ${testInfo.file}`);

    // Set viewport
    await page.setViewportSize({ width: 1920, height: 1080 });

    // Attach a console log listener for browser errors
    page.on('console', (msg) => {
      if (msg.type() === 'error') logger.error(`[Browser console] ${msg.text()}`);
    });

    // Attach a page error listener
    page.on('pageerror', (err) => {
      logger.error(`[Page error] ${err.message}`);
    });

    // Run the actual test    
    await use(page);

    // AFTER: capture screenshot on failure
    if (testInfo.status !== testInfo.expectedStatus) {
      const screenshot = await page.screenshot({ fullPage: true });
      await testInfo.attach('failure-screenshot', {
        body: screenshot,
        contentType: 'image/png',
      });
      logger.error(`✗ FAILED — ${testInfo.title}`);
    } else {
      logger.info(`✓ PASSED — ${testInfo.title}`);
    }

    // Attach browser console logs to test report
    logger.info(`  Duration: ${testInfo.duration}ms`);
  },
});

export { expect } from '@playwright/test';
