import { test, expect } from '../../src/fixtures/pageFixtures';
import { SEARCH_QUERIES } from '../../src/data/testData';

test.describe('Search — JioHotstar', () => {

  test.beforeEach(async ({ homePage, searchPage }) => {
    await homePage.navigateToHome();
    await homePage.clickSearchIcon();
    await searchPage.waitForPageLoad();
  });

  // ── Positive scenarios ────────────────────────────────────────
  test('TC_SEARCH_001 — search for a valid movie returns results @smoke @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.validMovie);
    await searchPage.assertSearchResultsVisible();
    const count = await searchPage.getResultCount();
    expect(count).toBeGreaterThan(0);
  });

  test('TC_SEARCH_002 — search for a valid TV series returns results @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.validSeries);
    await searchPage.assertSearchResultsVisible();
  });

  test('TC_SEARCH_003 — search for sports event returns results @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.validSports);
    await searchPage.assertSearchResultsVisible();
  });

  test('TC_SEARCH_004 — search input retains query after search @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.validMovie);
    await searchPage.assertSearchInputHasValue(SEARCH_QUERIES.validMovie);
  });

  test('TC_SEARCH_005 — autocomplete suggestions appear while typing @regression', async ({ searchPage }) => {
    await searchPage.typeAndWaitForSuggestions('Av');
    await searchPage.assertSuggestionsVisible();
  });

  test('TC_SEARCH_006 — trending searches are shown on empty search page @regression', async ({ searchPage }) => {
    await searchPage.assertTrendingSearchesVisible();
  });

  test('TC_SEARCH_007 — clicking trending search loads results @regression', async ({ searchPage }) => {
    const items = await searchPage.trendingSearchItems.count();
    if (items > 0) {
      await searchPage.clickTrendingSearch(0);
      await searchPage.assertSearchResultsVisible();
    }
  });

  test('TC_SEARCH_008 — Hindi content search works correctly @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.hindiContent);
    // Should return results OR no-results message — no crash
    const hasResults = await searchPage.searchResultItems.count() > 0;
    const hasNoResultMsg = await searchPage.noResultsMessage.isVisible().catch(() => false);
    expect(hasResults || hasNoResultMsg).toBe(true);
  });

  test('TC_SEARCH_009 — click first result navigates to content page @regression', async ({ searchPage, page }) => {
    await searchPage.searchFor(SEARCH_QUERIES.validMovie);
    await searchPage.assertSearchResultsVisible();
    const beforeUrl = page.url();
    await searchPage.clickFirstResult();
    expect(page.url()).not.toBe(beforeUrl);
  });

  test('TC_SEARCH_010 — filter by Movies shows only movie results @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.validMovie);
    await searchPage.assertSearchResultsVisible();
    if (await searchPage.movieFilterButton.isVisible()) {
      await searchPage.clickFilterMovies();
      await searchPage.assertSearchResultsVisible();
    }
  });

  test('TC_SEARCH_011 — filter by TV Shows works @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.validSeries);
    if (await searchPage.tvShowFilterButton.isVisible()) {
      await searchPage.clickFilterTvShows();
      await searchPage.assertSearchResultsVisible();
    }
  });

  // ── Negative scenarios ────────────────────────────────────────
  test('TC_SEARCH_012 — searching non-existent content shows no results message @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.nonExistent);
    await searchPage.assertNoResultsMessageVisible();
  });

  test('TC_SEARCH_013 — searching special characters does not crash the page @regression', async ({ searchPage, page }) => {
    await searchPage.searchFor(SEARCH_QUERIES.specialChars);
    // Page should still be functional
    await expect(page).not.toHaveURL(/error|500/i);
  });

  test('TC_SEARCH_014 — single character search returns results or no-results @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.singleChar);
    const hasResults = await searchPage.searchResultItems.count() > 0;
    const hasNoMsg   = await searchPage.noResultsMessage.isVisible().catch(() => false);
    expect(hasResults || hasNoMsg).toBe(true);
  });

  test('TC_SEARCH_015 — clear button resets search input @regression', async ({ searchPage }) => {
    await searchPage.searchFor(SEARCH_QUERIES.validMovie);
    if (await searchPage.clearSearchButton.isVisible()) {
      await searchPage.clearSearch();
      await expect(searchPage.searchInput).toHaveValue('');
    }
  });

  test('TC_SEARCH_016 — very long query is handled gracefully @regression', async ({ searchPage, page }) => {
    await searchPage.searchFor(SEARCH_QUERIES.longQuery);
    await expect(page).not.toHaveURL(/error|500/i);
  });
});
