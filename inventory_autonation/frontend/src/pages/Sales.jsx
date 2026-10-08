import React, { useEffect, useState, useCallback, useRef } from 'react';
import { salesAPI, productsAPI, barcodeAPI } from '../services/api';
import { useLocation } from 'react-router-dom';

function BillModal({ sale, onClose }) {
  const handlePrint = () => window.print();
  return (
    <div className="modal-overlay">
      <div className="modal" style={{ maxWidth: 480 }}>
        <div className="modal-header">
          <div className="modal-title">🧾 Invoice — {sale.invoice_number}</div>
          <button className="modal-close" onClick={onClose}>✕</button>
        </div>
        <div className="modal-body">
          <div style={{ textAlign: 'center', marginBottom: 16 }}>
            <div style={{ fontSize: 18, fontWeight: 700 }}>ShopSync</div>
            <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>Inventory Management</div>
            <div style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 4 }}>
              {new Date(sale.created_at).toLocaleString()}
            </div>
          </div>
          <table style={{ width: '100%', fontSize: 13, borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ borderBottom: '1px dashed var(--border)' }}>
                <th style={{ textAlign: 'left', padding: '6px 0', color: 'var(--text-muted)', fontWeight: 600 }}>Item</th>
                <th style={{ textAlign: 'center', padding: '6px 0', color: 'var(--text-muted)', fontWeight: 600 }}>Qty</th>
                <th style={{ textAlign: 'right', padding: '6px 0', color: 'var(--text-muted)', fontWeight: 600 }}>Amount</th>
              </tr>
            </thead>
            <tbody>
              {sale.items?.map((item) => (
                <tr key={item.id} style={{ borderBottom: '1px solid var(--border)' }}>
                  <td style={{ padding: '8px 0' }}>
                    <div>{item.product?.name || `Product #${item.product_id}`}</div>
                    <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>₹{item.unit_price} × {item.quantity}</div>
                  </td>
                  <td style={{ textAlign: 'center', padding: '8px 0' }}>{item.quantity}</td>
                  <td style={{ textAlign: 'right', padding: '8px 0', fontWeight: 600 }}>₹{item.subtotal?.toFixed(2)}</td>
                </tr>
              ))}
            </tbody>
          </table>
          <div style={{ marginTop: 12, borderTop: '1px dashed var(--border)', paddingTop: 10 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 6, color: 'var(--text-secondary)' }}>
              <span>Subtotal</span><span>₹{sale.total_amount?.toFixed(2)}</span>
            </div>
            {sale.discount > 0 && (
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 6, color: 'var(--accent-green)' }}>
                <span>Discount</span><span>-₹{sale.discount?.toFixed(2)}</span>
              </div>
            )}
            <div style={{ display: 'flex', justifyContent: 'space-between', fontWeight: 700, fontSize: 16, borderTop: '1px solid var(--border)', paddingTop: 8, marginTop: 6 }}>
              <span>Total</span><span className="text-green">₹{sale.final_amount?.toFixed(2)}</span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 8, fontSize: 13, color: 'var(--text-secondary)' }}>
              <span>Payment</span><span style={{ textTransform: 'capitalize' }}>{sale.payment_method}</span>
            </div>
          </div>
        </div>
        <div className="modal-footer">
          <button className="btn btn-ghost" onClick={onClose}>Close</button>
          <button className="btn btn-primary" onClick={handlePrint}>🖨️ Print</button>
        </div>
      </div>
    </div>
  );
}

