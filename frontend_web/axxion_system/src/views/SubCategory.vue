<template>
  <div class="app flex">
    <SideBar/>
    <RouterView />
    <main class="container h-screen p-4 flex-1 overflow-y-auto" >
      <headerP/>
      <section class="flex flex-row">
        <article class="basis-1/5 mr-5 p-5 rounded-md bg-[#000f14] text-cyan-100">
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Dolor in laborum maiores repellat asperiores id qui magnam adipisci perspiciatis ratione consequatur aperiam optio repellendus laudantium, commodi non necessitatibus aut autem!</p>
        </article>
        <article class="basis-4/5 mr-5 p-5 rounded-md bg-[#000f14] text-cyan-100">
          <p>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Neque consequatur aut tenetur minus eligendi expedita labore officia necessitatibus commodi beatae, possimus voluptates animi nostrum quibusdam fugit modi asperiores repellendus totam!</p>
        </article>
      </section>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import SideBar from '@/components/SideBar.vue';
import headerP from '@/components/headerP.vue';
import { FwbButton, FwbModal, FwbAlert, FwbInput } from 'flowbite-vue';
import { FwbCard } from 'flowbite-vue'

const name = ref('')

const isShowModal = ref(false)

function closeModal () {
  isShowModal.value = false
}
function showModal () {
  isShowModal.value = true
}

</script>

<style>

</style>