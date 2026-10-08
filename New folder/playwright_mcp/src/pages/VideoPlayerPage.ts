import { Page, Locator, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class VideoPlayerPage extends BasePage {
  // ── Locators ─────────────────────────────────────────────────
  readonly videoPlayer: Locator;
  readonly playButton: Locator;
  readonly pauseButton: Locator;
  readonly playPauseToggle: Locator;
  readonly fullscreenButton: Locator;
  readonly exitFullscreenButton: Locator;
  readonly muteButton: Locator;
  readonly unmuteButton: Locator;
  readonly volumeSlider: Locator;
  readonly progressBar: Locator;
  readonly progressHandle: Locator;
  readonly currentTimeLabel: Locator;
  readonly totalDurationLabel: Locator;
  readonly settingsButton: Locator;
  readonly qualitySelector: Locator;
  readonly subtitleButton: Locator;
  readonly subtitleSelector: Locator;
  readonly nextEpisodeButton: Locator;
  readonly prevEpisodeButton: Locator;
  readonly skipIntroButton: Locator;
  readonly playerControls: Locator;
  readonly loadingSpinner: Locator;
  readonly errorOverlay: Locator;
  readonly watchPartyButton: Locator;
  readonly shareButton: Locator;
  readonly backButton: Locator;
  readonly contentTitle: Locator;

  constructor(page: Page) {
    super(page);
    this.videoPlayer        = page.locator('video, [data-testid="video-player"]').first();
    this.playButton         = page.locator('[aria-label*="play" i]:not([aria-label*="pause"])').first();
    this.pauseButton        = page.locator('[aria-label*="pause" i]').first();
    this.playPauseToggle    = page.locator('[class*="play-pause"], [data-testid="play-pause"]').first();
    this.fullscreenButton   = page.locator('[aria-label*="full screen"], [aria-label*="fullscreen"]').first();
    this.exitFullscreenButton = page.locator('[aria-label*="exit full"]').first();
    this.muteButton         = page.locator('[aria-label*="mute" i]').first();
    this.unmuteButton       = page.locator('[aria-label*="unmute" i]').first();
    this.volumeSlider       = page.locator('input[type="range"][aria-label*="volume" i]').first();
    this.progressBar        = page.locator('[class*="progress"], [role="slider"][aria-label*="time"]').first();
    this.progressHandle     = page.locator('[class*="progress-handle"], [class*="seek-handle"]').first();
    this.currentTimeLabel   = page.locator('[class*="current-time"], [data-testid="current-time"]').first();
    this.totalDurationLabel = page.locator('[class*="duration"], [data-testid="duration"]').first();
    this.settingsButton     = page.locator('[aria-label*="settings" i], [data-testid="settings"]').first();
    this.qualitySelector    = page.locator('[class*="quality"], [data-testid="quality"]').first();
    this.subtitleButton     = page.locator('[aria-label*="subtitle" i], [aria-label*="caption" i]').first();
    this.subtitleSelector   = page.locator('[class*="subtitle-option"]');
    this.nextEpisodeButton  = page.locator('[aria-label*="next episode"]').first();
    this.prevEpisodeButton  = page.locator('[aria-label*="previous episode"]').first();
    this.skipIntroButton    = page.getByRole('button', { name: /skip intro/i });
    this.playerControls     = page.locator('[class*="controls"], [data-testid="player-controls"]').first();
    this.loadingSpinner     = page.locator('[class*="spinner"], [class*="loading"]').first();
    this.errorOverlay       = page.locator('[class*="error-overlay"], [data-testid="error"]').first();
    this.watchPartyButton   = page.locator('[aria-label*="watch party"]').first();
    this.shareButton        = page.locator('[aria-label*="share"]').first();
    this.backButton         = page.locator('[aria-label*="back"], [class*="back-btn"]').first();
    this.contentTitle       = page.locator('[class*="title"], h1').first();
  }

  // ── Actions ──────────────────────────────────────────────────
  async waitForPlayerToLoad(): Promise<void> {
    await this.videoPlayer.waitFor({ state: 'visible', timeout: 30_000 });
    // Wait until loading spinner disappears
    try {
      await this.loadingSpinner.waitFor({ state: 'hidden', timeout: 15_000 });
    } catch {
      // spinner may never appear for fast-loading content
    }
  }

  async play(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await this.waitForElement(this.playerControls);
    await this.click(this.playButton);
  }

  async pause(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await this.waitForElement(this.playerControls);
    await this.click(this.pauseButton);
  }

  async togglePlayPause(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await this.page.keyboard.press('Space');
  }

  async mute(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await this.click(this.muteButton);
  }

  async unmute(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await this.click(this.unmuteButton);
  }

  async enterFullscreen(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await this.click(this.fullscreenButton);
  }

  async exitFullscreen(): Promise<void> {
    await this.pressKey('Escape');
  }

  async seekTo(percent: number): Promise<void> {
    const box = await this.progressBar.boundingBox();
    if (!box) return;
    const x = box.x + box.width * (percent / 100);
    const y = box.y + box.height / 2;
    await this.page.mouse.click(x, y);
  }

  async forwardByKeyboard(): Promise<void> {
    await this.page.keyboard.press('ArrowRight');
  }

  async rewindByKeyboard(): Promise<void> {
    await this.page.keyboard.press('ArrowLeft');
  }

  async setVolume(level: number): Promise<void> {
    await this.volumeSlider.fill(String(level));
  }

  async openSettings(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await this.click(this.settingsButton);
  }

  async selectQuality(quality: string): Promise<void> {
    await this.openSettings();
    await this.click(this.qualitySelector);
    await this.page.getByText(quality, { exact: false }).click();
  }

  async enableSubtitles(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await this.click(this.subtitleButton);
  }

  async clickSkipIntro(): Promise<void> {
    await this.skipIntroButton.waitFor({ state: 'visible', timeout: 15_000 });
    await this.click(this.skipIntroButton);
  }

  async clickNextEpisode(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await this.click(this.nextEpisodeButton);
    await this.waitForPlayerToLoad();
  }

  async getCurrentTime(): Promise<string> {
    return this.getText(this.currentTimeLabel);
  }

  async getTotalDuration(): Promise<string> {
    return this.getText(this.totalDurationLabel);
  }

  async isPlaying(): Promise<boolean> {
    return this.page.evaluate(() => {
      const video = document.querySelector('video');
      return video ? !video.paused : false;
    });
  }

  async isMuted(): Promise<boolean> {
    return this.page.evaluate(() => {
      const video = document.querySelector('video');
      return video ? video.muted : false;
    });
  }

  // ── Assertions ───────────────────────────────────────────────
  async assertPlayerVisible(): Promise<void> {
    await expect(this.videoPlayer).toBeVisible({ timeout: 30_000 });
  }

  async assertIsPlaying(): Promise<void> {
    const playing = await this.isPlaying();
    expect(playing).toBe(true);
  }

  async assertIsPaused(): Promise<void> {
    const playing = await this.isPlaying();
    expect(playing).toBe(false);
  }

  async assertIsMuted(): Promise<void> {
    const muted = await this.isMuted();
    expect(muted).toBe(true);
  }

  async assertFullscreenActive(): Promise<void> {
    const isFullscreen = await this.page.evaluate(() => !!document.fullscreenElement);
    expect(isFullscreen).toBe(true);
  }

  async assertPlayerControlsVisible(): Promise<void> {
    await this.hoverElement(this.videoPlayer);
    await expect(this.playerControls).toBeVisible();
  }

  async assertNoError(): Promise<void> {
    await expect(this.errorOverlay).not.toBeVisible();
  }
}
