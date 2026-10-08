import { Page, Locator, expect } from "@playwright/test";

type SelectInput = {
    type: "value" | "label" | "index";
    data: string | number;
};

type SingleDropDown = {
    value?: string;
    label?: string;
    index?: number;
};

export class Baseclass {
    readonly page: Page;

    constructor(page: Page) {
        this.page = page;
    }

    async alert_accept(text: string, type_action: string = "accept"): Promise<void> {
        this.page.on("dialog", async (dialog) => {
            console.log("the accept dialog is started");
            if (dialog.type() === "alert") {
                expect(dialog.message()).toContain(text);
            }
            if (type_action === "accept") {
                await dialog.accept();
            } else if (type_action === "dismiss") {
                await dialog.dismiss();
            }
        });
    }

    async confirm_accept(text: string, type_action: string = "accept"): Promise<void> {
        this.page.on("dialog", async (dialog) => {
            console.log("the confirm dialog is started");
            if (dialog.type() === "confirm") {
                expect(dialog.message()).toContain(text);
            }
            if (type_action === "accept") {
                await dialog.accept();
            } else if (type_action === "dismiss") {
                await dialog.dismiss();
            }
        });
    }

    async prompt_accept(text: string, type_action: string = "accept"): Promise<void> {
        this.page.on("dialog", async (dialog) => {
            console.log("the prompt dialog is started");
            if (dialog.type().toLowerCase() === "prompt") {
                expect(dialog.message()).toContain(text);
            }
            if (type_action === "accept") {
                await dialog.accept(text);
            } else if (type_action === "dismiss") {
                await dialog.dismiss();
            }
        });
    }

    async click(locator: Locator): Promise<void> {
        await locator.waitFor({ state: "visible", timeout: 30000 });
        await locator.click();
    }

    async get_Text(locator: Locator): Promise<string> {
        await locator.waitFor({ state: "visible", timeout: 30000 });
        return locator.innerText();
    }

    async vaidate_type_dropdown(dropdown: Locator): Promise<boolean> {
        return dropdown.evaluate((el) => {
            return (el as HTMLSelectElement).multiple;
        });
    }

    async select_by_values_index_dropdown(dropdown: Locator, ...each_values: SelectInput[]): Promise<void> {
        const options = each_values.map(each => {
            if (each.type === "index") {
                return { index: each.data as number };
            } else if (each.type === "label") {
                return { label: each.data as string };
            } else {
                return { value: each.data as string };
            }
        });
        await dropdown.selectOption(options as any);
    }

    async slect_single_drop_down(dropdown: Locator, each_values: SingleDropDown): Promise<void> {
     
        await dropdown.selectOption(each_values);
    }

    async deselect_values_index_label(locator: Locator, params: SelectInput[]): Promise<void> {
        await locator.evaluate((el, params) => {
            const select = el as HTMLSelectElement;
            for (let each of params) {
                for (let option of select.options) {
                    if (each.type === "value" && option.value === each.data) {
                        option.selected = false;
                    } else if (each.type === "label" && option.text === each.data) {
                        option.selected = false;
                    } else if (each.type === "index" && option.index === each.data) {
                        option.selected = false;
                    }
                }
            }
            select.dispatchEvent(new Event("change", { bubbles: true }));
        }, params);
    }
}
