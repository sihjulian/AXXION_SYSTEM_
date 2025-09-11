<template>
  <FwbCard
    class="w-sm"
    img-alt="Categoria"
    img-src="https://flowbite.com/docs/images/blog/image-4.jpg"
    variant="horizontal"
  >
    <div class="p-5">
      <div class="flex gap-2">
        <!-- Botones editar / eliminar -->
        <FwbButton class=" transition  duration-300 ease-in-out hover:-translate-y-1 hover:scale-110"
          size="xs"
          color="yellow"
          @click="$emit('edit', category)"
        >
          <font-awesome-icon icon="fa-solid fa-pen-to-square" />
        </FwbButton>
        <FwbButton class=" transition  duration-300 ease-in-out hover:-translate-y-1 hover:scale-110"
          size="xs"
          color="red"
          @click="$emit('delete', category)"
        >
          <font-awesome-icon icon="fa-solid fa-trash" />
        </FwbButton>
      </div>

      <br />
      <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
        {{ category.nombre }}
      </h5>
      <p class="font-normal text-gray-700 dark:text-gray-400">
        {{ category.descripcion }}
        <br />
        <span class="text-sm text-blue-600">Tipo: {{ category.tipo_categoria }}</span>
      </p>
    </div>
  </FwbCard>
</template>

<script setup>
import { FwbButton, FwbCard } from "flowbite-vue";

// Props: recibimos la categoría a mostrar
const props = defineProps({
  category: {
    type: Object,
    required: true,
  },
});

// Emitimos eventos al padre
const emit = defineEmits(["edit", "delete"]);
</script>
