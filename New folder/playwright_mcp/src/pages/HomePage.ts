import { Page, Locator, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class HomePage extends BasePage {
  // ── Locators ─────────────────────────────────────────────────
  readonly navBar: Locator;
  readonly logo: Locator;
  readonly searchIcon: Locator;
  readonly heroSection: Locator;
  readonly heroPlayButton: Locator;
  readonly heroBanner: Locator;
  readonly continueWatchingSection: Locator;
  readonly trendingSection: Locator;
  readonly recommendedSection: Locator;
  readonly moviesTab: Locator;
  readonly tvShowsTab: Locator;
  readonly sportsTab: Locator;
  readonly kidsTab: Locator;
  readonly newsTab: Locator;
  readonly contentCards: Locator;
  readonly carouselNextBtn: Locator;
  readonly carouselPrevBtn: Locator;
  readonly subscribeButton: Locator;
  readonly languageSelector: Locator;
  readonly notificationBell: Locator;
  readonly watchlistButton: Locator;
  readonly footerSection: Locator;
  readonly cookieBanner: Locator;
  readonly acceptCookiesBtn: Locator;

  constructor(page: Page) {
    super(page);
    this.navBar                 = page.locator('nav, [class*="navbar"], header').first();
    this.logo                   = page.locator('[class*="logo"], [aria-label*="Hotstar"]').first();
    this.searchIcon             = page.locator('[data-testid="search"], [aria-label="search"]').first();
    this.heroSection            = page.locator('[class*="hero"], [data-testid="hero"]').first();
    this.heroPlayButton         = page.locator('[class*="hero"] button[class*="play"]').first();
    this.heroBanner             = page.locator('[class*="banner"], [class*="carousel"]').first();
    this.continueWatchingSection = page.getByText(/continue watching/i).locator('..');
    this.trendingSection        = page.getByText(/trending/i).locator('..');
    this.recommendedSection     = page.getByText(/recommended/i).locator('..');
    this.moviesTab              = page.getByRole('link', { name: /movies/i });
    this.tvShowsTab             = page.getByRole('link', { name: /tv shows|series/i });
    this.sportsTab              = page.getByRole('link', { name: /sports/i });
    this.kidsTab                = page.getByRole('link', { name: /kids/i });
    this.newsTab                = page.getByRole('link', { name: /news/i });
    this.contentCards           = page.locator('[class*="card"], [class*="tile"]');
    this.carouselNextBtn        = page.locator('[aria-label*="next"], [class*="next-btn"]').first();
    this.carouselPrevBtn        = page.locator('[aria-label*="prev"], [class*="prev-btn"]').first();
    this.subscribeButton        = page.getByRole('button', { name: /subscribe|get plan/i }).first();
    this.languageSelector       = page.locator('[aria-label*="language"], [class*="language"]').first();
    this.notificationBell       = page.locator('[aria-label*="notification"]').first();
    this.watchlistButton        = page.getByRole('button', { name: /watchlist/i }).first();
    this.footerSection          = page.locator('footer');
    this.cookieBanner           = page.locator('[class*="cookie"], [id*="cookie"]').first();
    this.acceptCookiesBtn       = page.getByRole('button', { name: /accept|agree/i }).first();
  }

  // ── Actions ──────────────────────────────────────────────────
  async navigateToHome(): Promise<void> {
    await this.navigateTo('/');
    await this.acceptCookiesIfPresent();
  }

  async acceptCookiesIfPresent(): Promise<void> {
    try {
      await this.cookieBanner.waitFor({ state: 'visible', timeout: 3_000 });
      await this.click(this.acceptCookiesBtn);
    } catch {
      // No cookie banner — continue
    }
  }

  async clickMoviesTab(): Promise<void> {
    await this.click(this.moviesTab);
    await this.waitForPageLoad();
  }

  async clickTvShowsTab(): Promise<void> {
    await this.click(this.tvShowsTab);
    await this.waitForPageLoad();
  }

  async clickSportsTab(): Promise<void> {
    await this.click(this.sportsTab);
    await this.waitForPageLoad();
  }

  async clickKidsTab(): Promise<void> {
    await this.click(this.kidsTab);
    await this.waitForPageLoad();
  }

  async clickSearchIcon(): Promise<void> {
    await this.click(this.searchIcon);
  }

  async clickHeroPlayButton(): Promise<void> {
    await this.waitForElement(this.heroPlayButton);
    await this.click(this.heroPlayButton);
  }

  async scrollToFooter(): Promise<void> {
    await this.scrollIntoView(this.footerSection);
  }

  async getContentCardCount(): Promise<number> {
    return this.contentCards.count();
  }

  async clickFirstContentCard(): Promise<void> {
    await this.contentCards.first().click();
    await this.waitForPageLoad();
  }

  async navigateCarouselNext(): Promise<void> {
    await this.click(this.carouselNextBtn);
  }

  async navigateCarouselPrev(): Promise<void> {
    await this.click(this.carouselPrevBtn);
  }

  // ── Assertions ───────────────────────────────────────────────
  async assertHomePageLoaded(): Promise<void> {
    await expect(this.page).toHaveURL(/jiohotstar\.com|hotstar\.com/);
    await expect(this.navBar).toBeVisible();
    await expect(this.logo).toBeVisible();
  }

  async assertNavbarVisible(): Promise<void> {
    await expect(this.navBar).toBeVisible();
    await expect(this.moviesTab).toBeVisible();
    await expect(this.tvShowsTab).toBeVisible();
    await expect(this.sportsTab).toBeVisible();
  }

  async assertHeroSectionVisible(): Promise<void> {
    await expect(this.heroSection).toBeVisible();
  }

  async assertTrendingSectionVisible(): Promise<void> {
    await expect(this.trendingSection).toBeVisible();
  }

  async assertContentCardsLoaded(minCount = 1): Promise<void> {
    await expect(this.contentCards).toHaveCount(expect.any(Number) as unknown as number);
    const count = await this.contentCards.count();
    expect(count).toBeGreaterThanOrEqual(minCount);
  }
}
