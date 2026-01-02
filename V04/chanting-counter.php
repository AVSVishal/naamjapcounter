<?php
header('Content-Type: text/html; charset=utf-8');
header('Cache-Control: public, max-age=3600');

$action = $_GET['action'] ?? '';
$response = ['success' => false];

if ($action === 'save' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if (isset($data['count']) && isset($data['total'])) {
        $save = [
            'count' => (int)$data['count'],
            'total' => (int)$data['total'],
            'timestamp' => time()
        ];
        file_put_contents('counter_data.json', json_encode($save));
        $response = ['success' => true];
    }
    header('Content-Type: application/json');
    echo json_encode($response);
    exit;
}

if ($action === 'load') {
    if (file_exists('counter_data.json')) {
        $response = json_decode(file_get_contents('counter_data.json'), true);
    }
    header('Content-Type: application/json');
    echo json_encode($response);
    exit;
}
?><!DOCTYPE html>
<html lang="hi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#667eea">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<title>Japa Counter - Free Digital Mantra Counter Online | Naam Japa Mala 108</title>
<meta name="description" content="Free online japa counter for mantra chanting. Digital japa mala counter with 108 beads tracking, session counts, lifetime totals. Works offline for meditation, naam japa, Hindu & Buddhist prayers.">
<meta name="keywords" content="japa counter, japa mala counter, digital japa counter, mantra counter, naam japa counter, 108 mala counter, chanting counter online, free japa counter, meditation counter, bhajan counter, मंत्र गणक, जप काउंटर">
<meta name="author" content="ChantingCounter.com">
<meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1">
<link rel="canonical" href="https://chantingcounter.com/">
<meta property="og:locale" content="en_US">
<meta property="og:type" content="website">
<meta property="og:title" content="Japa Counter - Free Digital Mantra Counter Online">
<meta property="og:description" content="Free online japa counter for mantra chanting. Digital japa mala counter with 108 beads tracking. Works offline for meditation & naam japa.">
<meta property="og:url" content="https://chantingcounter.com/">
<meta property="og:site_name" content="ChantingCounter.com">
<meta property="og:image" content="https://chantingcounter.com/og-image.jpg">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Japa Counter - Free Digital Mantra Counter">
<meta name="twitter:description" content="Free online japa counter. Track mantra chanting with digital 108 mala counter. Works offline.">
<meta name="twitter:image" content="https://chantingcounter.com/twitter-image.jpg">
<style>
*{margin:0;padding:0;box-sizing:border-box}
html{font-size:16px}
body{font-family:system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);min-height:100vh;min-height:-webkit-fill-available;display:flex;align-items:center;justify-content:center;padding:0.5rem;user-select:none;-webkit-tap-highlight-color:transparent;overflow-x:hidden}
.container{background:rgba(255,255,255,.95);backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px);border-radius:24px;box-shadow:0 20px 60px rgba(0,0,0,.3);padding:clamp(1.5rem,5vw,2.5rem);max-width:450px;width:100%;text-align:center;margin:auto}
h1{font-size:clamp(1.25rem,5vw,1.75rem);color:#333;margin-bottom:.5rem;font-weight:600;line-height:1.2}
.subtitle{color:#666;font-size:clamp(.85rem,3.5vw,1rem);margin-bottom:1.5rem}
.count-display{font-size:clamp(2.5rem,12vw,4.5rem);font-weight:700;color:#667eea;margin:0.5rem 0;font-variant-numeric:tabular-nums;letter-spacing:-0.05em;line-height:1;word-break:break-all}
.btn-count{width:clamp(120px,32vw,180px);height:clamp(120px,32vw,180px);max-width:90vw;max-height:90vw;border-radius:50%;border:none;background:linear-gradient(135deg,#ff6b35,#f7931e);color:#fff;font-size:clamp(1.1rem,4.5vw,1.8rem);font-weight:700;cursor:pointer;box-shadow:0 10px 30px rgba(255,107,53,.4);transition:transform .1s,box-shadow .1s;touch-action:manipulation;margin:0.5rem auto;display:flex;align-items:center;justify-content:center}
.btn-count:active{transform:scale(.95);box-shadow:0 5px 15px rgba(255,107,53,.4)}
.stats{display:grid;grid-template-columns:1fr 1fr;gap:clamp(.75rem,3vw,1rem);margin:clamp(1.5rem,4vw,2rem) 0}
.stat{background:#f8f9fa;padding:clamp(.75rem,3vw,1.25rem);border-radius:12px}
.stat-label{font-size:clamp(.75rem,3vw,.9rem);color:#666;margin-bottom:.3rem}
.stat-value{font-size:clamp(1.25rem,5vw,1.75rem);font-weight:700;color:#333}
.controls{display:flex;flex-wrap:wrap;gap:.5rem;justify-content:center;margin-top:1.5rem}
.btn{padding:clamp(.65rem,2.5vw,.85rem) clamp(1rem,4vw,1.75rem);border:none;border-radius:12px;font-size:clamp(.8rem,3.5vw,.95rem);font-weight:600;cursor:pointer;transition:all .2s;touch-action:manipulation;white-space:nowrap}
.btn-reset{background:#e0e0e0;color:#333}
.btn-reset:active{background:#d0d0d0}
.btn-save{background:#4caf50;color:#fff}
.btn-save:active{background:#45a049}
.toast{position:fixed;top:20px;left:50%;transform:translateX(-50%);background:#333;color:#fff;padding:.75rem 1.5rem;border-radius:8px;opacity:0;transition:opacity .3s;pointer-events:none;z-index:1000;max-width:90vw;text-align:center;font-size:clamp(.85rem,3.5vw,.95rem)}
.toast.show{opacity:1}
@media(max-width:380px){
.container{padding:1.25rem;border-radius:20px}
.controls{gap:.4rem}
.btn{padding:.6rem .9rem;font-size:.8rem}
}
@media(max-width:320px){
.stats{gap:.5rem}
.stat{padding:.65rem}
}
@media(min-width:481px)and (max-width:768px){
.container{max-width:500px;padding:2.5rem}
}
@media(orientation:landscape)and (max-height:500px){
body{padding:.5rem}
.container{padding:1rem}
.count-display{margin:1rem 0}
.btn-count{width:120px;height:120px;font-size:1.5rem}
.stats{margin:1rem 0}
}
</style>
</head>
<body>
<main>
<div class="container" role="main">
<h1>🕉️ Japa Counter</h1>
<p class="subtitle">Digital Mantra Counter | जप माला गणक</p>
<div class="count-display" id="count">0</div>
<button class="btn-count" id="btnCount" aria-label="Count">COUNT</button>
<div class="stats">
<div class="stat">
<div class="stat-label">Session</div>
<div class="stat-value" id="session">0</div>
</div>
<div class="stat">
<div class="stat-label">Total Lifetime</div>
<div class="stat-value" id="total">0</div>
</div>
</div>
<div class="controls">
<button class="btn btn-reset" id="btnReset">Reset Session</button>
<button class="btn btn-save" id="btnSave">Save to Server</button>
</div>
</div>
<div class="toast" id="toast" role="alert" aria-live="polite"></div>
</main>
<script type="application/ld+json">
{
"@context":"https://schema.org",
"@type":"WebApplication",
"name":"Japa Counter",
"alternateName":["Digital Japa Counter","Mantra Counter","Naam Japa Counter","जप माला गणक"],
"url":"https://chantingcounter.com",
"description":"Free online japa counter for mantra chanting and naam japa. Digital japa mala counter with 108 beads tracking, session counts, lifetime totals. Perfect for Hindu prayers, Buddhist meditation, and spiritual practices.",
"applicationCategory":"UtilityApplication",
"operatingSystem":"Any",
"offers":{
"@type":"Offer",
"price":"0",
"priceCurrency":"USD"
},
"featureList":[
"Session counter",
"Lifetime total tracking",
"Offline support",
"LocalStorage persistence",
"Server backup option",
"Keyboard shortcuts",
"Mobile optimized",
"Vibration feedback"
],
"browserRequirements":"Requires JavaScript. Requires HTML5."
}
</script>
<script>
const KEY_COUNT='chant_count';
const KEY_TOTAL='chant_total';
const el={
count:document.getElementById('count'),
session:document.getElementById('session'),
total:document.getElementById('total'),
btnCount:document.getElementById('btnCount'),
btnReset:document.getElementById('btnReset'),
btnSave:document.getElementById('btnSave'),
toast:document.getElementById('toast')
};
let count=0;
let total=0;

function load(){
try{
count=parseInt(localStorage.getItem(KEY_COUNT)||'0');
total=parseInt(localStorage.getItem(KEY_TOTAL)||'0');
}catch(e){
count=0;total=0;
}
render();
}

function save(){
try{
localStorage.setItem(KEY_COUNT,count);
localStorage.setItem(KEY_TOTAL,total);
}catch(e){
showToast('Storage error');
}
}

function render(){
el.count.textContent=count;
el.session.textContent=count;
el.total.textContent=total;
}

function increment(){
count++;
total++;
render();
save();
if(navigator.vibrate)navigator.vibrate(10);
}

function reset(){
if(count>0&&!confirm('Reset session count?'))return;
count=0;
render();
save();
showToast('Session reset');
}

function saveToServer(){
el.btnSave.disabled=true;
el.btnSave.textContent='Saving...';
fetch('?action=save',{
method:'POST',
headers:{'Content-Type':'application/json'},
body:JSON.stringify({count,total})
})
.then(r=>r.json())
.then(d=>{
showToast(d.success?'Saved to server!':'Save failed');
})
.catch(()=>showToast('Network error'))
.finally(()=>{
el.btnSave.disabled=false;
el.btnSave.textContent='Save to Server';
});
}

function showToast(msg){
el.toast.textContent=msg;
el.toast.classList.add('show');
setTimeout(()=>el.toast.classList.remove('show'),2000);
}

el.btnCount.addEventListener('click',increment);
el.btnReset.addEventListener('click',reset);
el.btnSave.addEventListener('click',saveToServer);

document.addEventListener('keydown',e=>{
if(e.key===' '||e.key==='Enter'){
e.preventDefault();
increment();
}
});

load();
</script>
</body>
</html>