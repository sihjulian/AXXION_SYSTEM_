import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import UserService from '@/services/UserService.js';

export const useUserStore = defineStore('user', () => {
  // Estado
  const users = ref([]);
  const roles = ref([]);
  const isLoading = ref(false);
  const error = ref(null);

  // Getters
  const activeUsers = computed(() => 
    users.value.filter(user => user.estado === 'activo')
  );

  const inactiveUsers = computed(() => 
    users.value.filter(user => user.estado === 'inactivo')
  );

  const usersByDepartment = computed(() => {
    const departments = {};
    users.value.forEach(user => {
      if (!departments[user.departamento]) {
        departments[user.departamento] = [];
      }
      departments[user.departamento].push(user);
    });
    return departments;
  });

  // Actions
  const fetchUsers = async () => {
    try {
      isLoading.value = true;
      error.value = null;
      const response = await UserService.getUsers();
      users.value = response.data || [];
      return response;
    } catch (err) {
      error.value = err.message || 'Error al cargar usuarios';
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const fetchRoles = async () => {
    try {
      const response = await UserService.getRoles();
      console.log('Roles response in store:', response);
      // La API devuelve {rol: [...], status: 200} no {data: [...]}
      roles.value = response.rol || response.data || [];
      return response;
    } catch (err) {
      console.error('Error al cargar roles:', err);
      // Roles por defecto si falla la API
      roles.value = [
        { id: 1, nombre: 'Administrador' },
        { id: 2, nombre: 'Auxiliar' },
        { id: 3, nombre: 'Técnico' }
      ];
    }
  };

  const createUser = async (userData) => {
    try {
      isLoading.value = true;
      error.value = null;
      const response = await UserService.createUser(userData);
      
      // Agregar el nuevo usuario al estado local
      if (response.data && response.data.data) {
        users.value.push(response.data.data);
      }
      
      return response;
    } catch (err) {
      error.value = err.message || 'Error al crear usuario';
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const updateUser = async (id, userData) => {
    try {
      isLoading.value = true;
      error.value = null;
      const response = await UserService.updateUser(id, userData);
      
      // Actualizar el usuario en el estado local
      const index = users.value.findIndex(user => user.id === id);
      if (index !== -1 && response.data && response.data.data) {
        users.value[index] = response.data.data;
      }
      
      return response;
    } catch (err) {
      error.value = err.message || 'Error al actualizar usuario';
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const deleteUser = async (id) => {
    try {
      isLoading.value = true;
      error.value = null;
      const response = await UserService.deleteUser(id);
      
      // Remover el usuario del estado local
      const index = users.value.findIndex(user => user.id === id);
      if (index !== -1) {
        users.value.splice(index, 1);
      }
      
      return response;
    } catch (err) {
      error.value = err.message || 'Error al eliminar usuario';
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  const clearError = () => {
    error.value = null;
  };

  const resetState = () => {
    users.value = [];
    roles.value = [];
    isLoading.value = false;
    error.value = null;
  };

  return {
    // Estado
    users,
    roles,
    isLoading,
    error,
    
    // Getters
    activeUsers,
    inactiveUsers,
    usersByDepartment,
    
    // Actions
    fetchUsers,
    fetchRoles,
    createUser,
    updateUser,
    deleteUser,
    clearError,
    resetState
  };
});
