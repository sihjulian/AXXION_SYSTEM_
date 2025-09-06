import axios from "axios";

let urlBase = "http://localhost:8000/api";

export default class ServiceLogin {

  resetPassword(userData) {
    return axios.post(`${urlBase}/passwordreset`, userData);
  }
  login(userData) {
    return axios.post(`${urlBase}/login`, userData);
  }
  register(userData) {
    return axios.post(`${urlBase} + /register`, userData);
  }
}