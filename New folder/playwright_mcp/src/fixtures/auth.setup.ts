/**
 * Global auth setup — runs once before the test suite via the "setup" project.
 * Saves authenticated storage state so other tests reuse the session instead
 * of logging in on every single test (faster and more stable).
 */
import { test as setup, expect } from '@playwright/test';
import * as path from 'path';
import * as fs from 'fs';
import * as dotenv from 'dotenv';

dotenv.config();

const AUTH_FILE = path.join(__dirname, '.auth/user.json');

setup('authenticate user', async ({ page }) => {
  // Ensure .auth directory exists
  const authDir = path.dirname(AUTH_FILE);
  if (!fs.existsSync(authDir)) {
    fs.mkdirSync(authDir, { recursive: true });
  }

  const email    = process.env.VALID_EMAIL    ?? '';
  const password = process.env.VALID_PASSWORD ?? '';

  if (!email || !password) {
    console.warn('[Setup] VALID_EMAIL / VALID_PASSWORD not set — skipping auth setup');
    // Save empty state so tests that depend on this file don't crash
    await page.context().storageState({ path: AUTH_FILE });
    return;
  }

  // Navigate to home
  await page.goto(process.env.BASE_URL ?? 'https://www.jiohotstar.com');
  await page.waitForLoadState('networkidle');

  // Click Sign In
  const loginBtn = page.getByRole('button', { name: /sign in|log in/i }).first();
  await loginBtn.waitFor({ state: 'visible', timeout: 15_000 });
  await loginBtn.click();

  // Fill email
  const emailInput = page.getByPlaceholder(/email/i);
  await emailInput.waitFor({ state: 'visible', timeout: 10_000 });
  await emailInput.fill(email);
  await page.getByRole('button', { name: /continue/i }).click();

  // Fill password
  const passwordInput = page.getByPlaceholder(/password/i);
  await passwordInput.waitFor({ state: 'visible', timeout: 10_000 });
  await passwordInput.fill(password);
  await page.getByRole('button', { name: /log in|sign in|submit/i }).click();

  // Wait for successful login — profile icon becomes visible
  const profileIcon = page.locator('[data-testid="profile-icon"], [aria-label*="profile" i]').first();
  await expect(profileIcon).toBeVisible({ timeout: 20_000 });

  // Persist storage state
  await page.context().storageState({ path: AUTH_FILE });
  console.log(`[Setup] Auth state saved to ${AUTH_FILE}`);
});
