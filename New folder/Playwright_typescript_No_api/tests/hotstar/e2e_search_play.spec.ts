import { test, expect } from '../../src/fixtures/hotstar.fixtures';
import { hotstar } from '../../test-data/hotstar';

/**
 * TC_HS_E2E_02 — Search and Content Detail Verification
 *
 * Flow:
 *   1. Land on JioHotstar home page
 *   2. Open search
 *   3. Search for a valid title ("Loki")
 *   4. Verify search results are returned
 *   5. Click the first result
 *   6. Verify content detail page: title visible, Watch Now button present
 *   7. Verify video player launches on clicking Watch Now
 */

test.describe('TC_HS_E2E_02 — Search and Play Content @hotstar @regression', () => {
  test.beforeEach(async ({ authenticatedHome }) => {});

  test('Search returns results for a valid query', async ({ homePage, searchPage }) => {
    await homePage.openSearch();
    await searchPage.searchFor(hotstar.search.validQuery);

    const count = await searchPage.getResultCount();
    expect(count).toBeGreaterThan(0);
  });

  test('No results message shown for an invalid query', async ({ homePage, searchPage }) => {
    await homePage.openSearch();
    await searchPage.searchFor(hotstar.search.invalidQuery);

    const noResults = await searchPage.isNoResultsVisible();
    expect(noResults).toBe(true);
  });

  test('Content detail page shows title and Watch Now button', async ({ homePage, searchPage, contentDetailPage }) => {
    await homePage.openSearch();
    await searchPage.searchFor(hotstar.search.validQuery);
    await searchPage.clickFirstResult();

    const title = await contentDetailPage.getContentTitle();
    expect(title.length).toBeGreaterThan(0);

    const watchNowVisible = await contentDetailPage.isWatchNowVisible();
    expect(watchNowVisible).toBe(true);
  });

  test('Clicking Watch Now launches the video player', async ({ homePage, searchPage, contentDetailPage }) => {
    await homePage.openSearch();
    await searchPage.searchFor(hotstar.search.validQuery);
    await searchPage.clickFirstResult();
    await contentDetailPage.clickWatchNow();

    const playerVisible = await contentDetailPage.isPlayerVisible();
    expect(playerVisible).toBe(true);
  });
});
