import React, { lazy, Suspense } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import Layout from './components/Layout/Layout';

// Lazy-load every page — each becomes its own JS chunk downloaded on demand
const Login         = lazy(() => import('./pages/Login'));
const Dashboard     = lazy(() => import('./pages/Dashboard'));
const Products      = lazy(() => import('./pages/Products'));
const BarcodeScanner = lazy(() => import('./pages/BarcodeScanner'));
const Stock         = lazy(() => import('./pages/Stock'));
const Sales         = lazy(() => import('./pages/Sales'));
const Reports       = lazy(() => import('./pages/Reports'));
const Suppliers     = lazy(() => import('./pages/Suppliers'));
const Users         = lazy(() => import('./pages/Users'));

function PageLoader() {
  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      height: '60vh',
      gap: '16px',
      color: 'var(--text-secondary)',
    }}>
      <div style={{
        width: '36px',
        height: '36px',
        border: '3px solid var(--border)',
        borderTopColor: 'var(--accent-blue)',
        borderRadius: '50%',
        animation: 'spin 0.7s linear infinite',
      }} />
      <span style={{ fontSize: '13px' }}>Loading…</span>
    </div>
  );
}

function ProtectedRoute({ children, ownerOnly = false }) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        height: '100vh',
        flexDirection: 'column',
        gap: '16px',
        color: 'var(--text-secondary)',
      }}>
        <div style={{
          width: '40px',
          height: '40px',
          border: '3px solid var(--border)',
          borderTopColor: 'var(--accent-blue)',
          borderRadius: '50%',
          animation: 'spin 0.7s linear infinite',
        }} />
        <span>ShopSync</span>
      </div>
    );
  }

  if (!user) return <Navigate to="/login" replace />;
  if (ownerOnly && user.role !== 'owner') return <Navigate to="/" replace />;
  return children;
}

function AppRoutes() {
  const { user } = useAuth();

  return (
    <Suspense fallback={<PageLoader />}>
      <Routes>
        <Route
          path="/login"
          element={user ? <Navigate to="/" replace /> : <Login />}
        />
        <Route
          path="/"
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          <Route index element={<Dashboard />} />
          <Route path="products" element={<Products />} />
          <Route path="barcode" element={<BarcodeScanner />} />
          <Route path="stock" element={<Stock />} />
          <Route path="sales" element={<Sales />} />
          <Route path="reports" element={<Reports />} />
          <Route path="suppliers" element={<Suppliers />} />
          <Route
            path="users"
            element={
              <ProtectedRoute ownerOnly>
                <Users />
              </ProtectedRoute>
            }
          />
        </Route>
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Suspense>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <AppRoutes />
      </AuthProvider>
    </BrowserRouter>
  );
}
