<template>
    <div class="app flex">
        <SideBar/>
        <RouterView></RouterView>
        <main class="container h-screen p-4 flex-1 overflow-y-auto">
            <headerP/>
            <section class="flex flex-col">
                <h1><strong>Reportes de alquiler</strong></h1>
                <br>
                <GraphAlq/>
            </section>
        </main>
    </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import GraphAlq from '@/components/Graficos/GraphAlq.vue';
</script>

<style>

</style>

