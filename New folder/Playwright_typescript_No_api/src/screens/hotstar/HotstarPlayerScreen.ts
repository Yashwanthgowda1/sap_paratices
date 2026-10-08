import { BaseScreen } from '../BaseScreen';

export class HotstarPlayerScreen extends BaseScreen {
  private readonly contentTitle  = 'in.startv.hotstar:id/tv_content_title';
  private readonly watchNowBtn   = 'in.startv.hotstar:id/btn_watch_now';
  private readonly addToListBtn  = 'in.startv.hotstar:id/iv_add_to_list';
  private readonly removeListBtn = 'in.startv.hotstar:id/iv_remove_from_list';
  private readonly videoPlayer   = 'in.startv.hotstar:id/player_view';
  private readonly playBtn       = 'in.startv.hotstar:id/exo_play';
  private readonly myListItems   = 'in.startv.hotstar:id/rv_my_list';

  async getContentTitle(): Promise<string> {
    await this.waitForDisplayed(this.contentTitle, 10_000);
    return this.getText(this.contentTitle);
  }

  async isWatchNowVisible(): Promise<boolean> {
    return this.isDisplayed(this.watchNowBtn).catch(() => false);
  }

  async tapWatchNow(): Promise<void> {
    await this.tap(this.watchNowBtn);
  }

  async isPlayerVisible(): Promise<boolean> {
    return this.isDisplayed(this.videoPlayer).catch(() => false);
  }

  async addToMyList(): Promise<void> {
    await this.tap(this.addToListBtn);
  }

  async isAddedToMyList(): Promise<boolean> {
    return this.isDisplayed(this.removeListBtn).catch(() => false);
  }

  async isMyListPopulated(): Promise<boolean> {
    return this.isDisplayed(this.myListItems).catch(() => false);
  }
}
