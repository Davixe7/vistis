<script setup>
import { ref, onMounted, watch } from 'vue'
import VisitForm from './VisitForm.vue'
import { api } from 'src/boot/axios'

import { formatRelative } from 'date-fns'
import { es } from 'date-fns/locale'

const loading = ref(false)
const mode = ref('history')
const visits = ref([])

watch(mode, (newVal) => {
  if (newVal == 'history') {
    fetchVisits()
  }
})

async function fetchVisits() {
  loading.value = true
  try {
    visits.value = (await api.get('visits')).data.data
  } catch (error) {
    console.log(error)
  } finally {
    loading.value = false
  }
}

onMounted(async () => await fetchVisits())
</script>

<template>
  <q-tabs
    dense
    no-caps
    narrow-indicator
    inline-label
    v-model="mode"
    class="bg-primary text-white"
    style="border-bottom: 1px solid #d9d9d9"
  >
    <q-tab name="create" icon="edit" label="Nueva"></q-tab>
    <q-tab
      name="history"
      icon="history"
      label="Historial"
    ></q-tab>
  </q-tabs>

  <template v-if="mode == 'create'">
    <VisitForm />
  </template>

  <template v-else>
    <div
      v-if="loading"
      class="flex justify-center items-center"
      style="height: 360px"
    >
      <q-spinner color="primary" size="48px"></q-spinner>
    </div>
    <q-list v-else separator>
      <q-item v-for="visit in visits" :key="visit.id">
        <q-item-section
          avatar
          style="padding-right: 0; min-width: 46px"
        >
          <q-avatar>
            <q-img
              v-if="visit.picture"
              :src="visit.picture"
            ></q-img>
            <q-icon
              v-else
              name="account_circle"
              style="font-size: 48px"
            ></q-icon>
          </q-avatar>
        </q-item-section>
        <q-item-section avatar>
          <q-avatar
            icon="qr_code"
            style="border: 1px solid #d9d9d9"
          ></q-avatar>
        </q-item-section>

        <q-item-section>
          <q-item-label>{{
            visit.extension_name
          }}</q-item-label>
          <q-item-label caption>{{
            visit.name
          }}</q-item-label>
        </q-item-section>
        <q-item-section side top>
          <q-item-label caption>{{
            formatRelative(
              new Date(visit.checkin),
              new Date(),
              { addSuffix: false, locale: es },
            )
          }}</q-item-label>
          <div
            class="text-mono q-py-xs"
            style="font-family: 'monospace'"
          >
            {{
              visit.password ? visit.password : 'PWD0000'
            }}
          </div>
        </q-item-section>
      </q-item>
    </q-list>
  </template>
</template>

<style>
.q-btn {
  text-transform: none;
}
.q-toolbar-title {
  font-size: 18px;
}
</style>
