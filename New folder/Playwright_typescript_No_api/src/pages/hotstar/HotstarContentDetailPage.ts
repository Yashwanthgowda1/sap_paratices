import { Page } from '@playwright/test';
import { HotstarBasePage } from './HotstarBasePage';

export class HotstarContentDetailPage extends HotstarBasePage {
  private readonly contentTitle   = this.page.locator('h1, [data-testid="content-title"], [class*="title"]').first();
  private readonly watchNowBtn    = this.page.locator('button:has-text("Watch Now"), button:has-text("Play"), [data-testid="play-btn"]').first();
  private readonly addToMyListBtn = this.page.locator('button:has-text("My List"), button[aria-label*="My List"], [data-testid="add-to-list"]').first();
  private readonly videoPlayer    = this.page.locator('video, [data-testid="player"], [class*="player"]').first();
  private readonly contentDesc    = this.page.locator('[data-testid="synopsis"], [class*="synopsis"], [class*="description"]').first();

  constructor(page: Page) {
    super(page);
  }

  async getContentTitle(): Promise<string> {
    await this.contentTitle.waitFor({ timeout: 10_000 });
    return this.contentTitle.innerText();
  }

  async isWatchNowVisible(): Promise<boolean> {
    return this.watchNowBtn.isVisible({ timeout: 8_000 }).catch(() => false);
  }

  async clickWatchNow(): Promise<void> {
    await this.watchNowBtn.click();
  }

  async isPlayerVisible(): Promise<boolean> {
    return this.videoPlayer.isVisible({ timeout: 15_000 }).catch(() => false);
  }

  async addToMyList(): Promise<void> {
    await this.addToMyListBtn.waitFor({ timeout: 5_000 });
    await this.addToMyListBtn.click();
  }

  async isAddedToMyList(): Promise<boolean> {
    // After adding, the button label changes to "Remove from My List" or icon changes
    const removed = this.page.locator('button:has-text("Remove"), button[aria-label*="Remove from My List"]').first();
    return removed.isVisible({ timeout: 5_000 }).catch(() => false);
  }
}
