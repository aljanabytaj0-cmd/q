<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>شاشة قاعة الانتظار الرئيسية</title>
<style>
  :root{ --teal-deep:#0f4c4c; --teal:#146464; --sand:#f6f3ec; --ink:#1f2a2a; --muted:#6b7a7a; --amber:#c98a2c; --line:#dfe3e0; }
  *{box-sizing:border-box;}
  html,body{margin:0;padding:0;height:100%;}
  body{font-family:"Tahoma","Segoe UI",Arial,sans-serif;background:var(--sand);color:var(--ink);min-height:100vh;}

  header{
    background:var(--teal-deep);color:#fff;padding:20px 28px;display:flex;align-items:center;
    justify-content:space-between;flex-wrap:wrap;gap:10px;
  }
  header h1{margin:0;font-size:clamp(20px,2.4vw,32px);}
  header .sub{font-size:clamp(11px,1.2vw,15px);opacity:.85;margin-top:4px;}
  #syncStatus{font-size:clamp(11px,1.1vw,14px);}
  #clock{font-size:clamp(16px,1.8vw,26px);font-weight:800;text-align:center;}
  #dateLine{font-size:clamp(11px,1.1vw,14px);text-align:center;opacity:.85;}
  #soundToggle{
    background:rgba(255,255,255,0.15);border:1px solid rgba(255,255,255,0.3);color:#fff;
    border-radius:10px;padding:10px 16px;font-size:14px;cursor:pointer;
  }

  .grid{
    display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:18px;
    padding:26px;
  }
  .cell{
    background:#fff;border-radius:18px;padding:22px 16px;text-align:center;
    border:2px solid var(--line);transition:border-color .3s ease, transform .3s ease;
  }
  .cell.flash{ border-color:var(--amber); transform:scale(1.02); }
  .cell .dname{font-size:clamp(18px,1.8vw,26px);font-weight:800;color:var(--teal-deep);margin-bottom:8px;}
  .cell .num{font-size:clamp(46px,6vw,90px);font-weight:900;color:var(--ink);line-height:1;}
  .cell .num.empty{color:var(--muted);font-size:clamp(28px,3vw,42px);}

  .empty-note{padding:60px;text-align:center;color:var(--muted);font-size:16px;}
</style>
</head>
<body>
<header>
  <div>
    <h1 id="hospitalName">مستشفى الدورة الأهلي</h1>
    <div class="sub">شاشة قاعة الانتظار الرئيسية</div>
    <div id="syncStatus">⏳ جاري الاتصال...</div>
  </div>
  <div>
    <div id="clock">--:--</div>
    <div id="dateLine">--/--/----</div>
  </div>
  <button id="soundToggle">🔇 تفعيل التنبيه الصوتي</button>
</header>

<div class="grid" id="grid"></div>
<div class="empty-note" id="emptyNote" style="display:none;">لا توجد أقسام مضافة بعد</div>

<script src="https://www.gstatic.com/firebasejs/10.12.5/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.12.5/firebase-firestore-compat.js"></script>
<script>
(function(){
  "use strict";
  const firebaseConfig = {
    apiKey: "AIzaSyAaK9BQ1CA1RIJkPcSLj6ozgdzNEg5Qmgg",
    authDomain: "hospital-queue-2k.firebaseapp.com",
    projectId: "hospital-queue-2k",
    storageBucket: "hospital-queue-2k.firebasestorage.app",
    messagingSenderId: "522241092777",
    appId: "1:522241092777:web:53988cc45d5035285dcdb8"
  };
  firebase.initializeApp(firebaseConfig);
  const db = firebase.firestore();
  const stateDocRef = db.collection("hospitalQueue").doc("state");

  let soundEnabled = false;
  let previousServing = {};
  let firstSnapshot = true;
  let audioCtx = null;

  function ensureAudioContext(){
    if(!audioCtx){
      audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    }
    if(audioCtx.state === "suspended") audioCtx.resume();
    return audioCtx;
  }

  document.getElementById("soundToggle").addEventListener("click", ()=>{
    soundEnabled = !soundEnabled;
    document.getElementById("soundToggle").textContent = soundEnabled ? "🔊 التنبيه الصوتي مفعّل" : "🔇 تفعيل التنبيه الصوتي";
    if(soundEnabled){
      ensureAudioContext(); // unlock audio with this user gesture
    }
  });

  function updateSyncStatus(text, ok){
    const el = document.getElementById("syncStatus");
    el.textContent = text;
    el.style.color = ok ? "#bfe9c9" : "#f3c98a";
  }

  function tickClock(){
    const now = new Date();
    document.getElementById("clock").textContent =
      String(now.getHours()).padStart(2,"0")+":"+String(now.getMinutes()).padStart(2,"0");
    document.getElementById("dateLine").textContent =
      String(now.getDate()).padStart(2,"0")+"/"+String(now.getMonth()+1).padStart(2,"0")+"/"+now.getFullYear();
  }
  tickClock();
  setInterval(tickClock, 1000*15);

  function playAlertBeep(){
    try{
      const ctx = ensureAudioContext();
      const now = ctx.currentTime;
      const tones = [ {freq:880, start:0}, {freq:1046, start:0.28} ];
      tones.forEach(t=>{
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = "sine";
        osc.frequency.setValueAtTime(t.freq, now + t.start);
        gain.gain.setValueAtTime(0.0001, now + t.start);
        gain.gain.exponentialRampToValueAtTime(0.35, now + t.start + 0.02);
        gain.gain.exponentialRampToValueAtTime(0.0001, now + t.start + 0.26);
        osc.connect(gain).connect(ctx.destination);
        osc.start(now + t.start);
        osc.stop(now + t.start + 0.3);
      });
    }catch(e){ console.error(e); }
  }

  function announce(dept, number){
    if(!soundEnabled) return;
    playAlertBeep();
  }

  function render(departments, nowServing){
    const grid = document.getElementById("grid");
    document.getElementById("emptyNote").style.display = departments.length ? "none" : "block";
    grid.innerHTML = "";
    departments.forEach(dept=>{
      const serving = nowServing[dept.id] || 0;
      const cell = document.createElement("div");
      cell.className = "cell";
      const numText = serving>0 ? (dept.prefix+"-"+String(serving).padStart(3,"0")) : "—";
      cell.innerHTML = `
        <div class="dname">${escapeHtml(dept.name)}</div>
        <div class="num ${serving>0?"":"empty"}">${numText}</div>
      `;
      if(!firstSnapshot && previousServing[dept.id] !== undefined && previousServing[dept.id] !== serving && serving>0){
        cell.classList.add("flash");
        setTimeout(()=>cell.classList.remove("flash"), 2500);
        announce(dept, serving);
      }
      grid.appendChild(cell);
    });
  }

  function escapeHtml(str){
    const div = document.createElement("div");
    div.textContent = str;
    return div.innerHTML;
  }

  stateDocRef.onSnapshot((snap)=>{
    if(!snap.exists){ updateSyncStatus("⏳ في انتظار إنشاء قاعدة البيانات من جهاز الاستعلامات", false); return; }
    const data = snap.data();
    const departments = data.departments || [];
    const nowServing = data.nowServing || {};
    updateSyncStatus("● متصل - يتزامن لحظياً", true);
    render(departments, nowServing);
    previousServing = Object.assign({}, nowServing);
    firstSnapshot = false;
  }, (err)=>{
    console.error(err);
    updateSyncStatus("⚠ تعذر الاتصال بقاعدة البيانات", false);
  });
})();
</script>
</body>
</html>
