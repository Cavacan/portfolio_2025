import { schedulePresets } from "./presets/schedule_presets";

console.log("preset.js loaded");
console.log("schedulePresets is:", schedulePresets);

document.addEventListener("DOMContentLoaded", () => {
  const select = document.getElementById('presetSelect');
  
  const defaultOption = document.createElement("option");
  defaultOption.value = "";
  defaultOption.textContent = "-- 選択して下さい --";
  select.appendChild(defaultOption);

  for (const key in schedulePresets) {
    const option = document.createElement("option");
    option.value = key;
    option.textContent = schedulePresets[key].name;
    select.appendChild(option);
  }

  const titleField = document.getElementById('schedule_title');
  const periodField = document.getElementById('schedule_period');
  const priceField = document.getElementById('schedule_price');
  const nextNotificationField = document.getElementById('schedule_next_notification');

  select.addEventListener('change', (e) => {
    const preset = schedulePresets[e.target.value];
    if (preset) {
      titleField.value = preset.title;
      periodField.value = preset.period;
      priceField.value = preset.price;

      const nextDate = new Date();
      nextDate.setDate(nextDate.getDate() + preset.period);
      const year = nextDate.getFullYear();
      const month = String(nextDate.getMonth() + 1).padStart(2, "0");
      const day = String(nextDate.getDate()).padStart(2, "0");
      
      nextNotificationField.value = `${year}-${month}-${day}T00:00`;
    }
  });
});