/* GCWBB – App-Logik (Vanilla JS, keine Abhängigkeiten).
   Persistenz: localStorage (siehe Pflichtenheft Punkt 9 – Start lokal, iCloud-Sync ist Backlog). */

const LS_CLUBS = "gcwbb_clubs";
const LS_ROUNDS = "gcwbb_rounds";
const LS_CURRENT = "gcwbb_current_round";
const LS_LANG = "gcwbb_lang";

const GITHUB_OWNER = "carstenroesner";
const GITHUB_REPO = "gc-winterberg-birdie-book";

let state = {
  activePage: 0,         // 0 = Einstellungen, 1..holeCount = Löcher, holeCount+1 = Scorecard
  currentRoundId: null,
  selectedClubId: null,  // im Anzeige-Modus ausgewählter Schläger (nur visuell)
  clubsEditMode: false,  // true = gesamte Schläger-Liste wird bearbeitet
  editBuffer: null,      // Arbeitskopie der Schläger während des Bearbeitens
  reportType: "bug"      // "bug" | "idea" – aktuell gewählter Typ im Problem-melden-Dialog
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
function holeCountFor(round){
  return (round && round.holeCount) || 18;
}

/* ---------- Navigation (Screens) ---------- */
function showScreen(id){
  document.querySelectorAll(".screen").forEach(s => s.classList.remove("active"));
  const el = document.getElementById(id);
  if (el) el.classList.add("active");
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
    holeCount: 18, // Default; auf der neuen Rundeneinstellungen-Seite umschaltbar (Pflichtenheft 10.2)
    scores: {} // Schlüssel: "front-3" oder "back-7" -> Zahl
  };
  rounds.unshift(round);
  saveRounds(rounds);
  state.currentRoundId = id;
  localStorage.setItem(LS_CURRENT, id);
  state.activePage = 0; // Rundeneinstellungen zuerst (Pflichtenheft 10.1)
  renderPager();
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
    const hc = holeCountFor(r);
    const item = document.createElement("button");
    item.className = "list-item round-item";
    item.innerHTML = `
      <div class="ico"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--green)" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2.5"/><line x1="4" y1="10" x2="20" y2="10"/></svg></div>
      <div class="body"><div class="name">${fmtDate(r.date)}</div><div class="meta">${scored} / ${hc} ${t("score")} &middot; ${hc === 9 ? t("nineHoleRound") : t("eighteenHoleRound")}</div></div>
      <svg class="chev" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg>
    `;
    item.addEventListener("click", () => {
      state.currentRoundId = r.id;
      localStorage.setItem(LS_CURRENT, r.id);
      state.activePage = 0;
      renderPager();
      showScreen("screen-main");
    });
    list.appendChild(item);
  });
}

/* ---------- Loch-Skizzen: 9 individuelle, handgezeichnet wirkende Motive
   (siehe Pflichtenheft 10.5 – Referenzskizze des Nutzers, 15.09.2026).
   Vordere und hintere Neun teilen sich dieselben 9 Bahn-Formen (Pflichtenheft 3.2). */
