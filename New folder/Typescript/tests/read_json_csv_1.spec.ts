import { test } from '@playwright/test';
import fs from 'fs';

test('Read JSON file', async () => {

  const data = JSON.parse(
    fs.readFileSync('config.json', 'utf-8')
  );

// console.log(data['users'][1]['permissions'])

console.log(data?.users[1].permissions)
});


// ---------------------------------------------------------------------------------------

// csv npm install csv-parse


import { parse } from 'csv-parse/sync';

interface CSVRow {
  name: string;
  role: string;
  permissions: string;
}
test.only('Read CSV file', async () => {

  // Read CSV content
  const fileContent = fs.readFileSync('config.csv', 'utf-8');

//   // Parse CSV
//   const records = parse(fileContent, {
//     columns: true,      // first row as keys
//     skip_empty_lines: true
//   });

 const records: CSVRow[] = parse(fileContent, {
    columns: true,
    skip_empty_lines: true
  });


  // Access first row
  console.log(records[0]); // { name: 'John', role: 'admin', permissions: 'read;write' }

console.log(records[1].name)
console.log(records[1].permissions)




});
