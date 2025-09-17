// src/services/SubCategoryService.js
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://127.0.0.1:8000/api',
  headers: { 'Content-Type': 'application/json', Accept: 'application/json' }
});

export default {
  async create(payload) {              // payload must include categoria_id
    const res = await api.post('/subcategoria', payload);
    return res.data;
  },
  async update(id, payload) {
    const res = await api.put(`/subcategoria/${id}`, payload);
    return res.data;
  },
  async delete(id) {
    const res = await api.delete(`/subcategoria/${id}`);
    return res.data;
  },
  async getAll() {
    const res = await api.get('/subcategoria');
    return res.data?.subcategoria ?? res.data;
  }
};



