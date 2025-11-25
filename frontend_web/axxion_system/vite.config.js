import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'
import vueDevTools from 'vite-plugin-vue-devtools'
import tailwindcss from '@tailwindcss/vite'
// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueJsx(),
    vueDevTools(),
    tailwindcss(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
        proxy: {
      // Si una petición empieza con '/api', Vite la interceptará.
      '/api': {
        // Y la reenviará a nuestro backend de Laravel.
        target: 'http://127.0.0.1:8000',
        
        // Esto es importante para evitar problemas con Virtual Hosts.
        changeOrigin: true,

        // Esto es opcional y generalmente no es necesario,
        // pero no hace daño tenerlo para claridad.
        // Le dice a Vite que no modifique la ruta,
        // así que /api/auth/login se reenvía como /api/auth/login.
        rewrite: (path) => path.replace(/^\/api/, '/api'),
      },
    },
  },
})
