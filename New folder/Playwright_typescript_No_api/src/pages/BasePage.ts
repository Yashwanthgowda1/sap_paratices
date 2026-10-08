import { Page } from '@playwright/test';

export class BasePage {
  constructor(protected readonly page: Page) {}

  async navigate(path: string = ''): Promise<void> {
    await this.page.goto(path);
  }

  async getTitle(): Promise<string> {
    return this.page.title();
  }

  async waitForURL(pattern: RegExp): Promise<void> {
    await this.page.waitForURL(pattern);
  }
}
