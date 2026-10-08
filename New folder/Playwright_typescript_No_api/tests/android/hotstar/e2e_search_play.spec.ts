import { expect } from '@wdio/globals';
import { screens } from '../../../src/screens';

/**
 * TC_AND_HS_E2E_02 — Search and Play Content (Android)
 *
 * Flow:
 *   1. Home screen is loaded
 *   2. Open search
 *   3. Search for "Loki"
 *   4. Verify results appear
 *   5. Tap first result → verify content detail
 *   6. Tap Watch Now → verify player loads
 */

describe('TC_AND_HS_E2E_02 — Android Search and Play @android @regression', () => {

  before(async () => {
    await screens.home.waitForHomeScreen();
  });

  it('Tapping search icon opens search screen', async () => {
    await screens.home.tapSearch();
    const visible = await screens.search.isDisplayed('in.startv.hotstar:id/et_search');
    expect(visible).toBe(true);
  });

  it('Searching for a valid title returns results', async () => {
    await screens.search.searchFor('Loki');
    await screens.search.waitForResults();
    const count = await screens.search.getResultCount();
    expect(count).toBeGreaterThan(0);
  });

  it('Tapping a result opens content detail with a title', async () => {
    await screens.search.tapFirstResult();
    const title = await screens.player.getContentTitle();
    expect(title.length).toBeGreaterThan(0);
  });

  it('Watch Now button is visible on content detail page', async () => {
    const visible = await screens.player.isWatchNowVisible();
    expect(visible).toBe(true);
  });

  it('Tapping Watch Now launches the video player', async () => {
    await screens.player.tapWatchNow();
    const playerVisible = await screens.player.isPlayerVisible();
    expect(playerVisible).toBe(true);
  });
});
