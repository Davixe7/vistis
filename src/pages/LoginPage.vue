<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { api } from '../boot/axios'

const router = useRouter()
const loading = ref(false)
const errors = ref(false)

const credentials = reactive({
  email: 'prueba@phenlinea.com',
  password: '123456',
})

async function attemptLogin() {
  loading.value = true
  errors.value = false
  try {
    let response = (await api.post('/porteria-login', { ...credentials })).data
    localStorage.setItem('apiToken', response.user.api_token)
    router.push('/visitas')
  } catch (error) {
    console.log(error)
    if (error.response && error.response.status == 422) {
      errors.value = true
    }
  }
  loading.value = false
}
</script>

<template>
  <div class="q-pa-md">
    <div class="flex justify-center">
      <q-img src="https://phenlinea.com/img/logo.png" width="100px" class="q-mb-md" />
    </div>

    <div class="q-py-xs">
      <h1 class="page-title">Control de Visitas</h1>
    </div>

    <q-form @submit.prevent="attemptLogin" class="q-gutter-y-md">
      <q-input
        outlined
        stack-label
        label="Email"
        hide-bottom-space
        type="email"
        v-model="credentials.email"
        :error="errors.email"
        :error-message="'Nombre de usuario o contrasena incorrectos'"
      />

      <q-input
        outlined
        stack-label
        label="Contrasena"
        hide-bottom-space
        type="password"
        v-model="credentials.password"
        :error="errors.password"
        :error-message="'Nombre de usuario o contrasena incorrectos'"
      />

      <div class="flex justify-end">
        <q-btn type="submit" color="primary" class="full-width" :loading="loading">Ingresar</q-btn>
      </div>
    </q-form>
  </div>
</template>
