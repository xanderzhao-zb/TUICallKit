<script setup lang="ts">
import Dialing from "./Dialing.vue";
import ControlPanel from "./ControlPanel.vue";
import CallingGroup from "./Calling-Group.vue";
import CallingC2CVideo from "./Calling-C2CVideo.vue";
import { status, isMinimized, currentDisplayMode, currentVideoResolution, componentEmits } from "../store";
import { STATUS } from "../constants";
import { TUICallKitServer } from "../index";
import MinimizeSVG from "../icons/minimize.vue";
import fullScreenSVG from "../icons/fullScreen.vue";
import { VideoDisplayMode, VideoResolution } from "../interface";
import { withDefaults, defineProps, toRefs, watchEffect, defineEmits } from "vue";

const emits = defineEmits<{
  (e: "kicked-out", value: any): void;
  (e: "status-changed", value: { oldStatus: string, newStatus: string }): void;
}>();

componentEmits.value = emits;

const props = withDefaults(
  defineProps<{
    beforeCalling?: (...args: any[]) => void;
    afterCalling?: (...args: any[]) => void;
    onMinimized?: (...args: any[]) => void;
    onMessageSentByMe?: (...args: any[]) => void;
    allowedMinimized?: boolean;
    allowedFullScreen?: boolean;
    videoDisplayMode?: VideoDisplayMode;
    videoResolution?: VideoResolution;
    lang?: string;
  }>(),
  {
    allowedMinimized: false,
    allowedFullScreen: true,
    videoDisplayMode: VideoDisplayMode.COVER,
    videoResolution: VideoResolution.RESOLUTION_480P,
    lang: "zh-cn"
  }
);

const { beforeCalling, afterCalling, onMinimized, onMessageSentByMe, allowedMinimized, allowedFullScreen, videoDisplayMode, videoResolution } =
toRefs(props);

watchEffect(() => {
  TUICallKitServer.setCallback({
    beforeCalling: beforeCalling && beforeCalling.value,
    afterCalling: afterCalling && afterCalling.value,
    onMinimized: onMinimized && onMinimized.value,
    onMessageSentByMe: onMessageSentByMe && onMessageSentByMe.value,
  });
  currentDisplayMode.value = videoDisplayMode.value;
  currentVideoResolution.value = videoResolution.value;
});

function toggleMinimize() {
  if (document.fullscreenElement) {
    document.exitFullscreen();
  }
  TUICallKitServer.toggleMinimize();
}

function toggleFullscreen() {
  let elem = document.getElementById("tui-call-kit-id") as HTMLElement;
  if (!document.fullscreenElement) {
    elem.requestFullscreen().catch((err) => {
      alert(`Error attempting to enable fullscreen mode: ${err.message} (${err.name})`);
    });
  } else {
    document.exitFullscreen();
  }
}
</script>

<template>
  <div class="tui-call-kit" id="tui-call-kit-id" v-if="status !== STATUS.IDLE" v-show="!isMinimized">
    <div class="function-buttons">
      <div
        class="minimize"
        @click="toggleMinimize"
        v-if="
          status !== STATUS.IDLE &&
          allowedMinimized === true &&
          status !== STATUS.DIALING_C2C &&
          status !== STATUS.DIALING_GROUP &&
          status !== STATUS.BE_INVITED
        "
      >
        <MinimizeSVG />
      </div>
      <div
        class="minimize"
        @click="toggleFullscreen"
        v-if="allowedFullScreen === true"
      >
        <fullScreenSVG />
      </div>
    </div>
    <Dialing
      v-if="
        status === STATUS.BE_INVITED ||
        status === STATUS.DIALING_C2C ||
        status === STATUS.CALLING_C2C_AUDIO
      "
    />
    <CallingC2CVideo v-if="status === STATUS.CALLING_C2C_VIDEO" />
    <CallingGroup
      v-if="
        status === STATUS.DIALING_GROUP ||
        status === STATUS.CALLING_GROUP_AUDIO ||
        status === STATUS.CALLING_GROUP_VIDEO
      "
    />
    <ControlPanel v-if="status !== STATUS.IDLE" />
  </div>
</template>

<style scoped>
@import "../style.css";
</style>