<script setup>
import { ref, onMounted } from 'vue'
defineProps(['fullscreen'])
const emits = defineEmits(['pictureTaken', 'close'])

const width = ref(640)
const height = ref(0)
const videoRef = ref(null)
const canvasRef = ref(null)

function startVideo() {
  navigator.getMedia =
    navigator.getUserMedia ||
    navigator.msGetUserMedia ||
    navigator.mozGetUserMedia ||
    navigator.webkitGetUserMedia

  if (!navigator.getMedia) return

  navigator.getMedia(
    { video: true, audio: false },
    function (stream) {
      videoRef.value.srcObject = stream
      videoRef.value.play()
    },
    function (err) {
      console.log(err)
    },
  )
}

function setDimensions() {
  console.log(videoRef.value.height)
  console.log(videoRef.value.width)

  height.value =
    videoRef.value.height /
    (videoRef.value.width / width.value)
  videoRef.value.width = width.value
  videoRef.value.height = height.value
  canvasRef.value.width = width.value
  canvasRef.value.height = height.value
}

function takePicture() {
  canvasRef.value
    .getContext('2d')
    .drawImage(
      videoRef.value,
      0,
      0,
      width.value,
      height.value,
    )

  canvasRef.value.toBlob((blob) =>
    emits('pictureTaken', blob),
  )
}
onMounted(() => startVideo())
</script>

<template>
  <div id="camera">
    <video
      id="video"
      ref="videoRef"
      width="320"
      height="640"
      @canplay="setDimensions"
    ></video>

    <div class="camera-actions">
      <q-btn
        color="white"
        class="q-mr-md"
        text-color="black"
        @click="emits('close')"
        label="Cancelar"
      ></q-btn>
      <q-btn
        label="Capturar"
        color="primary"
        @click="takePicture"
        :icon="'camera'"
      >
      </q-btn>
    </div>
    <canvas v-show="false" ref="canvasRef"></canvas>
  </div>
</template>

<style scoped>
#camera {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  z-index: 30000;
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-flow: column nowrap;
  align-items: center;
  background: rgba(0, 0, 0, 0.7);
}
#video {
  margin-bottom: 10px;
}
.camera-actions {
  position: fixed;
  bottom: 50px;
}
</style>
