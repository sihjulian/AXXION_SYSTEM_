<template>
<div>
<header class="flex items-center justify-between border-b pb-4 mb-6 flex-shrink-0">


            <!-- Encabezado del contenido - REUTILIZADO -->

                <h1 class="text-3xl font-semibold text-gray-800">AXION SYSTEM</h1>
                <div class="flex items-center space-x-4">
                    <div v-if="user.roles && user.roles.length > 0">
                        <span class="text-lg font-medium text-gray-700">{{ user.roles[0].nombre}}</span>
                        <font-awesome-icon icon="fa-solid fa-user-tie" fade size="xl" style="color: #63E6BE;" />
                    </div>
                    <div v-else>
                        <span class="text-lg font-medium text-gray-700">no hay roles</span>
                    </div>
                    <svg @click="logout" class="h-8 w-8 text-red-500 cursor-pointer" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                </div>


</header>
</div>

</template>
<script setup>
import { ref, onMounted } from 'vue';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

/**
 * Componente headerP.
 * 
 * Encabezado principal de la aplicación (versión alternativa o específica).
 * Muestra el título del sistema, el rol del usuario actual y el botón de cerrar sesión.
 */

const router = useRouter();
const authStore = useAuthStore();

const user = ref([]);

// Recupera los datos del usuario desde el almacenamiento local.
const getuserdata = () => {
    const userData = localStorage.getItem('user');
    return userData ? JSON.parse(userData) : null;
};

// Cierra la sesión del usuario y redirige al login.
const logout = () => {
    authStore.logout();
    router.push('/login');
};



onMounted(() => {
    user.value = getuserdata();
    console.log('User data:', user.value);
});



</script>

<style scoped>

</style>