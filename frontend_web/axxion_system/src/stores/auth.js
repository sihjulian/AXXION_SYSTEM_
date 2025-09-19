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
        const user = localStorage.getItem('user');
        
        if (token && user) {
            try {
                this.token = token;
                this.user = JSON.parse(user);
                axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
                console.log('Auth restored from localStorage:', {
                    hasToken: !!token,
                    user: this.user
                });
            } catch (error) {
                console.error('Error parsing user data from localStorage:', error);
                this.logout();
            }
        } else {
            console.log('No auth data found in localStorage');
        }
    },
    
    // Método para verificar si el usuario tiene un rol específico
    hasRole(roleName) {
        if (!this.user || !this.user.roles) return false;
        
        // Si roles es un array de strings (formato anterior)
        if (typeof this.user.roles[0] === 'string') {
            return this.user.roles.includes(roleName);
        }
        
        // Si roles es un array de objetos (formato nuevo)
        return this.user.roles.some(role => 
            role.codigo === roleName || 
            role.name === roleName ||
            role.nombre === roleName
        );
    },
    
    // Método para verificar si el usuario tiene alguno de los roles especificados
    hasAnyRole(roleNames) {
        if (!Array.isArray(roleNames)) return false;
        return roleNames.some(roleName => this.hasRole(roleName));
    }
  },
});
