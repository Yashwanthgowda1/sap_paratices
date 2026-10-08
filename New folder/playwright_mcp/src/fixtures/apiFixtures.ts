import { test as base } from '@playwright/test';
import * as dotenv from 'dotenv';
import { AuthApiService }    from '../api/services/AuthApiService';
import { BookingApiService } from '../api/services/BookingApiService';
import { Logger }            from '../utils/logger';

dotenv.config();

const API_BASE_URL = process.env.API_BASE_URL ?? 'https://restful-booker.herokuapp.com';

type ApiFixtures = {
  authApi:    AuthApiService;
  bookingApi: BookingApiService;
  /** bookingApi pre-loaded with an auth token */
  authedBookingApi: BookingApiService;
};

export const test = base.extend<ApiFixtures>({
  authApi: async ({ request }, use, testInfo) => {
    const logger = new Logger(testInfo.title);
    logger.info(`▶ START [API] — ${testInfo.title}`);
    const service = new AuthApiService(request, API_BASE_URL);
    await use(service);
    logger.info(
      testInfo.status === testInfo.expectedStatus
        ? `✓ PASSED [API] — ${testInfo.title}`
        : `✗ FAILED [API] — ${testInfo.title}`
    );
  },

  bookingApi: async ({ request }, use) => {
    await use(new BookingApiService(request, API_BASE_URL));
  },

  authedBookingApi: async ({ request }, use) => {
    const auth    = new AuthApiService(request, API_BASE_URL);
    const booking = new BookingApiService(request, API_BASE_URL);

    const res = await auth.createToken({
      username: process.env.API_USERNAME ?? 'admin',
      password: process.env.API_PASSWORD ?? 'password123',
    });

    if (res.ok && res.body.token) {
      booking.setAuthToken(res.body.token);
    }

    await use(booking);
  },
});

export { expect } from '@playwright/test';
