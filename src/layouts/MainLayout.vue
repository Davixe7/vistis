<template>
  <q-layout view="lHh Lpr lFf">
    <q-header>
      <q-toolbar class="bg-primary text-white">
        <q-toolbar-title
          >Control de Visitas</q-toolbar-title
        >
        <q-btn
          flat
          round
          icon="logout"
          @click="logout"
        ></q-btn>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import notify from 'src/utils/notify'
import { useRouter } from 'vue-router'
const router = useRouter()
async function logout() {
  try {
    localStorage.removeItem('apiToken')
    notify.positive('Su sesion ha cerrado exitosamente')
    router.push('/login')
  } catch (error) {
    console.log(error)
    notify.negative('Error al cerrar sesion')
  }
}
</script>
