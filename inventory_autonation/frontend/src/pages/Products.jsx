import React, { useEffect, useState, useCallback } from 'react';
import { productsAPI, categoriesAPI, suppliersAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';

function ProductModal({ product, categories, suppliers, onClose, onSave }) {
  const isEdit = !!product;
  const [form, setForm] = useState(
    product || {
      name: '', barcode: '', category_id: '', brand: '', purchase_price: '',
      selling_price: '', stock_quantity: 0, expiry_date: '',
      supplier_id: '', image_url: '', storage_location: '',
      description: '', min_stock_level: 10,
    }
  );
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    if (!form.name || !form.barcode || !form.purchase_price || !form.selling_price) {
      setError('Name, barcode, purchase price, and selling price are required.');
      return;
    }
    setLoading(true);
    try {
      const payload = {
        ...form,
        category_id: form.category_id ? Number(form.category_id) : null,
        supplier_id: form.supplier_id ? Number(form.supplier_id) : null,
        purchase_price: Number(form.purchase_price),
        selling_price: Number(form.selling_price),
        stock_quantity: Number(form.stock_quantity),
        min_stock_level: Number(form.min_stock_level),
        expiry_date: form.expiry_date || null,
      };
      if (isEdit) {
        await productsAPI.update(product.id, payload);
      } else {
        await productsAPI.create(payload);
      }
      onSave();
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to save product.');
    } finally {
      setLoading(false);
    }
  };

  const f = (key) => ({ value: form[key] ?? '', onChange: (e) => setForm({ ...form, [key]: e.target.value }) });

  return (
    <div className="modal-overlay" onClick={(e) => e.target === e.currentTarget && onClose()}>
      <div className="modal modal-lg">
        <div className="modal-header">
          <div className="modal-title">{isEdit ? 'Edit Product' : 'Add New Product'}</div>
          <button className="modal-close" onClick={onClose}>✕</button>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="modal-body">
            {error && <div className="alert alert-error">{error}</div>}
            <div className="form-row form-row-2">
              <div className="form-group">
                <label>Product Name *</label>
                <input placeholder="e.g. Tata Salt 1kg" {...f('name')} />
              </div>
              <div className="form-group">
                <label>Barcode *</label>
                <input placeholder="e.g. 8901234567890" {...f('barcode')} />
              </div>
            </div>
            <div className="form-row form-row-3">
              <div className="form-group">
                <label>Category</label>
                <select {...f('category_id')}>
                  <option value="">— Select Category —</option>
                  {categories.map((c) => (
                    <option key={c.id} value={c.id}>{c.name}</option>
                  ))}
                </select>
              </div>
              <div className="form-group">
                <label>Brand</label>
                <input placeholder="e.g. Tata" {...f('brand')} />
              </div>
              <div className="form-group">
                <label>Supplier</label>
                <select {...f('supplier_id')}>
                  <option value="">— Select Supplier —</option>
                  {suppliers.map((s) => (
                    <option key={s.id} value={s.id}>{s.name}</option>
                  ))}
                </select>
              </div>
            </div>
            <div className="form-row form-row-3">
              <div className="form-group">
                <label>Purchase Price (₹) *</label>
                <input type="number" step="0.01" min="0" placeholder="0.00" {...f('purchase_price')} />
              </div>
              <div className="form-group">
                <label>Selling Price (₹) *</label>
                <input type="number" step="0.01" min="0" placeholder="0.00" {...f('selling_price')} />
              </div>
              <div className="form-group">
                <label>Stock Quantity</label>
                <input type="number" min="0" {...f('stock_quantity')} />
              </div>
            </div>
            <div className="form-row form-row-3">
              <div className="form-group">
                <label>Min Stock Level</label>
                <input type="number" min="0" {...f('min_stock_level')} />
              </div>
              <div className="form-group">
                <label>Expiry Date</label>
                <input type="date" {...f('expiry_date')} />
              </div>
              <div className="form-group">
                <label>Storage Location</label>
                <input placeholder="e.g. Rack A-3" {...f('storage_location')} />
              </div>
            </div>
            <div className="form-row form-row-2">
              <div className="form-group">
                <label>Image URL</label>
                <input placeholder="https://..." {...f('image_url')} />
              </div>
              <div className="form-group">
                <label>Description</label>
                <input placeholder="Brief description" {...f('description')} />
              </div>
            </div>
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-ghost" onClick={onClose}>Cancel</button>
            <button type="submit" className="btn btn-primary" disabled={loading}>
              {loading ? 'Saving...' : isEdit ? '✓ Update Product' : '➕ Add Product'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default function Products() {
  const { user } = useAuth();
  const [products, setProducts] = useState([]);
  const [categories, setCategories] = useState([]);
  const [suppliers, setSuppliers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [filterCat, setFilterCat] = useState('');
  const [filterStock, setFilterStock] = useState('');
  const [modalOpen, setModalOpen] = useState(false);
  const [editProduct, setEditProduct] = useState(null);
  const [deleteConfirm, setDeleteConfirm] = useState(null);
  const [page, setPage] = useState(0);
  const PAGE_SIZE = 20;

  const loadData = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        skip: page * PAGE_SIZE,
        limit: PAGE_SIZE,
        search: search || undefined,
        category_id: filterCat || undefined,
        low_stock: filterStock === 'low' || undefined,
        out_of_stock: filterStock === 'out' || undefined,
      };
      const [prodRes, catRes, supRes] = await Promise.all([
        productsAPI.list(params),
        categoriesAPI.list(),
        suppliersAPI.list(),
      ]);
      setProducts(prodRes.data);
      setCategories(catRes.data);
      setSuppliers(supRes.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, [page, search, filterCat, filterStock]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const handleDelete = async (id) => {
    try {
      await productsAPI.delete(id);
      setDeleteConfirm(null);
      loadData();
    } catch (err) {
      alert(err.response?.data?.detail || 'Delete failed');
    }
  };

  const stockStatus = (p) => {
    if (p.stock_quantity === 0) return <span className="badge badge-danger">Out of Stock</span>;
    if (p.stock_quantity <= p.min_stock_level) return <span className="badge badge-warning">Low Stock</span>;
    return <span className="badge badge-success">In Stock</span>;
  };

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 20 }}>
        <div>
          <div className="page-title">Products</div>
          <div className="page-subtitle">Manage your product catalogue</div>
        </div>
        <button className="btn btn-primary" onClick={() => { setEditProduct(null); setModalOpen(true); }}>
          ➕ Add Product
        </button>
      </div>

      {/* Toolbar */}
      <div className="toolbar">
        <div className="search-input-wrap" style={{ maxWidth: 300 }}>
          <span className="search-icon">🔍</span>
          <input
            placeholder="Search by name or barcode..."
            value={search}
            onChange={(e) => { setSearch(e.target.value); setPage(0); }}
          />
        </div>
        <select
          value={filterCat}
          onChange={(e) => { setFilterCat(e.target.value); setPage(0); }}
          style={{ width: 160 }}
        >
          <option value="">All Categories</option>
          {categories.map((c) => (
            <option key={c.id} value={c.id}>{c.name}</option>
          ))}
        </select>
        <select
          value={filterStock}
          onChange={(e) => { setFilterStock(e.target.value); setPage(0); }}
          style={{ width: 140 }}
        >
          <option value="">All Stock</option>
          <option value="low">Low Stock</option>
          <option value="out">Out of Stock</option>
        </select>
        <button className="btn btn-ghost btn-sm" onClick={loadData}>↺ Refresh</button>
      </div>

      {/* Table */}
      <div className="card" style={{ padding: 0 }}>
        {loading ? (
          <div className="loading-container"><div className="spinner" /></div>
        ) : products.length === 0 ? (
          <div className="empty-state">
            <div className="empty-state-icon">📦</div>
            <div className="empty-state-text">No products found</div>
            <div className="empty-state-sub">Add your first product to get started</div>
          </div>
        ) : (
          <>
            <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
              <table>
                <thead>
                  <tr>
                    <th>Product</th>
                    <th>Barcode</th>
                    <th>Category</th>
                    <th>Buy Price</th>
                    <th>Sell Price</th>
                    <th>Stock</th>
                    <th>Status</th>
                    <th>Location</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {products.map((p) => (
                    <tr key={p.id}>
                      <td>
                        <div style={{ fontWeight: 500 }}>{p.name}</div>
                        {p.brand && <div className="td-muted" style={{ fontSize: 12 }}>{p.brand}</div>}
                      </td>
                      <td style={{ fontFamily: 'monospace', fontSize: 12 }}>{p.barcode}</td>
                      <td className="td-muted">{p.category?.name || '—'}</td>
                      <td>₹{p.purchase_price?.toFixed(2)}</td>
                      <td className="text-green font-semibold">₹{p.selling_price?.toFixed(2)}</td>
                      <td style={{ fontWeight: 600 }}>{p.stock_quantity}</td>
                      <td>{stockStatus(p)}</td>
                      <td className="td-muted">{p.storage_location || '—'}</td>
                      <td>
                        <div style={{ display: 'flex', gap: 6 }}>
                          <button
                            className="btn btn-ghost btn-sm"
                            onClick={() => { setEditProduct(p); setModalOpen(true); }}
                          >
                            ✏️
                          </button>
                          {user?.role === 'owner' && (
                            <button
                              className="btn btn-danger btn-sm"
                              onClick={() => setDeleteConfirm(p)}
                            >
                              🗑️
                            </button>
                          )}
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <div className="pagination">
              <span>{products.length} products shown</span>
              <div className="pagination-controls">
                <button
                  className="btn btn-ghost btn-sm"
                  onClick={() => setPage((p) => Math.max(0, p - 1))}
                  disabled={page === 0}
                >
                  ← Prev
                </button>
                <button
                  className="btn btn-ghost btn-sm"
                  onClick={() => setPage((p) => p + 1)}
                  disabled={products.length < PAGE_SIZE}
                >
                  Next →
                </button>
              </div>
            </div>
          </>
        )}
      </div>

      {/* Add/Edit Modal */}
      {modalOpen && (
        <ProductModal
          product={editProduct}
          categories={categories}
          suppliers={suppliers}
          onClose={() => setModalOpen(false)}
          onSave={() => { setModalOpen(false); loadData(); }}
        />
      )}

      {/* Delete Confirm */}
      {deleteConfirm && (
        <div className="modal-overlay" onClick={() => setDeleteConfirm(null)}>
          <div className="modal" style={{ maxWidth: 400 }} onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <div className="modal-title">Delete Product</div>
              <button className="modal-close" onClick={() => setDeleteConfirm(null)}>✕</button>
            </div>
            <div className="modal-body">
              <p style={{ color: 'var(--text-secondary)' }}>
                Are you sure you want to delete <strong>{deleteConfirm.name}</strong>? This cannot be undone.
              </p>
            </div>
            <div className="modal-footer">
              <button className="btn btn-ghost" onClick={() => setDeleteConfirm(null)}>Cancel</button>
              <button className="btn btn-danger" onClick={() => handleDelete(deleteConfirm.id)}>
                Delete
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
