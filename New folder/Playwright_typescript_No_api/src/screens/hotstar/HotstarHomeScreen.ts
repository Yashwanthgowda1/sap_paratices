import { BaseScreen } from '../BaseScreen';

export class HotstarHomeScreen extends BaseScreen {

  // Accessibility ID — ~prefix, works on both Android and iOS
  private readonly moviesTab     = '~Movies';
  private readonly showsTab      = '~Shows';
  private readonly sportsTab     = '~Sports';

  // Resource ID — WebdriverIO detects `:id/` and uses ID strategy (fastest)
  private readonly heroBanner    = 'in.startv.hotstar:id/cl_hero_container';
  private readonly searchIcon    = 'in.startv.hotstar:id/iv_search';
  private readonly myListBtn     = 'in.startv.hotstar:id/tv_my_list';

  // XPath — string starting with // triggers XPath strategy automatically
  private readonly contentItem   = '//android.widget.FrameLayout[@resource-id="in.startv.hotstar:id/iv_content_thumbnail"]';

  async isHeroBannerVisible(): Promise<boolean> {
    return this.isDisplayed(this.heroBanner).catch(() => false);
  }

  async isNavTabVisible(tab: 'Movies' | 'Shows' | 'Sports'): Promise<boolean> {
    return this.isDisplayed(`~${tab}`).catch(() => false);
  }

  // Pass an array of tabs — returns true only if ALL are visible
  async areNavTabsVisible(tabs: Array<'Movies' | 'Shows' | 'Sports'>): Promise<boolean> {
    const results = await Promise.all(tabs.map(tab => this.isDisplayed(`~${tab}`).catch(() => false)));
    return results.every(visible => visible === true);
  }

  async waitForHomeScreen(): Promise<void> {
    await this.waitForDisplayed(this.heroBanner, 20_000);
  }

  async tapSearch(): Promise<void> {
    await this.tap(this.searchIcon);
  }

  async tapMovies(): Promise<void> {
    await this.tap(this.moviesTab);
  }

  async tapShows(): Promise<void> {
    await this.tap(this.showsTab);
  }

  async tapFirstContentItem(): Promise<void> {
    await this.tap(this.contentItem);
  }

  async tapMyList(): Promise<void> {
    await this.tap(this.myListBtn);
  }
}
