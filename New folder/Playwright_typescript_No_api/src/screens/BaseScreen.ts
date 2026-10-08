import { $, $$, browser, expect } from '@wdio/globals';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const driver = browser as any;

export abstract class BaseScreen {
  // ── Single-element actions (pass selector string) ─────────────────────────

  async tap(selector: string): Promise<void> {
    await (await $(selector)).click();
  }

  async typeText(selector: string, text: string): Promise<void> {
    await (await $(selector)).setValue(text);
  }

  async getText(selector: string): Promise<string> {
    return (await $(selector)).getText();
  }

  async isDisplayed(selector: string): Promise<boolean> {
    return (await $(selector)).isDisplayed().catch(() => false);
  }

  async waitForDisplayed(selector: string, timeout = 10_000): Promise<void> {
    await (await $(selector)).waitForDisplayed({ timeout });
  }

  async getElementCount(selector: string): Promise<number> {
    return (await $$(selector)).length;
  }

  async scrollToElement(selector: string): Promise<void> {
    await (await $(selector)).scrollIntoView();
  }

  // Helper for inline dynamic locators
  protected el(selector: string) {
    return $(selector);
  }

  // ── Activity check ────────────────────────────────────────────────────────

  async waitForActivity(activity: string, timeout = 10_000): Promise<void> {
    await driver.waitUntil(
      async () => {
        const current: string = await driver.getCurrentActivity();
        return current.includes(activity);
      },
      { timeout, timeoutMsg: `Activity '${activity}' not reached within ${timeout}ms` }
    );
  }

  // ── Hybrid App Context Switching ──────────────────────────────────────────
  // Pass 'WEBVIEW' → finds and switches to WebView context
  // Pass 'NATIVE_APP' → switches back to native

  async switchTo(target: 'WEBVIEW' | 'NATIVE_APP'): Promise<void> {
    if (target === 'WEBVIEW') {
      await driver.waitUntil(
        async () => {
          const ctxList: string[] = await driver.getContexts();
          return ctxList.some((ctx: string) => ctx.includes('WEBVIEW'));
        },
        { timeout: 10_000, timeoutMsg: 'No WebView context found within 10s' }
      );
      const contexts: string[] = await driver.getContexts();
      const webview = contexts.find((ctx: string) => ctx.includes('WEBVIEW'));
      await driver.switchContext(webview);
    } else {
      await driver.switchContext('NATIVE_APP');
    }
  }

  async getCurrentContext(): Promise<string> {
    return driver.getContext();
  }

  async isInWebView(): Promise<boolean> {
    const ctx = await this.getCurrentContext();
    return ctx.includes('WEBVIEW');
  }

  async switchToWebView(): Promise<void> {
    await this.switchTo('WEBVIEW');
  }

  async switchToNative(): Promise<void> {
    await this.switchTo('NATIVE_APP');
  }
}
