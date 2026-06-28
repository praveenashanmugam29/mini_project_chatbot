// login.js
// --------
// Show/hide password for all password inputs on login page.

document.addEventListener("click", (e) => {
  const btn = e.target.closest(".toggle-pass");
  if (!btn) return;

  const group = btn.closest(".input-group");
  if (!group) return;

  const input = group.querySelector(".password-input");
  if (!input) return;

  const icon = btn.querySelector("i");
  if (input.type === "password") {
    input.type = "text";
    if (icon) icon.className = "fa-regular fa-eye-slash";
  } else {
    input.type = "password";
    if (icon) icon.className = "fa-regular fa-eye";
  }
});