const HOLE_SKETCH_DEFS = {
  1: { fairway:"M96 20 C 122 44, 118 78, 96 104 C 78 126, 58 140, 62 172 C 64 192, 78 206, 82 220 L 56 220 C 50 200, 40 188, 44 164 C 50 128, 76 112, 88 84 C 96 62, 78 40, 68 22 Z",
       water:{cx:132, cy:96, rx:26, ry:34}, bunkers:[], green:{cx:70,cy:210,rx:22,ry:15}, flag:{x:64,y:190} },
  2: { fairway:"M90 18 C 128 30, 130 60, 100 76 C 66 94, 56 116, 92 130 C 124 142, 128 168, 96 188 C 80 198, 78 210, 84 222 L 54 222 C 48 206, 52 194, 66 182 C 92 160, 86 140, 58 126 C 30 112, 30 84, 64 66 C 90 52, 86 34, 66 22 Z",
       water:{cx:46, cy:36, rx:18, ry:14}, bunkers:[{cx:118,cy:98,rx:14,ry:9}], green:{cx:86,cy:212,rx:18,ry:13}, flag:{x:80,y:195} },
  3: { fairway:"M92 60 C 112 76, 112 100, 92 118 C 76 132, 74 150, 88 168 L 62 168 C 50 150, 52 132, 68 118 C 84 104, 84 82, 66 68 Z",
       water:null, bunkers:[{cx:118,cy:140,rx:11,ry:8}], green:{cx:78,cy:158,rx:22,ry:15}, flag:{x:72,y:140} },
  4: { fairway:"M84 18 C 108 40, 114 66, 100 92 C 88 114, 86 132, 96 150 L 66 150 C 58 132, 60 114, 72 94 C 84 74, 78 46, 58 26 Z",
       water:{cx:80, cy:172, rx:38, ry:16}, bunkers:[], green:{cx:80,cy:208,rx:20,ry:13}, flag:{x:74,y:190} },
  5: { fairway:"M92 20 C 100 60, 96 100, 90 140 C 86 168, 84 196, 90 222 L 60 222 C 56 196, 58 168, 64 140 C 70 100, 72 60, 64 22 Z",
       water:null, bunkers:[{cx:126,cy:132,rx:18,ry:12}], green:{cx:76,cy:210,rx:20,ry:14}, flag:{x:70,y:192} },
  6: { fairway:"M90 16 C 96 56, 92 96, 90 136 C 88 168, 90 196, 96 222 L 58 222 C 54 196, 56 168, 58 136 C 60 96, 62 56, 58 18 Z",
       water:{cx:74, cy:34, rx:22, ry:12}, bunkers:[{cx:44,cy:196,rx:14,ry:9},{cx:112,cy:200,rx:14,ry:9}], green:{cx:78,cy:210,rx:20,ry:13}, flag:{x:72,y:192} },
  7: { fairway:"M96 18 C 70 40, 66 66, 88 84 C 110 100, 108 122, 82 138 C 60 150, 56 172, 74 192 L 100 192 C 108 174, 100 158, 82 146 C 64 134, 66 116, 90 100 C 112 84, 114 58, 94 36 Z",
       water:{cx:88, cy:118, rx:34, ry:9}, bunkers:[{cx:66,cy:176,rx:12,ry:8},{cx:104,cy:180,rx:12,ry:8}], green:{cx:86,cy:186,rx:20,ry:13}, flag:{x:80,y:168} },
  8: { fairway:"M90 20 C 94 60, 90 100, 92 140 C 94 168, 92 196, 90 220 L 60 220 C 58 196, 60 168, 58 140 C 56 100, 60 60, 56 22 Z",
       water:null, bunkers:[{cx:36,cy:196,rx:14,ry:10},{cx:120,cy:196,rx:14,ry:10}], green:{cx:76,cy:206,rx:22,ry:13}, flag:{x:70,y:188} },
  9: { fairway:"M92 22 C 100 50, 98 78, 88 102 C 80 122, 80 144, 92 162 L 64 162 C 54 144, 54 122, 62 102 C 70 78, 68 50, 60 24 Z",
       water:null, bunkers:[{cx:42,cy:148,rx:11,ry:8}], green:{cx:78,cy:154,rx:20,ry:13}, flag:{x:72,y:136} }
};

/* Erweiterte Lochskizzen (Designmuster Loch 2, auf alle 9 Löcher übertragen, 15.09.2026):
   gleiche, individuell abgestimmte Fairway-/Wasser-/Bunker-/Grün-Geometrie je Loch (HOLE_SKETCH_DEFS,
   unverändert), aber mit reicherer Zeichentechnik: Wasser mit Verlauf + Wellenlinien, Bunker mit
   Sand-Textur + Schattenkante, Mähstreifen-Effekt im Fairway (per Clip-Path), Grün mit Fransensaum,
   sowie zwei kleine Tee-Markierungen am Abschlag. */
