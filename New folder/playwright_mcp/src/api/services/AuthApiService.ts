import { APIRequestContext } from '@playwright/test';
import { ApiClient, ApiResponse } from '../ApiClient';

export interface AuthPayload {
  username: string;
  password: string;
}

export interface AuthToken {
  token: string;
}

export class AuthApiService extends ApiClient {
  constructor(request: APIRequestContext, baseURL: string) {
    super(request, baseURL, 'AuthApiService');
  }

  /** POST /auth — get a token, store it, and return the response */
  async createToken(payload: AuthPayload): Promise<ApiResponse<AuthToken>> {
    const res = await this.post<AuthToken>('/auth', { data: payload });
    if (res.ok && res.body.token) {
      this.setToken(Buffer.from(`${payload.username}:${payload.password}`).toString('base64'));
      this.logger.info(`Token acquired (${res.body.token.substring(0, 6)}…)`);
    }
    return res;
  }

  /** POST /auth — attempt login with bad credentials */
  async createTokenInvalid(payload: AuthPayload): Promise<ApiResponse<unknown>> {
    return this.post<unknown>('/auth', { data: payload });
  }
}
