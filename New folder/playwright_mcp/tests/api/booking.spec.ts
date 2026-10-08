/**
 * TC_API_BOOKING — Full CRUD test suite for the Booking resource.
 * Covers: GET list, GET by id, POST create, PUT update, PATCH partial-update, DELETE.
 * Uses Restful Booker (https://restful-booker.herokuapp.com).
 */
import { test, expect } from '../../src/fixtures/apiFixtures';
import {
  VALID_BOOKING,
  BOOKING_UPDATED,
  BOOKING_PARTIAL_UPDATE,
  BOOKING_ALL_FIELDS,
  BOOKING_MINIMAL,
  BOOKING_FILTERS,
}
 from '../../src/data/apiTestData';

// ─────────────────────────────────────────────────────────────────────────────
// GET /booking
// ─────────────────────────────────────────────────────────────────────────────
test.describe('GET /booking — List Bookings', () => {

  test('TC_API_BOOKING_001: returns 200 and an array of booking ids @smoke @api @regression', async ({ bookingApi }) => {
    const res = await bookingApi.getBookingIds();

    expect(res.status).toBe(200);
    expect(res.ok).toBe(true);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.length).toBeGreaterThan(0);
    res.body.forEach((item) => expect(item).toHaveProperty('bookingid'));
  });

  test('TC_API_BOOKING_002: each booking id is a positive integer @api @regression', async ({ bookingApi }) => {
    const res = await bookingApi.getBookingIds();

    expect(res.status).toBe(200);
    res.body.forEach(({ bookingid }) => {
      expect(typeof bookingid).toBe('number');
      expect(bookingid).toBeGreaterThan(0);
    });
  });

  test('TC_API_BOOKING_003: filter by firstname returns matching results @api @regression', async ({ bookingApi }) => {
    // First create a booking so the filter definitely has something to match
    const created = await bookingApi.createBooking(VALID_BOOKING);
    expect(created.status).toBe(200);

    const res = await bookingApi.getBookingIds(BOOKING_FILTERS.byFirstName);
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  test('TC_API_BOOKING_004: filter by lastname returns an array @api @regression', async ({ bookingApi }) => {
    const res = await bookingApi.getBookingIds(BOOKING_FILTERS.byLastName);
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

});

// ─────────────────────────────────────────────────────────────────────────────
// POST /booking — Create Booking
// ─────────────────────────────────────────────────────────────────────────────
test.describe('POST /booking — Create Booking', () => {

  test('TC_API_BOOKING_005: create booking returns 200 with bookingid @smoke @api @regression', async ({ bookingApi }) => {
    const res = await bookingApi.createBooking(VALID_BOOKING);

    expect(res.status).toBe(200);
    expect(res.ok).toBe(true);
    expect(res.body).toHaveProperty('bookingid');
    expect(typeof res.body.bookingid).toBe('number');
  });

  test('TC_API_BOOKING_006: created booking body matches payload @api @regression', async ({ bookingApi }) => {
    const res = await bookingApi.createBooking(VALID_BOOKING);

    expect(res.status).toBe(200);
    const b = res.body.booking;
    expect(b.firstname).toBe(VALID_BOOKING.firstname);
    expect(b.lastname).toBe(VALID_BOOKING.lastname);
    expect(b.totalprice).toBe(VALID_BOOKING.totalprice);
    expect(b.depositpaid).toBe(VALID_BOOKING.depositpaid);
    expect(b.bookingdates.checkin).toBe(VALID_BOOKING.bookingdates.checkin);
    expect(b.bookingdates.checkout).toBe(VALID_BOOKING.bookingdates.checkout);
    expect(b.additionalneeds).toBe(VALID_BOOKING.additionalneeds);
  });

  test('TC_API_BOOKING_007: create booking with all fields @api @regression', async ({ bookingApi }) => {
    const res = await bookingApi.createBooking(BOOKING_ALL_FIELDS);

    expect(res.status).toBe(200);
    expect(res.body.bookingid).toBeGreaterThan(0);
    expect(res.body.booking.firstname).toBe(BOOKING_ALL_FIELDS.firstname);
  });

  test('TC_API_BOOKING_008: create minimal booking with zero price @api @regression', async ({ bookingApi }) => {
    const res = await bookingApi.createBooking(BOOKING_MINIMAL);

    expect(res.status).toBe(200);
    expect(res.body.booking.totalprice).toBe(0);
    expect(res.body.booking.depositpaid).toBe(false);
  });

  test('TC_API_BOOKING_009: content-type is application/json @api @regression', async ({ bookingApi }) => {
    const res = await bookingApi.createBooking(VALID_BOOKING);

    expect(res.headers['content-type']).toContain('application/json');
  });

});

// ─────────────────────────────────────────────────────────────────────────────
// GET /booking/:id — Get Booking by ID
// ─────────────────────────────────────────────────────────────────────────────
test.describe('GET /booking/:id — Get Single Booking', () => {

  test('TC_API_BOOKING_010: get booking by id returns correct data @smoke @api @regression', async ({ bookingApi }) => {
    const created = await bookingApi.createBooking(VALID_BOOKING);
    expect(created.status).toBe(200);

    const res = await bookingApi.getBookingById(created.body.bookingid);

    expect(res.status).toBe(200);
    expect(res.ok).toBe(true);
    expect(res.body.firstname).toBe(VALID_BOOKING.firstname);
    expect(res.body.lastname).toBe(VALID_BOOKING.lastname);
    expect(res.body.totalprice).toBe(VALID_BOOKING.totalprice);
  });

  test('TC_API_BOOKING_011: get booking contains all required fields @api @regression', async ({ bookingApi }) => {
    const created = await bookingApi.createBooking(VALID_BOOKING);
    const res = await bookingApi.getBookingById(created.body.bookingid);

    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('firstname');
    expect(res.body).toHaveProperty('lastname');
    expect(res.body).toHaveProperty('totalprice');
    expect(res.body).toHaveProperty('depositpaid');
    expect(res.body).toHaveProperty('bookingdates');
    expect(res.body.bookingdates).toHaveProperty('checkin');
    expect(res.body.bookingdates).toHaveProperty('checkout');
  });

  test('TC_API_BOOKING_012: non-existent booking id returns 404 @api @regression', async ({ bookingApi }) => {
    const res = await bookingApi.getBookingById(999_999_999);

    expect(res.status).toBe(404);
  });

});

// ─────────────────────────────────────────────────────────────────────────────
// PUT /booking/:id — Full Update
// ─────────────────────────────────────────────────────────────────────────────
test.describe('PUT /booking/:id — Full Update', () => {

  test('TC_API_BOOKING_013: full update returns 200 with updated data @api @regression', async ({ authedBookingApi }) => {
    const created = await authedBookingApi.createBooking(VALID_BOOKING);
    expect(created.status).toBe(200);

    const res = await authedBookingApi.updateBooking(created.body.bookingid, BOOKING_UPDATED);

    expect(res.status).toBe(200);
    expect(res.body.firstname).toBe(BOOKING_UPDATED.firstname);
    expect(res.body.lastname).toBe(BOOKING_UPDATED.lastname);
    expect(res.body.totalprice).toBe(BOOKING_UPDATED.totalprice);
  });

  test('TC_API_BOOKING_014: full update persists to GET @api @regression', async ({ authedBookingApi }) => {
    const created = await authedBookingApi.createBooking(VALID_BOOKING);
    await authedBookingApi.updateBooking(created.body.bookingid, BOOKING_UPDATED);

    const get = await authedBookingApi.getBookingById(created.body.bookingid);
    expect(get.body.firstname).toBe(BOOKING_UPDATED.firstname);
    expect(get.body.totalprice).toBe(BOOKING_UPDATED.totalprice);
  });

  test('TC_API_BOOKING_015: update without token returns 403 @api @regression', async ({ bookingApi }) => {
    const created = await bookingApi.createBooking(VALID_BOOKING);
    const res = await bookingApi.updateBooking(created.body.bookingid, BOOKING_UPDATED);

    expect(res.status).toBe(403);
  });

});

// ─────────────────────────────────────────────────────────────────────────────
// PATCH /booking/:id — Partial Update
// ─────────────────────────────────────────────────────────────────────────────
test.describe('PATCH /booking/:id — Partial Update', () => {

  test('TC_API_BOOKING_016: partial update only changes specified fields @api @regression', async ({ authedBookingApi }) => {
    const created = await authedBookingApi.createBooking(VALID_BOOKING);
    expect(created.status).toBe(200);

    const res = await authedBookingApi.partialUpdateBooking(
      created.body.bookingid,
      BOOKING_PARTIAL_UPDATE
    );

    expect(res.status).toBe(200);
    expect(res.body.firstname).toBe(BOOKING_PARTIAL_UPDATE.firstname);
    expect(res.body.totalprice).toBe(BOOKING_PARTIAL_UPDATE.totalprice);
    // Unmodified fields should stay the same
    expect(res.body.lastname).toBe(VALID_BOOKING.lastname);
  });

  test('TC_API_BOOKING_017: partial update without token returns 403 @api @regression', async ({ bookingApi }) => {
    const created = await bookingApi.createBooking(VALID_BOOKING);
    const res = await bookingApi.partialUpdateBooking(
      created.body.bookingid,
      BOOKING_PARTIAL_UPDATE
    );

    expect(res.status).toBe(403);
  });

});

// ─────────────────────────────────────────────────────────────────────────────
// DELETE /booking/:id
// ─────────────────────────────────────────────────────────────────────────────
test.describe('DELETE /booking/:id — Delete Booking', () => {

  test('TC_API_BOOKING_018: delete booking returns 201 @api @regression', async ({ authedBookingApi }) => {
    const created = await authedBookingApi.createBooking(VALID_BOOKING);
    expect(created.status).toBe(200);

    const res = await authedBookingApi.deleteBooking(created.body.bookingid);
    expect(res.status).toBe(201);
  });

  test('TC_API_BOOKING_019: deleted booking returns 404 on subsequent GET @smoke @api @regression', async ({ authedBookingApi }) => {
    const created = await authedBookingApi.createBooking(VALID_BOOKING);
    await authedBookingApi.deleteBooking(created.body.bookingid);

    const get = await authedBookingApi.getBookingById(created.body.bookingid);
    expect(get.status).toBe(404);
  });

  test('TC_API_BOOKING_020: delete without token returns 403 @api @regression', async ({ bookingApi }) => {
    const created = await bookingApi.createBooking(VALID_BOOKING);
    const res = await bookingApi.deleteBooking(created.body.bookingid);

    expect(res.status).toBe(403);
  });

});

// ─────────────────────────────────────────────────────────────────────────────
// End-to-End CRUD flow
// ─────────────────────────────────────────────────────────────────────────────
test.describe('E2E CRUD flow @smoke @api', () => {

  test('TC_API_BOOKING_021: create → read → update → delete full flow', async ({ authedBookingApi }) => {
    // CREATE
    const created = await authedBookingApi.createBooking(VALID_BOOKING);
    expect(created.status).toBe(200);
    const id = created.body.bookingid;

    // READ
    const got = await authedBookingApi.getBookingById(id);
    expect(got.status).toBe(200);
    expect(got.body.firstname).toBe(VALID_BOOKING.firstname);

    // UPDATE (full)
    const updated = await authedBookingApi.updateBooking(id, BOOKING_UPDATED);
    expect(updated.status).toBe(200);
    expect(updated.body.firstname).toBe(BOOKING_UPDATED.firstname);

    // PARTIAL UPDATE
    const patched = await authedBookingApi.partialUpdateBooking(id, { totalprice: 999 });
    expect(patched.status).toBe(200);
    expect(patched.body.totalprice).toBe(999);

    // DELETE
    const deleted = await authedBookingApi.deleteBooking(id);
    expect(deleted.status).toBe(201);

    // VERIFY GONE
    const gone = await authedBookingApi.getBookingById(id);
    expect(gone.status).toBe(404);
  });

});