function holeSketchSVG(n){
  const def = HOLE_SKETCH_DEFS[n] || HOLE_SKETCH_DEFS[1];
  const teeMatch = /^M\s*([\d.]+)[\s,]+([\d.]+)/.exec(def.fairway.trim());
  const tee = teeMatch ? { x: parseFloat(teeMatch[1]), y: parseFloat(teeMatch[2]) } : { x: 90, y: 18 };

  const waterBody = def.water ? `
    <ellipse cx="${def.water.cx}" cy="${def.water.cy}" rx="${def.water.rx}" ry="${def.water.ry}" fill="url(#sk-water-${n})" stroke="oklch(58% 0.1 235)" stroke-width="1"/>
    <g stroke="oklch(90% 0.03 220)" stroke-width="1" opacity="0.6" fill="none" stroke-linecap="round">
      <path d="M ${def.water.cx - def.water.rx*0.55} ${def.water.cy - def.water.ry*0.15} C ${def.water.cx - def.water.rx*0.2} ${def.water.cy - def.water.ry*0.4}, ${def.water.cx + def.water.rx*0.15} ${def.water.cy - def.water.ry*0.4}, ${def.water.cx + def.water.rx*0.5} ${def.water.cy - def.water.ry*0.1}"/>
      <path d="M ${def.water.cx - def.water.rx*0.4} ${def.water.cy + def.water.ry*0.2} C ${def.water.cx - def.water.rx*0.1} ${def.water.cy}, ${def.water.cx + def.water.rx*0.25} ${def.water.cy}, ${def.water.cx + def.water.rx*0.55} ${def.water.cy + def.water.ry*0.25}"/>
    </g>` : "";

  const bunkerEls = def.bunkers.map(b => {
    const dots = [[-0.5,0.1],[-0.15,-0.4],[0.25,0.3],[0.5,-0.15],[0.05,0.45]]
      .map(([ox,oy]) => `<circle cx="${(b.cx + ox*b.rx).toFixed(1)}" cy="${(b.cy + oy*b.ry).toFixed(1)}" r="0.9"/>`).join("");
    return `
    <g>
      <ellipse cx="${b.cx}" cy="${b.cy}" rx="${b.rx}" ry="${b.ry}" fill="var(--sand)" stroke="oklch(66% 0.06 85)" stroke-width="1"/>
      <path d="M ${(b.cx - b.rx*0.6).toFixed(1)} ${(b.cy - b.ry*0.3).toFixed(1)} A ${(b.rx*0.8).toFixed(1)} ${(b.ry*0.6).toFixed(1)} 0 0 1 ${(b.cx + b.rx*0.6).toFixed(1)} ${(b.cy - b.ry*0.2).toFixed(1)}" fill="none" stroke="oklch(70% 0.06 85)" stroke-width="1" opacity="0.6"/>
      <g fill="oklch(66% 0.06 85)" opacity="0.55">${dots}</g>
    </g>`;
  }).join("");

  const stripes = [];
  for (let y = -60; y < 280; y += 42) stripes.push(`<line x1="-20" y1="${y}" x2="200" y2="${y - 60}" stroke="var(--rough)" stroke-width="15" opacity="0.1"/>`);

  return `
  <svg width="150" height="190" viewBox="0 0 180 230">
    <defs>
      <clipPath id="sk-clip-${n}"><path d="${def.fairway}"/></clipPath>
      ${def.water ? `<radialGradient id="sk-water-${n}" cx="40%" cy="30%" r="80%">
        <stop offset="0%" stop-color="oklch(78% 0.08 220)"/>
        <stop offset="100%" stop-color="var(--water)"/>
      </radialGradient>` : ""}
    </defs>
    <g fill="var(--rough)" opacity="0.85">
      <circle cx="44" cy="30" r="7"/><circle cx="38" cy="26" r="4.5"/><circle cx="36" cy="55" r="5"/><circle cx="32" cy="85" r="7"/><circle cx="26" cy="81" r="4"/><circle cx="34" cy="115" r="6"/><circle cx="40" cy="145" r="6"/><circle cx="36" cy="170" r="5"/><circle cx="40" cy="195" r="6"/><circle cx="34" cy="199" r="4"/>
      <circle cx="130" cy="30" r="6"/><circle cx="138" cy="55" r="5"/><circle cx="144" cy="51" r="4"/><circle cx="142" cy="85" r="6"/><circle cx="140" cy="115" r="7"/><circle cx="146" cy="111" r="4.2"/><circle cx="134" cy="145" r="7"/><circle cx="138" cy="170" r="5"/><circle cx="132" cy="195" r="5"/>
      <circle cx="100" cy="10" r="6"/><circle cx="70" cy="10" r="6"/>
    </g>
    <path d="${def.fairway}" fill="var(--fairway)" stroke="oklch(68% 0.07 150)" stroke-width="1.5"/>
    <g clip-path="url(#sk-clip-${n})">${stripes.join("")}</g>
    ${waterBody}
    ${bunkerEls}
    <ellipse cx="${def.green.cx}" cy="${def.green.cy}" rx="${(def.green.rx*1.25).toFixed(1)}" ry="${(def.green.ry*1.25).toFixed(1)}" fill="var(--rough)" opacity="0.3"/>
    <ellipse cx="${def.green.cx}" cy="${def.green.cy}" rx="${def.green.rx}" ry="${def.green.ry}" fill="oklch(80% 0.09 150)" stroke="oklch(60% 0.08 150)" stroke-width="1.5"/>
    <circle cx="${def.flag.x - 4}" cy="${def.flag.y + 15}" r="1.3" fill="oklch(40% 0.06 150)"/>
    <ellipse cx="${(tee.x - 6).toFixed(1)}" cy="${(tee.y - 2).toFixed(1)}" rx="2.6" ry="1.7" fill="var(--gold)"/>
    <ellipse cx="${(tee.x + 6).toFixed(1)}" cy="${(tee.y - 2).toFixed(1)}" rx="2.6" ry="1.7" fill="oklch(97% 0.012 95)" stroke="oklch(70% 0.02 95)" stroke-width="0.8"/>
    <line x1="${def.flag.x}" y1="${def.flag.y + 22}" x2="${def.flag.x}" y2="${def.flag.y}" stroke="var(--ink)" stroke-width="1.5"/>
    <path d="M${def.flag.x} ${def.flag.y} L${def.flag.x + 14} ${def.flag.y + 5} L${def.flag.x} ${def.flag.y + 10} Z" fill="var(--red)"/>
  </svg>`;
}

