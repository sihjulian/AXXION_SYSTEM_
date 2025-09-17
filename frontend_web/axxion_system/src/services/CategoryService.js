// src/services/CategoryService.js
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://127.0.0.1:8000/api',
  headers: { 'Content-Type': 'application/json', Accept: 'application/json' }
});

export default {
  async getAll() {
    const res = await api.get('/categoria');
    return res.data?.categoria ?? res.data;
  },
  async createCategory(payload) {
    const res = await api.post('/categoria', payload);
    return res.data;
  },
  async updateCategory(id, payload) {
    const res = await api.put(`/categoria/${id}`, payload);
    return res.data;
  },
  async deleteCategory(id) {
    const res = await api.delete(`/categoria/${id}`);
    return res.data;
  }
};


