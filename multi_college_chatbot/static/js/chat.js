// chat.js
// -------
// ChatGPT-like UI: send message -> /api/chat -> show reply.

const chatBody = document.getElementById("chatBody");
const chatForm = document.getElementById("chatForm");
const chatMessage = document.getElementById("chatMessage");
const typingIndicator = document.getElementById("typingIndicator");
const chipRow = document.getElementById("chipRow");

let speakEnabled = false;

function scrollToBottom() {
  chatBody.scrollTop = chatBody.scrollHeight;
}

function nowTime() {
  const d = new Date();
  return d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
}

function escapeHtml(s) {
  const div = document.createElement("div");
  div.innerText = s;
  return div.innerHTML;
}

function addMessage({ who, text, images }) {
  const row = document.createElement("div");
  row.className = `msg-row ${who}`;

  const bubble = document.createElement("div");
  bubble.className = "msg bubble glass";

  const name = who === "user" ? "You" : "Assistant";
  bubble.innerHTML = `
    <div class="msg-meta">
      <span class="name">${name}</span>
      <span class="dot"></span>
      <span class="time">${nowTime()}</span>
    </div>
    <div class="msg-text">${escapeHtml(text || "")}</div>
  `;

  // Render images (hostel feature)
  if (Array.isArray(images) && images.length) {
    const grid = document.createElement("div");
    grid.className = "img-grid";
    images.forEach((img) => {
      const card = document.createElement("div");
      card.className = "img-card";
      card.innerHTML = `
        <img src="${img.url}" alt="${escapeHtml(img.title || "Image")}">
        <div class="cap">${escapeHtml(img.title || "")}</div>
      `;
      grid.appendChild(card);
    });
    bubble.appendChild(grid);
  }

  row.appendChild(bubble);
  chatBody.appendChild(row);
  scrollToBottom();
}

function setTyping(isTyping) {
  if (!typingIndicator) return;
  typingIndicator.hidden = !isTyping;
  if (isTyping) scrollToBottom();
}

function updateSuggestions(suggestions) {
  if (!chipRow || !Array.isArray(suggestions) || !suggestions.length) return;
  chipRow.innerHTML = "";
  suggestions.slice(0, 6).forEach((s) => {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = "chip";
    btn.dataset.chip = s;
    btn.textContent = s;
    chipRow.appendChild(btn);
  });
}

async function sendMessage(text) {
  const url = window.CHAT_API_URL || "/api/chat";

  addMessage({ who: "user", text });
  setTyping(true);

  try {
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: text }),
    });
    const data = await res.json();
    if (!data.ok) throw new Error(data.error || "Failed");

    addMessage({ who: "bot", text: data.reply, images: data.type === "images" ? data.images : null });
    updateSuggestions(data.suggestions || []);

    // Voice-like UI feel (optional)
    if (speakEnabled && "speechSynthesis" in window) {
      const u = new SpeechSynthesisUtterance(data.reply || "");
      u.rate = 1;
      u.pitch = 1.05;
      window.speechSynthesis.cancel();
      window.speechSynthesis.speak(u);
    }
  } catch (err) {
    addMessage({ who: "bot", text: `Error: ${err.message}` });
  } finally {
    setTyping(false);
  }
}

// Auto-grow textarea
function autoGrow() {
  chatMessage.style.height = "auto";
  chatMessage.style.height = Math.min(chatMessage.scrollHeight, 160) + "px";
}

chatMessage?.addEventListener("input", autoGrow);

chatForm?.addEventListener("submit", (e) => {
  e.preventDefault();
  const text = (chatMessage.value || "").trim();
  if (!text) return;
  chatMessage.value = "";
  autoGrow();
  sendMessage(text);
});

// Press Enter to send, Shift+Enter for new line
chatMessage?.addEventListener("keydown", (e) => {
  if (e.key === "Enter" && !e.shiftKey) {
    e.preventDefault();
    chatForm.requestSubmit();
  }
});

// Click suggestion chips
document.addEventListener("click", (e) => {
  const chip = e.target.closest(".chip");
  if (!chip) return;
  const text = chip.dataset.chip || chip.textContent;
  if (!text) return;
  sendMessage(text);
});

// Speech synthesis toggle
document.getElementById("btnSpeak")?.addEventListener("click", () => {
  speakEnabled = !speakEnabled;
  const btn = document.getElementById("btnSpeak");
  btn.classList.toggle("btn-primary", speakEnabled);
  btn.classList.toggle("btn-outline-light", !speakEnabled);
});

// Initial scroll
scrollToBottom();

