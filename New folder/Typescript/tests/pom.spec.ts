// WRONG — no test block, just plain code


// CORRECT — must have test() block
import { test } from "@playwright/test"
import fs from "fs"
import { parse } from "csv-parse/sync";

test("read csv", async ({ page }) => {
      const fileContent = fs.readFileSync("tests/config.csv", "utf-8");
    
    const records = parse(fileContent, {
        columns: true,           // header row as keys
        skip_empty_lines: true
    });

    console.log(records[0].name)
});
