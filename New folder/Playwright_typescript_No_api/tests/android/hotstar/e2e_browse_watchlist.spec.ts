import { expect } from '@wdio/globals';
import { screens } from '../../../src/screens';

/**
 * TC_AND_HS_E2E_03 — Browse Category and Add to Watchlist (Android)
 *
 * Flow:
 *   1. Home screen loaded
 *   2. Tap Shows tab
 *   3. Tap first content item
 *   4. Add to My List → verify added
 *   5. Navigate to My List → verify populated
 */

describe('TC_AND_HS_E2E_03 — Android Browse and Watchlist @android @regression', () => {

  before(async () => {
    await screens.home.waitForHomeScreen();
  });

  it('Tapping Shows tab loads content grid', async () => {
    await screens.home.tapShows();
    const visible = await screens.home.isNavTabVisible('Shows');
    expect(visible).toBe(true);
  });

  it('Tapping a content item opens its detail page', async () => {
    await screens.home.tapFirstContentItem();
    const title = await screens.player.getContentTitle();
    expect(title.length).toBeGreaterThan(0);
  });

  it('Adding content to My List shows the remove button', async () => {
    await screens.player.addToMyList();
    const added = await screens.player.isAddedToMyList();
    expect(added).toBe(true);
  });

  it('My List screen is accessible and contains items', async () => {
    await screens.home.tapMyList();
    const populated = await screens.player.isMyListPopulated();
    expect(populated).toBe(true);
  });
});
