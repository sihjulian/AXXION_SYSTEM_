import apiClient from '@/plugins/axios';

export default {
  async getAll() {
    const res = await apiClient.get('/categoria');
    return res.data?.categoria ?? res.data;
  },
  async createCategory(payload) {
    const res = await apiClient.post('/categoria', payload);
    return res.data;
  },
  async updateCategory(id, payload) {
    const res = await apiClient.put(`/categoria/${id}`, payload);
    return res.data;
  },
  async deleteCategory(id) {
    const res = await apiClient.delete(`/categoria/${id}`);
    return res.data;
  }
};

