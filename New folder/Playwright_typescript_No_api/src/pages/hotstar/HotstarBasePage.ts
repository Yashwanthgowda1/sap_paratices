import { Page } from '@playwright/test';
import { BasePage } from '../BasePage';
import { hotstar } from '@test-data/hotstar';

export class HotstarBasePage extends BasePage {
  constructor(page: Page) {
    super(page);
  }

  async goto(): Promise<void> {
    await this.page.goto(hotstar.baseUrl);
  }

  async waitForPageReady(): Promise<void> {
    await this.page.waitForLoadState('domcontentloaded');
  }

  async dismissAdsOrModals(): Promise<void> {
    const closeBtn = this.page.locator('[aria-label="Close"]').first();
    if (await closeBtn.isVisible({ timeout: 3_000 }).catch(() => false)) {
      await closeBtn.click();
    }
  }
}
