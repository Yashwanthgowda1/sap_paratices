import { APIRequestContext, APIResponse } from '@playwright/test';
import { Logger } from '../utils/logger';

export interface RequestOptions {
  headers?: Record<string, string>;
  params?:  Record<string, string | number | boolean>;
  data?:    unknown;
  timeout?: number;
}

export interface ApiResponse<T = unknown> {
  status:  number;
  body:    T;
  headers: Record<string, string>;
  ok:      boolean;
}

export class ApiClient {
  protected readonly request: APIRequestContext;
  protected readonly baseURL: string;
  protected readonly logger:  Logger;
  private   token:  string | null = null;

  constructor(request: APIRequestContext, baseURL: string, context = 'ApiClient') {
    this.request = request;
    this.baseURL  = baseURL.replace(/\/$/, '');
    this.logger   = new Logger(context);
  }

  setToken(token: string): void {
    this.token = token;
  }



  clearToken(): void {
    this.token = null;
  }


  
  private buildHeaders(extra?: Record<string, string>): Record<string, string> {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      Accept:         'application/json',
      ...extra,
    };
    if (this.token) headers['Authorization'] = `Basic ${this.token}`;
    return headers;
  }

  private url(path: string): string {
    return `${this.baseURL}/${path.replace(/^\//, '')}`;
  }

  private async parse<T>(res: APIResponse): Promise<ApiResponse<T>> {
    let body: T;
    const contentType = res.headers()['content-type'] ?? '';
    if (contentType.includes('application/json')) {
      body = (await res.json()) as T;
    } else {
      body = (await res.text()) as unknown as T;
    }
    return { status: res.status(), body, headers: res.headers(), ok: res.ok() };
  }

  async get<T = unknown>(path: string, opts: RequestOptions = {}): Promise<ApiResponse<T>> {
    this.logger.info(`GET ${this.url(path)}`);
    const res = await this.request.get(this.url(path), {
      headers: this.buildHeaders(opts.headers),
      params:  opts.params as Record<string, string>,
      timeout: opts.timeout,
    });
    return this.parse<T>(res);
  }

  async post<T = unknown>(path: string, opts: RequestOptions = {}): Promise<ApiResponse<T>> {
    this.logger.info(`POST ${this.url(path)}`);
    const res = await this.request.post(this.url(path), {
      headers: this.buildHeaders(opts.headers),
      data:    opts.data,
      timeout: opts.timeout,
    });
    return this.parse<T>(res);
  }

  async put<T = unknown>(path: string, opts: RequestOptions = {}): Promise<ApiResponse<T>> {
    this.logger.info(`PUT ${this.url(path)}`);
    const res = await this.request.put(this.url(path), {
      headers: this.buildHeaders(opts.headers),
      data:    opts.data,
      timeout: opts.timeout,
    });
    return this.parse<T>(res);
  }

  async patch<T = unknown>(path: string, opts: RequestOptions = {}): Promise<ApiResponse<T>> {
    this.logger.info(`PATCH ${this.url(path)}`);
    const res = await this.request.patch(this.url(path), {
      headers: this.buildHeaders(opts.headers),
      data:    opts.data,
      timeout: opts.timeout,
    });
    return this.parse<T>(res);
  }

  async delete<T = unknown>(path: string, opts: RequestOptions = {}): Promise<ApiResponse<T>> {
    this.logger.info(`DELETE ${this.url(path)}`);
    const res = await this.request.delete(this.url(path), {
      headers: this.buildHeaders(opts.headers),
      timeout: opts.timeout,
    });
    return this.parse<T>(res);
  }
}
