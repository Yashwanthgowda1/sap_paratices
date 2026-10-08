import { Page, Locator, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class ProfilePage extends BasePage {
  // ── Locators ─────────────────────────────────────────────────
  readonly profileIcon: Locator;
  readonly profileDropdown: Locator;
  readonly profileName: Locator;
  readonly profileEmail: Locator;
  readonly editProfileButton: Locator;
  readonly addProfileButton: Locator;
  readonly profileAvatar: Locator;
  readonly nameInput: Locator;
  readonly saveButton: Locator;
  readonly kidsProfileToggle: Locator;
  readonly languagePreference: Locator;
  readonly watchHistory: Locator;
  readonly clearHistoryButton: Locator;
  readonly manageDevicesLink: Locator;
  readonly subscriptionPlanInfo: Locator;
  readonly accountSettingsLink: Locator;
  readonly notificationSettings: Locator;
  readonly parentalControlsLink: Locator;
  readonly deleteProfileButton: Locator;
  readonly confirmDeleteButton: Locator;

  constructor(page: Page) {
    super(page);
    this.profileIcon          = page.locator('[data-testid="profile-icon"], [aria-label*="profile" i]').first();
    this.profileDropdown      = page.locator('[class*="profile-menu"], [class*="account-menu"]').first();
    this.profileName          = page.locator('[class*="profile-name"], [data-testid="profile-name"]').first();
    this.profileEmail         = page.locator('[class*="profile-email"], [data-testid="profile-email"]').first();
    this.editProfileButton    = page.getByRole('button', { name: /edit profile/i }).first();
    this.addProfileButton     = page.getByRole('button', { name: /add profile/i }).first();
    this.profileAvatar        = page.locator('[class*="avatar"], [class*="profile-pic"]').first();
    this.nameInput            = page.getByPlaceholder(/name/i).first();
    this.saveButton           = page.getByRole('button', { name: /save/i });
    this.kidsProfileToggle    = page.locator('[aria-label*="kids"], input[type="checkbox"]').first();
    this.languagePreference   = page.locator('[class*="language-pref"]').first();
    this.watchHistory         = page.getByRole('link', { name: /watch history/i });
    this.clearHistoryButton   = page.getByRole('button', { name: /clear history/i });
    this.manageDevicesLink    = page.getByRole('link', { name: /manage devices/i });
    this.subscriptionPlanInfo = page.locator('[class*="plan-info"], [data-testid="plan"]').first();
    this.accountSettingsLink  = page.getByRole('link', { name: /account settings/i });
    this.notificationSettings = page.getByRole('link', { name: /notifications/i }).first();
    this.parentalControlsLink = page.getByRole('link', { name: /parental controls/i });
    this.deleteProfileButton  = page.getByRole('button', { name: /delete profile/i });
    this.confirmDeleteButton  = page.getByRole('button', { name: /confirm|yes, delete/i });
  }

  // ── Actions ──────────────────────────────────────────────────
  async openProfileMenu(): Promise<void> {
    await this.click(this.profileIcon);
    await this.waitForElement(this.profileDropdown);
  }

  async navigateToProfileSettings(): Promise<void> {
    await this.openProfileMenu();
    await this.click(this.accountSettingsLink);
    await this.waitForPageLoad();
  }

  async editProfileName(newName: string): Promise<void> {
    await this.click(this.editProfileButton);
    await this.fill(this.nameInput, newName);
    await this.click(this.saveButton);
    await this.waitForPageLoad();
  }

  async addNewProfile(name: string, isKids = false): Promise<void> {
    await this.click(this.addProfileButton);
    await this.fill(this.nameInput, name);
    if (isKids) {
      await this.click(this.kidsProfileToggle);
    }
    await this.click(this.saveButton);
    await this.waitForPageLoad();
  }

  async deleteProfile(): Promise<void> {
    await this.click(this.deleteProfileButton);
    await this.waitForElement(this.confirmDeleteButton);
    await this.click(this.confirmDeleteButton);
    await this.waitForPageLoad();
  }

  async navigateToWatchHistory(): Promise<void> {
    await this.click(this.watchHistory);
    await this.waitForPageLoad();
  }

  async clearWatchHistory(): Promise<void> {
    await this.click(this.clearHistoryButton);
    await this.waitForPageLoad();
  }

  async getProfileName(): Promise<string> {
    return this.getText(this.profileName);
  }

  // ── Assertions ───────────────────────────────────────────────
  async assertProfileMenuOpen(): Promise<void> {
    await expect(this.profileDropdown).toBeVisible();
  }

  async assertProfileNameIs(name: string): Promise<void> {
    await expect(this.profileName).toContainText(name);
  }

  async assertSubscriptionPlanVisible(): Promise<void> {
    await expect(this.subscriptionPlanInfo).toBeVisible();
  }
}