/* ---------- Hauptbildschirm: Pager (Einstellungen ↔ Löcher ↔ Scorecard) ---------- */
function buildSettingsPage(round, hc){
  const div = document.createElement("div");
  div.className = "pager-page";
  div.innerHTML = `
    <div class="settings-page">
      <div class="eyebrow">GCWBB</div>
      <h2>${t("settingsTitle")}</h2>
      <div class="sub">${t("settingsSub")}</div>
      <div class="settings-row">
        <div class="settings-label">${t("roundType")}</div>
        <div class="nine-toggle" style="padding:0;">
          <button type="button" class="round-type-btn${hc === 9 ? " active" : ""}" data-hc="9">${t("nineHoleRound")}</button>
          <button type="button" class="round-type-btn${hc === 18 ? " active" : ""}" data-hc="18">${t("eighteenHoleRound")}</button>
        </div>
      </div>
    </div>
  `;
  div.querySelectorAll(".round-type-btn").forEach(btn => {
    btn.addEventListener("click", () => {
      if (!round) return;
      const newHc = parseInt(btn.dataset.hc, 10);
      if (newHc === hc) return;
      updateCurrentRound(r => { r.holeCount = newHc; });
      state.activePage = 0;
      renderPager();
    });
  });
  return div;
}

function buildHolePage(n){
  const holeData = HOLES[(n - 1) % 9];
  const side = n > 9 ? "back" : "front";
  const sc = holeData.scorecard;
  const div = document.createElement("div");
  div.className = "pager-page";
  div.innerHTML = `
    <div class="hole-card">
      <div class="hole-card-head">
        <div>
          <div class="hole-num-label">${t("hole")}</div>
          <div class="hole-num">${n}</div>
        </div>
        <div class="hole-meta">
          <div>${t("par")} <strong>${sc ? sc.par : "–"}</strong></div>
          <div>${t("hcp")} <strong>${sc ? sc.hcp[side] : "–"}</strong></div>
        </div>
      </div>
      <div class="hole-sketch">${holeSketchSVG(((n - 1) % 9) + 1)}</div>
      <div class="hole-desc">${escapeHtml(holeData.text)}</div>
      <div class="tee-row">
        <div class="tee-chip herren"><div class="tee-label">${t("herren")}</div><div class="tee-val">${sc ? sc.herren[side] + " m" : "–"}</div></div>
        <div class="tee-chip damen"><div class="tee-label">${t("damen")}</div><div class="tee-val">${sc ? sc.damen[side] + " m" : "–"}</div></div>
      </div>
    </div>
  `;
  return div;
}

