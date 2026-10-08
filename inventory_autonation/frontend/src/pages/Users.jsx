import React, { useEffect, useState, useCallback } from 'react';
import { usersAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';

function UserModal({ user, onClose, onSave }) {
  const isEdit = !!user;
  const [form, setForm] = useState(
    user
      ? { username: user.username, email: user.email, full_name: user.full_name, role: user.role, is_active: user.is_active, password: '' }
      : { username: '', email: '', full_name: '', role: 'manager', password: '' }
  );
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    if (!form.username || !form.email || !form.full_name) {
      setError('Username, email, and full name are required.');
      return;
    }
    if (!isEdit && !form.password) {
      setError('Password is required for new users.');
      return;
    }
    setLoading(true);
    try {
      const payload = { ...form };
      if (!payload.password) delete payload.password;
      if (isEdit) {
        await usersAPI.update(user.id, payload);
      } else {
        await usersAPI.create(payload);
      }
      onSave();
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to save user.');
    } finally {
      setLoading(false);
    }
  };

  const f = (key) => ({
    value: form[key] ?? '',
    onChange: (e) => setForm({ ...form, [key]: e.target.value }),
  });

  return (
    <div className="modal-overlay" onClick={(e) => e.target === e.currentTarget && onClose()}>
      <div className="modal">
        <div className="modal-header">
          <div className="modal-title">{isEdit ? 'Edit User' : 'Add User'}</div>
          <button className="modal-close" onClick={onClose}>✕</button>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="modal-body">
            {error && <div className="alert alert-error">{error}</div>}
            <div className="form-group">
              <label>Full Name *</label>
              <input placeholder="e.g. John Smith" {...f('full_name')} />
            </div>
            <div className="form-row form-row-2">
              <div className="form-group">
                <label>Username *</label>
                <input placeholder="e.g. john_manager" {...f('username')} disabled={isEdit} />
              </div>
              <div className="form-group">
                <label>Email *</label>
                <input type="email" placeholder="john@shop.com" {...f('email')} />
              </div>
            </div>
            <div className="form-row form-row-2">
              <div className="form-group">
                <label>Role</label>
                <select {...f('role')}>
                  <option value="manager">Manager</option>
                  <option value="owner">Owner</option>
                </select>
              </div>
              <div className="form-group">
                <label>{isEdit ? 'New Password (leave blank to keep)' : 'Password *'}</label>
                <input type="password" placeholder={isEdit ? 'Leave blank to keep' : 'Min 6 characters'} {...f('password')} />
              </div>
            </div>
            {isEdit && (
              <div className="form-group">
                <label>Status</label>
                <select
                  value={form.is_active ? 'true' : 'false'}
                  onChange={(e) => setForm({ ...form, is_active: e.target.value === 'true' })}
                >
                  <option value="true">Active</option>
                  <option value="false">Disabled</option>
                </select>
              </div>
            )}
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-ghost" onClick={onClose}>Cancel</button>
            <button type="submit" className="btn btn-primary" disabled={loading}>
              {loading ? 'Saving...' : isEdit ? '✓ Update User' : '➕ Add User'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default function Users() {
  const { user: currentUser } = useAuth();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [modalOpen, setModalOpen] = useState(false);
  const [editUser, setEditUser] = useState(null);
  const [deleteConfirm, setDeleteConfirm] = useState(null);
  const [search, setSearch] = useState('');

  const loadUsers = useCallback(async () => {
    setLoading(true);
    try {
      const res = await usersAPI.list();
      setUsers(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  const handleDelete = async (id) => {
    try {
      await usersAPI.delete(id);
      setDeleteConfirm(null);
      loadUsers();
    } catch (err) {
      alert(err.response?.data?.detail || 'Delete failed');
    }
  };

  const filtered = users.filter((u) =>
    !search ||
    u.full_name.toLowerCase().includes(search.toLowerCase()) ||
    u.username.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 20 }}>
        <div>
          <div className="page-title">Users</div>
          <div className="page-subtitle">Manage staff accounts and roles</div>
        </div>
        <button className="btn btn-primary" onClick={() => { setEditUser(null); setModalOpen(true); }}>
          ➕ Add User
        </button>
      </div>

      <div className="toolbar">
        <div className="search-input-wrap" style={{ maxWidth: 300 }}>
          <span className="search-icon">🔍</span>
          <input
            placeholder="Search users..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <button className="btn btn-ghost btn-sm" onClick={loadUsers}>↺ Refresh</button>
      </div>

      <div className="card" style={{ padding: 0 }}>
        {loading ? (
          <div className="loading-container"><div className="spinner" /></div>
        ) : filtered.length === 0 ? (
          <div className="empty-state">
            <div className="empty-state-icon">👥</div>
            <div className="empty-state-text">No users found</div>
          </div>
        ) : (
          <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
            <table>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Username</th>
                  <th>Email</th>
                  <th>Role</th>
                  <th>Status</th>
                  <th>Joined</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((u) => (
                  <tr key={u.id}>
                    <td>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                        <div
                          style={{
                            width: 32, height: 32, borderRadius: '50%',
                            background: u.role === 'owner'
                              ? 'linear-gradient(135deg, #f59e0b, #ef4444)'
                              : 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
                            display: 'flex', alignItems: 'center', justifyContent: 'center',
                            fontWeight: 700, fontSize: 12, color: 'white', flexShrink: 0,
                          }}
                        >
                          {u.full_name.split(' ').map((n) => n[0]).join('').toUpperCase().slice(0, 2)}
                        </div>
                        <span style={{ fontWeight: 500 }}>{u.full_name}</span>
                        {u.id === currentUser?.id && (
                          <span className="badge badge-blue" style={{ fontSize: 10 }}>You</span>
                        )}
                      </div>
                    </td>
                    <td style={{ fontFamily: 'monospace' }}>{u.username}</td>
                    <td className="td-muted">{u.email}</td>
                    <td>
                      <span className={u.role === 'owner' ? 'badge badge-warning' : 'badge badge-blue'}>
                        {u.role}
                      </span>
                    </td>
                    <td>
                      <span className={u.is_active ? 'badge badge-success' : 'badge badge-danger'}>
                        {u.is_active ? 'Active' : 'Disabled'}
                      </span>
                    </td>
                    <td className="td-muted">{new Date(u.created_at).toLocaleDateString()}</td>
                    <td>
                      <div style={{ display: 'flex', gap: 6 }}>
                        <button
                          className="btn btn-ghost btn-sm"
                          onClick={() => { setEditUser(u); setModalOpen(true); }}
                        >
                          ✏️
                        </button>
                        {u.id !== currentUser?.id && (
                          <button
                            className="btn btn-danger btn-sm"
                            onClick={() => setDeleteConfirm(u)}
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
        )}
      </div>

      {modalOpen && (
        <UserModal
          user={editUser}
          onClose={() => setModalOpen(false)}
          onSave={() => { setModalOpen(false); loadUsers(); }}
        />
      )}

      {deleteConfirm && (
        <div className="modal-overlay" onClick={() => setDeleteConfirm(null)}>
          <div className="modal" style={{ maxWidth: 400 }} onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <div className="modal-title">Delete User</div>
              <button className="modal-close" onClick={() => setDeleteConfirm(null)}>✕</button>
            </div>
            <div className="modal-body">
              <p style={{ color: 'var(--text-secondary)' }}>
                Delete user <strong>{deleteConfirm.full_name}</strong> (@{deleteConfirm.username})? This cannot be undone.
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
