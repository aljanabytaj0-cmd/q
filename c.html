<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>لوحة تحكم القسم - استدعاء التالي</title>
<style>
  :root{
    --teal-deep:#0f4c4c; --teal:#146464; --teal-light:#1c8080;
    --sand:#f6f3ec; --ink:#1f2a2a; --muted:#6b7a7a; --amber:#c98a2c; --line:#dfe3e0;
  }
  *{box-sizing:border-box;}
  html,body{margin:0;padding:0;height:100%;}
  body{font-family:"Tahoma","Segoe UI",Arial,sans-serif;background:var(--sand);color:var(--ink);
    display:flex;flex-direction:column;align-items:center;min-height:100vh;}
  header{width:100%;background:var(--teal-deep);color:#fff;padding:14px 20px;text-align:center;}
  header h1{margin:0;font-size:18px;}
  header .sub{font-size:12.5px;opacity:.85;margin-top:4px;}
  #syncStatus{font-size:12px;margin-top:4px;}

  .wrap{flex:1;width:100%;max-width:520px;padding:24px 18px;display:flex;flex-direction:column;align-items:center;gap:18px;}

  select, .btn{
    font-family:inherit;font-size:16px;border-radius:10px;padding:12px 16px;border:1px solid var(--line);
  }
  select{width:100%;background:#fff;color:var(--ink);}

  .dept-name{font-size:22px;font-weight:800;color:var(--teal-deep);text-align:center;}

  .serving-box{
    background:#fff;border:2px solid var(--teal);border-radius:20px;width:100%;
    padding:28px 16px;text-align:center;
  }
  .serving-label{font-size:14px;color:var(--muted);margin-bottom:6px;}
  .serving-number{font-size:72px;font-weight:900;color:var(--teal-deep);letter-spacing:1px;}
  .issued-label{font-size:13px;color:var(--muted);margin-top:10px;}

  .call-btn{
    width:100%;background:var(--teal);color:#fff;border:none;border-radius:16px;
    padding:26px 10px;font-size:24px;font-weight:800;cursor:pointer;
  }
  .call-btn:active{background:var(--teal-light);}
  .call-btn:disabled{background:#b7c4c4;cursor:not-allowed;}

  .secondary-btn{
    width:100%;background:#fff;color:var(--teal);border:1px solid var(--teal);border-radius:12px;
    padding:12px 10px;font-size:14px;cursor:pointer;
  }

  .change-dept{font-size:12.5px;color:var(--muted);text-decoration:underline;cursor:pointer;background:none;border:none;}

  .toast{
    position:fixed;bottom:20px;left:50%;transform:translateX(-50%);
    background:var(--teal-deep);color:#fff;padding:11px 20px;border-radius:30px;
    font-size:13.5px;box-shadow:0 6px 20px rgba(0,0,0,0.2);opacity:0;pointer-events:none;
    transition:opacity .25s ease;z-index:999;
  }
  .toast.show{opacity:1;}
</style>
</head>
<body>
<header>
  <h1 id="hospitalName">مستشفى الدورة الأهلي</h1>
  <div class="sub">لوحة تحكم القسم - استدعاء المراجعين</div>
  <div id="syncStatus">⏳ جاري الاتصال...</div>
</header>

<div class="wrap">
  <div id="deptPicker" style="width:100%;display:none;">
    <div class="dept-name" style="margin-bottom:10px;">اختر القسم لهذا الجهاز</div>
    <select id="deptSelect"></select>
    <button class="call-btn" id="confirmDeptBtn" style="margin-top:14px;">تأكيد الاختيار</button>
  </div>

  <div id="mainView" style="width:100%;display:none;flex-direction:column;align-items:center;gap:18px;">
    <div class="dept-name" id="deptNameLabel"></div>

    <div class="serving-box">
      <div class="serving-label">الرقم الجاري خدمته الآن</div>
      <div class="serving-number" id="servingNumber">—</div>
      <div class="issued-label" id="issuedLabel"></div>
    </div>

    <button class="call-btn" id="callNextBtn">📢 استدعاء التالي</button>
    <button class="secondary-btn" id="recallBtn">🔁 إعادة استدعاء نفس الرقم</button>
    <button class="change-dept" id="changeDeptBtn">تغيير القسم</button>
  </div>
</div>

<div class="toast" id="toast"></div>

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
  const DEVICE_KEY = "hospitalQueueControl_deptId";

  let departments = [];
  let counts = {};
  let nowServing = {};
  let selectedDeptId = localStorage.getItem(DEVICE_KEY) || null;

  function showToast(msg){
    const el = document.getElementById("toast");
    el.textContent = msg;
    el.classList.add("show");
    setTimeout(()=>el.classList.remove("show"), 2200);
  }
  function updateSyncStatus(text, ok){
    const el = document.getElementById("syncStatus");
    el.textContent = text;
    el.style.color = ok ? "#bfe9c9" : "#f3c98a";
  }

  const urlParams = new URLSearchParams(window.location.search);
  const urlDept = urlParams.get("dept");
  if(urlDept) selectedDeptId = urlDept;

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
    const sel = document.getElementById("deptSelect");
    selectedDeptId = sel.value;
    localStorage.setItem(DEVICE_KEY, selectedDeptId);
    renderMain();
  });
  document.getElementById("changeDeptBtn").addEventListener("click", ()=>{
    renderDeptPicker();
  });

  function renderMain(){
    const dept = departments.find(d=>d.id===selectedDeptId);
    if(!dept){ renderDeptPicker(); return; }
    document.getElementById("deptPicker").style.display = "none";
    document.getElementById("mainView").style.display = "flex";
    document.getElementById("deptNameLabel").textContent = dept.name;
    const serving = nowServing[dept.id] || 0;
    const issued = counts[dept.id] || 0;
    document.getElementById("servingNumber").textContent = serving>0 ? (dept.prefix+"-"+String(serving).padStart(3,"0")) : "—";
    document.getElementById("issuedLabel").textContent = "آخر رقم صادر اليوم: " + (issued>0 ? (dept.prefix+"-"+String(issued).padStart(3,"0")) : "لا يوجد");
    const callBtn = document.getElementById("callNextBtn");
    const canCallNext = serving < issued;
    callBtn.disabled = !canCallNext;
    callBtn.textContent = canCallNext ? "📢 استدعاء التالي" : "📢 لا يوجد مراجعين إضافيين بالانتظار";
    document.getElementById("recallBtn").style.display = serving>0 ? "block" : "none";
  }

  document.getElementById("callNextBtn").addEventListener("click", async ()=>{
    const dept = departments.find(d=>d.id===selectedDeptId);
    if(!dept) return;
    try{
      await db.runTransaction(async (tx)=>{
        const snap = await tx.get(stateDocRef);
        const data = snap.exists ? snap.data() : {};
        const counts2 = data.counts || {};
        const nowServing2 = data.nowServing || {};
        const issued = counts2[dept.id] || 0;
        const serving = nowServing2[dept.id] || 0;
        if(serving >= issued){
          throw new Error("NO_MORE_TICKETS");
        }
        nowServing2[dept.id] = serving + 1;
        tx.set(stateDocRef, Object.assign({}, data, {nowServing: nowServing2}));
      });
      showToast("تم استدعاء الرقم التالي");
    }catch(e){
      if(e.message === "NO_MORE_TICKETS"){
        showToast("لا يوجد مراجعين إضافيين بانتظار الاستدعاء");
      }else{
        console.error(e);
        showToast("تعذر الاتصال بقاعدة البيانات");
      }
    }
  });

  document.getElementById("recallBtn").addEventListener("click", ()=>{
    showToast("تم إعادة إرسال إشعار الاستدعاء لنفس الرقم");
    // Re-triggers listeners on display screens by touching a recall timestamp
    stateDocRef.set({ recallPing: { deptId: selectedDeptId, ts: Date.now() } }, {merge:true})
      .catch(err=>console.error(err));
  });

  stateDocRef.onSnapshot((snap)=>{
    if(!snap.exists){ updateSyncStatus("⏳ في انتظار إنشاء قاعدة البيانات من جهاز الاستعلامات", false); return; }
    const data = snap.data();
    departments = data.departments || [];
    counts = data.counts || {};
    nowServing = data.nowServing || {};
    updateSyncStatus("● متصل - يتزامن لحظياً", true);
    if(!selectedDeptId || !departments.find(d=>d.id===selectedDeptId)){
      renderDeptPicker();
    }else{
      renderMain();
    }
  }, (err)=>{
    console.error(err);
    updateSyncStatus("⚠ تعذر الاتصال بقاعدة البيانات، تحقق من الإنترنت", false);
  });
})();
</script>
</body>
</html>
