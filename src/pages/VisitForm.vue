<script setup>
import { ref, computed } from 'vue'
import { api } from '../boot/axios'
import notify from 'src/utils/notify'
import CameraWidget from 'src/components/CameraWidget.vue'

const loading = ref(false)
const errors = ref({})
const toggleNoteInput = ref(false)
const camera = ref(false)

const visitTemplate = ref({
  dni: '',
  name: '',
  phone: '',
  type: 'singular',
  company: '',
  arl: '',
  eps: '',
  extension_name: '',
  plate: '',
  authorized_by: '',
  note: '',
  visitor_id: null,
  picture: '',
})

const visit = ref({ ...visitTemplate.value })

function visitorToVisit(visitor) {
  Object.keys(visitTemplate.value).forEach((key) => {
    visit.value[key] =
      visitor[key] && visitor[key] != 'null'
        ? visitor[key]
        : visit.value[key]
  })

  visit.value.visitor_id = visitor.id
}

async function queryByDni() {
  loading.value = true
  try {
    let response = (
      await api.get(`/visitors?dni=${visit.value.dni}`)
    ).data.data
    visitorToVisit(response)
  } catch (error) {
    if (error.response.status == 404) {
      errors.value.dni = 'No se encontraron resultados'
    }
  } finally {
    loading.value = false
  }
}

async function storeVisit() {
  loading.value = true
  try {
    ;(await api.post(`/visits`, setData())).data.data
    visit.value = { ...visitTemplate.value }
    notify.positive('Visita registrada con exito')
  } catch (error) {
    if (error.status == 422) {
      notify.negative(
        'No se pudo registrar, confirme la informacion',
      )
      errors.value = error.formatted ? error.formatted : {}
    }
  } finally {
    loading.value = false
  }
}

function setData() {
  let data = new FormData()
  delete visit.value.picture

  Object.keys(visit.value).forEach((key) => {
    data.append(key, visit.value[key])
  })

  if (blobRef.value) {
    data.append('picture', blobRef.value)
  }

  return data
}

const blobRef = ref(null)

function setBlob(blob) {
  blobRef.value = blob
  camera.value = false
}

const currentPictureUrl = computed(() => {
  if (visit.value.picture) {
    return visit.value.picture
  }
  if (blobRef.value) {
    return URL.createObjectURL(blobRef.value)
  }
  return null
})
</script>

<template>
  <CameraWidget
    v-if="camera"
    @pictureTaken="setBlob"
    @close="camera = false"
  />

  <q-form
    @submit.prevent="storeVisit"
    class="q-gutter-y-md q-pa-md"
  >
    <div
      style="height: 180px; position: relative"
      class="bg-grey"
    >
      <q-img
        :src="currentPictureUrl"
        width="100%"
        height="180px"
      ></q-img>

      <div
        class="flex justify-center"
        style="
          width: 100%;
          position: absolute;
          bottom: 0;
          left: 0;
          right: 0;
        "
      >
        <q-btn
          @click="camera = !camera"
          flat
          round
          icon="camera"
          class="q-mr-md bg-white"
        />
      </div>
    </div>

    <div class="flex q-mb-md">
      <q-radio
        dense
        val="singular"
        label="Personal"
        v-model="visit.type"
        class="q-mr-md"
      />
      <q-radio
        val="enterprise"
        label="Empresa"
        v-model="visit.type"
      />
    </div>

    <q-input
      outlined
      stack-label
      label="Apartamento"
      hide-bottom-space
      v-model="visit.extension_name"
      :error="!!errors.extension_name"
      :error-message="errors.extension_name"
    />

    <q-input
      outlined
      stack-label
      label="Cedula"
      hide-bottom-space
      v-model="visit.dni"
      :error="!!errors.dni"
      :error-message="errors.dni"
      @blur="queryByDni"
    />

    <q-input
      outlined
      stack-label
      label="Nombre"
      hide-bottom-space
      v-model="visit.name"
      :error="!!errors.name"
      :error-message="errors.name"
    />

    <q-input
      outlined
      stack-label
      label="Celular"
      type="tel"
      hide-bottom-space
      v-model="visit.phone"
      :error="!!errors.phone"
      :error-message="errors.phone"
    />

    <q-input
      outlined
      stack-label
      label="Placa (opcional)"
      hide-bottom-space
      v-model="visit.plate"
      :error="!!errors.plate"
      :error-message="errors.plate"
    />

    <template v-if="visit.type == 'enterprise'">
      <q-input
        outlined
        stack-label
        label="Nombre Empresa"
        hide-bottom-space
        v-model="visit.company"
        :error="!!errors.company"
        :error-message="errors.company"
      />

      <q-input
        outlined
        stack-label
        label="ARL"
        hide-bottom-space
        v-model="visit.arl"
        :error="!!errors.arl"
        :error-message="errors.arl"
      />

      <q-input
        outlined
        stack-label
        label="EPS"
        hide-bottom-space
        v-model="visit.eps"
        :error="!!errors.eps"
        :error-message="errors.eps"
      />
    </template>

    <q-input
      outlined
      stack-label
      label="Autorizado por"
      hide-bottom-space
      v-model="visit.authorized_by"
      :error="!!errors.authorized_by"
      :error-message="errors.authorized_by"
    />

    <q-input
      v-show="toggleNoteInput"
      type="textarea"
      outlined
      stack-label
      label="Nota"
      hide-bottom-space
      v-model="visit.note"
      :error="!!errors.note"
      :error-message="errors.note"
    />

    <span
      @click="toggleNoteInput = !toggleNoteInput"
      class="text-primary flex justify-end"
    >
      <small>{{
        !toggleNoteInput ? 'Agregar nota' : 'Cancelar'
      }}</small>
    </span>

    <div class="flex justify-end">
      <q-btn
        type="submit"
        color="primary"
        :loading="loading"
        >Registrar visita</q-btn
      >
    </div>
  </q-form>
</template>
