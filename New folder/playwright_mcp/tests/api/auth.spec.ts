/**
 * TC_API_AUTH — Authentication API tests (POST /auth)
 * Uses the Restful Booker public practice API.
 */
import { test, expect } from '../../src/fixtures/apiFixtures';
import { API_CREDENTIALS, INVALID_API_CREDENTIALS } from '../../src/data/apiTestData';

test.describe('Authentication API', () => {

  test('TC_API_AUTH_001: valid credentials return a token @smoke @api @regression', async ({ authApi }) => {
    const res = await authApi.createToken(API_CREDENTIALS);

    expect(res.status).toBe(200);
    expect(res.ok).toBe(true);
    expect(res.body).toHaveProperty('token');
    expect(typeof res.body.token).toBe('string');
    expect(res.body.token.length).toBeGreaterThan(0);
  });

  test('TC_API_AUTH_002: response Content-Type is application/json @api @regression', async ({ authApi }) => {
    const res = await authApi.createToken(API_CREDENTIALS);

    expect(res.headers['content-type']).toContain('application/json');
  });

  test('TC_API_AUTH_003: token has expected string format @api @regression', async ({ authApi }) => {
    const res = await authApi.createToken(API_CREDENTIALS);

    expect(res.status).toBe(200);
    // Restful Booker tokens are alphanumeric strings
    expect(res.body.token).toMatch(/^[a-zA-Z0-9]+$/);
  });

  test('TC_API_AUTH_004: wrong password returns reason field @api @regression', async ({ authApi }) => {
    const res = await authApi.createTokenInvalid(INVALID_API_CREDENTIALS);

    expect(res.status).toBe(200); // API returns 200 but with reason field
    expect(res.body).toHaveProperty('reason');
  });

  test('TC_API_AUTH_005: empty credentials return error reason @api @regression', async ({ authApi }) => {
    const res = await authApi.createTokenInvalid({ username: '', password: '' });

    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('reason');
  });

  test('TC_API_AUTH_006: repeated auth calls each return a valid token @api @regression', async ({ authApi }) => {
    const first  = await authApi.createToken(API_CREDENTIALS);
    const second = await authApi.createToken(API_CREDENTIALS);

    expect(first.status).toBe(200);
    expect(second.status).toBe(200);
    expect(first.body.token.length).toBeGreaterThan(0);
    expect(second.body.token.length).toBeGreaterThan(0);
  });

});
