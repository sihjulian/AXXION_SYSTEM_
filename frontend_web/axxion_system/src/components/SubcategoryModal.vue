<template>
  <FwbModal @close="onClose">
    <template #header>
      <div class="text-lg text-amber-50">
        {{ mode === 'add' ? 'Agregar Subcategoría' :
           mode === 'edit' ? 'Editar Subcategoría' :
           'Eliminar Subcategoría' }}
      </div>
    </template>

    <template #body>
      <div v-if="mode !== 'delete'" class="text-amber-50">
        <FwbInput v-model="form.nombre" label="Nombre" placeholder="Ej: Teclados" />
        <br />
        <FwbInput v-model="form.descripcion" label="Descripción" placeholder="Ej: Periféricos" />
      </div>

      <div v-else class="text-amber-50">
        ¿Seguro que deseas eliminar la subcategoría <b>{{ subcategoria?.nombre }}</b>?
      </div>
    </template>

    <template #footer>
      <div class="flex justify-between w-full">
        <FwbButton @click="onClose" color="alternative">Cancelar</FwbButton>

        <FwbButton
          v-if="mode === 'add' || mode === 'edit'"
          @click="onSave"
          color="green"
        >
          Guardar
        </FwbButton>

        <FwbButton
          v-if="mode === 'delete'"
          @click="onDelete"
          color="red"
        >
          Eliminar
        </FwbButton>
      </div>
    </template>
  </FwbModal>
</template>

<script setup>
import { ref, watch } from 'vue'
import { FwbButton, FwbModal, FwbInput } from 'flowbite-vue'

// props que recibe el modal (el padre controla v-if)
const props = defineProps({
  mode: { type: String, default: 'add' },        // 'add' | 'edit' | 'delete'
  subcategoria: { type: Object, default: null }, // si edit/delete
  categoriaId: { type: [Number, String], default: null }
})

const emit = defineEmits(['close', 'save', 'delete'])

// formulario local (ref!!)
const form = ref({
  id: null,
  nombre: '',
  descripcion: '',
  categorias: props.categoriaId ? [props.categoriaId] : []
})

// sincronizar cuando cambian props (edit / categoriaId)
watch(
  () => [props.subcategoria, props.mode, props.categoriaId],
  () => {
    if (props.mode === 'edit' && props.subcategoria) {
      // si subcategoria viene del padre, clonar sus valores
      form.value = {
        id: props.subcategoria.id ?? null,
        nombre: props.subcategoria.nombre ?? '',
        descripcion: props.subcategoria.descripcion ?? '',
        categorias: props.categoriaId ? [props.categoriaId] : (props.subcategoria.categorias ? props.subcategoria.categorias.map(c=>c.id) : [])
      }
    } else {
      // en add o delete inicializamos
      form.value = {
        id: null,
        nombre: '',
        descripcion: '',
        categorias: props.categoriaId ? [props.categoriaId] : []
      }
    }
  },
  { immediate: true }
)

function onClose() {
  emit('close')
}

function onSave() {
  // debug: mostrar lo que se intenta emitir (transforma a JSON simple para evitar Proxy log confuso)
  console.log('SubcategoryModal onSave - form (to emit):', JSON.parse(JSON.stringify(form.value)))
  emit('save', JSON.parse(JSON.stringify(form.value))) // enviar valor plano (no Proxy)
}

function onDelete() {
  if (!props.subcategoria?.id) { emit('close'); return }
  console.log('SubcategoryModal onDelete - id:', props.subcategoria.id)
  emit('delete', props.subcategoria.id)
}
</script>







