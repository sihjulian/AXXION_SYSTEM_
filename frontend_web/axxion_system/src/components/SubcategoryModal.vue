<template>
  <FwbModal @close="onClose">
    <template #header>
      <div class="text-lg text-amber-50">
        {{ mode === 'add' ? 'Agregar Subcategoría' : mode === 'edit' ? 'Editar Subcategoría' : 'Eliminar Subcategoría' }}
      </div>
    </template>

    <template #body>
      <div v-if="mode !== 'delete'">
        <fwb-input v-model="form.nombre" label="Nombre" />
        <br />
        <fwb-input v-model="form.descripcion" label="Descripción" />
      </div>
      <div v-else>
        <p class="text-amber-50">¿Eliminar la subcategoría <b>{{ subcategoria?.nombre }}</b>?</p>
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
  mode: { type: String, default: 'add' },
  subcategoria: { type: Object, default: null },
  categoriaId: { type: [Number,String], default: null }
})
const emit = defineEmits(['close','save','delete'])

const form = ref({ id: null, nombre:'', descripcion:'', categoria_id: props.categoriaId ?? null })

watch(() => [props.subcategoria, props.mode, props.categoriaId], () => {
  if (props.mode === 'edit' && props.subcategoria) {
    form.value = { id: props.subcategoria.id, nombre: props.subcategoria.nombre ?? '', descripcion: props.subcategoria.descripcion ?? '', categoria_id: props.categoriaId ?? null }
  } else {
    form.value = { id: null, nombre:'', descripcion:'', categoria_id: props.categoriaId ?? null }
  }
}, { immediate: true })

function onClose(){ emit('close') }
function onSave(){ emit('save', { ...form.value }) }
function onDelete(){ if(props.subcategoria?.id) emit('delete', props.subcategoria.id); else emit('close') }
</script>





