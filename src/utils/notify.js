import { Notify } from "quasar";

const notify = {
  positive(caption) {
    Notify.create({
      icon: "check_circle",
      iconColor: "positive",
      position: "bottom",
      timeout: 3000,
      caption,
    });
  },

  negative(caption) {
    Notify.create({
      icon: "warning",
      iconColor: "negative",
      position: "bottom",
      timeout: 3000,
      caption,
    });
  },

  info(caption) {
    Notify.create({
      icon: "info",
      iconColor: "positive",
      position: "bottom",
      timeout: 3000,
      caption,
    });
  },

  warning(caption) {
    Notify.create({
      color: "warning",
      icon: "priority_high",
      position: "bottom",
      timeout: 3000,
      caption,
    });
  },
};

export default notify;
