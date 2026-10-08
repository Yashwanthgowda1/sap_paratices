import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';

export default function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({ username: '', password: '' });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    if (!form.username || !form.password) {
      setError('Please enter username and password.');
      return;
    }
    setLoading(true);
    try {
      await login(form.username, form.password);
      navigate('/');
    } catch (err) {
      setError(
        err.response?.data?.detail || 'Login failed. Check your credentials.'
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-logo">
          <div
            className="login-logo-icon"
            style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}
          >
            🏪
          </div>
          <div className="login-title">ShopSync</div>
          <div className="login-subtitle">Inventory Management System</div>
        </div>

        {error && (
          <div className="alert alert-error" style={{ marginBottom: 20 }}>
            ⚠️ {error}
          </div>
        )}

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="username">Username</label>
            <input
              id="username"
              type="text"
              placeholder="Enter your username"
              value={form.username}
              onChange={(e) => setForm({ ...form, username: e.target.value })}
              autoFocus
            />
          </div>
          <div className="form-group">
            <label htmlFor="password">Password</label>
            <input
              id="password"
              type="password"
              placeholder="Enter your password"
              value={form.password}
              onChange={(e) => setForm({ ...form, password: e.target.value })}
            />
          </div>
          <button
            type="submit"
            className="btn btn-primary w-full btn-lg"
            style={{ width: '100%', marginTop: 8 }}
            disabled={loading}
          >
            {loading ? 'Signing in...' : '🔐 Sign In'}
          </button>
        </form>

        <div
          style={{
            marginTop: 20,
            padding: 12,
            background: 'rgba(59,130,246,0.08)',
            borderRadius: 6,
            border: '1px solid rgba(59,130,246,0.2)',
            fontSize: 12,
            color: 'var(--text-secondary)',
          }}
        >
          <strong>Default Owner Account:</strong>
          <br />
          Username: <code>admin</code> &nbsp;|&nbsp; Password: <code>admin123</code>
        </div>
      </div>
    </div>
  );
}
