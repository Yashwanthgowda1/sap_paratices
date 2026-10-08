import { defineConfig, devices } from '@playwright/test';
import * as dotenv from 'dotenv';

dotenv.config();

export default defineConfig({
  // Root test directory
  testDir: './tests',

  // Match all spec files
  testMatch: '**/*.spec.ts',

  // Maximum time one test can run
  timeout: Number(process.env.DEFAULT_TIMEOUT) || 30_000,

  // Maximum time for expect() to wait
  expect: { timeout: 10_000 },

  // Run tests in parallel
  fullyParallel: true,

  // Fail the build on CI if test.only left in source
  forbidOnly: !!process.env.CI,

  // Retry failed tests
  retries: process.env.CI ? 2 : Number(process.env.RETRIES) || 0,

  // Workers (parallel test runners)
  workers: process.env.CI ? 4 : Number(process.env.WORKERS) || 2,

  // Reporter configuration
  reporter: [
    ['list'],                                              // Console output
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    ['allure-playwright', { outputFolder: 'allure-results' }],
    ...(process.env.CI ? [['github'] as ['github']] : []),
  ],

  // Shared settings for ALL tests
  use: {
    // Base URL for navigation calls like page.goto('/')
    baseURL: process.env.BASE_URL || 'https://www.jiohotstar.com',

    // Navigation timeout
    navigationTimeout: Number(process.env.NAVIGATION_TIMEOUT) || 60_000,

    // Collect traces on first retry
    trace: 'on-first-retry',

    // Screenshot on failure
    screenshot: 'only-on-failure',

    // Video on first retry
    video: 'on-first-retry',

    // Slow down actions (useful for debug)
    launchOptions: {
      slowMo: Number(process.env.SLOW_MO) || 0,
      headless: process.env.HEADLESS !== 'false',
    },

    // Viewport
    viewport: { width: 1920, height: 1080 },

    // Locale
    locale: 'en-IN',

    // Timezone
    timezoneId: 'Asia/Kolkata',

    // Accept downloads
    acceptDownloads: true,

    // Ignore HTTPS errors
    ignoreHTTPSErrors: false,
  },

  // Per-project browser configurations
  projects: [
    // --- API tests: no browser required ---
    {
      name: 'api',
      testMatch: '**/tests/api/**/*.spec.ts',
      use: { baseURL: process.env.API_BASE_URL ?? 'https://restful-booker.herokuapp.com' },
    },

    // --- Setup project: authenticate and store session ---
    {
      name: 'setup',
      testMatch: '**/auth.setup.ts',
    },

    // --- Desktop Browsers ---
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        storageState: 'src/fixtures/.auth/user.json',
      },
      testIgnore: '**/tests/api/**',
      dependencies: ['setup'],
    },
    {
      name: 'firefox',
      use: {
        ...devices['Desktop Firefox'],
        storageState: 'src/fixtures/.auth/user.json',
      },
      testIgnore: '**/tests/api/**',
      dependencies: ['setup'],
    },
    {
      name: 'webkit',
      use: {
        ...devices['Desktop Safari'],
        storageState: 'src/fixtures/.auth/user.json',
      },
      testIgnore: '**/tests/api/**',
      dependencies: ['setup'],
    },

    // --- Mobile Viewports ---
    {
      name: 'mobile-chrome',
      use: {
        ...devices['Pixel 7'],
        storageState: 'src/fixtures/.auth/user.json',
      },
      testIgnore: '**/tests/api/**',
      dependencies: ['setup'],
    },
    {
      name: 'mobile-safari',
      use: {
        ...devices['iPhone 14'],
        storageState: 'src/fixtures/.auth/user.json',
      },
      testIgnore: '**/tests/api/**',
      dependencies: ['setup'],
    },

    // --- Unauthenticated tests (login, registration) ---
    {
      name: 'unauthenticated',
      testMatch: ['**/login.spec.ts', '**/logout.spec.ts'],
      use: { ...devices['Desktop Chrome'] },
    },
  ],

  // Output directory for test artifacts
  outputDir: 'test-results/',
});
