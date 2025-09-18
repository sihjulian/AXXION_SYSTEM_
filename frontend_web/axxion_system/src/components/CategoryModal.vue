<template>
  <FwbModal class="text-amber-50" @close="onClose">
    <template #header>
      <div class="text-lg text-amber-50">
        {{ mode === 'add' ? 'Agregar Categoría' : mode === 'edit' ? 'Editar Categoría' : 'Eliminar Categoría' }}
      </div>
    </template>

    <template #body>
      <div v-if="mode !== 'delete'">
        <fwb-input v-model="local.nombre" label="Nombre" />
        <br />
        <fwb-input v-model="local.descripcion" label="Descripción" />
        <br />
        <fwb-input v-model="local.tipo_categoria" label="Tipo" />
      </div>
      <div v-else>
        <p class="text-amber-50">¿Eliminar la categoría <b>{{ category?.nombre }}</b>?</p>
      </div>
    </template>

    <template #footer>
      <div class="flex justify-between w-full">
        <FwbButton @click="onClose" color="alternative">Cancelar</FwbButton>
        <FwbButton v-if="mode !== 'delete'" @click="onSave" color="green">Guardar</FwbButton>
        <FwbButton v-else @click="onDelete" color="red">Eliminar</FwbButton>
      </div>
    </template>
  </FwbModal>
</template>

<script setup>
import { ref, watch } from 'vue'
import { FwbModal, FwbButton, FwbInput } from 'flowbite-vue'

const props = defineProps({
  mode: { type: String, default: 'add' }, // 'add' | 'edit' | 'delete'
  category: { type: Object, default: null }
})
const emit = defineEmits(['close','save','delete'])

const local = ref({ nombre: '', descripcion: '', tipo_categoria: '' })

watch(() => [props.category, props.mode], () => {
  if (props.mode === 'edit' && props.category) {
    local.value = { ...props.category }
  } else {
    local.value = { nombre: '', descripcion: '', tipo_categoria: '' }
  }
}, { immediate: true })

function onClose(){ emit('close') }
function onSave(){ emit('save', { ...local.value }) }
function onDelete(){ if(props.category?.id) emit('delete', props.category.id); else emit('close') }
</script>
