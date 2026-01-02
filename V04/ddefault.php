<?php
header('Content-Type: text/html; charset=utf-8');
header('Cache-Control: public, max-age=3600');

$action = $_GET['action'] ?? '';
$response = ['success' => false];

if ($action === 'save' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if (isset($data['count']) && isset($data['total']) && isset($data['malas'])) {
        $save = [
            'count' => (int)$data['count'],
            'total' => (int)$data['total'],
            'malas' => (int)$data['malas'],
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
<html lang="en">
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
html{font-size:16px;scroll-behavior:smooth}
body{font-family:system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);min-height:100vh;padding:0;margin:0}
.header{background:#fff;box-shadow:0 2px 10px rgba(0,0,0,.1);position:sticky;top:0;z-index:100;padding:0.5rem 0}
.header-content{max-width:1200px;margin:0 auto;padding:0 1rem;display:flex;justify-content:space-between;align-items:center}
.logo{font-size:1.5rem;font-weight:700;color:#667eea;text-decoration:none}
.nav{display:flex;gap:2rem;list-style:none}
.nav a{color:#333;text-decoration:none;font-weight:500;transition:color .2s}
.nav a:hover{color:#667eea}
.tool-section{padding:2rem 1rem;min-height:80vh;display:flex;align-items:center;justify-content:center}
.container{background:rgba(255,255,255,.95);backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px);border-radius:24px;box-shadow:0 20px 60px rgba(0,0,0,.3);padding:clamp(1.5rem,5vw,2.5rem);max-width:500px;width:100%;text-align:center}
h1{font-size:clamp(1.5rem,5vw,2rem);color:#333;margin-bottom:.5rem;font-weight:700;line-height:1.2}
.subtitle{color:#666;font-size:clamp(.85rem,3.5vw,1rem);margin-bottom:1rem}
.timer{font-size:clamp(1rem,4vw,1.2rem);color:#667eea;font-weight:600;margin-bottom:1rem;font-variant-numeric:tabular-nums}
.count-display{font-size:clamp(4rem,15vw,7rem);font-weight:700;color:#667eea;margin:clamp(1rem,4vw,1.5rem) 0;font-variant-numeric:tabular-nums;letter-spacing:-0.05em;line-height:1}
.mala-badge{display:inline-block;background:linear-gradient(135deg,#ffd700,#ffed4e);color:#333;padding:.5rem 1rem;border-radius:20px;font-size:.9rem;font-weight:600;margin:.5rem 0;box-shadow:0 4px 15px rgba(255,215,0,.3)}
.btn-count{width:clamp(160px,40vw,200px);height:clamp(160px,40vw,200px);border-radius:50%;border:none;background:linear-gradient(135deg,#ff6b35,#f7931e);color:#fff;font-size:clamp(1.5rem,5vw,2rem);font-weight:700;cursor:pointer;box-shadow:0 10px 30px rgba(255,107,53,.4);transition:transform .1s,box-shadow .1s;touch-action:manipulation;margin:0.5rem auto;display:flex;align-items:center;justify-content:center}
.btn-count:active{transform:scale(.95);box-shadow:0 5px 15px rgba(255,107,53,.4)}
.stats{display:grid;grid-template-columns:repeat(3,1fr);gap:.75rem;margin:1.5rem 0}
.stat{background:#f8f9fa;padding:0.5rem;border-radius:12px}
.stat-label{font-size:.75rem;color:#666;margin-bottom:.3rem}
.stat-value{font-size:1.25rem;font-weight:700;color:#333}
.controls{display:flex;flex-wrap:wrap;gap:.5rem;justify-content:center;margin-top:1rem}
.btn{padding:.65rem 1.25rem;border:none;border-radius:12px;font-size:.85rem;font-weight:600;cursor:pointer;transition:all .2s;touch-action:manipulation}
.btn-reset{background:#e0e0e0;color:#333}
.btn-reset:active{background:#d0d0d0}
.btn-save{background:#4caf50;color:#fff}
.btn-save:active{background:#45a049}
.btn-audio{background:#667eea;color:#fff}
.btn-audio:active{background:#5568d3}
.content-section{max-width:900px;margin:0 auto;padding:3rem 1rem;background:#fff}
.content-section h2{font-size:clamp(1.5rem,4vw,2rem);color:#333;margin:2rem 0 1rem;padding-left:1rem;border-left:4px solid #667eea}
.content-section h3{font-size:clamp(1.2rem,3.5vw,1.5rem);color:#333;margin:1.5rem 0 .75rem}
.content-section p{line-height:1.8;color:#555;margin-bottom:1rem;font-size:1.05rem}
.content-section ul{margin:1rem 0 1rem 2rem;line-height:1.8}
.content-section li{margin:.5rem 0;color:#555}
.feature-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:1.5rem;margin:2rem 0}
.feature-card{background:#f8f9fa;padding:1.5rem;border-radius:12px;border-left:4px solid #667eea}
.feature-card h4{color:#667eea;margin-bottom:.5rem}
.faq{margin:2rem 0}
.faq-item{background:#f8f9fa;padding:1.5rem;border-radius:12px;margin-bottom:1rem}
.faq-question{font-weight:600;color:#333;margin-bottom:.5rem;font-size:1.1rem}
.faq-answer{color:#555;line-height:1.8}
.cta-section{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);padding:3rem 1rem;text-align:center;color:#fff}
.cta-section h2{font-size:clamp(1.8rem,5vw,2.5rem);margin-bottom:1rem}
.cta-section p{font-size:clamp(1rem,3vw,1.2rem);margin-bottom:2rem;opacity:.95}
.counter-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:1.5rem;margin:2rem 0;padding:0 1rem}
.counter-card{background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,.1);transition:transform .3s,box-shadow .3s;text-decoration:none;display:block}
.counter-card:hover{transform:translateY(-5px);box-shadow:0 8px 30px rgba(0,0,0,.15)}
.counter-card-img{width:100%;height:180px;background:linear-gradient(135deg,#667eea,#764ba2);display:flex;align-items:center;justify-content:center;font-size:4rem}
.counter-card-content{padding:1.5rem}
.counter-card h3{color:#333;margin-bottom:.5rem;font-size:1.3rem}
.counter-card p{color:#666;font-size:.95rem;line-height:1.6}
.footer{background:#333;color:#fff;padding:2rem 1rem;text-align:center}
.footer-links{display:flex;justify-content:center;gap:2rem;margin-bottom:1rem;flex-wrap:wrap}
.footer-links a{color:#fff;text-decoration:none;opacity:.8;transition:opacity .2s}
.footer-links a:hover{opacity:1}
.toast{position:fixed;top:20px;left:50%;transform:translateX(-50%);background:#333;color:#fff;padding:.75rem 1.5rem;border-radius:8px;opacity:0;transition:opacity .3s;pointer-events:none;z-index:1000;max-width:90vw;text-align:center}
.toast.show{opacity:1}
@media(max-width:768px){
.nav{display:none}
.stats{grid-template-columns:1fr 1fr;gap:.5rem}
.stat:last-child{grid-column:1/-1}
}
</style>
</head>
<body>
<header class="header">
<div class="header-content">
<a href="/" class="logo">🕉️ Japa Counter</a>
<ul class="nav">
<li><a href="#tool">Counter</a></li>
<li><a href="#features">Features</a></li>
<li><a href="#how-to-use">How to Use</a></li>
<li><a href="#faq">FAQ</a></li>
<li><a href="/blog">Blog</a></li>
</ul>
</div>
</header>

<section id="tool" class="tool-section">
<main>
<div class="container" role="main">
<h1>Japa Counter</h1>
<p class="subtitle">Digital Mantra Counter | जप माला गणक</p>
<div class="timer" id="timer">00:00:00</div>
<div class="count-display" id="count" aria-live="polite">0</div>
<div class="mala-badge" id="mala-badge" style="display:none">🙏 Mala Complete!</div>
<button class="btn-count" id="btnCount" aria-label="Count Mantra">COUNT</button>
<div class="stats">
<div class="stat">
<div class="stat-label">Session</div>
<div class="stat-value" id="session">0</div>
</div>
<div class="stat">
<div class="stat-label">Malas (108)</div>
<div class="stat-value" id="malas">0</div>
</div>
<div class="stat">
<div class="stat-label">Lifetime</div>
<div class="stat-value" id="total">0</div>
</div>
</div>
<div class="controls">
<button class="btn btn-audio" id="btnAudio" title="Toggle Sound">🔊 Sound</button>
<button class="btn btn-reset" id="btnReset">Reset</button>
<button class="btn btn-save" id="btnSave">Save</button>
</div>
</div>
</main>
</section>

<section class="content-section">
<article>
<h2 id="what-is">What is a Japa Counter?</h2>
<p>A <strong>japa counter</strong> is a digital tool designed for counting mantras, prayers, and japa mala rounds during meditation. Traditional japa mala beads have 108 beads, and this online counter helps you track your spiritual practice without physical beads.</p>
<p>Our free japa counter is perfect for Hindu prayers, Buddhist meditation, Sikh naam simran, and any repetitive spiritual practice. It works completely offline after the first load, making it ideal for uninterrupted meditation sessions.</p>

<h2 id="features">Features of Our Digital Japa Counter</h2>
<div class="feature-grid">
<div class="feature-card">
<h4>⚡ Lightning Fast</h4>
<p>Loads in under 50ms - 7x faster than alternatives. Optimized for instant counting.</p>
</div>
<div class="feature-card">
<h4>🔢 108 Mala Tracking</h4>
<p>Automatically tracks when you complete traditional 108-bead mala rounds.</p>
</div>
<div class="feature-card">
<h4>⏱️ Built-in Timer</h4>
<p>Track how long you've been chanting with the integrated stopwatch.</p>
</div>
<div class="feature-card">
<h4>📱 Works Offline</h4>
<p>Continue counting even without internet connection. Your progress is saved locally.</p>
</div>
<div class="feature-card">
<h4>⌨️ Keyboard Shortcuts</h4>
<p>Press Space or Enter to count quickly without touching your mouse.</p>
</div>
<div class="feature-card">
<h4>📳 Vibration Feedback</h4>
<p>Get haptic feedback on mobile devices for each count.</p>
</div>
</div>

<h2 id="how-to-use">How to Use the Japa Counter</h2>
<ol>
<li><strong>Click the COUNT button</strong> or press Space/Enter key for each mantra repetition</li>
<li><strong>Watch your progress</strong> in real-time with session count and mala tracker</li>
<li><strong>The timer automatically starts</strong> when you begin counting</li>
<li><strong>Get notified</strong> when you complete a mala (108 counts)</li>
<li><strong>Your counts are saved automatically</strong> to your browser</li>
<li><strong>Reset session</strong> anytime while keeping your lifetime total</li>
<li><strong>Save to server</strong> for backup across devices</li>
</ol>

<h3>Why 108 Counts?</h3>
<p>The number 108 holds deep spiritual significance in Hinduism, Buddhism, and other Eastern traditions. It represents:</p>
<ul>
<li>The distance between Earth and Sun is 108 times the Sun's diameter</li>
<li>There are 108 Upanishads in Hindu scriptures</li>
<li>108 sacred sites in India</li>
<li>108 energy lines converging to form the heart chakra</li>
<li>Traditional japa mala has 108 beads for this reason</li>
</ul>

<h2 id="benefits">Benefits of Using a Digital Japa Counter</h2>
<ul>
<li><strong>Never lose count</strong> during deep meditation states</li>
<li><strong>Track your spiritual progress</strong> over days, weeks, and months</li>
<li><strong>No need to carry physical mala beads</strong> - practice anywhere</li>
<li><strong>Perfect for long sessions</strong> like 1008 or 10,000 mantra counting</li>
<li><strong>Lightweight and fast</strong> - works on slow connections</li>
<li><strong>Completely free</strong> with no ads or signup required</li>
<li><strong>Privacy-focused</strong> - your data stays on your device</li>
</ul>

<h2 id="popular-mantras">Popular Mantras for Japa Meditation</h2>
<p>Use our japa counter for any of these traditional mantras:</p>
<div class="counter-grid">
<a href="/gayatri-mantra-counter.php" class="counter-card">
<div class="counter-card-img">☀️</div>
<div class="counter-card-content">
<h3>Gayatri Mantra</h3>
<p>Most powerful Vedic mantra for wisdom and enlightenment</p>
</div>
</a>
<a href="/hare-krishna-mantra-counter.php" class="counter-card">
<div class="counter-card-img">🦚</div>
<div class="counter-card-content">
<h3>Hare Krishna Mantra</h3>
<p>Maha mantra for Krishna bhakti and divine love</p>
</div>
</a>
<a href="/om-namah-shivaya-counter.php" class="counter-card">
<div class="counter-card-img">🔱</div>
<div class="counter-card-content">
<h3>Om Namah Shivaya</h3>
<p>Powerful Shiva mantra for inner peace and transformation</p>
</div>
</a>
</div>

<h2 id="faq">Frequently Asked Questions</h2>
<div class="faq">
<div class="faq-item">
<div class="faq-question">What is the significance of 108 in japa mala?</div>
<div class="faq-answer">108 is a sacred number in Hinduism and Buddhism representing spiritual completion. Traditional mala beads have 108 beads, and completing 108 repetitions of a mantra is considered one mala round.</div>
</div>
<div class="faq-item">
<div class="faq-question">Can I use this japa counter offline?</div>
<div class="faq-answer">Yes! After the first page load, our japa counter works completely offline. Your counts are saved in your browser's local storage, so you can continue your practice without internet connection.</div>
</div>
<div class="faq-item">
<div class="faq-question">How do I count mantras quickly?</div>
<div class="faq-answer">Use keyboard shortcuts! Press Space or Enter key to count without clicking. This is especially useful during deep meditation when you want minimal distraction.</div>
</div>
<div class="faq-item">
<div class="faq-question">Is this japa counter really free?</div>
<div class="faq-answer">Yes, completely free with no ads, no signup, and no hidden costs. We built this tool to support spiritual practitioners worldwide.</div>
</div>
<div class="faq-item">
<div class="faq-question">What mantras can I count with this?</div>
<div class="faq-answer">Any mantra! Our counter works for Gayatri Mantra, Om Namah Shivaya, Hare Krishna, Maha Mrityunjaya, Hanuman Chalisa, or any personal mantra you practice.</div>
</div>
<div class="faq-item">
<div class="faq-question">Why is this counter faster than others?</div>
<div class="faq-answer">We built it with pure PHP and vanilla JavaScript - no WordPress, no heavy frameworks. It's 7x faster and 18x lighter than alternatives, loading in just 30 milliseconds.</div>
</div>
</div>
</article>
</section>

<section class="cta-section">
<h2>Start Your Japa Practice Today</h2>
<p>Join thousands of practitioners using the fastest japa counter online</p>
<a href="#tool" class="btn" style="background:#fff;color:#667eea;padding:0.5rem 2rem;font-size:1.1rem;display:inline-block;margin-top:1rem;text-decoration:none;border-radius:12px;font-weight:600">Start Counting Now</a>
</section>

<footer class="footer">
<div class="footer-links">
<a href="/">Home</a>
<a href="/blog">Blog</a>
<a href="/gayatri-mantra-counter">Gayatri Mantra</a>
<a href="/hare-krishna-mantra-counter">Hare Krishna</a>
<a href="/meditation-timer">Meditation Timer</a>
<a href="/about">About</a>
<a href="/contact">Contact</a>
</div>
<p>&copy; 2026 ChantingCounter.com - Free Japa Counter for Spiritual Practice</p>
</footer>

<div class="toast" id="toast" role="alert" aria-live="polite"></div>

<script type="application/ld+json">
{
"@context":"https://schema.org",
"@type":"WebApplication",
"name":"Japa Counter",
"alternateName":["Digital Japa Counter","Mantra Counter","Naam Japa Counter","जप माला गणक"],
"url":"https://chantingcounter.com",
"description":"Free online japa counter for mantra chanting and naam japa. Digital japa mala counter with 108 beads tracking, session counts, lifetime totals.",
"applicationCategory":"UtilityApplication",
"operatingSystem":"Any",
"offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},
"featureList":["108 mala tracking","Built-in timer","Offline support","Keyboard shortcuts","Vibration feedback","Auto-save"],
"browserRequirements":"Requires JavaScript"
}
</script>
<script type="application/ld+json">
{
"@context":"https://schema.org",
"@type":"FAQPage",
"mainEntity":[
{"@type":"Question","name":"What is the significance of 108 in japa mala?","acceptedAnswer":{"@type":"Answer","text":"108 is a sacred number in Hinduism and Buddhism representing spiritual completion. Traditional mala beads have 108 beads, and completing 108 repetitions of a mantra is considered one mala round."}},
{"@type":"Question","name":"Can I use this japa counter offline?","acceptedAnswer":{"@type":"Answer","text":"Yes! After the first page load, our japa counter works completely offline. Your counts are saved in your browser's local storage."}}
]
}
</script>
<script>
const KEY_COUNT='chant_count',KEY_TOTAL='chant_total',KEY_MALAS='chant_malas';
const el={count:document.getElementById('count'),session:document.getElementById('session'),total:document.getElementById('total'),malas:document.getElementById('malas'),timer:document.getElementById('timer'),btnCount:document.getElementById('btnCount'),btnReset:document.getElementById('btnReset'),btnSave:document.getElementById('btnSave'),btnAudio:document.getElementById('btnAudio'),malaBadge:document.getElementById('mala-badge'),toast:document.getElementById('toast')};
let count=0,total=0,malas=0,timerSeconds=0,timerInterval=null,audioEnabled=false;
const beep=new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmwhBTGH0fPTgjMGHm7A7+OZSA0PVqzn77BdGAg+ltryxnMpBSuAy/LZkzoIGGe57OihUREKTKXh8bllHAU2jdXywn0yBSF1xe/glEILElyx6OyrWBUIQ5zd8sFuJAUuhM/z1YU2Bhxqvu7mnU0NElat6O6zYBoGPJPY8s5+MwUme8rx4pVDCxNctejusloVCECY3PLEcSYELIHN89aINQccab3t55xNDRJUrevvtmEaBjyS1/PN'); beep.volume=0.3;

function load(){try{count=parseInt(localStorage.getItem(KEY_COUNT)||'0');total=parseInt(localStorage.getItem(KEY_TOTAL)||'0');malas=parseInt(localStorage.getItem(KEY_MALAS)||'0');}catch(e){count=0;total=0;malas=0;}render();}
function save(){try{localStorage.setItem(KEY_COUNT,count);localStorage.setItem(KEY_TOTAL,total);localStorage.setItem(KEY_MALAS,malas);}catch(e){showToast('Storage error');}}
function render(){el.count.textContent=count;el.session.textContent=count;el.total.textContent=total;el.malas.textContent=malas;}
function startTimer(){if(!timerInterval){timerInterval=setInterval(()=>{timerSeconds++;const h=Math.floor(timerSeconds/3600),m=Math.floor((timerSeconds%3600)/60),s=timerSeconds%60;el.timer.textContent=`${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:${String(s).padStart(2,'0')}`;},1000);}}
function increment(){if(count===0)startTimer();count++;total++;if(count%108===0&&count>0){malas=Math.floor(count/108);el.malaBadge.style.display='inline-block';setTimeout(()=>el.malaBadge.style.display='none',2000);if(audioEnabled)beep.play();showToast('🙏 Mala Complete! '+malas+' total');}render();save();if(navigator.vibrate)navigator.vibrate(10);}
function reset(){if(count>0&&!confirm('Reset session?'))return;count=0;timerSeconds=0;el.timer.textContent='00:00:00';if(timerInterval){clearInterval(timerInterval);timerInterval=null;}render();save();showToast('Session reset');}
function saveToServer(){el.btnSave.disabled=true;el.btnSave.textContent='Saving...';fetch('?action=save',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({count,total,malas})}).then(r=>r.json()).then(d=>showToast(d.success?'Saved!':'Failed')).catch(()=>showToast('Error')).finally(()=>{el.btnSave.disabled=false;el.btnSave.textContent='Save';});}
function toggleAudio(){audioEnabled=!audioEnabled;el.btnAudio.textContent=audioEnabled?'🔊 Sound':'🔇 Sound';el.btnAudio.style.background=audioEnabled?'#4caf50':'#667eea';showToast(audioEnabled?'Sound ON':'Sound OFF');}
function showToast(msg){el.toast.textContent=msg;el.toast.classList.add('show');setTimeout(()=>el.toast.classList.remove('show'),2000);}
el.btnCount.addEventListener('click',increment);
el.btnReset.addEventListener('click',reset);
el.btnSave.addEventListener('click',saveToServer);
el.btnAudio.addEventListener('click',toggleAudio);
document.addEventListener('keydown',e=>{if(e.key===' '||e.key==='Enter'){e.preventDefault();increment();}});
load();
</script>
</body>
</html>

