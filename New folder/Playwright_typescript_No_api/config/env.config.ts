import * as dotenv from 'dotenv';
dotenv.config();

export const ENV = {
  BASE_URL: process.env['BASE_URL'] ?? 'https://www.hotstar.com/in',
  HEADLESS: process.env['HEADLESS'] !== 'false',
  SLOW_MO: Number(process.env['SLOW_MO'] ?? 0),
};
