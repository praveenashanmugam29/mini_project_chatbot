// enquiry.js
// ----------
// Opens the enquiry modal and submits it to /api/enquiry.

function showMiniToast(message, type = "info") {
  // Simple toast creation (uses the CSS from app.css)
  const stack = document.querySelector(".toast-stack");
  if (!stack) return alert(message);

  const el = document.createElement("div");
  el.className = `toast show app-toast toast-${type}`;
  el.setAttribute("role", "alert");
  el.innerHTML = `
    <div class="d-flex">
      <div class="toast-body">${message}</div>
      <button type="button" class="btn-close me-2 m-auto" aria-label="Close"></button>
    </div>
  `;
  el.querySelector(".btn-close").addEventListener("click", () => el.remove());
  stack.appendChild(el);
  setTimeout(() => el.remove(), 4200);
}

function openEnquiryModal() {
  const modalEl = document.getElementById("enquiryModal");
  if (!modalEl) return;
  const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
  modal.show();
}

document.addEventListener("click", (e) => {
  const trigger = e.target.closest("[data-open-enquiry]");
  if (trigger) openEnquiryModal();
});

document.addEventListener("DOMContentLoaded", () => {
  const btn = document.getElementById("btnSubmitEnquiry");
  if (!btn) return;

  btn.addEventListener("click", async () => {
    const name = (document.getElementById("enqName")?.value || "").trim();
    const email = (document.getElementById("enqEmail")?.value || "").trim();
    const phone = (document.getElementById("enqPhone")?.value || "").trim();
    const message = (document.getElementById("enqMessage")?.value || "").trim();

    if (!name || !message) {
      showMiniToast("Please enter your name and message.", "warning");
      return;
    }

    const url = window.ENQUIRY_API_URL || "/api/enquiry";
    btn.disabled = true;
    btn.innerHTML = `Submitting <i class="fa-solid fa-spinner fa-spin ms-2"></i>`;

    try {
      const res = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name, email, phone, message }),
      });
      const data = await res.json();
      if (!data.ok) throw new Error(data.error || "Failed");

      showMiniToast("Enquiry submitted successfully!", "success");
      document.getElementById("enqMessage").value = "";
      const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById("enquiryModal"));
      modal.hide();
    } catch (err) {
      showMiniToast(`Enquiry failed: ${err.message}`, "danger");
    } finally {
      btn.disabled = false;
      btn.innerHTML = `Submit <i class="fa-solid fa-arrow-right ms-2"></i>`;
    }
  });
});

