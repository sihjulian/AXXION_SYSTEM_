<template>
  <div v-if="showNotification" class="auth-notification" :class="notificationType">
    <div class="notification-content">
      <i class="notification-icon" :class="iconClass"></i>
      <span class="notification-message">{{ message }}</span>
      <button @click="closeNotification" class="close-btn">
        <i class="fas fa-times"></i>
      </button>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';

export default {
  /**
   * Componente AuthNotification.
   * 
   * Muestra notificaciones flotantes (toast) para feedback de autenticación y otras acciones.
   * Soporta tipos: 'success', 'warning', 'error'.
   * Se integra con los query params de la URL para mostrar mensajes al redirigir.
   */
  name: 'AuthNotification',
  setup() {
    const route = useRoute();
    const showNotification = ref(false);
    const message = ref('');
    const notificationType = ref('error');

    // Computed para determinar el icono según el tipo de notificación
    const iconClass = computed(() => {
      switch (notificationType.value) {
        case 'success':
          return 'fas fa-check-circle';
        case 'warning':
          return 'fas fa-exclamation-triangle';
        case 'error':
        default:
          return 'fas fa-exclamation-circle';
      }
    });

    const closeNotification = () => {
      showNotification.value = false;
    };

    /**
     * Muestra una notificación con un mensaje y tipo específicos.
     * Se cierra automáticamente después de 5 segundos.
     * @param {string} msg - El mensaje a mostrar.
     * @param {string} type - El tipo de notificación ('error', 'success', 'warning').
     */
    const showMessage = (msg, type = 'error') => {
      message.value = msg;
      notificationType.value = type;
      showNotification.value = true;
      
      // Auto-cerrar después de 5 segundos
      setTimeout(() => {
        showNotification.value = false;
      }, 5000);
    };

    // Al montar, verifica si hay mensajes en los parámetros de la URL (query params)
    // Esto es útil para mostrar errores o éxitos después de una redirección (ej. login fallido).
    onMounted(() => {
      if (route.query.error) {
        showMessage(route.query.error, 'error');
      }
      if (route.query.success) {
        showMessage(route.query.success, 'success');
      }
      if (route.query.warning) {
        showMessage(route.query.warning, 'warning');
      }
    });

    return {
      showNotification,
      message,
      notificationType,
      iconClass,
      closeNotification,
      showMessage
    };
  }
};
</script>

<style scoped>
.auth-notification {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  max-width: 400px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  animation: slideIn 0.3s ease-out;
}

.auth-notification.error {
  background-color: #fee;
  border-left: 4px solid #dc3545;
  color: #721c24;
}

.auth-notification.success {
  background-color: #d4edda;
  border-left: 4px solid #28a745;
  color: #155724;
}

.auth-notification.warning {
  background-color: #fff3cd;
  border-left: 4px solid #ffc107;
  color: #856404;
}

.notification-content {
  display: flex;
  align-items: center;
  padding: 16px;
  gap: 12px;
}

.notification-icon {
  font-size: 20px;
  flex-shrink: 0;
}

.notification-message {
  flex: 1;
  font-weight: 500;
}

.close-btn {
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  color: inherit;
  opacity: 0.7;
  transition: opacity 0.2s;
}

.close-btn:hover {
  opacity: 1;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}
</style>
