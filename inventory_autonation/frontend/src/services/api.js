import axios from 'axios';

const API_BASE = process.env.REACT_APP_API_URL || 'http://localhost:8000';

// Simple in-memory cache for reference data (categories, suppliers) that rarely changes.
// Entries expire after TTL_MS — avoids redundant fetches on every page navigation.
const TTL_MS = 30_000;
const _cache = {};
function cached(key, fn) {
  const hit = _cache[key];
  if (hit && Date.now() - hit.ts < TTL_MS) return Promise.resolve({ data: hit.data });
  return fn().then((res) => {
    _cache[key] = { data: res.data, ts: Date.now() };
    return res;
  });
}
export function invalidateCache(key) {
  if (key) delete _cache[key];
  else Object.keys(_cache).forEach((k) => delete _cache[k]);
}

const api = axios.create({
  baseURL: `${API_BASE}/api/v1`,
  headers: { 'Content-Type': 'application/json' },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('inv_token');
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('inv_token');
      localStorage.removeItem('inv_user');
      if (window.location.pathname !== '/login') {
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

// ─── AUTH ───
export const authAPI = {
  login: (data) => api.post('/auth/login', data),
  register: (data) => api.post('/auth/register', data),
};

// ─── USERS ───
export const usersAPI = {
  me: () => api.get('/users/me'),
  list: () => api.get('/users/'),
  create: (data) => api.post('/users/', data),
  update: (id, data) => api.put(`/users/${id}`, data),
  delete: (id) => api.delete(`/users/${id}`),
};

// ─── PRODUCTS ───
export const productsAPI = {
  list: (params) => api.get('/products/', { params }),
  get: (id) => api.get(`/products/${id}`),
  stats: () => api.get('/products/stats'),
  create: (data) => api.post('/products/', data),
  update: (id, data) => api.put(`/products/${id}`, data),
  delete: (id) => api.delete(`/products/${id}`),
};

// ─── CATEGORIES ───
export const categoriesAPI = {
  list: () => cached('categories', () => api.get('/categories/')),
  create: (data) => { invalidateCache('categories'); return api.post('/categories/', data); },
  update: (id, data) => { invalidateCache('categories'); return api.put(`/categories/${id}`, data); },
  delete: (id) => { invalidateCache('categories'); return api.delete(`/categories/${id}`); },
};

// ─── SUPPLIERS ───
export const suppliersAPI = {
  list: () => cached('suppliers', () => api.get('/suppliers/')),
  get: (id) => api.get(`/suppliers/${id}`),
  create: (data) => { invalidateCache('suppliers'); return api.post('/suppliers/', data); },
  update: (id, data) => { invalidateCache('suppliers'); return api.put(`/suppliers/${id}`, data); },
  delete: (id) => { invalidateCache('suppliers'); return api.delete(`/suppliers/${id}`); },
};

// ─── STOCK ───
export const stockAPI = {
  list: (params) => api.get('/stock/', { params }),
  create: (data) => api.post('/stock/', data),
};

// ─── BARCODE ───
export const barcodeAPI = {
  scan: (barcode) => api.get(`/barcode/scan/${barcode}`),
};

// ─── SALES ───
export const salesAPI = {
  list: (params) => api.get('/sales/', { params }),
  get: (id) => api.get(`/sales/${id}`),
  create: (data) => api.post('/sales/', data),
  summary: () => api.get('/sales/summary'),
};

// ─── REPORTS ───
export const reportsAPI = {
  dashboard: () => api.get('/reports/dashboard'),
  sales: (params) => api.get('/reports/sales', { params }),
  stock: () => api.get('/reports/stock'),
  productSales: (params) => api.get('/reports/product-sales', { params }),
  exportSalesCSV: (params) =>
    api.get('/reports/export/sales', { params, responseType: 'blob' }),
  exportStockCSV: () =>
    api.get('/reports/export/stock', { responseType: 'blob' }),
};

export default api;
