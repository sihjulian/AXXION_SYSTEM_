import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useCartStore = defineStore('cart', () => {
  const items = ref([]);
  const isOpen = ref(false);

  const totalItems = computed(() => items.value.length);
  
  const totalPrice = computed(() => {
    return items.value.reduce((total, item) => {
      // Intentar obtener precio de diferentes propiedades posibles
      const price = parseFloat(item.precio_alquiler_dia || item.precio_renta || 0);
      return total + (isNaN(price) ? 0 : price);
    }, 0);
  });

  function addItem(item) {
    // Evitar duplicados si es necesario, o permitir múltiples cantidades
    const exists = items.value.find(i => i.id === item.id);
    if (!exists) {
      items.value.push(item);
      // Abrir el carrito automáticamente al agregar (opcional, pero buena UX)
      isOpen.value = true;
    }
  }

  function removeItem(itemId) {
    items.value = items.value.filter(item => item.id !== itemId);
  }

  function clearCart() {
    items.value = [];
  }

  function toggleCart() {
    isOpen.value = !isOpen.value;
  }

  function openCart() {
    isOpen.value = true;
  }

  function closeCart() {
    isOpen.value = false;
  }

  return {
    items,
    isOpen,
    totalItems,
    totalPrice,
    addItem,
    removeItem,
    clearCart,
    toggleCart,
    openCart,
    closeCart
  };
});
