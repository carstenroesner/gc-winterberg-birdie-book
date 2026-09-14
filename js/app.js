/* GCWBB – App-Logik (Vanilla JS, keine Abhängigkeiten).
   Persistenz: localStorage (siehe Pflichtenheft Punkt 9 – Start lokal, iCloud-Sync ist Backlog). */

const LS_CLUBS = "gcwbb_clubs";
const LS_ROUNDS = "gcwbb_rounds";
const LS_CURRENT = "gcwbb_current_round";
const LS_LANG = "gcwbb_lang";

let state = {
  activeHole: 1,        // 1..9 (Bahn-Nummer, unabhängig von vorne/hinten)
  isBack: false,         // false = vordere Neun (1-9), true = hintere Neun (10-18)
  scoreNine: "front",    // Anzeige auf der Scorecard: "front" | "back"
  currentRoundId: null,
  editingClubId: null    // null = neuer Schläger im Modal
};

/* ---------- Persistenz ---------- */
function getClubs(){
  try{
    const raw = localStorage.getItem(LS_CLUBS);
    if (raw) return JSON.parse(raw);
  }catch(e){}
  return JSON.parse(JSON.stringify(DEFAULT_CLUBS));
}
function saveClubs(clubs){
  try{ localStorage.setItem(LS_CLUBS, JSON.stringify(clubs)); }catch(e){}
}
function getRounds(){
  try{
    const raw = localStorage.getItem(LS_ROUNDS);
    if (raw) return JSON.parse(raw);
  }catch(e){}
  return [];
}
function saveRounds(rounds){
  try{ localStorage.setItem(LS_ROUNDS, JSON.stringify(rounds)); }catch(e){}
}
function getCurrentRound(){
  const rounds = getRounds();
  return rounds.find(r => r.id === state.currentRoundId) || null;
}
function updateCurrentRound(mutator){
  const rounds = getRounds();
  const idx = rounds.findIndex(r => r.id === state.currentRoundId);
  if (idx === -1) return;
  mutator(rounds[idx]);
  saveRounds(rounds);
}

/* ---------- Navigation ---------- */
function showScreen(id){
  document.querySelectorAll(".screen").forEach(s => s.classList.remove("active"));
  const el = document.getElementById(id);
  if (el) el.classList.add("active");
  document.querySelectorAll(".nav-item").forEach(n => n.classList.toggle("active", n.dataset.nav === id));
  window.scrollTo(0,0);
}

document.querySelectorAll("[data-nav]").forEach(el => {
  el.addEventListener("click", () => showScreen(el.dataset.nav));
});
document.querySelectorAll("[data-back]").forEach(el => {
  el.addEventListener("click", () => showScreen(el.dataset.back));
});

/* ---------- Start: Neue Runde / Bestehende Runden ---------- */
function createNewRound(){
  const rounds = getRounds();
  const id = "r" + Date.now();
  const round = {
    id,
    date: new Date().toISOString().slice(0,10),
    scores: {} // Schlüssel: "front-3" oder "back-7" -> Zahl
  };
  rounds.unshift(round);
  saveRounds(rounds);
  state.currentRoundId = id;
  localStorage.setItem(LS_CURRENT, id);
  state.activeHole = 1; state.isBack = false; state.scoreNine = "front";
  renderMain();
  showScreen("screen-main");
}
document.getElementById("btn-new-round").addEventListener("click", createNewRound);
document.getElementById("btn-new-round-2").addEventListener("click", createNewRound);

document.getElementById("btn-existing-rounds").addEventListener("click", () => {
  renderRoundsList();
  showScreen("screen-rounds");
});

function fmtDate(iso){
  const d = new Date(iso + "T00:00:00");
  return d.toLocaleDateString(localStorage.getItem(LS_LANG) === "en" ? "en-GB" : (localStorage.getItem(LS_LANG) === "nl" ? "nl-NL" : "de-DE"));
}

