import React, { memo } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';

const NAV_ITEMS = [
  { to: '/', label: 'Dashboard', icon: '📊', exact: true },
  { to: '/barcode', label: 'Barcode Scanner', icon: '📷' },
  { to: '/sales', label: 'Sales / POS', icon: '🛒' },
  { to: '/products', label: 'Products', icon: '📦' },
  { to: '/stock', label: 'Stock Management', icon: '🗂️' },
  { to: '/reports', label: 'Reports', icon: '📈' },
  { to: '/suppliers', label: 'Suppliers', icon: '🏭' },
];

const OWNER_ITEMS = [
  { to: '/users', label: 'Users', icon: '👥' },
];

function Sidebar() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const initials = user?.full_name
    ? user.full_name.split(' ').map((n) => n[0]).join('').toUpperCase().slice(0, 2)
    : 'U';

  return (
    <aside className="sidebar">
      {/* Logo */}
      <div className="sidebar-logo">
        <div className="sidebar-logo-icon">🏪</div>
        <div>
          <div className="sidebar-logo-text">ShopSync</div>
          <div className="sidebar-logo-sub">Inventory System</div>
        </div>
      </div>

      {/* Navigation */}
      <nav className="sidebar-nav">
        <div className="sidebar-section-label">Main Menu</div>
        {NAV_ITEMS.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            end={item.exact}
            className={({ isActive }) =>
              `sidebar-item ${isActive ? 'active' : ''}`
            }
          >
            <span className="sidebar-item-icon">{item.icon}</span>
            {item.label}
          </NavLink>
        ))}

        {user?.role === 'owner' && (
          <>
            <div className="sidebar-section-label" style={{ marginTop: 8 }}>
              Admin
            </div>
            {OWNER_ITEMS.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  `sidebar-item ${isActive ? 'active' : ''}`
                }
              >
                <span className="sidebar-item-icon">{item.icon}</span>
                {item.label}
              </NavLink>
            ))}
          </>
        )}
      </nav>

      {/* User footer */}
      <div className="sidebar-footer">
        <div className="sidebar-user">
          <div className="sidebar-avatar">{initials}</div>
          <div className="sidebar-user-info">
            <div className="sidebar-user-name">{user?.full_name}</div>
            <div className="sidebar-user-role">{user?.role}</div>
          </div>
          <button
            onClick={handleLogout}
            title="Logout"
            style={{
              background: 'transparent',
              border: 'none',
              cursor: 'pointer',
              color: 'var(--text-muted)',
              fontSize: 16,
              padding: 4,
            }}
          >
            🚪
          </button>
        </div>
      </div>
    </aside>
  );
}

export default memo(Sidebar);
