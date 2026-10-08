import React, { useEffect, useState } from 'react';
import { reportsAPI } from '../services/api';
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
} from 'recharts';

const TABS = ['Sales Report', 'Stock Report', 'Product Sales', 'Dashboard'];

function downloadBlob(blob, filename) {
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}

export default function Reports() {
  const [tab, setTab] = useState(0);
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);

  const today = new Date().toISOString().split('T')[0];
  const monthStart = new Date(new Date().getFullYear(), new Date().getMonth(), 1)
    .toISOString().split('T')[0];

  useEffect(() => {
    setStartDate(monthStart);
    setEndDate(today);
  }, []); // eslint-disable-line

  useEffect(() => {
    loadReport();
  }, [tab]); // eslint-disable-line

  const loadReport = async () => {
    setLoading(true);
    setData(null);
    try {
      const params = { start_date: startDate || undefined, end_date: endDate || undefined };
      let res;
      if (tab === 0) res = await reportsAPI.sales(params);
      else if (tab === 1) res = await reportsAPI.stock();
      else if (tab === 2) res = await reportsAPI.productSales(params);
      else res = await reportsAPI.dashboard();
      setData(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleExportCSV = async () => {
    try {
      const params = { start_date: startDate || undefined, end_date: endDate || undefined };
      let res;
      if (tab === 1) {
        res = await reportsAPI.exportStockCSV();
        downloadBlob(new Blob([res.data]), 'stock_report.csv');
      } else {
        res = await reportsAPI.exportSalesCSV(params);
        downloadBlob(new Blob([res.data]), 'sales_report.csv');
      }
    } catch (err) {
      alert('Export failed');
    }
  };

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 20 }}>
        <div>
          <div className="page-title">Reports</div>
          <div className="page-subtitle">Analyse sales, stock, and profit data</div>
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          <button className="btn btn-ghost btn-sm" onClick={handleExportCSV}>
            📥 Export CSV
          </button>
        </div>
      </div>

      {/* Tabs */}
      <div className="report-tabs">
        {TABS.map((t, i) => (
          <button
            key={t}
            className={`report-tab ${tab === i ? 'active' : ''}`}
            onClick={() => setTab(i)}
          >
            {t}
          </button>
        ))}
      </div>

      {/* Date filter (not for stock/dashboard) */}
      {tab !== 1 && tab !== 3 && (
        <div style={{ display: 'flex', gap: 12, marginBottom: 20, flexWrap: 'wrap', alignItems: 'flex-end' }}>
          <div className="form-group" style={{ margin: 0 }}>
            <label>From</label>
            <input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} style={{ width: 160 }} />
          </div>
          <div className="form-group" style={{ margin: 0 }}>
            <label>To</label>
            <input type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} style={{ width: 160 }} />
          </div>
          <button className="btn btn-primary btn-sm" onClick={loadReport}>Apply</button>
        </div>
      )}

      {loading && (
        <div className="loading-container"><div className="spinner" /></div>
      )}

      {!loading && data && (
        <>
          {/* ── Sales Report ── */}
          {tab === 0 && (
            <>
              <div className="stats-grid" style={{ marginBottom: 20 }}>
                <StatCard icon="💰" label="Total Revenue" value={`₹${data.total_sales?.toFixed(2)}`} color="green" />
                <StatCard icon="🧾" label="Total Orders" value={data.count} color="blue" />
                <StatCard icon="🏷️" label="Total Discounts" value={`₹${data.total_discount?.toFixed(2)}`} color="yellow" />
                <StatCard
                  icon="📊"
                  label="Avg Order Value"
                  value={data.count ? `₹${(data.total_sales / data.count).toFixed(2)}` : '₹0'}
                  color="purple"
                />
              </div>
              <div className="card" style={{ padding: 0 }}>
                <div style={{ padding: '14px 16px', borderBottom: '1px solid var(--border)' }}>
                  <div className="card-title">Sales Transactions</div>
                </div>
                {data.sales?.length === 0 ? (
                  <div className="empty-state">
                    <div className="empty-state-icon">📊</div>
                    <div className="empty-state-text">No sales in this period</div>
                  </div>
                ) : (
                  <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
                    <table>
                      <thead>
                        <tr>
                          <th>Invoice</th>
                          <th>Total</th>
                          <th>Discount</th>
                          <th>Final</th>
                          <th>Payment</th>
                          <th>Date</th>
                        </tr>
                      </thead>
                      <tbody>
                        {data.sales?.map((s) => (
                          <tr key={s.id}>
                            <td style={{ fontFamily: 'monospace' }}>{s.invoice_number}</td>
                            <td>₹{s.total_amount?.toFixed(2)}</td>
                            <td className="text-yellow">₹{s.discount?.toFixed(2)}</td>
                            <td className="text-green font-bold">₹{s.final_amount?.toFixed(2)}</td>
                            <td><span className="badge badge-blue">{s.payment_method}</span></td>
                            <td className="td-muted">{new Date(s.created_at).toLocaleString()}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                )}
              </div>
            </>
          )}

          {/* ── Stock Report ── */}
          {tab === 1 && (
            <>
              <div className="stats-grid" style={{ marginBottom: 20 }}>
                <StatCard icon="📦" label="Total Products" value={data.total_products} color="blue" />
                <StatCard icon="🏦" label="Stock Value" value={`₹${data.total_value?.toFixed(2)}`} color="green" />
              </div>
              <div className="card" style={{ padding: 0 }}>
                <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
                  <table>
                    <thead>
                      <tr>
                        <th>Product</th>
                        <th>Barcode</th>
                        <th>Stock</th>
                        <th>Min Level</th>
                        <th>Buy Price</th>
                        <th>Sell Price</th>
                        <th>Stock Value</th>
                        <th>Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      {data.products?.map((p) => (
                        <tr key={p.id}>
                          <td style={{ fontWeight: 500 }}>{p.name}</td>
                          <td style={{ fontFamily: 'monospace', fontSize: 12 }}>{p.barcode}</td>
                          <td style={{ fontWeight: 600 }}>{p.stock_quantity}</td>
                          <td className="td-muted">{p.min_stock_level}</td>
                          <td>₹{p.purchase_price?.toFixed(2)}</td>
                          <td className="text-green">₹{p.selling_price?.toFixed(2)}</td>
                          <td>₹{p.stock_value?.toFixed(2)}</td>
                          <td>
                            <span className={
                              p.status === 'out_of_stock' ? 'badge badge-danger' :
                              p.status === 'low_stock' ? 'badge badge-warning' : 'badge badge-success'
                            }>
                              {p.status === 'out_of_stock' ? 'Out of Stock' :
                               p.status === 'low_stock' ? 'Low Stock' : 'OK'}
                            </span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </>
          )}

          {/* ── Product Sales ── */}
          {tab === 2 && (
            <>
              {data.products?.length > 0 && (
                <div className="card" style={{ marginBottom: 16 }}>
                  <div className="card-title" style={{ marginBottom: 12 }}>Top Selling Products</div>
                  <ResponsiveContainer width="100%" height={220}>
                    <BarChart data={data.products?.slice(0, 10)} barSize={28}>
                      <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" vertical={false} />
                      <XAxis dataKey="name" tick={{ fill: 'var(--text-muted)', fontSize: 10 }} axisLine={false} tickLine={false} />
                      <YAxis tick={{ fill: 'var(--text-muted)', fontSize: 11 }} axisLine={false} tickLine={false} />
                      <Tooltip
                        contentStyle={{ background: 'var(--bg-secondary)', border: '1px solid var(--border)', borderRadius: 6 }}
                        labelStyle={{ color: 'var(--text-primary)' }}
                      />
                      <Bar dataKey="total_sold" fill="var(--accent-blue)" radius={[4, 4, 0, 0]} name="Units Sold" />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              )}
              <div className="card" style={{ padding: 0 }}>
                <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
                  <table>
                    <thead>
                      <tr>
                        <th>Product</th>
                        <th>Barcode</th>
                        <th>Units Sold</th>
                        <th>Revenue</th>
                        <th>Profit</th>
                      </tr>
                    </thead>
                    <tbody>
                      {data.products?.map((p) => (
                        <tr key={p.id}>
                          <td style={{ fontWeight: 500 }}>{p.name}</td>
                          <td style={{ fontFamily: 'monospace', fontSize: 12 }}>{p.barcode}</td>
                          <td style={{ fontWeight: 600 }}>{p.total_sold}</td>
                          <td className="text-blue">₹{p.total_revenue?.toFixed(2)}</td>
                          <td className="text-green font-semibold">₹{p.total_profit?.toFixed(2)}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </>
          )}

          {/* ── Dashboard Stats ── */}
          {tab === 3 && (
            <>
              <div className="stats-grid">
                <StatCard icon="📦" label="Total Products" value={data.total_products} color="blue" />
                <StatCard icon="💰" label="Today Sales" value={`₹${data.today_sales?.toFixed(2)}`} color="green" />
                <StatCard icon="📈" label="Month Sales" value={`₹${data.month_sales?.toFixed(2)}`} color="cyan" />
                <StatCard icon="💹" label="Total Profit" value={`₹${data.total_profit?.toFixed(2)}`} color="purple" />
                <StatCard icon="🏦" label="Stock Value" value={`₹${data.total_stock_value?.toFixed(2)}`} color="yellow" />
                <StatCard icon="🚫" label="Out of Stock" value={data.out_of_stock} color="red" />
              </div>
            </>
          )}
        </>
      )}
    </div>
  );
}

function StatCard({ icon, label, value, color }) {
  return (
    <div className="stat-card">
      <div className={`stat-icon ${color}`}>{icon}</div>
      <div className="stat-info">
        <div className="stat-value">{value}</div>
        <div className="stat-label">{label}</div>
      </div>
    </div>
  );
}
