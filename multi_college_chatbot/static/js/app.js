// app.js
// ------
// Global small helpers (works for all pages).

(function () {
  // Auto-hide toasts after some seconds
  const toasts = document.querySelectorAll(".toast.app-toast");
  toasts.forEach((t) => {
    setTimeout(() => {
      try {
        const toast = bootstrap.Toast.getOrCreateInstance(t);
        toast.hide();
      } catch (e) {
        // ignore
      }
    }, 4500);
  });
})();