function buildScorecardPage(round, hc){
  const div = document.createElement("div");
  div.className = "pager-page";
  const showToggle = hc > 9;
  div.innerHTML = `
    <div class="page-head" style="padding:max(env(safe-area-inset-top,0px),12px) 8px 0 8px;">
      <div class="eyebrow">GCWBB</div>
      <h1 style="font-size:24px;" data-i18n="scorecardTitle">${t("scorecardTitle")}</h1>
      <div class="sub">${round ? fmtDate(round.date) : "–"}</div>
    </div>
    ${showToggle ? `<div class="nine-toggle" id="pager-nine-toggle" style="padding:0 8px;">
      <button type="button" class="active" data-nine="front">${t("frontNine")}</button>
      <button type="button" data-nine="back">${t("backNine")}</button>
    </div>` : ""}
    <div class="card-table" style="margin:10px 8px 12px 8px;">
      <div class="card-row head">
        <div class="cell">${t("hole")}</div><div class="cell">${t("par")}</div><div class="cell">${t("hcp")}</div>
        <div class="cell">${t("herren")}</div><div class="cell">${t("damen")}</div><div class="cell">${t("score")}</div>
      </div>
      <div id="pager-scorecard-rows"></div>
    </div>
    <p class="note" style="margin:0 8px 16px 8px;">${t("scoreNote")}</p>
  `;

  let currentNine = "front";
  function renderRows(){
    const rowsEl = div.querySelector("#pager-scorecard-rows");
    rowsEl.innerHTML = "";
    const side = (hc > 9 && currentNine === "back") ? "back" : "front";
    HOLES.slice(0, Math.min(hc, 9)).forEach(hole => {
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
  renderRows();

  if (showToggle){
    const toggleBtns = div.querySelectorAll("#pager-nine-toggle button");
    toggleBtns.forEach(btn => {
      btn.addEventListener("click", () => {
        toggleBtns.forEach(b => b.classList.remove("active"));
        btn.classList.add("active");
        currentNine = btn.dataset.nine;
        renderRows();
      });
    });
  }

  return div;
}

function renderHoleColumns(hc){
  const front = document.getElementById("col-front");
  const back = document.getElementById("col-back");
  front.innerHTML = ""; back.innerHTML = "";
  front.appendChild(settingsListItem());
  const frontCount = Math.min(hc, 9);
  for (let n = 1; n <= frontCount; n++) front.appendChild(holeListItem(n));
  if (hc > 9){
    back.classList.remove("hidden-col");
    for (let n = 10; n <= hc; n++) back.appendChild(holeListItem(n));
    back.appendChild(scorecardListItem(hc));
  } else {
    front.appendChild(scorecardListItem(hc));
    back.classList.add("hidden-col");
  }
}
function holeListItem(pageIndex){
  const b = document.createElement("button");
  b.type = "button";
  b.className = "hole-list-item" + (pageIndex === state.activePage ? " active" : "");
  b.textContent = pageIndex;
  b.dataset.page = pageIndex;
  b.addEventListener("click", () => navigateToPage(pageIndex, false));
  return b;
}
/* Reiter „Einstellungen" (immer Seite 0, oben in der linken Spalte, über Loch 1) und
   „Scorecard" (letzte Seite, unter Loch 9 bzw. Loch 18 – je nach Rundenlänge). */
function settingsListItem(){
  const b = document.createElement("button");
  b.type = "button";
  b.className = "hole-list-item tab-icon" + (0 === state.activePage ? " active" : "");
  b.dataset.page = 0;
  b.setAttribute("aria-label", t("settingsTitle"));
  b.innerHTML = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82A1.65 1.65 0 0 0 3 13.09H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>`;
  b.addEventListener("click", () => navigateToPage(0, false));
  return b;
}
function scorecardListItem(hc){
  const pageIndex = hc + 1;
  const b = document.createElement("button");
  b.type = "button";
  b.className = "hole-list-item tab-icon" + (pageIndex === state.activePage ? " active" : "");
  b.dataset.page = pageIndex;
  b.setAttribute("aria-label", t("scorecardTitle"));
  b.innerHTML = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2.5"/><line x1="4" y1="10" x2="20" y2="10"/><line x1="9" y1="10" x2="9" y2="20"/></svg>`;
  b.addEventListener("click", () => navigateToPage(pageIndex, false));
  return b;
}

function renderPager(){
  const pager = document.getElementById("pager");
  const round = getCurrentRound();
  if (!round){
    pager.innerHTML = "";
    document.getElementById("col-front").innerHTML = "";
    document.getElementById("col-back").innerHTML = "";
    document.getElementById("main-context").textContent = "–";
    return;
  }
  const hc = holeCountFor(round);
  pager.innerHTML = "";
  pager.appendChild(buildSettingsPage(round, hc));
  for (let n = 1; n <= hc; n++) pager.appendChild(buildHolePage(n));
  pager.appendChild(buildScorecardPage(round, hc));
  renderHoleColumns(hc);
  navigateToPage(Math.min(state.activePage, hc + 1), false);
}

function navigateToPage(index, smooth){
  if (smooth === undefined) smooth = true;
  requestAnimationFrame(() => {
    const pager = document.getElementById("pager");
    if (!pager || !pager.children.length) return;
    const clamped = Math.max(0, Math.min(index, pager.children.length - 1));
    state.activePage = clamped;
    pager.scrollTo({ left: clamped * pager.clientWidth, behavior: smooth ? "smooth" : "auto" });
    updateActiveStates();
  });
}

function updateActiveStates(){
  document.querySelectorAll(".hole-list-item").forEach(el => {
    el.classList.toggle("active", parseInt(el.dataset.page, 10) === state.activePage);
  });
  const round = getCurrentRound();
  const ctx = document.getElementById("main-context");
  if (!round){ ctx.textContent = "–"; return; }
  const hc = holeCountFor(round);
  if (state.activePage === 0) ctx.textContent = t("settingsTitle");
  else if (state.activePage === hc + 1) ctx.textContent = t("scorecardTitle");
  else ctx.textContent = `${t("hole")} ${state.activePage}`;
}

(function setupPagerScrollTracking(){
  const pager = document.getElementById("pager");
  let debounceTimer = null;
  pager.addEventListener("scroll", () => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      if (!pager.clientWidth) return;
      const idx = Math.round(pager.scrollLeft / pager.clientWidth);
      if (idx !== state.activePage){
        state.activePage = idx;
        updateActiveStates();
      }
    }, 100);
  });
})();

