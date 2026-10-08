import React from 'react';
import { useLocation } from 'react-router-dom';

const PAGE_TITLES = {
  '/': 'Dashboard',
  '/products': 'Products',
  '/barcode': 'Barcode Scanner',
  '/stock': 'Stock Management',
  '/sales': 'Sales / POS',
  '/reports': 'Reports',
  '/suppliers': 'Suppliers',
  '/users': 'Users',
};

export default function Header() {
  const location = useLocation();
  const title = PAGE_TITLES[location.pathname] || 'Inventory';

  return (
    <header className="header">
      <h1 className="header-title">{title}</h1>
      <div className="header-right">
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: 6,
            fontSize: 12,
            color: 'var(--text-muted)',
          }}
        >
          <span
            style={{
              width: 8,
              height: 8,
              borderRadius: '50%',
              background: 'var(--accent-green)',
              display: 'inline-block',
            }}
          />
          System Online
        </div>
      </div>
    </header>
  );
}
