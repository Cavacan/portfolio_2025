document.addEventListener('turbo:load', () => {
  const buttons = document.querySelectorAll(".show-loading");
  const loading = document.getElementById("loading");
  buttons.forEach(button => {
    button.addEventListener('click', () => {
      loading.classList.remove("d-none");
    });
  });
});