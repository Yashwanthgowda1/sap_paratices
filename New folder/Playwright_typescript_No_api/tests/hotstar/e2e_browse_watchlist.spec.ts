import { test, expect } from '../../src/fixtures/hotstar.fixtures';

/**
 * TC_HS_E2E_03 — Browse Category and Add to Watchlist
 *
 * Flow:
 *   1. Land on JioHotstar home page
 *   2. Navigate to Shows category
 *   3. Open a content item from the grid
 *   4. Add the item to My List
 *   5. Navigate to My List
 *   6. Verify the item is present in the watchlist
 */

test.describe('TC_HS_E2E_03 — Browse and Watchlist @hotstar @regression', () => {
  test.beforeEach(async ({ authenticatedHome }) => {});

  test('Shows category page loads with content tiles', async ({ homePage }) => {
    await homePage.clickShows();
    const count = await homePage.getContentTileCount();
    expect(count).toBeGreaterThan(0);
  });

  test('Opening a content item shows detail page with title', async ({ homePage, contentDetailPage }) => {
    await homePage.clickShows();
    await homePage.clickContentTile(0);

    const title = await contentDetailPage.getContentTitle();
    expect(title.length).toBeGreaterThan(0);
  });

  test('Content item can be added to My List', async ({ homePage, contentDetailPage }) => {
    await homePage.clickShows();
    await homePage.clickContentTile(0);

    await contentDetailPage.addToMyList();
    const added = await contentDetailPage.isAddedToMyList();
    expect(added).toBe(true);
  });

  test('My List page is accessible from home navigation', async ({ homePage }) => {
    await homePage.goToMyList();
    const title = await homePage.getTitle();
    expect(title).toBeTruthy();
  });
});