function renderRoundsList(){
  const rounds = getRounds();
  const list = document.getElementById("rounds-list");
  list.innerHTML = "";
  if (!rounds.length){
    const div = document.createElement("div");
    div.className = "empty-state";
    div.innerHTML = `<div>${t("roundsEmpty")}</div>`;
    const btn = document.createElement("button");
    btn.className = "btn btn-primary";
    btn.style.marginTop = "16px";
    btn.textContent = t("startNewInstead");
    btn.addEventListener("click", createNewRound);
    div.appendChild(btn);
    list.appendChild(div);
    return;
  }
  rounds.forEach(r => {
    const scored = Object.keys(r.scores || {}).length;
    const item = document.createElement("button");
    item.className = "list-item round-item";
    item.innerHTML = `
      <div class="ico"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--green)" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2.5"/><line x1="4" y1="10" x2="20" y2="10"/></svg></div>
      <div class="body"><div class="name">${fmtDate(r.date)}</div><div class="meta">${scored} / 18 ${t("score")}</div></div>
      <svg class="chev" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg>
    `;
    item.addEventListener("click", () => {
      state.currentRoundId = r.id;
      localStorage.setItem(LS_CURRENT, r.id);
      state.activeHole = 1; state.isBack = false; state.scoreNine = "front";
      renderMain();
      showScreen("screen-main");
    });
    list.appendChild(item);
  });
}

/* ---------- Hauptbildschirm / Lochansicht ---------- */
function holeSketchSVG(){
  // Generischer Platzhalter-Stil (siehe Pflichtenheft 3.2 / offener Punkt 7) – identisch für alle Bahnen,
  // bis echte Lochformen aus den Referenzfotos/-grafiken (4a) erstellt sind.
  return `
  <svg width="150" height="190" viewBox="0 0 180 230">
    <g fill="var(--rough)" opacity="0.85">
      <circle cx="44" cy="30" r="7"/><circle cx="36" cy="55" r="5"/><circle cx="32" cy="85" r="7"/><circle cx="34" cy="115" r="6"/><circle cx="40" cy="145" r="6"/><circle cx="36" cy="170" r="5"/><circle cx="40" cy="195" r="6"/>
      <circle cx="130" cy="30" r="6"/><circle cx="138" cy="55" r="5"/><circle cx="142" cy="85" r="6"/><circle cx="140" cy="115" r="7"/><circle cx="134" cy="145" r="7"/><circle cx="138" cy="170" r="5"/><circle cx="132" cy="195" r="5"/>
      <circle cx="100" cy="10" r="6"/><circle cx="70" cy="10" r="6"/>
    </g>
    <path d="M100 18 C 118 40, 122 70, 108 100 C 96 128, 70 150, 74 182 C 76 200, 90 212, 92 222 L 60 222 C 56 200, 44 190, 46 168 C 50 132, 78 112, 86 84 C 92 60, 72 40, 66 20 Z" fill="var(--fairway)" stroke="oklch(70% 0.06 150)" stroke-width="1.5"/>
    <ellipse cx="52" cy="150" rx="14" ry="8" fill="var(--sand)" stroke="oklch(70% 0.06 85)" stroke-width="1"/>
    <circle cx="94" cy="26" r="4" fill="var(--yellow)" stroke="oklch(55% 0.1 90)" stroke-width="1"/>
    <circle cx="106" cy="30" r="4" fill="var(--red)"/>
    <ellipse cx="76" cy="212" rx="24" ry="16" fill="oklch(80% 0.09 150)" stroke="oklch(60% 0.08 150)" stroke-width="1.5"/>
    <line x1="70" y1="212" x2="70" y2="190" stroke="var(--ink)" stroke-width="1.5"/>
    <path d="M70 190 L84 195 L70 200 Z" fill="var(--red)"/>
  </svg>`;
}

function renderHoleColumns(){
  const front = document.getElementById("col-front");
  const back = document.getElementById("col-back");
  front.innerHTML = ""; back.innerHTML = "";
  for (let n = 1; n <= 9; n++){
    const b = document.createElement("button");
    b.className = "hole-btn" + ((!state.isBack && state.activeHole === n) ? " active" : "");
    b.textContent = n;
    b.addEventListener("click", () => { state.activeHole = n; state.isBack = false; renderMain(); });
    front.appendChild(b);
  }
  for (let n = 1; n <= 9; n++){
    const b = document.createElement("button");
    b.className = "hole-btn" + ((state.isBack && state.activeHole === n) ? " active" : "");
    b.textContent = n + 9;
    b.addEventListener("click", () => { state.activeHole = n; state.isBack = true; renderMain(); });
    back.appendChild(b);
  }
}

