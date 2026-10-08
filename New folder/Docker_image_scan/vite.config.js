import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/proxy/anthropic': {
        target: 'https://api.anthropic.com',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/anthropic/, ''),
      },
      '/proxy/openai': {
        target: 'https://api.openai.com',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/openai/, ''),
      },
      '/proxy/groq': {
        target: 'https://api.groq.com',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/groq/, ''),
      },
      '/proxy/mistral': {
        target: 'https://api.mistral.ai',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/mistral/, ''),
      },
      '/proxy/npm': {
        target: 'https://registry.npmjs.org',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/npm/, ''),
      },
      '/proxy/pypi': {
        target: 'https://pypi.org',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/pypi/, ''),
      },
      '/proxy/github': {
        target: 'https://api.github.com',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/github/, ''),
      },
      '/proxy/osv': {
        target: 'https://api.osv.dev',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/osv/, ''),
      },
      '/proxy/clearlydefined': {
        target: 'https://api.clearlydefined.io',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/clearlydefined/, ''),
      },
      '/proxy/gitlab': {
        target: 'https://gitlab.com',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/gitlab/, ''),
      },
      '/proxy/crates': {
        target: 'https://crates.io',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/crates/, ''),
      },
      '/proxy/maven': {
        target: 'https://search.maven.org',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/maven/, ''),
      },
      '/proxy/packagist': {
        target: 'https://packagist.org',
        changeOrigin: true,
        secure: true,
        rewrite: path => path.replace(/^\/proxy\/packagist/, ''),
      },
    },
  },
})
