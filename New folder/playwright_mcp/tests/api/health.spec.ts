/**
 * TC_API_HEALTH — Restful-Booker health check
 * Verifies the API is reachable and returning 201 from the /ping endpoint.
 */
import { test, expect } from '../../src/fixtures/apiFixtures';

test.describe('API Health Check', () => {

  test('TC_API_HEALTH_001: ping endpoint returns 201 @smoke @api', async ({ bookingApi }) => {
    const res = await bookingApi.get('/ping');
    expect(res.status).toBe(201);
  });

});