function renderMain(){
  renderHoleColumns();
  const hole = HOLES[state.activeHole - 1];
  const side = state.isBack ? "back" : "front";
  const displayNum = state.isBack ? state.activeHole + 9 : state.activeHole;

  document.getElementById("hole-num").textContent = displayNum;
  document.getElementById("hole-desc").textContent = hole.text;

  const sc = hole.scorecard;
  document.getElementById("hole-par").textContent = sc ? sc.par : "–";
  document.getElementById("hole-hcp").textContent = sc ? sc.hcp[side] : "–";
  document.getElementById("tee-herren").textContent = sc ? sc.herren[side] + " m" : "–";
  document.getElementById("tee-damen").textContent = sc ? sc.damen[side] + " m" : "–";
  document.getElementById("hole-sketch").innerHTML = holeSketchSVG();

  const round = getCurrentRound();
  const ctx = document.getElementById("main-context");
  if (round){
    ctx.textContent = t("newRound") === "Neue Runde" ? fmtDate(round.date) : fmtDate(round.date);
  } else {
    ctx.textContent = "–";
  }
}

/* ---------- Schläger ---------- */
function fmtDistance(c){
  if (c.min == null || c.max == null) return t("noDistance");
  return `${c.min}–${c.max} m`;
}

function renderClubs(){
  const list = document.getElementById("clubs-list");
  list.innerHTML = "";
  const clubs = getClubs();
  clubs.forEach(c => {
    const item = document.createElement("button");
    item.className = "list-item";
    item.innerHTML = `
      <div class="ico"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--green)" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="19" x2="18" y2="6"/><path d="M13 6l5 5"/><circle cx="6.2" cy="19.5" r="1.6" fill="var(--green)" stroke="none"/></svg></div>
      <div class="body"><div class="name">${escapeHtml(c.name)}</div><div class="meta">${c.category} &middot; ${fmtDistance(c)}</div></div>
      <svg class="chev" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg>
    `;
    item.addEventListener("click", () => openClubModal(c.id));
    list.appendChild(item);
  });
  const addBtn = document.createElement("button");
  addBtn.className = "add-btn";
  addBtn.innerHTML = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg><span>${t("addClub")}</span>`;
  addBtn.addEventListener("click", () => openClubModal(null));
  list.appendChild(addBtn);
}

function escapeHtml(s){
  return String(s).replace(/[&<>"']/g, m => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[m]));
}

function openClubModal(clubId){
  state.editingClubId = clubId;
  const modal = document.getElementById("club-modal");
  const nameInput = document.getElementById("field-name");
  const minInput = document.getElementById("field-min");
  const maxInput = document.getElementById("field-max");
  const delBtn = document.getElementById("btn-delete-club");
  const titleEl = document.getElementById("modal-title");

  if (clubId){
    const c = getClubs().find(x => x.id === clubId);
    titleEl.textContent = t("editClub");
    nameInput.value = c.name;
    minInput.value = c.min ?? "";
    maxInput.value = c.max ?? "";
    delBtn.style.display = "block";
  } else {
    titleEl.textContent = t("newClub");
    nameInput.value = "";
    minInput.value = "";
    maxInput.value = "";
    delBtn.style.display = "none";
  }
  modal.classList.add("open");
}
function closeClubModal(){
  document.getElementById("club-modal").classList.remove("open");
}
document.getElementById("btn-cancel-club").addEventListener("click", closeClubModal);
document.getElementById("club-modal").addEventListener("click", (e) => {
  if (e.target.id === "club-modal") closeClubModal();
});
document.getElementById("btn-save-club").addEventListener("click", () => {
  const name = document.getElementById("field-name").value.trim();
  if (!name) return;
  const minV = document.getElementById("field-min").value;
  const maxV = document.getElementById("field-max").value;
  const min = minV === "" ? null : parseInt(minV, 10);
  const max = maxV === "" ? null : parseInt(maxV, 10);

  let clubs = getClubs();
  if (state.editingClubId){
    clubs = clubs.map(c => c.id === state.editingClubId ? { ...c, name, min, max } : c);
  } else {
    clubs.push({ id: "c" + Date.now(), name, category: "Eigener Schläger", min, max });
  }
  saveClubs(clubs);
  closeClubModal();
  renderClubs();
});
document.getElementById("btn-delete-club").addEventListener("click", () => {
  if (!state.editingClubId) return;
  const clubs = getClubs().filter(c => c.id !== state.editingClubId);
  saveClubs(clubs);
  closeClubModal();
  renderClubs();
});

/* ---------- Scorecard ---------- */
document.getElementById("btn-front-nine").addEventListener("click", () => { state.scoreNine = "front"; renderScorecard(); });
document.getElementById("btn-back-nine").addEventListener("click", () => { state.scoreNine = "back"; renderScorecard(); });

function renderScorecard(){
  document.getElementById("btn-front-nine").classList.toggle("active", state.scoreNine === "front");
  document.getElementById("btn-back-nine").classList.toggle("active", state.scoreNine === "back");

  const round = getCurrentRound();
  document.getElementById("scorecard-date").textContent = round ? fmtDate(round.date) : "–";

  const rowsEl = document.getElementById("scorecard-rows");
  rowsEl.innerHTML = "";
  const side = state.scoreNine;

  HOLES.forEach(hole => {
    const displayNum = side === "back" ? hole.n + 9 : hole.n;
    const sc = hole.scorecard;
    const scoreKey = `${side}-${hole.n}`;
    const savedScore = round && round.scores ? round.scores[scoreKey] : "";

    const row = document.createElement("div");
    row.className = "card-row";
    row.innerHTML = `
      <div class="cell" style="font-weight:700;">${displayNum}</div>
      <div class="cell" style="color:${sc ? 'var(--ink)' : 'var(--ink-faint)'};">${sc ? sc.par : "–"}</div>
      <div class="cell" style="color:${sc ? 'var(--ink)' : 'var(--ink-faint)'};">${sc ? sc.hcp[side] : "–"}</div>
      <div class="cell" style="color:${sc ? 'var(--ink)' : 'var(--ink-faint)'};">${sc ? sc.herren[side] : "–"}</div>
      <div class="cell" style="color:${sc ? 'var(--ink)' : 'var(--ink-faint)'};">${sc ? sc.damen[side] : "–"}</div>
      <div class="cell"><input type="number" inputmode="numeric" min="1" max="15" class="score-input" data-key="${scoreKey}" value="${savedScore || ""}" placeholder="&ndash;"></div>
    `;
    rowsEl.appendChild(row);
  });

  rowsEl.querySelectorAll(".score-input").forEach(input => {
    input.addEventListener("change", () => {
      if (!round) return;
      const val = input.value === "" ? null : parseInt(input.value, 10);
      updateCurrentRound(r => {
        r.scores = r.scores || {};
        if (val == null) delete r.scores[input.dataset.key];
        else r.scores[input.dataset.key] = val;
      });
    });
  });
}

/* ---------- Sonstiges: Über / Kontakt / Sprache ---------- */
function renderAboutContact(){
  document.getElementById("about-text").textContent = t("aboutText");
  const c = COURSE_INFO;
  document.getElementById("contact-text").textContent = t("contactText")
    .replace("{address}", c.address).replace("{phone}", c.phone).replace("{email}", c.email).replace("{web}", c.web);
}

function renderLangRow(){
  const row = document.getElementById("lang-row");
  row.innerHTML = "";
  const current = localStorage.getItem(LS_LANG) || "de";
  ["de","en","nl"].forEach(code => {
    const b = document.createElement("button");
    b.className = "lang-btn" + (code === current ? " active" : "");
    b.innerHTML = `<span class="flag">${I18N[code].flag}</span><span>${I18N[code].label}</span>`;
    b.addEventListener("click", () => {
      localStorage.setItem(LS_LANG, code);
      applyI18n();
    });
    row.appendChild(b);
  });
}

/* ---------- i18n anwenden ---------- */
function applyI18n(){
  document.documentElement.lang = localStorage.getItem(LS_LANG) || "de";
  document.querySelectorAll("[data-i18n]").forEach(el => {
    el.textContent = t(el.dataset.i18n);
  });
  renderLangRow();
  renderMain();
  renderClubs();
  renderScorecard();
  renderAboutContact();
  renderRoundsList();
}

/* ---------- Start ---------- */
(function init(){
  const savedId = localStorage.getItem(LS_CURRENT);
  if (savedId && getRounds().some(r => r.id === savedId)) state.currentRoundId = savedId;
  renderLangRow();
  renderMain();
  renderClubs();
  renderScorecard();
  renderAboutContact();

  if ("serviceWorker" in navigator){
    window.addEventListener("load", () => {
      navigator.serviceWorker.register("service-worker.js").catch(() => {});
    });
  }
})();
