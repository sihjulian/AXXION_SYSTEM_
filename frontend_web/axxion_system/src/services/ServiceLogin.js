import apiClient from '@/plugins/axios';

export default class ServiceLogin {

  resetPassword(userData) {
    return apiClient.post(`/passwordreset`, userData);
  }
  login(userData) {
    // Para login no usamos el interceptor porque aún no tenemos token
    return apiClient.post(`/login`, userData);
  }
  register(userData) {
    return apiClient.post(`/register`, userData);
  }
}