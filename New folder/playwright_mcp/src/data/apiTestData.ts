import type { BookingPayload } from '../api/services/BookingApiService';
import type { AuthPayload }    from '../api/services/AuthApiService';

export const API_CREDENTIALS: AuthPayload = {
  username: 'admin',
  password: 'password123',
};

export const INVALID_API_CREDENTIALS: AuthPayload = {
  username: 'wrong_user',
  password: 'wrong_pass',
};

export const VALID_BOOKING: BookingPayload = {
  firstname:       'James',
  lastname:        'Brown',
  totalprice:      500,
  depositpaid:     true,
  bookingdates: {
    checkin:  '2025-01-15',
    checkout: '2025-01-20',
  },
  additionalneeds: 'Breakfast',
};

export const BOOKING_UPDATED: BookingPayload = {
  firstname:       'Jane',
  lastname:        'Smith',
  totalprice:      750,
  depositpaid:     false,
  bookingdates: {
    checkin:  '2025-03-01',
    checkout: '2025-03-07',
  },
  additionalneeds: 'Late checkout',
};

export const BOOKING_PARTIAL_UPDATE = {
  firstname:  'UpdatedName',
  totalprice: 999,
};

/** A booking that exercises all optional fields */
export const BOOKING_ALL_FIELDS: BookingPayload = {
  firstname:       'Alice',
  lastname:        'Wonderland',
  totalprice:      1200,
  depositpaid:     true,
  bookingdates: {
    checkin:  '2025-06-01',
    checkout: '2025-06-10',
  },
  additionalneeds: 'Airport shuttle, room service',
};

/** A booking with minimum required data */
export const BOOKING_MINIMAL: BookingPayload = {
  firstname:       'Bob',
  lastname:        'Minimal',
  totalprice:      0,
  depositpaid:     false,
  bookingdates: {
    checkin:  '2025-07-01',
    checkout: '2025-07-02',
  },
  additionalneeds: '',
};

export const BOOKING_FILTERS = {
  byFirstName: { firstname: 'James' },
  byLastName:  { lastname:  'Brown' },
};
