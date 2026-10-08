import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';
import { reportsAPI } from '../services/api';

const STAT_CARDS = [
  { key: 'total_products', label: 'Total Products', icon: '📦', color: 'blue', prefix: '' },
  { key: 'today_sales', label: "Today's Sales", icon: '💰', color: 'green', prefix: '₹' },
  { key: 'month_sales', label: 'Month Sales', icon: '📈', color: 'cyan', prefix: '₹' },
  { key: 'total_stock_value', label: 'Stock Value', icon: '🏦', color: 'purple', prefix: '₹' },
  { key: 'low_stock', label: 'Low Stock', icon: '⚠️', color: 'yellow', prefix: '' },
  { key: 'out_of_stock', label: 'Out of Stock', icon: '🚫', color: 'red', prefix: '' },
];

function fmtCurrency(val) {
  if (val >= 100000) return `${(val / 100000).toFixed(1)}L`;
  if (val >= 1000) return `${(val / 1000).toFixed(1)}K`;
  return val?.toFixed ? val.toFixed(0) : val;
}

function CustomTooltip({ active, payload, label }) {
  if (active && payload?.length) {
    return (
      <div
        style={{
          background: 'var(--bg-secondary)',
          border: '1px solid var(--border)',
          borderRadius: 6,
          padding: '8px 12px',
          fontSize: 12,
        }}
      >
        <div style={{ color: 'var(--text-muted)', marginBottom: 4 }}>{label}</div>
        <div style={{ color: 'var(--accent-blue)', fontWeight: 600 }}>
          ₹{payload[0].value?.toFixed(2)}
        </div>
      </div>
    );
  }
  return null;
}

export default function Dashboard() {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    reportsAPI
      .dashboard()
      .then((res) => setStats(res.data))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <div className="loading-container">
        <div className="spinner" />
        <span>Loading dashboard...</span>
      </div>
    );
  }

  return (
    <div>
      <div className="page-title">Dashboard</div>
      <div className="page-subtitle">Overview of your inventory and sales</div>

      {/* Stat Cards */}
      <div className="stats-grid">
        {STAT_CARDS.map((card) => (
          <div className="stat-card" key={card.key}>
            <div className={`stat-icon ${card.color}`}>{card.icon}</div>
            <div className="stat-info">
              <div className="stat-value">
                {card.prefix}
                {card.prefix === '₹'
                  ? fmtCurrency(stats?.[card.key] || 0)
                  : stats?.[card.key] || 0}
              </div>
              <div className="stat-label">{card.label}</div>
            </div>
          </div>
        ))}
      </div>

      <div className="charts-grid">
        {/* Sales Chart */}
        <div className="card">
          <div className="card-header">
            <div className="card-title">Sales — Last 7 Days</div>
          </div>
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={stats?.daily_sales || []} barSize={28}>
              <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" vertical={false} />
              <XAxis
                dataKey="date"
                tick={{ fill: 'var(--text-muted)', fontSize: 11 }}
                axisLine={false}
                tickLine={false}
              />
              <YAxis
                tick={{ fill: 'var(--text-muted)', fontSize: 11 }}
                axisLine={false}
                tickLine={false}
                tickFormatter={(v) => `₹${fmtCurrency(v)}`}
              />
              <Tooltip content={<CustomTooltip />} />
              <Bar dataKey="amount" fill="var(--accent-blue)" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Low Stock Alert */}
        <div className="card">
          <div className="card-header">
            <div className="card-title">⚠️ Low / Out of Stock</div>
            <button
              className="btn btn-ghost btn-sm"
              onClick={() => navigate('/stock')}
            >
              Manage
            </button>
          </div>
          {stats?.low_stock_products?.length === 0 ? (
            <div className="empty-state" style={{ padding: '20px 0' }}>
              <div className="empty-state-icon">✅</div>
              <div className="empty-state-text">All stock levels OK</div>
            </div>
          ) : (
            <div style={{ maxHeight: 220, overflowY: 'auto' }}>
              {stats?.low_stock_products?.map((p) => (
                <div
                  key={p.id}
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    padding: '8px 0',
                    borderBottom: '1px solid var(--border)',
                    fontSize: 13,
                  }}
                >
                  <span className="truncate" style={{ maxWidth: 140 }}>
                    {p.name}
                  </span>
                  <span
                    className={
                      p.stock_quantity === 0 ? 'stock-out font-bold' : 'stock-low font-bold'
                    }
                  >
                    {p.stock_quantity === 0 ? 'Out' : p.stock_quantity}
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Recent Sales */}
      <div className="card" style={{ marginTop: 16 }}>
        <div className="card-header">
          <div className="card-title">Recent Transactions</div>
          <button
            className="btn btn-ghost btn-sm"
            onClick={() => navigate('/sales')}
          >
            View All
          </button>
        </div>
        {stats?.recent_sales?.length === 0 ? (
          <div className="empty-state">
            <div className="empty-state-icon">🛒</div>
            <div className="empty-state-text">No sales yet</div>
          </div>
        ) : (
          <div className="table-wrapper" style={{ border: 'none' }}>
            <table>
              <thead>
                <tr>
                  <th>Invoice</th>
                  <th>Amount</th>
                  <th>Payment</th>
                  <th>Date</th>
                </tr>
              </thead>
              <tbody>
                {stats?.recent_sales?.map((s) => (
                  <tr key={s.id}>
                    <td style={{ fontFamily: 'monospace' }}>{s.invoice_number}</td>
                    <td className="text-green font-bold">₹{s.final_amount?.toFixed(2)}</td>
                    <td>
                      <span className="badge badge-blue">{s.payment_method}</span>
                    </td>
                    <td className="td-muted">
                      {new Date(s.created_at).toLocaleString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Quick Actions */}
      <div
        style={{
          display: 'flex',
          gap: 12,
          marginTop: 16,
          flexWrap: 'wrap',
        }}
      >
        <button className="btn btn-primary" onClick={() => navigate('/barcode')}>
          📷 Scan Barcode
        </button>
        <button className="btn btn-success" onClick={() => navigate('/sales')}>
          🛒 New Sale
        </button>
        <button className="btn btn-ghost" onClick={() => navigate('/products')}>
          ➕ Add Product
        </button>
        <button className="btn btn-ghost" onClick={() => navigate('/reports')}>
          📊 View Reports
        </button>
      </div>
    </div>
  );
}
