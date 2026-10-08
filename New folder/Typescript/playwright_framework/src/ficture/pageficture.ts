import { test as base, expect } from '@playwright/test';
import { loginonly } from "../pajeobject/loginpage.spec";

type PageObjects = {
    loginPage: loginonly;
};

export const test = base.extend<PageObjects>({
    loginPage: async ({ page }, use) => {
        await use(new loginonly(page));
    },
});

export { expect };
