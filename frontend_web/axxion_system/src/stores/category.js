const categorias = ref([]); // Aquí guardamos las categorías
const nombre = ref('');
const descripcion = ref('');
const tipo_categoria = ref('');

async function fetchCategorias() {
  try {
    const data = await CategoryService.getCategory();
    categorias.value = data.data ?? data; // Laravel normalmente envía {data: [...]}
  } catch (error) {
    console.error("Error al obtener categorías", error);
  }
}

async function crearCategoria() {
  try {
    const nuevaCategoria = {
      nombre: nombre.value,
      descripcion: descripcion.value,
      tipo_categoria: tipo_categoria.value,
    };
    await CategoryService.createCategory(nuevaCategoria);
    await fetchCategorias(); // refrescar lista
    closeModal(); // cerrar modal
  } catch (error) {
    console.error("Error al crear categoría", error);
  }
}

// Cargar categorías cuando se monte el componente
onMounted(() => {
  fetchCategorias();
});