/* ---------- Schläger ---------- */
function fmtDistance(c){
  if (c.min == null || c.max == null) return t("noDistance");
  return `${c.min}–${c.max} m`;
}

function escapeHtml(s){
  return String(s).replace(/[&<>"']/g, m => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[m]));
}
function escapeAttr(s){ return escapeHtml(s); }

function renderClubs(){
  const list = document.getElementById("clubs-list");
  const editBtn = document.getElementById("btn-edit-clubs");
  const actionbar = document.getElementById("clubs-edit-actionbar");
  list.innerHTML = "";

  if (state.clubsEditMode){
    editBtn.hidden = true;
    actionbar.hidden = false;

    state.editBuffer.forEach((c, idx) => {
      const row = document.createElement("div");
      row.className = "club-edit-row";
      row.innerHTML = `
        <div class="field">
          <label>${t("clubName")}</label>
          <input type="text" class="edit-name" maxlength="30" value="${escapeAttr(c.name)}">
        </div>
        <div class="field-row">
          <div class="field"><label>${t("minDist")}</label><input type="number" class="edit-min" min="0" max="400" inputmode="numeric" value="${c.min ?? ""}"></div>
          <div class="field"><label>${t("maxDist")}</label><input type="number" class="edit-max" min="0" max="400" inputmode="numeric" value="${c.max ?? ""}"></div>
          <button type="button" class="btn-remove-row" data-idx="${idx}" aria-label="${t("delete")}">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 7h16"/><path d="M9 7V5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/><path d="M6 7l1 13a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2l1-13"/></svg>
          </button>
        </div>
      `;
      row.querySelector(".edit-name").addEventListener("input", (e) => { state.editBuffer[idx].name = e.target.value; });
      row.querySelector(".edit-min").addEventListener("input", (e) => { state.editBuffer[idx].min = e.target.value === "" ? null : parseInt(e.target.value, 10); });
      row.querySelector(".edit-max").addEventListener("input", (e) => { state.editBuffer[idx].max = e.target.value === "" ? null : parseInt(e.target.value, 10); });
      row.querySelector(".btn-remove-row").addEventListener("click", () => {
        state.editBuffer.splice(idx, 1);
        renderClubs();
      });
      list.appendChild(row);
    });

    const addBtn = document.createElement("button");
    addBtn.className = "add-btn";
    addBtn.innerHTML = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg><span>${t("addClub")}</span>`;
    addBtn.addEventListener("click", () => {
      state.editBuffer.push({ id: "c" + Date.now() + Math.random().toString(36).slice(2, 6), name: "", category: "Eigener Schläger", min: null, max: null });
      renderClubs();
      const nameInputs = list.querySelectorAll(".edit-name");
      if (nameInputs.length) nameInputs[nameInputs.length - 1].focus();
    });
    list.appendChild(addBtn);

  } else {
    editBtn.hidden = false;
    actionbar.hidden = true;
    const clubs = getClubs();
    clubs.forEach(c => {
      const item = document.createElement("button");
      item.className = "list-item" + (state.selectedClubId === c.id ? " selected" : "");
      item.innerHTML = `
        <div class="ico"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--green)" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="19" x2="18" y2="6"/><path d="M13 6l5 5"/><circle cx="6.2" cy="19.5" r="1.6" fill="var(--green)" stroke="none"/></svg></div>
        <div class="body"><div class="name">${escapeHtml(c.name)}</div><div class="meta">${c.category} &middot; ${fmtDistance(c)}</div></div>
        <svg class="chev" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg>
      `;
      item.addEventListener("click", () => {
        state.selectedClubId = (state.selectedClubId === c.id) ? null : c.id;
        renderClubs();
      });
      list.appendChild(item);
    });
  }
}

document.getElementById("btn-edit-clubs").addEventListener("click", () => {
  state.clubsEditMode = true;
  state.editBuffer = JSON.parse(JSON.stringify(getClubs()));
  renderClubs();
});
document.getElementById("btn-cancel-clubs-edit").addEventListener("click", () => {
  state.clubsEditMode = false;
  state.editBuffer = null;
  renderClubs();
});
document.getElementById("btn-save-clubs-edit").addEventListener("click", () => {
  const cleaned = state.editBuffer
    .filter(c => c.name && c.name.trim().length > 0)
    .map(c => ({ ...c, name: c.name.trim() }));
  saveClubs(cleaned);
  state.clubsEditMode = false;
  state.editBuffer = null;
  state.selectedClubId = null;
  renderClubs();
});

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

/* ---------- Problem/Anregung melden (nach Vorbild der Referenz-App, Pflichtenheft 10.6) ----------
   Öffnet ein vorausgefülltes GitHub-"New Issue"-Formular im Browser. Bewusst OHNE Token in der App –
   die Übermittlung erfolgt mit dem eigenen GitHub-Konto der meldenden Person. */
const reportModal = document.getElementById("report-modal");
const reportBugBtn = document.getElementById("btn-report-bug");
const reportIdeaBtn = document.getElementById("btn-report-idea");

function setReportType(type){
  state.reportType = type;
  reportBugBtn.classList.toggle("active", type === "bug");
  reportIdeaBtn.classList.toggle("active", type === "idea");
}

document.getElementById("btn-open-report").addEventListener("click", () => {
  document.getElementById("report-title").value = "";
  document.getElementById("report-desc").value = "";
  setReportType("bug");
  reportModal.classList.add("open");
});
document.getElementById("btn-cancel-report").addEventListener("click", () => {
  reportModal.classList.remove("open");
});
reportBugBtn.addEventListener("click", () => setReportType("bug"));
reportIdeaBtn.addEventListener("click", () => setReportType("idea"));

document.getElementById("btn-submit-report").addEventListener("click", () => {
  const title = document.getElementById("report-title").value.trim();
  const desc = document.getElementById("report-desc").value.trim();
  if (!title) { document.getElementById("report-title").focus(); return; }
  const label = state.reportType === "idea" ? "enhancement" : "bug";
  const params = new URLSearchParams({ title, body: desc, labels: label });
  const url = `https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}/issues/new?${params.toString()}`;
  window.open(url, "_blank", "noopener");
  reportModal.classList.remove("open");
});

/* ---------- i18n anwenden ---------- */
function applyI18n(){
  document.documentElement.lang = localStorage.getItem(LS_LANG) || "de";
  document.querySelectorAll("[data-i18n]").forEach(el => {
    el.textContent = t(el.dataset.i18n);
  });
  renderLangRow();
  renderPager();
  renderClubs();
  renderAboutContact();
  renderRoundsList();
}

/* ---------- Start ---------- */
(function init(){
  const savedId = localStorage.getItem(LS_CURRENT);
  if (savedId && getRounds().some(r => r.id === savedId)) state.currentRoundId = savedId;
  renderLangRow();
  renderPager();
  renderClubs();
  renderAboutContact();

  if ("serviceWorker" in navigator){
    window.addEventListener("load", () => {
      navigator.serviceWorker.register("service-worker.js").catch(() => {});
    });
  }
})();
