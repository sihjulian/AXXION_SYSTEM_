import { defineStore } from 'pinia';
import ServiceLogin from '@/services/ServiceLogin';
import axios from 'axios';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('token') || null,
    user: JSON.parse(localStorage.getItem('user')) || null,
    error: null,
  }),
  getters: {
    isAuthenticated: (state) => !!state.token,
    getUser: (state) => state.user,
  },
  actions: {
    async login(credentials) {
      const service = new ServiceLogin();
      try {
        const response = await service.login(credentials);
        const { token, user } = response.data;
        
        this.token = token;
        this.user = user;
        this.error = null;

        localStorage.setItem('token', token);
        localStorage.setItem('user', JSON.stringify(user));

        axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
        
        return true;
      } catch (error) {
        this.error = 'Credenciales incorrectas. Por favor, inténtalo de nuevo.';
        console.error('Error de login:', error);
        return false;
      }
    },
    logout() {
      this.token = null;
      this.user = null;
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      delete axios.defaults.headers.common['Authorization'];
    },
    checkAuth() {
        const token = localStorage.getItem('token');
        if (token) {
            this.token = token;
            this.user = JSON.parse(localStorage.getItem('user'));
            axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
        }
    }
  },
});
