export const hotstar = {
  baseUrl: process.env['HOTSTAR_URL'] ?? 'https://www.hotstar.com/in',

  credentials: {
    mobile:   process.env['HOTSTAR_MOBILE']   ?? '9999999999',
    email:    process.env['HOTSTAR_EMAIL']    ?? 'testuser@example.com',
    password: process.env['HOTSTAR_PASSWORD'] ?? 'Test@1234',
    otp:      process.env['HOTSTAR_OTP']      ?? '123456',
  },

  search: {
    validQuery:   'Loki',
    invalidQuery: 'xyzxyzxyz123notfound',
  },

  content: {
    movieTitle: 'Avengers: Endgame',
    showTitle:  'Loki',
  },

  nav: {
    movies: 'Movies',
    shows:  'Shows',
    sports: 'Sports',
    kids:   'Kids',
  },
} as const;
