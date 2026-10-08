import React, { useEffect, useState, useCallback } from 'react';
import { suppliersAPI } from '../services/api';

function SupplierModal({ supplier, onClose, onSave }) {
  const isEdit = !!supplier;
  const [form, setForm] = useState(
    supplier || { name: '', contact_number: '', email: '', address: '' }
  );
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    if (!form.name.trim()) {
      setError('Supplier name is required.');
      return;
    }
    setLoading(true);
    try {
      if (isEdit) {
        await suppliersAPI.update(supplier.id, form);
      } else {
        await suppliersAPI.create(form);
      }
      onSave();
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to save supplier.');
    } finally {
      setLoading(false);
    }
  };

  const f = (key) => ({
    value: form[key] || '',
    onChange: (e) => setForm({ ...form, [key]: e.target.value }),
  });

  return (
    <div className="modal-overlay" onClick={(e) => e.target === e.currentTarget && onClose()}>
      <div className="modal">
        <div className="modal-header">
          <div className="modal-title">{isEdit ? 'Edit Supplier' : 'Add Supplier'}</div>
          <button className="modal-close" onClick={onClose}>✕</button>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="modal-body">
            {error && <div className="alert alert-error">{error}</div>}
            <div className="form-group">
              <label>Supplier Name *</label>
              <input placeholder="e.g. ABC Distributors" {...f('name')} />
            </div>
            <div className="form-row form-row-2">
              <div className="form-group">
                <label>Contact Number</label>
                <input placeholder="+91 9876543210" {...f('contact_number')} />
              </div>
              <div className="form-group">
                <label>Email</label>
                <input type="email" placeholder="supplier@email.com" {...f('email')} />
              </div>
            </div>
            <div className="form-group">
              <label>Address</label>
              <textarea placeholder="Full address" {...f('address')} />
            </div>
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-ghost" onClick={onClose}>Cancel</button>
            <button type="submit" className="btn btn-primary" disabled={loading}>
              {loading ? 'Saving...' : isEdit ? '✓ Update' : '➕ Add Supplier'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default function Suppliers() {
  const [suppliers, setSuppliers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [modalOpen, setModalOpen] = useState(false);
  const [editSupplier, setEditSupplier] = useState(null);
  const [deleteConfirm, setDeleteConfirm] = useState(null);

  const loadSuppliers = useCallback(async () => {
    setLoading(true);
    try {
      const res = await suppliersAPI.list();
      setSuppliers(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadSuppliers();
  }, [loadSuppliers]);

  const handleDelete = async (id) => {
    try {
      await suppliersAPI.delete(id);
      setDeleteConfirm(null);
      loadSuppliers();
    } catch (err) {
      alert(err.response?.data?.detail || 'Delete failed');
    }
  };

  const filtered = suppliers.filter((s) =>
    !search || s.name.toLowerCase().includes(search.toLowerCase()) ||
    (s.email || '').toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 20 }}>
        <div>
          <div className="page-title">Suppliers</div>
          <div className="page-subtitle">Manage your product suppliers</div>
        </div>
        <button className="btn btn-primary" onClick={() => { setEditSupplier(null); setModalOpen(true); }}>
          ➕ Add Supplier
        </button>
      </div>

      <div className="toolbar">
        <div className="search-input-wrap" style={{ maxWidth: 300 }}>
          <span className="search-icon">🔍</span>
          <input
            placeholder="Search suppliers..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <button className="btn btn-ghost btn-sm" onClick={loadSuppliers}>↺ Refresh</button>
      </div>

      <div className="card" style={{ padding: 0 }}>
        {loading ? (
          <div className="loading-container"><div className="spinner" /></div>
        ) : filtered.length === 0 ? (
          <div className="empty-state">
            <div className="empty-state-icon">🏭</div>
            <div className="empty-state-text">No suppliers found</div>
            <div className="empty-state-sub">Add your first supplier to link products</div>
          </div>
        ) : (
          <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
            <table>
              <thead>
                <tr>
                  <th>#</th>
                  <th>Name</th>
                  <th>Contact</th>
                  <th>Email</th>
                  <th>Address</th>
                  <th>Added</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((s, idx) => (
                  <tr key={s.id}>
                    <td className="td-muted">{idx + 1}</td>
                    <td style={{ fontWeight: 500 }}>{s.name}</td>
                    <td className="td-muted">{s.contact_number || '—'}</td>
                    <td className="td-muted">{s.email || '—'}</td>
                    <td className="td-muted" style={{ maxWidth: 200 }}>
                      <span className="truncate">{s.address || '—'}</span>
                    </td>
                    <td className="td-muted">{new Date(s.created_at).toLocaleDateString()}</td>
                    <td>
                      <div style={{ display: 'flex', gap: 6 }}>
                        <button
                          className="btn btn-ghost btn-sm"
                          onClick={() => { setEditSupplier(s); setModalOpen(true); }}
                        >
                          ✏️
                        </button>
                        <button
                          className="btn btn-danger btn-sm"
                          onClick={() => setDeleteConfirm(s)}
                        >
                          🗑️
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {modalOpen && (
        <SupplierModal
          supplier={editSupplier}
          onClose={() => setModalOpen(false)}
          onSave={() => { setModalOpen(false); loadSuppliers(); }}
        />
      )}

      {deleteConfirm && (
        <div className="modal-overlay" onClick={() => setDeleteConfirm(null)}>
          <div className="modal" style={{ maxWidth: 400 }} onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <div className="modal-title">Delete Supplier</div>
              <button className="modal-close" onClick={() => setDeleteConfirm(null)}>✕</button>
            </div>
            <div className="modal-body">
              <p style={{ color: 'var(--text-secondary)' }}>
                Delete <strong>{deleteConfirm.name}</strong>? This cannot be undone.
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
