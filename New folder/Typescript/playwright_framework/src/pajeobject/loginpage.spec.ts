import { Locator, Page } from "@playwright/test";
import { Baseclass } from "../utility/Baseclass.spec";

export class loginonly extends Baseclass {
    readonly js_alert: Locator;
    readonly js_confirm: Locator;
    readonly js_prompt: Locator;

    constructor(page: Page) {
        super(page);
        this.js_alert = page.getByText("Click for JS Alert");
        this.js_confirm = page.getByText("Click for JS Confirm");
        this.js_prompt = page.getByText("Click for JS Prompt");
    }

    async click_and_handel_js_alert(expected_text: string = ""): Promise<void> {
        this.alert_accept(expected_text);   // register handler before triggering click
        await this.js_alert.click();
    }

    async click_and_handel_js_confirm(expected_text: string = "", type_action: string = "accept"): Promise<void> {
        this.confirm_accept(expected_text, type_action);
        await this.js_confirm.click();
    }

    async click_and_handel_js_prompt(expected_text: string = "", type_action: string = "accept"): Promise<void> {
        this.prompt_accept(expected_text, type_action);
        await this.js_prompt.click();
    }
}
