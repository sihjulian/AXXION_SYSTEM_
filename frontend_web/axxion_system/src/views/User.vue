<template>
  <div class=" flex">

<SideBar/>
<RouterView></RouterView>

<headerP></headerP>




















</div>



</template>

<script setup>
import { RouterLink } from 'vue-router';
import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
</script>

<style>

</style>