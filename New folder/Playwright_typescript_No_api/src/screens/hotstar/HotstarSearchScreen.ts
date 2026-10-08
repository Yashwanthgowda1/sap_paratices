
import { BaseScreen } from '../BaseScreen';

export class HotstarSearchScreen extends BaseScreen {
  private readonly searchInput   = 'in.startv.hotstar:id/et_search';
  private readonly resultItem    = 'in.startv.hotstar:id/iv_content_thumbnail';
  private readonly noResultsText = 'in.startv.hotstar:id/tv_no_results';

  async searchFor(query: string): Promise<void> {
    await this.typeText(this.searchInput, query);
  }

  async getResultCount(): Promise<number> {
    return this.getElementCount(this.resultItem);
  }

  async tapFirstResult(): Promise<void> {
    await this.tap(this.resultItem);
  }

  async isNoResultsVisible(): Promise<boolean> {
    return this.isDisplayed(this.noResultsText).catch(() => false);
  }

  async waitForResults(timeout = 8_000): Promise<void> {
    await this.waitForDisplayed(this.resultItem, timeout);
  }
}
