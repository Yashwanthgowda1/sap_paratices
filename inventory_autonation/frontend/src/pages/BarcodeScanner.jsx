import React, { useEffect, useRef, useState } from 'react';
import { barcodeAPI, productsAPI } from '../services/api';
import { useNavigate } from 'react-router-dom';

export default function BarcodeScanner() {
  const [manualBarcode, setManualBarcode] = useState('');
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [cameraActive, setCameraActive] = useState(false);
  const [error, setError] = useState('');
  const scannerRef = useRef(null);
  const html5QrRef = useRef(null);
  const navigate = useNavigate();

  const handleScan = async (barcode) => {
    if (!barcode.trim()) return;
    setLoading(true);
    setError('');
    setResult(null);
    try {
      const res = await barcodeAPI.scan(barcode.trim());
      setResult(res.data);
    } catch (err) {
      setError(err.response?.data?.detail || 'Scan failed. Try again.');
    } finally {
      setLoading(false);
    }
  };

  const startCamera = async () => {
    try {
      const { Html5QrcodeScanner } = await import('html5-qrcode');
      setCameraActive(true);
      setTimeout(() => {
        if (scannerRef.current && !html5QrRef.current) {
          const scanner = new Html5QrcodeScanner(
            'qr-reader',
            { fps: 10, qrbox: { width: 280, height: 120 }, supportedScanTypes: [0] },
            false
          );
          scanner.render(
            (decodedText) => {
              setManualBarcode(decodedText);
              handleScan(decodedText);
            },
            () => {}
          );
          html5QrRef.current = scanner;
        }
      }, 100);
    } catch (err) {
      setError('Camera not available. Use manual input.');
      setCameraActive(false);
    }
  };

  const stopCamera = () => {
    if (html5QrRef.current) {
      html5QrRef.current.clear().catch(() => {});
      html5QrRef.current = null;
    }
    setCameraActive(false);
  };

  useEffect(() => {
    return () => {
      if (html5QrRef.current) {
        html5QrRef.current.clear().catch(() => {});
      }
    };
  }, []);

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') handleScan(manualBarcode);
  };

  return (
    <div>
      <div className="page-title">Barcode Scanner</div>
      <div className="page-subtitle">Scan a product barcode to view details or add to cart</div>

      <div className="scanner-container">
        {/* Manual Input */}
        <div className="card" style={{ marginBottom: 16 }}>
          <div className="card-title" style={{ marginBottom: 12 }}>🔢 Manual Barcode Entry</div>
          <div className="input-group">
            <input
              type="text"
              placeholder="Type or scan barcode here..."
              value={manualBarcode}
              onChange={(e) => setManualBarcode(e.target.value)}
              onKeyDown={handleKeyDown}
              autoFocus
            />
            <button
              className="btn btn-primary"
              onClick={() => handleScan(manualBarcode)}
              disabled={loading || !manualBarcode.trim()}
            >
              {loading ? '...' : '🔍 Search'}
            </button>
          </div>
          <div style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 6 }}>
            Press Enter or click Search. Physical barcode scanners (USB/Bluetooth) work automatically.
          </div>
        </div>

        {/* Camera Scanner */}
        <div className="card" style={{ marginBottom: 16 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
            <div className="card-title">📷 Camera Scanner</div>
            {!cameraActive ? (
              <button className="btn btn-primary btn-sm" onClick={startCamera}>
                Start Camera
              </button>
            ) : (
              <button className="btn btn-danger btn-sm" onClick={stopCamera}>
                Stop Camera
              </button>
            )}
          </div>
          {cameraActive ? (
            <div id="qr-reader" ref={scannerRef} />
          ) : (
            <div
              style={{
                textAlign: 'center',
                padding: 40,
                color: 'var(--text-muted)',
                background: 'var(--bg-hover)',
                borderRadius: 8,
                fontSize: 13,
              }}
            >
              📷 Click "Start Camera" to enable real-time scanning
            </div>
          )}
        </div>

        {/* Error */}
        {error && <div className="alert alert-error">{error}</div>}

        {/* Result */}
        {loading && (
          <div className="loading-container" style={{ padding: 20 }}>
            <div className="spinner" />
            <span>Looking up barcode...</span>
          </div>
        )}

        {result && !loading && (
          <div className={`product-result-card ${result.found ? 'found' : 'not-found'}`}>
            {result.found ? (
              <>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
                  <div style={{ fontSize: 16, fontWeight: 700 }}>✅ Product Found</div>
                  <span className={result.product.is_available ? 'badge badge-success' : 'badge badge-danger'}>
                    {result.product.is_available ? 'In Stock' : 'Out of Stock'}
                  </span>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, marginBottom: 16 }}>
                  <InfoRow label="Name" value={result.product.name} bold />
                  <InfoRow label="Barcode" value={result.product.barcode} mono />
                  <InfoRow label="Selling Price" value={`₹${result.product.selling_price}`} highlight />
                  <InfoRow label="Stock Quantity" value={result.product.stock_quantity} />
                  <InfoRow label="Category" value={result.product.category || '—'} />
                  <InfoRow label="Brand" value={result.product.brand || '—'} />
                  <InfoRow label="Storage" value={result.product.storage_location || '—'} />
                  <InfoRow label="Min Stock" value={result.product.min_stock_level} />
                </div>

                <div style={{ display: 'flex', gap: 10 }}>
                  <button
                    className="btn btn-success"
                    onClick={() => navigate('/sales', { state: { product: result.product } })}
                  >
                    🛒 Add to Sale
                  </button>
                  <button
                    className="btn btn-ghost"
                    onClick={() => navigate('/products')}
                  >
                    📦 View Products
                  </button>
                </div>
              </>
            ) : (
              <>
                <div style={{ fontSize: 16, fontWeight: 700, marginBottom: 12 }}>
                  ⚠️ Product Not Found
                </div>
                <p style={{ color: 'var(--text-secondary)', marginBottom: 16, fontSize: 13 }}>
                  Barcode <strong style={{ fontFamily: 'monospace' }}>{result.barcode}</strong> is not registered.
                  You can add a new product with this barcode.
                </p>
                <button
                  className="btn btn-primary"
                  onClick={() =>
                    navigate('/products', {
                      state: { prefillBarcode: result.barcode },
                    })
                  }
                >
                  ➕ Add New Product
                </button>
              </>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

function InfoRow({ label, value, bold, mono, highlight }) {
  return (
    <div>
      <div style={{ fontSize: 11, color: 'var(--text-muted)', marginBottom: 2 }}>{label}</div>
      <div
        style={{
          fontWeight: bold || highlight ? 600 : 400,
          fontFamily: mono ? 'monospace' : 'inherit',
          color: highlight ? 'var(--accent-green)' : 'var(--text-primary)',
          fontSize: highlight ? 16 : 14,
        }}
      >
        {value}
      </div>
    </div>
  );
}
