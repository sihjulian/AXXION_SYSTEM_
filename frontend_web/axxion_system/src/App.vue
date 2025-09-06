<template>
  <div>
    <RouterView />
  </div>
</template>

<script setup>
import { RouterView } from 'vue-router'
import { RouterLink } from 'vue-router';
</script>

<style lang="scss">


.app {
  display: flex;
  main {
    flex: 1;
    padding: 2rem;
    @media (max-width: 1024px) {
      padding-left: 6rem;
    }
  }
}
</style>
