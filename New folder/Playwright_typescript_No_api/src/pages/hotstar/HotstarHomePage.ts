import { Page } from '@playwright/test';
import { HotstarBasePage } from './HotstarBasePage';

export class HotstarHomePage extends HotstarBasePage {
  private readonly heroBanner     = this.page.locator('[data-testid="hero-banner"], [class*="hero"], [class*="featured"]').first();
  private readonly moviesTab      = this.page.locator('nav a:has-text("Movies"), [aria-label="Movies"]').first();
  private readonly showsTab       = this.page.locator('nav a:has-text("Shows"), [aria-label="Shows"]').first();
  private readonly sportsTab      = this.page.locator('nav a:has-text("Sports"), [aria-label="Sports"]').first();
  private readonly searchIcon     = this.page.locator('[data-testid="search"], [aria-label*="Search"], [class*="search-icon"]').first();
  private readonly contentTiles   = this.page.locator('[data-testid="content-tile"], [class*="tile"], [class*="card"]');
  private readonly myListNav      = this.page.locator('a:has-text("My List"), [aria-label*="My List"], [href*="my-list"]').first();

  constructor(page: Page) {
    super(page);
  }

  async isHeroBannerVisible(): Promise<boolean> {
    return this.heroBanner.isVisible({ timeout: 15_000 }).catch(() => false);
  }

  async isNavTabVisible(tabName: 'Movies' | 'Shows' | 'Sports'): Promise<boolean> {
    const tab = this.page.locator(`nav a:has-text("${tabName}"), [aria-label="${tabName}"]`).first();
    return tab.isVisible().catch(() => false);
  }

  async clickMovies(): Promise<void> {
    await this.moviesTab.click();
  }

  async clickShows(): Promise<void> {
    await this.showsTab.click();
  }

  async openSearch(): Promise<void> {
    await this.searchIcon.click();
  }

  async getContentTileCount(): Promise<number> {
    return this.contentTiles.count();
  }

  async clickContentTile(index = 0): Promise<void> {
    await this.contentTiles.nth(index).click();
  }

  async goToMyList(): Promise<void> {
    await this.myListNav.click();
  }
}
