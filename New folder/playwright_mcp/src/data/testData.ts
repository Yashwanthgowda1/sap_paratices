import * as dotenv from 'dotenv';
dotenv.config();

export const TEST_USERS = {
  valid: {
    email:    process.env.VALID_EMAIL    ?? 'valid@example.com',
    password: process.env.VALID_PASSWORD ?? 'Test@1234',
    phone:    process.env.PHONE_NUMBER   ?? '9999999999',
  },
  invalid: {
    email:    process.env.INVALID_EMAIL    ?? 'invalid@example.com',
    password: process.env.INVALID_PASSWORD ?? 'WrongPass@1',
  },
  unregistered: {
    email: 'notregistered_xyz123@example.com',
    password: 'AnyPass@123',
  },
} as const;

export const SEARCH_QUERIES = {
  validMovie:     'Avengers',
  validSeries:    'Breaking Bad',
  validSports:    'IPL',
  specialChars:   '@#$%^&*()',
  singleChar:     'A',
  longQuery:      'a'.repeat(100),
  emptyString:    '',
  hindiContent:   'महाभारत',
  tamilContent:   'விக்ரம்',
  nonExistent:    'xyznonexistent123abc',
} as const;

export const SUBSCRIPTION_PLANS = {
  mobile: {
    name:  'Mobile',
    price: '149',
  },
  super: {
    name:  'Super',
    price: '299',
  },
  premium: {
    name:  'Premium',
    price: '1499',
  },
} as const;

export const PAYMENT_DATA = {
  validUpi:     'success@paytm',
  invalidUpi:   'invalid_upi_id',
  validCoupon:  'HOTSTAR50',
  invalidCoupon:'EXPIRED999',
  testCard: {
    number: '4111111111111111',
    expiry: '12/26',
    cvv:    '123',
    name:   'Test User',
  },
} as const;

export const CONTENT = {
  featuredMovie:  'Jawan',
  featuredSeries: 'Loki',
  sportEvent:     'IPL 2024',
  kidsContent:    'Doraemon',
} as const;

export const URLS = {
  home:         '/',
  login:        '/in/v2/login',
  search:       '/search',
  subscribe:    '/subscribe',
  watchHistory: '/account/history',
  profile:      '/account/profile',
} as const;
