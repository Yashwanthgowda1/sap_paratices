import { Page } from '@playwright/test';
import { HotstarBasePage } from './HotstarBasePage';

export class HotstarSearchPage extends HotstarBasePage {
  private readonly searchInput    = this.page.locator('input[type="search"], input[placeholder*="Search"], input[data-testid="search-input"]').first();
  private readonly searchResults  = this.page.locator('[data-testid="search-result"], [class*="search-result"], [class*="tile"]');
  private readonly noResultsText  = this.page.locator('text=No results, text=no results found').first();

  constructor(page: Page) {
    super(page);
  }

  async searchFor(query: string): Promise<void> {
    await this.searchInput.fill(query);
    await this.page.keyboard.press('Enter');
    await this.page.waitForLoadState('networkidle').catch(() => {});
  }

  async getResultCount(): Promise<number> {
    return this.searchResults.count();
  }

  async clickFirstResult(): Promise<void> {
    await this.searchResults.first().click();
  }

  async isNoResultsVisible(): Promise<boolean> {
    return this.noResultsText.isVisible({ timeout: 5_000 }).catch(() => false);
  }
}
