import React, { useEffect, useState, useCallback } from 'react';
import { stockAPI, productsAPI } from '../services/api';

export default function Stock() {
  const [transactions, setTransactions] = useState([]);
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState({
    product_id: '', transaction_type: 'add', quantity: '', notes: '',
  });
  const [formError, setFormError] = useState('');
  const [formLoading, setFormLoading] = useState(false);
  const [filterProductId, setFilterProductId] = useState('');
  const [search, setSearch] = useState('');

  const loadData = useCallback(async () => {
    setLoading(true);
    try {
      const [txRes, prodRes] = await Promise.all([
        stockAPI.list({ product_id: filterProductId || undefined, limit: 100 }),
        productsAPI.list({ limit: 500 }),
      ]);
      setTransactions(txRes.data);
      setProducts(prodRes.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [filterProductId]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setFormError('');
    if (!form.product_id || !form.quantity) {
      setFormError('Select a product and enter quantity.');
      return;
    }
    setFormLoading(true);
    try {
      await stockAPI.create({
        product_id: Number(form.product_id),
        transaction_type: form.transaction_type,
        quantity: Number(form.quantity),
        notes: form.notes || undefined,
      });
      setForm({ product_id: '', transaction_type: 'add', quantity: '', notes: '' });
      loadData();
    } catch (err) {
      setFormError(err.response?.data?.detail || 'Failed to record transaction.');
    } finally {
      setFormLoading(false);
    }
  };

  const txTypeColor = {
    add: 'badge-success',
    reduce: 'badge-danger',
    damaged: 'badge-warning',
    adjustment: 'badge-blue',
  };

  const txTypeLabel = { add: '+ Add', reduce: '- Reduce', damaged: '⚠ Damaged', adjustment: '↔ Adjust' };

  const filteredTx = transactions.filter((t) => {
    if (!search) return true;
    return t.product?.name?.toLowerCase().includes(search.toLowerCase());
  });

  return (
    <div>
      <div className="page-title">Stock Management</div>
      <div className="page-subtitle">Track and manage inventory stock levels</div>

      <div className="grid-2" style={{ gap: 20, alignItems: 'start' }}>
        {/* Add Transaction Form */}
        <div className="card">
          <div className="card-title" style={{ marginBottom: 16 }}>📋 Record Stock Transaction</div>
          {formError && <div className="alert alert-error">{formError}</div>}
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Product *</label>
              <select
                value={form.product_id}
                onChange={(e) => setForm({ ...form, product_id: e.target.value })}
              >
                <option value="">— Select Product —</option>
                {products.map((p) => (
                  <option key={p.id} value={p.id}>
                    {p.name} (Stock: {p.stock_quantity})
                  </option>
                ))}
              </select>
            </div>
            <div className="form-group">
              <label>Transaction Type *</label>
              <select
                value={form.transaction_type}
                onChange={(e) => setForm({ ...form, transaction_type: e.target.value })}
              >
                <option value="add">Add Stock</option>
                <option value="reduce">Reduce Stock</option>
                <option value="damaged">Mark as Damaged</option>
                <option value="adjustment">Stock Adjustment (set exact qty)</option>
              </select>
            </div>
            <div className="form-group">
              <label>
                Quantity *{' '}
                {form.transaction_type === 'adjustment' && (
                  <span style={{ color: 'var(--accent-yellow)', fontSize: 11 }}>
                    (will set stock to this value)
                  </span>
                )}
              </label>
              <input
                type="number"
                min="0"
                placeholder="Enter quantity"
                value={form.quantity}
                onChange={(e) => setForm({ ...form, quantity: e.target.value })}
              />
            </div>
            <div className="form-group">
              <label>Notes</label>
              <textarea
                placeholder="Optional notes about this transaction"
                value={form.notes}
                onChange={(e) => setForm({ ...form, notes: e.target.value })}
                style={{ minHeight: 60 }}
              />
            </div>
            <button type="submit" className="btn btn-primary w-full" disabled={formLoading}>
              {formLoading ? 'Recording...' : '✓ Record Transaction'}
            </button>
          </form>
        </div>

        {/* Current Stock Overview */}
        <div className="card">
          <div className="card-title" style={{ marginBottom: 12 }}>📦 Current Stock Overview</div>
          <div className="search-input-wrap" style={{ marginBottom: 12 }}>
            <span className="search-icon">🔍</span>
            <input
              placeholder="Search products..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>
          <div style={{ maxHeight: 420, overflowY: 'auto' }}>
            {products
              .filter((p) => !search || p.name.toLowerCase().includes(search.toLowerCase()))
              .map((p) => (
                <div
                  key={p.id}
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    padding: '8px 0',
                    borderBottom: '1px solid var(--border)',
                  }}
                >
                  <div>
                    <div style={{ fontSize: 13, fontWeight: 500 }}>{p.name}</div>
                    <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>{p.barcode}</div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div
                      className={
                        p.stock_quantity === 0
                          ? 'text-red font-bold'
                          : p.stock_quantity <= p.min_stock_level
                          ? 'text-yellow font-bold'
                          : 'text-green font-bold'
                      }
                      style={{ fontSize: 15 }}
                    >
                      {p.stock_quantity}
                    </div>
                    <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>
                      min: {p.min_stock_level}
                    </div>
                  </div>
                </div>
              ))}
          </div>
        </div>
      </div>

      {/* Transaction History */}
      <div className="card" style={{ marginTop: 20, padding: 0 }}>
        <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--border)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div className="card-title">Stock Transaction History</div>
          <div style={{ display: 'flex', gap: 10 }}>
            <select
              value={filterProductId}
              onChange={(e) => setFilterProductId(e.target.value)}
              style={{ width: 180 }}
            >
              <option value="">All Products</option>
              {products.map((p) => (
                <option key={p.id} value={p.id}>{p.name}</option>
              ))}
            </select>
          </div>
        </div>

        {loading ? (
          <div className="loading-container"><div className="spinner" /></div>
        ) : filteredTx.length === 0 ? (
          <div className="empty-state">
            <div className="empty-state-icon">📋</div>
            <div className="empty-state-text">No transactions found</div>
          </div>
        ) : (
          <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
            <table>
              <thead>
                <tr>
                  <th>Product</th>
                  <th>Type</th>
                  <th>Quantity</th>
                  <th>Notes</th>
                  <th>Date</th>
                </tr>
              </thead>
              <tbody>
                {filteredTx.map((t) => (
                  <tr key={t.id}>
                    <td>
                      <div style={{ fontWeight: 500 }}>{t.product?.name || `Product #${t.product_id}`}</div>
                    </td>
                    <td>
                      <span className={`badge ${txTypeColor[t.transaction_type] || 'badge-gray'}`}>
                        {txTypeLabel[t.transaction_type] || t.transaction_type}
                      </span>
                    </td>
                    <td style={{ fontWeight: 600 }}>{t.quantity}</td>
                    <td className="td-muted">{t.notes || '—'}</td>
                    <td className="td-muted">{new Date(t.created_at).toLocaleString()}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