export default function Sales() {
  const location = useLocation();
  const [cart, setCart] = useState([]);
  const [discount, setDiscount] = useState(0);
  const [paymentMethod, setPaymentMethod] = useState('cash');
  const [notes, setNotes] = useState('');
  const [barcodeInput, setBarcodeInput] = useState('');
  const [scanLoading, setScanLoading] = useState(false);
  const [scanError, setScanError] = useState('');
  const [sales, setSales] = useState([]);
  const [loadingSales, setLoadingSales] = useState(true);
  const [checkoutLoading, setCheckoutLoading] = useState(false);
  const [billModal, setBillModal] = useState(null);
  const barcodeRef = useRef(null);

  // Pre-fill from barcode scanner navigation
  useEffect(() => {
    if (location.state?.product) {
      addToCartDirect(location.state.product);
    }
  }, []); // eslint-disable-line

  useEffect(() => {
    salesAPI.list({ limit: 20 }).then((r) => setSales(r.data)).catch(console.error).finally(() => setLoadingSales(false));
  }, []);

  const addToCartDirect = (product) => {
    setCart((prev) => {
      const existing = prev.find((i) => i.product_id === product.id);
      if (existing) {
        return prev.map((i) =>
          i.product_id === product.id ? { ...i, quantity: i.quantity + 1 } : i
        );
      }
      return [...prev, { product_id: product.id, name: product.name, unit_price: product.selling_price, quantity: 1, stock: product.stock_quantity }];
    });
  };

  const handleScanBarcode = async () => {
    if (!barcodeInput.trim()) return;
    setScanError('');
    setScanLoading(true);
    try {
      const res = await barcodeAPI.scan(barcodeInput.trim());
      if (res.data.found) {
        addToCartDirect(res.data.product);
        setBarcodeInput('');
        barcodeRef.current?.focus();
      } else {
        setScanError(`Barcode "${barcodeInput}" not found in system.`);
      }
    } catch (err) {
      setScanError(err.response?.data?.detail || 'Scan failed.');
    } finally {
      setScanLoading(false);
    }
  };

  const updateQty = (product_id, delta) => {
    setCart((prev) =>
      prev
        .map((i) => i.product_id === product_id ? { ...i, quantity: Math.max(0, i.quantity + delta) } : i)
        .filter((i) => i.quantity > 0)
    );
  };

  const removeItem = (product_id) => setCart((prev) => prev.filter((i) => i.product_id !== product_id));

  const total = cart.reduce((s, i) => s + i.unit_price * i.quantity, 0);
  const finalAmount = Math.max(0, total - Number(discount || 0));

  const handleCheckout = async () => {
    if (cart.length === 0) return;
    setCheckoutLoading(true);
    try {
      const res = await salesAPI.create({
        items: cart.map((i) => ({ product_id: i.product_id, quantity: i.quantity, unit_price: i.unit_price })),
        discount: Number(discount || 0),
        payment_method: paymentMethod,
        notes: notes || undefined,
      });
      setBillModal(res.data);
      setCart([]);
      setDiscount(0);
      setNotes('');
      // Refresh sales list
      salesAPI.list({ limit: 20 }).then((r) => setSales(r.data)).catch(console.error);
    } catch (err) {
      alert(err.response?.data?.detail || 'Checkout failed. Check stock levels.');
    } finally {
      setCheckoutLoading(false);
    }
  };

  return (
    <div>
      <div className="page-title">Sales / POS</div>
      <div className="page-subtitle">Create sales, scan products, and generate bills</div>

      <div className="pos-layout">
        {/* Left: Scanner + Recent Sales */}
        <div className="pos-products">
          {/* Barcode Scan */}
          <div className="card" style={{ marginBottom: 16 }}>
            <div className="card-title" style={{ marginBottom: 12 }}>🔍 Scan Product</div>
            <div className="input-group">
              <input
                ref={barcodeRef}
                type="text"
                placeholder="Scan or type barcode..."
                value={barcodeInput}
                onChange={(e) => setBarcodeInput(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && handleScanBarcode()}
                autoFocus
              />
              <button
                className="btn btn-primary"
                onClick={handleScanBarcode}
                disabled={scanLoading || !barcodeInput.trim()}
              >
                {scanLoading ? '...' : '➕ Add'}
              </button>
            </div>
            {scanError && <div className="alert alert-error" style={{ marginTop: 8 }}>{scanError}</div>}
          </div>

          {/* Recent Sales */}
          <div className="card" style={{ padding: 0 }}>
            <div style={{ padding: '14px 16px', borderBottom: '1px solid var(--border)' }}>
              <div className="card-title">Recent Sales</div>
            </div>
            {loadingSales ? (
              <div className="loading-container" style={{ padding: 20 }}><div className="spinner" /></div>
            ) : sales.length === 0 ? (
              <div className="empty-state" style={{ padding: 24 }}>
                <div className="empty-state-text">No sales yet</div>
              </div>
            ) : (
              <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
                <table>
                  <thead>
                    <tr>
                      <th>Invoice</th>
                      <th>Items</th>
                      <th>Amount</th>
                      <th>Payment</th>
                      <th>Time</th>
                    </tr>
                  </thead>
                  <tbody>
                    {sales.slice(0, 10).map((s) => (
                      <tr key={s.id} style={{ cursor: 'pointer' }} onClick={() => setBillModal(s)}>
                        <td style={{ fontFamily: 'monospace', fontSize: 12 }}>{s.invoice_number}</td>
                        <td>{s.items?.length || 0}</td>
                        <td className="text-green font-semibold">₹{s.final_amount?.toFixed(2)}</td>
                        <td><span className="badge badge-blue">{s.payment_method}</span></td>
                        <td className="td-muted" style={{ fontSize: 12 }}>
                          {new Date(s.created_at).toLocaleTimeString()}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>

        {/* Right: Cart */}
        <div className="pos-cart">
          <div className="pos-cart-header">
            🛒 Cart ({cart.length} items)
          </div>

          <div className="pos-cart-items">
            {cart.length === 0 ? (
              <div style={{ textAlign: 'center', padding: 40, color: 'var(--text-muted)', fontSize: 13 }}>
                <div style={{ fontSize: 32, marginBottom: 8 }}>🛒</div>
                Scan a product to add it here
              </div>
            ) : (
              cart.map((item) => (
                <div className="cart-item" key={item.product_id}>
                  <div className="cart-item-info">
                    <div className="cart-item-name">{item.name}</div>
                    <div className="cart-item-price">₹{item.unit_price} each</div>
                  </div>
                  <div className="qty-control">
                    <button className="qty-btn" onClick={() => updateQty(item.product_id, -1)}>−</button>
                    <span className="qty-display">{item.quantity}</span>
                    <button
                      className="qty-btn"
                      onClick={() => updateQty(item.product_id, 1)}
                      disabled={item.quantity >= item.stock}
                    >+</button>
                  </div>
                  <div style={{ fontWeight: 700, minWidth: 70, textAlign: 'right', fontSize: 13 }}>
                    ₹{(item.unit_price * item.quantity).toFixed(2)}
                  </div>
                  <button
                    style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--text-muted)', fontSize: 14 }}
                    onClick={() => removeItem(item.product_id)}
                  >✕</button>
                </div>
              ))
            )}
          </div>

          <div className="pos-cart-footer">
            <div className="cart-total-row">
              <span>Subtotal</span>
              <span>₹{total.toFixed(2)}</span>
            </div>

            <div className="form-group" style={{ marginBottom: 10 }}>
              <label style={{ fontSize: 12 }}>Discount (₹)</label>
              <input
                type="number"
                min="0"
                max={total}
                value={discount}
                onChange={(e) => setDiscount(e.target.value)}
                style={{ padding: '6px 10px', fontSize: 13 }}
              />
            </div>

            {Number(discount) > 0 && (
              <div className="cart-total-row" style={{ color: 'var(--accent-green)' }}>
                <span>Discount</span>
                <span>-₹{Number(discount).toFixed(2)}</span>
              </div>
            )}

            <div className="cart-total-row grand-total">
              <span>Total</span>
              <span className="text-green">₹{finalAmount.toFixed(2)}</span>
            </div>

            <div className="form-group" style={{ marginTop: 12, marginBottom: 10 }}>
              <label style={{ fontSize: 12 }}>Payment Method</label>
              <select
                value={paymentMethod}
                onChange={(e) => setPaymentMethod(e.target.value)}
                style={{ padding: '6px 10px', fontSize: 13 }}
              >
                <option value="cash">💵 Cash</option>
                <option value="card">💳 Card</option>
                <option value="upi">📱 UPI</option>
                <option value="other">Other</option>
              </select>
            </div>

            <div className="form-group" style={{ marginBottom: 12 }}>
              <label style={{ fontSize: 12 }}>Notes (optional)</label>
              <input
                placeholder="Customer name, order notes..."
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                style={{ padding: '6px 10px', fontSize: 13 }}
              />
            </div>

            <button
              className="btn btn-success w-full btn-lg"
              style={{ width: '100%' }}
              onClick={handleCheckout}
              disabled={cart.length === 0 || checkoutLoading}
            >
              {checkoutLoading ? 'Processing...' : `✓ Checkout — ₹${finalAmount.toFixed(2)}`}
            </button>
          </div>
        </div>
      </div>

      {billModal && <BillModal sale={billModal} onClose={() => setBillModal(null)} />}
    </div>
  );
}
