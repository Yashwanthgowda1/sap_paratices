import { Page } from '@playwright/test';

/** Wait for network requests matching a URL pattern to settle. */
export async function waitForApiResponse(page: Page, urlPattern: RegExp, timeout = 15_000): Promise<void> {
  await page.waitForResponse(
    (res) => urlPattern.test(res.url()) && res.status() < 400,
    { timeout }
  );
}

/** Return a random item from an array. */
export function randomItem<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

/** Generate a unique email for test registration flows. */
export function generateTestEmail(): string {
  const ts = Date.now();
  return `testuser_${ts}@mailinator.com`;
}

/** Pause execution — use sparingly and only when polling isn't an option. */
export function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/** Format a duration (ms) as a human-readable string. */
export function formatDuration(ms: number): string {
  const s = Math.floor(ms / 1000);
  const m = Math.floor(s / 60);
  return m > 0 ? `${m}m ${s % 60}s` : `${s}s`;
}

/** Retry a callback up to maxAttempts times, waiting delayMs between attempts. */
export async function retry<T>(
  fn: () => Promise<T>,
  maxAttempts = 3,
  delayMs = 1_000
): Promise<T> {
  let lastError: unknown;
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (err) {
      lastError = err;
      if (attempt < maxAttempts) await sleep(delayMs);
    }
  }
  throw lastError;
}

/** Convert time string "mm:ss" to total seconds. */
export function timeToSeconds(time: string): number {
  const parts = time.split(':').map(Number);
  if (parts.length === 2) return parts[0] * 60 + parts[1];
  if (parts.length === 3) return parts[0] * 3600 + parts[1] * 60 + parts[2];
  return 0;
}
