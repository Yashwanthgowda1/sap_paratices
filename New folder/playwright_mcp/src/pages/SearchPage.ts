import { Page, Locator, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class SearchPage extends BasePage {
  // ── Locators ─────────────────────────────────────────────────
  readonly searchInput: Locator;
  readonly searchResults: Locator;
  readonly searchResultItems: Locator;
  readonly noResultsMessage: Locator;
  readonly clearSearchButton: Locator;
  readonly filterButtons: Locator;
  readonly movieFilterButton: Locator;
  readonly tvShowFilterButton: Locator;
  readonly sportsFilterButton: Locator;
  readonly trendingSearches: Locator;
  readonly trendingSearchItems: Locator;
  readonly recentSearches: Locator;
  readonly searchSuggestions: Locator;
  readonly resultCount: Locator;
  readonly firstResultCard: Locator;

  constructor(page: Page) {
    super(page);
    this.searchInput        = page.locator('[placeholder*="Search"], input[type="search"], [data-testid="search-input"]').first();
    this.searchResults      = page.locator('[class*="search-result"], [data-testid="search-results"]').first();
    this.searchResultItems  = page.locator('[class*="result-item"], [class*="card"], [class*="tile"]');
    this.noResultsMessage   = page.getByText(/no results|no content found|nothing found/i);
    this.clearSearchButton  = page.locator('[aria-label*="clear"], [class*="clear"]').first();
    this.filterButtons      = page.locator('[class*="filter-btn"], [role="tab"]');
    this.movieFilterButton  = page.getByRole('button', { name: /movies/i }).first();
    this.tvShowFilterButton = page.getByRole('button', { name: /tv shows|series/i }).first();
    this.sportsFilterButton = page.getByRole('button', { name: /sports/i }).first();
    this.trendingSearches   = page.getByText(/trending searches/i).locator('..');
    this.trendingSearchItems = page.locator('[class*="trending"] [class*="item"], [class*="trending"] a');
    this.recentSearches     = page.getByText(/recent searches/i).locator('..');
    this.searchSuggestions  = page.locator('[class*="suggestion"], [class*="autocomplete"]');
    this.resultCount        = page.locator('[class*="result-count"]').first();
    this.firstResultCard    = page.locator('[class*="card"], [class*="tile"]').first();
  }

  // ── Actions ──────────────────────────────────────────────────
  async navigateToSearch(): Promise<void> {
    await this.navigateTo('/search');
    await this.waitForPageLoad();
  }

  async searchFor(query: string): Promise<void> {
    await this.waitForElement(this.searchInput);
    await this.fill(this.searchInput, query);
    await this.page.keyboard.press('Enter');
    await this.waitForPageLoad();
  }

  async typeAndWaitForSuggestions(query: string): Promise<void> {
    await this.waitForElement(this.searchInput);
    await this.fill(this.searchInput, query);
    await this.waitForElement(this.searchSuggestions, 5_000);
  }

  async clearSearch(): Promise<void> {
    await this.click(this.clearSearchButton);
  }

  async clickFilterMovies(): Promise<void> {
    await this.click(this.movieFilterButton);
    await this.waitForPageLoad();
  }

  async clickFilterTvShows(): Promise<void> {
    await this.click(this.tvShowFilterButton);
    await this.waitForPageLoad();
  }

  async clickFilterSports(): Promise<void> {
    await this.click(this.sportsFilterButton);
    await this.waitForPageLoad();
  }

  async clickFirstResult(): Promise<void> {
    await this.waitForElement(this.firstResultCard);
    await this.click(this.firstResultCard);
    await this.waitForPageLoad();
  }

  async clickTrendingSearch(index = 0): Promise<void> {
    await this.trendingSearchItems.nth(index).click();
    await this.waitForPageLoad();
  }

  async getResultCount(): Promise<number> {
    return this.searchResultItems.count();
  }

  async getSearchSuggestions(): Promise<string[]> {
    await this.waitForElement(this.searchSuggestions);
    return this.searchSuggestions.allTextContents();
  }

  // ── Assertions ───────────────────────────────────────────────
  async assertSearchResultsVisible(): Promise<void> {
    await expect(this.searchResultItems.first()).toBeVisible({ timeout: 10_000 });
  }

  async assertNoResultsMessageVisible(): Promise<void> {
    await expect(this.noResultsMessage).toBeVisible({ timeout: 5_000 });
  }

  async assertResultCountAtLeast(min: number): Promise<void> {
    const count = await this.searchResultItems.count();
    expect(count).toBeGreaterThanOrEqual(min);
  }

  async assertSearchInputHasValue(value: string): Promise<void> {
    await expect(this.searchInput).toHaveValue(value);
  }

  async assertSuggestionsVisible(): Promise<void> {
    await expect(this.searchSuggestions).toBeVisible({ timeout: 5_000 });
  }

  async assertTrendingSearchesVisible(): Promise<void> {
    await expect(this.trendingSearches).toBeVisible();
  }
}
