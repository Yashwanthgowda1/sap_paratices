import { defineConfig, devices } from '@playwright/test';
import { ENV } from './config/env.config';

export default defineConfig({
  testDir: './tests',
  testIgnore: ['**/android/**'],   // android tests run via wdio, not Playwright
  fullyParallel: true,
  forbidOnly: !!process.env['CI'],
  retries: process.env['CI'] ? 2 : 0,
  workers: process.env['CI'] ? 2 : undefined,
  timeout: 30_000,
  expect: { timeout: 5_000 },

  reporter: [
    ['html', { open: 'never', outputFolder: 'playwright-report' }],
    ['list'],
    ['junit', { outputFile: 'test-results/results.xml' }],
  ],

  use: {
    baseURL: ENV.BASE_URL,
    headless: ENV.HEADLESS,
    slowMo: ENV.SLOW_MO,
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  projects: [
    // ── Desktop Web ──────────────────────────────────────────────────────────
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },

    // ── Mobile Web (browser emulation — no device required) ──────────────────
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 13'] },
    },
  ],

  outputDir: 'test-results',
});
