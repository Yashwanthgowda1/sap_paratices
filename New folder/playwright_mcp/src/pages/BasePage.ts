import { Page, Locator, expect } from '@playwright/test';

/**
 * BasePage — shared methods inherited by every page object.
 * Never instantiated directly; always extended.
 */
export class BasePage {
  readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // ── Navigation ──────────────────────────────────────────────
  async navigateTo(path: string = '/'): Promise<void> {
    await this.page.goto(path);
    await this.waitForPageLoad();
  }

  async waitForPageLoad(): Promise<void> {
    await this.page.waitForLoadState('networkidle');
  }

  async getTitle(): Promise<string> {
    return this.page.title();
  }

  async getCurrentUrl(): Promise<string> {
    return this.page.url();
  }

  // ── Element Interactions ─────────────────────────────────────
  async click(locator: Locator): Promise<void> {
    await locator.waitFor({ state: 'visible' });
    await locator.click();
  }

  async fill(locator: Locator, value: string): Promise<void> {
    await locator.waitFor({ state: 'visible', timeout:1000 });
    await locator.clear();
    await locator.fill(value);
  }

  async selectOption(locator: Locator, value: string): Promise<void> {
    await locator.selectOption(value);
  }

  async getText(locator: Locator): Promise<string> {
    await locator.waitFor({ state: 'visible' });
    // nullish opetar
    return await locator.textContent() ?? '';
  }

  async isVisible(locator: Locator): Promise<boolean> {
    return locator.isVisible();
  }

  async isEnabled(locator: Locator): Promise<boolean> {
    return locator.isEnabled();
  }

  async hoverElement(locator: Locator): Promise<void> {
    await locator.hover();
  }

  async scrollIntoView(locator: Locator): Promise<void> {
    await locator.scrollIntoViewIfNeeded();
  }

  // ── Waits ────────────────────────────────────────────────────
  async waitForElement(locator: Locator, timeout = 10_000): Promise<void> {
    await locator.waitFor({ state: 'visible', timeout });
  }

  async waitForUrl(urlPattern: string | RegExp, timeout = 30_000): Promise<void> {
    await this.page.waitForURL(urlPattern, { timeout });
  }

  // ── Assertions ───────────────────────────────────────────────
  async assertVisible(locator: Locator, message?: string): Promise<void> {
    await expect(locator, message).toBeVisible();
  }

  async assertText(locator: Locator, text: string): Promise<void> {
    await expect(locator).toHaveText(text);
  }

  async assertContainsText(locator: Locator, text: string): Promise<void> {
    await expect(locator).toContainText(text);
  }

  async assertUrl(url: string | RegExp): Promise<void> {
    await expect(this.page).toHaveURL(url);
  }

  async assertTitle(title: string | RegExp): Promise<void> {
    await expect(this.page).toHaveTitle(title);
  }

  // ── Screenshot ───────────────────────────────────────────────
  async takeScreenshot(name: string): Promise<void> {
    await this.page.screenshot({ path: `test-results/screenshots/${name}.png`, fullPage: true });
  }

  // ── Storage ──────────────────────────────────────────────────
  async saveStorageState(path: string): Promise<void> {
    await this.page.context().storageState({ path });
  }

  // ── Keyboard / Mouse ─────────────────────────────────────────
  async pressKey(key: string): Promise<void> {
    await this.page.keyboard.press(key);
  }

  async clearAndType(locator: Locator, text: string): Promise<void> {
    await locator.clear();
    await locator.type(text);
  }
}
