<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>شاشة القسم</title>
<style>
  :root{ --teal-deep:#0f4c4c; --teal:#146464; --sand:#f6f3ec; --ink:#1f2a2a; --muted:#6b7a7a; --amber:#c98a2c; --line:#dfe3e0; }
  *{box-sizing:border-box;}
  html,body{margin:0;padding:0;height:100%;}
  body{
    font-family:"Tahoma","Segoe UI",Arial,sans-serif;background:var(--teal-deep);color:#fff;
    display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:100vh;
    text-align:center;
  }
  header{position:fixed;top:0;right:0;left:0;padding:18px 20px;text-align:center;}
  header h1{margin:0;font-size:clamp(18px,3vw,32px);}
  header .sub{font-size:clamp(11px,1.4vw,16px);opacity:.8;margin-top:4px;}
  #syncStatus{font-size:clamp(10px,1.2vw,13px);margin-top:4px;opacity:.85;}

  .dept-name{font-size:clamp(28px,6vw,64px);font-weight:800;margin-bottom:2vh;}
  .serving-label{font-size:clamp(14px,2vw,24px);opacity:.85;margin-bottom:1vh;}
  .serving-number{
    font-size:clamp(80px,22vw,260px);font-weight:900;letter-spacing:2px;line-height:1;
    transition:transform .25s ease;
  }
  .serving-number.pulse{ animation:pulse 1s ease; }
  @keyframes pulse{
    0%{ transform:scale(1); color:#fff; }
    30%{ transform:scale(1.08); color:var(--amber); }
    100%{ transform:scale(1); color:#fff; }
  }

  .deptPicker{max-width:600px;padding:20px;}
  .deptPicker select, .deptPicker button{
    font-family:inherit;font-size:20px;padding:14px 18px;border-radius:12px;border:none;margin-top:14px;width:100%;
  }
  .deptPicker button{background:var(--amber);color:#2a1c00;font-weight:800;cursor:pointer;}
</style>
</head>
<body>
<header>
  <h1 id="hospitalName">مستشفى الدورة الأهلي</h1>
  <div class="sub">شاشة القسم</div>
  <div id="syncStatus">⏳ جاري الاتصال...</div>
</header>

<div id="deptPicker" class="deptPicker" style="display:none;">
  <div style="font-size:22px;font-weight:800;">اختر القسم لهذه الشاشة</div>
  <select id="deptSelect"></select>
  <button id="confirmDeptBtn">تأكيد</button>
</div>

<div id="mainView" style="display:none;">
  <div class="dept-name" id="deptNameLabel"></div>
  <div class="serving-label">الرقم الجاري خدمته الآن</div>
  <div class="serving-number" id="servingNumber">—</div>
</div>

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
  const DEVICE_KEY = "hospitalQueueDisplay_deptId";

  let departments = [];
  let nowServing = {};
  let lastShownNumber = null;
  let selectedDeptId = localStorage.getItem(DEVICE_KEY) || null;

  const urlParams = new URLSearchParams(window.location.search);
  const urlDept = urlParams.get("dept");
  if(urlDept) selectedDeptId = urlDept;

  function updateSyncStatus(text, ok){
    const el = document.getElementById("syncStatus");
    el.textContent = text;
    el.style.opacity = ok ? "0.85" : "1";
  }

  function renderDeptPicker(){
    const sel = document.getElementById("deptSelect");
    sel.innerHTML = "";
    departments.forEach(d=>{
      const opt = document.createElement("option");
      opt.value = d.id;
      opt.textContent = d.name;
      sel.appendChild(opt);
    });
    document.getElementById("deptPicker").style.display = "block";
    document.getElementById("mainView").style.display = "none";
  }
  document.getElementById("confirmDeptBtn").addEventListener("click", ()=>{
    selectedDeptId = document.getElementById("deptSelect").value;
    localStorage.setItem(DEVICE_KEY, selectedDeptId);
    renderMain();
  });

  function renderMain(){
    const dept = departments.find(d=>d.id===selectedDeptId);
    if(!dept){ renderDeptPicker(); return; }
    document.getElementById("deptPicker").style.display = "none";
    document.getElementById("mainView").style.display = "block";
    document.getElementById("deptNameLabel").textContent = dept.name;
    const serving = nowServing[dept.id] || 0;
    const text = serving>0 ? (dept.prefix+"-"+String(serving).padStart(3,"0")) : "—";
    const numEl = document.getElementById("servingNumber");
    if(lastShownNumber !== null && text !== numEl.textContent){
      numEl.classList.remove("pulse");
      void numEl.offsetWidth;
      numEl.classList.add("pulse");
    }
    numEl.textContent = text;
    lastShownNumber = serving;
  }

  stateDocRef.onSnapshot((snap)=>{
    if(!snap.exists){ updateSyncStatus("⏳ في انتظار إنشاء قاعدة البيانات من جهاز الاستعلامات", false); return; }
    const data = snap.data();
    departments = data.departments || [];
    nowServing = data.nowServing || {};
    updateSyncStatus("● متصل - يتزامن لحظياً", true);
    if(!selectedDeptId || !departments.find(d=>d.id===selectedDeptId)){
      renderDeptPicker();
    }else{
      renderMain();
    }
  }, (err)=>{
    console.error(err);
    updateSyncStatus("⚠ تعذر الاتصال بقاعدة البيانات", false);
  });
})();
</script>
</body>
</html>
