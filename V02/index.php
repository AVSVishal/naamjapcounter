<?php
header('Content-Type: text/html; charset=utf-8');
header('Cache-Control: public, max-age=300');

$action = $_GET['action'] ?? '';
$response = ['success' => false];

if ($action === 'save' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if (isset($data['count']) && isset($data['total']) && isset($data['malas']) && isset($data['daily'])) {
        $today = date('Y-m-d');
        $save = [
            'count' => (int)$data['count'],
            'total' => (int)$data['total'],
            'malas' => (int)$data['malas'],
            'daily' => (int)$data['daily'],
            'lastDate' => $today,
            'timestamp' => time()
        ];
        
        if (@file_put_contents('counter_data.json', json_encode($save)) === false) {
            $response = ['success' => false, 'error' => 'Could not save data'];
        } else {
            $response = ['success' => true];
        }
    }
    header('Content-Type: application/json; charset=utf-8');
    header('Cache-Control: no-cache, no-store, must-revalidate');
    echo json_encode($response);
    exit;
}

if ($action === 'load') {
    if (file_exists('counter_data.json') && is_readable('counter_data.json')) {
        $response = json_decode(file_get_contents('counter_data.json'), true);
        $today = date('Y-m-d');
        if (isset($response['lastDate']) && $response['lastDate'] !== $today) {
            $response['daily'] = 0;
        }
    }
    header('Content-Type: application/json; charset=utf-8');
    header('Cache-Control: no-cache, no-store, must-revalidate');
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
<title>Free Online Japa Counter - 108 Mala Tracker for Meditation</title>
<meta name="description" content="Digital japa counter with 108 mala tracking, visual beads, and daily goals. Free online mantra counter for Hindu prayers and Buddhist meditation. Works offline.">
<meta name="keywords" content="japa counter online, 108 japa counter, naam japa counter, mala counter, digital japa counter, mantra counter, free japa counter, meditation counter">
<meta name="author" content="ChantingCounter.com">
<meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1">
<link rel="canonical" href="https://chantingcounter.com/">
<meta property="og:locale" content="en_US">
<meta property="og:type" content="website">
<meta property="og:title" content="Free Online Japa Counter - 108 Mala Tracker">
<meta property="og:description" content="Digital japa counter with 108 mala tracking. Free online mantra counter for meditation and naam japa.">
<meta property="og:url" content="https://chantingcounter.com/">
<meta property="og:site_name" content="ChantingCounter.com">
<meta property="og:image" content="https://chantingcounter.com/og-image.jpg">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="Japa Counter - Digital Mantra Meditation Tool">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Free Online Japa Counter - 108 Mala Tracker">
<meta name="twitter:description" content="Digital japa counter with 108 mala tracking. Free online mantra counter.">
<meta name="twitter:image" content="https://chantingcounter.com/twitter-image.jpg">
<meta name="twitter:image:alt" content="Free Online Japa Counter for Mantra Chanting">
<style>
*{margin:0;padding:0;box-sizing:border-box}
html{font-size:16px;scroll-behavior:smooth}
body{font-family:system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);min-height:100vh;padding:0;margin:0;color:#333}
.header{background:rgba(255,255,255,.98);backdrop-filter:blur(10px);box-shadow:0 2px 10px rgba(0,0,0,.1);position:sticky;top:0;z-index:100;padding:.75rem 0}
.header-content{max-width:1200px;margin:0 auto;padding:0 1rem;display:flex;justify-content:space-between;align-items:center}
.logo{font-size:1.5rem;font-weight:700;color:#667eea;text-decoration:none;display:flex;align-items:center;gap:.5rem}
.nav{display:flex;gap:1.5rem;list-style:none}
.nav a{color:#333;text-decoration:none;font-weight:500;transition:color .2s;font-size:.95rem;padding:.5rem}
.nav a:hover{color:#667eea}
.nav a:focus{outline:2px solid #667eea;outline-offset:2px;border-radius:4px}
.hamburger{display:none;flex-direction:column;gap:4px;cursor:pointer;padding:.5rem;background:none;border:none}
.hamburger span{width:24px;height:2px;background:#333;transition:all .3s;border-radius:2px}
.hamburger:focus{outline:2px solid #667eea;outline-offset:2px;border-radius:4px}
.tool-section{padding:2rem 1rem;min-height:80vh;display:flex;align-items:center;justify-content:center}
.container{background:rgba(255,255,255,.98);backdrop-filter:blur(10px);border-radius:24px;box-shadow:0 20px 60px rgba(0,0,0,.3);padding:clamp(1.5rem,5vw,2.5rem);max-width:540px;width:100%;text-align:center;position:relative}
h1{font-size:clamp(1.5rem,5vw,2rem);color:#333;margin-bottom:.5rem;font-weight:700;line-height:1.2}
.subtitle{color:#666;font-size:clamp(.85rem,3.5vw,1rem);margin-bottom:1rem}
.timer{font-size:clamp(1rem,4vw,1.2rem);color:#667eea;font-weight:600;margin-bottom:1rem;font-variant-numeric:tabular-nums}
.progress-circle{width:clamp(240px,70vw,280px);height:clamp(240px,70vw,280px);margin:0 auto 1.5rem;position:relative}
.progress-ring{transform:rotate(-90deg)}
.progress-ring-circle{transition:stroke-dashoffset .3s;fill:none;stroke:#e0e0e0;stroke-width:8}
.progress-ring-progress{fill:none;stroke:#667eea;stroke-width:8;stroke-linecap:round;transition:stroke-dashoffset .3s ease}
.count-display{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);font-size:clamp(3.5rem,12vw,5rem);font-weight:700;color:#333;font-variant-numeric:tabular-nums;letter-spacing:-0.05em;line-height:1;transition:transform .1s}
.count-display.pulse{animation:pulse .3s ease}
@keyframes pulse{0%{transform:translate(-50%,-50%) scale(1)}50%{transform:translate(-50%,-50%) scale(1.1)}100%{transform:translate(-50%,-50%) scale(1)}}
.mala-badge{display:inline-block;background:linear-gradient(135deg,#ffd700,#ffed4e);color:#333;padding:.5rem 1rem;border-radius:20px;font-size:.9rem;font-weight:600;margin:.5rem 0;box-shadow:0 4px 15px rgba(255,215,0,.3);opacity:0;transition:opacity .3s;position:absolute;top:-20px;left:50%;transform:translateX(-50%);white-space:nowrap}
.mala-badge.show{opacity:1}
.beads-container{display:grid;grid-template-columns:repeat(12,1fr);gap:3px;margin:1rem 0;padding:1rem;background:rgba(245,243,255,.5);border-radius:12px}
.bead{width:8px;height:8px;border-radius:50%;background:#c4b5fd;transition:all .3s}
.bead.completed{background:#4caf50;box-shadow:0 0 6px rgba(76,175,80,.6);transform:scale(1.2)}
.btn-count{width:clamp(140px,35vw,180px);height:clamp(140px,35vw,180px);min-width:44px;min-height:44px;border-radius:50%;border:none;background:linear-gradient(135deg,#ff6b35,#f7931e);color:#fff;font-size:clamp(1.25rem,5vw,1.75rem);font-weight:700;cursor:pointer;box-shadow:0 10px 30px rgba(255,107,53,.4);transition:transform .1s,box-shadow .1s;touch-action:manipulation;margin:1rem auto;display:flex;align-items:center;justify-content:center}
.btn-count:hover{transform:scale(1.02);box-shadow:0 12px 35px rgba(255,107,53,.5)}
.btn-count:focus{outline:3px solid #fff;outline-offset:3px}
.btn-count:active{transform:scale(.95);box-shadow:0 5px 15px rgba(255,107,53,.4)}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:clamp(.5rem,2vw,.75rem);margin:1.5rem 0}
.stat{background:#f8f9fa;padding:clamp(.75rem,3vw,1rem);border-radius:12px;transition:transform .2s}
.stat:hover{transform:translateY(-2px)}
.stat-label{font-size:clamp(.7rem,2.5vw,.8rem);color:#666;margin-bottom:.3rem}
.stat-value{font-size:clamp(1.1rem,4vw,1.4rem);font-weight:700;color:#333}
.controls{display:flex;flex-wrap:wrap;gap:.5rem;justify-content:center;margin-top:1rem}
.btn{padding:clamp(.7rem,2.5vw,.85rem) clamp(1rem,3.5vw,1.4rem);min-height:44px;min-width:44px;border:none;border-radius:12px;font-size:clamp(.85rem,3vw,.95rem);font-weight:600;cursor:pointer;transition:all .2s;touch-action:manipulation;white-space:nowrap}
.btn:hover{transform:translateY(-1px);box-shadow:0 4px 8px rgba(0,0,0,.15)}
.btn:focus{outline:2px solid #667eea;outline-offset:2px}
.btn-reset{background:#e0e0e0;color:#333}
.btn-reset:active{background:#d0d0d0}
.btn-save{background:#4caf50;color:#fff}
.btn-save:active{background:#45a049}
.btn-audio{background:#667eea;color:#fff}
.btn-audio:active{background:#5568d3}
.content-section{max-width:900px;margin:0 auto;padding:clamp(2rem,5vw,3rem) clamp(1rem,3vw,1.5rem);background:#fff}
.content-section h2{font-size:clamp(1.5rem,4vw,2rem);color:#333;margin:2rem 0 1rem;padding-left:1rem;border-left:4px solid #667eea}
.content-section h3{font-size:clamp(1.2rem,3.5vw,1.5rem);color:#333;margin:1.5rem 0 .75rem}
.content-section p{line-height:1.8;color:#555;margin-bottom:1rem;font-size:clamp(.95rem,2.5vw,1.05rem)}
.content-section ul,.content-section ol{margin:1rem 0 1rem clamp(1.5rem,4vw,2rem);line-height:1.8}
.content-section li{margin:.5rem 0;color:#555;font-size:clamp(.95rem,2.5vw,1rem)}
.feature-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:1.5rem;margin:2rem 0}
.feature-card{background:#f8f9fa;padding:1.5rem;border-radius:12px;border-left:4px solid #667eea;transition:transform .2s}
.feature-card:hover{transform:translateY(-3px)}
.feature-card h4{color:#667eea;margin-bottom:.5rem}
.faq{margin:2rem 0}
.faq-item{background:#f8f9fa;padding:1.5rem;border-radius:12px;margin-bottom:1rem}
.faq-question{font-weight:600;color:#333;margin-bottom:.5rem;font-size:clamp(1rem,3vw,1.1rem)}
.faq-answer{color:#555;line-height:1.8;font-size:clamp(.95rem,2.5vw,1rem)}
.cta-section{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);padding:clamp(2rem,5vw,3rem) 1rem;text-align:center;color:#fff}
.cta-section h2{font-size:clamp(1.8rem,5vw,2.5rem);margin-bottom:1rem}
.cta-section p{font-size:clamp(1rem,3vw,1.2rem);margin-bottom:2rem;opacity:.95}
.footer{background:#333;color:#fff;padding:2rem 1rem;text-align:center}
.footer-links{display:flex;justify-content:center;gap:clamp(1rem,3vw,2rem);margin-bottom:1rem;flex-wrap:wrap}
.footer-links a{color:#fff;text-decoration:none;opacity:.8;transition:opacity .2s;padding:.5rem}
.footer-links a:hover{opacity:1}
.footer-links a:focus{outline:2px solid #fff;outline-offset:2px;border-radius:4px}
.toast{position:fixed;top:20px;left:50%;transform:translateX(-50%);background:#333;color:#fff;padding:.75rem 1.5rem;border-radius:8px;opacity:0;transition:opacity .3s;pointer-events:none;z-index:1000;max-width:90vw;text-align:center;font-size:clamp(.9rem,3vw,1rem)}
.toast.show{opacity:1}
@media(max-width:768px){
.nav{display:none;position:absolute;top:100%;left:0;right:0;background:rgba(255,255,255,.98);flex-direction:column;gap:0;padding:1rem;box-shadow:0 4px 10px rgba(0,0,0,.1)}
.nav.active{display:flex}
.nav a{padding:.75rem}
.hamburger{display:flex}
.hamburger.active span:nth-child(1){transform:rotate(45deg) translate(6px,6px)}
.hamburger.active span:nth-child(2){opacity:0}
.hamburger.active span:nth-child(3){transform:rotate(-45deg) translate(6px,-6px)}
.stats{grid-template-columns:repeat(2,1fr)}
.beads-container{grid-template-columns:repeat(9,1fr);gap:2px}
.bead{width:6px;height:6px}
.content-section{padding:2rem 1rem}
.content-section ul,.content-section ol{margin-left:1.5rem}
}
@media(max-width:480px){
.stats{gap:.4rem}
.progress-circle{width:220px;height:220px}
.beads-container{padding:.75rem}
}
@media(max-width:375px){
.logo{font-size:1.25rem}
.controls{gap:.4rem}
.btn{padding:.7rem .9rem;font-size:.85rem}
}
@media(orientation:landscape) and (max-height:500px){
body{padding:.5rem}
.tool-section{padding:1rem;min-height:auto}
.container{padding:1rem}
.progress-circle{width:180px;height:180px}
.beads-container{display:none}
.stats{margin:1rem 0;gap:.5rem}
}
</style>
</head>
<body>
<header class="header">
<div class="header-content">
<a href="/" class="logo">🕉️ Japa Counter</a>
<button class="hamburger" id="hamburger" onclick="toggleMenu()" aria-label="Toggle menu">
<span></span>
<span></span>
<span></span>
</button>
<ul class="nav" id="nav">
<li><a href="#tool">Counter</a></li>
<li><a href="#features">Features</a></li>
<li><a href="#how-to-use">How to Use</a></li>
<li><a href="#faq">FAQ</a></li>
<li><a href="/blog/">Blog</a></li>
</ul>
</div>
</header>

<section id="tool" class="tool-section">
<main>
<div class="container" role="main">
<div class="mala-badge" id="mala-badge">🙏 Mala Complete!</div>
<h1>Japa Counter</h1>
<p class="subtitle">Digital Mantra Counter | जप माला गणक</p>
<div class="timer" id="timer">00:00:00</div>

<div class="progress-circle">
<svg class="progress-ring" width="280" height="280">
<circle class="progress-ring-circle" cx="140" cy="140" r="130"></circle>
<circle class="progress-ring-progress" id="progress" cx="140" cy="140" r="130"></circle>
</svg>
<div class="count-display" id="count" aria-live="polite" aria-atomic="true">0</div>
</div>

<div class="beads-container" id="beads" aria-label="108 mala beads visualization"></div>

<button class="btn-count" id="btnCount" aria-label="Count one mantra repetition">COUNT</button>

<div class="stats">
<div class="stat">
<div class="stat-label">Session</div>
<div class="stat-value" id="session" aria-live="polite">0</div>
</div>
<div class="stat">
<div class="stat-label">Malas</div>
<div class="stat-value" id="malas" aria-live="polite">0</div>
</div>
<div class="stat">
<div class="stat-label">Today</div>
<div class="stat-value" id="daily" aria-live="polite">0</div>
</div>
<div class="stat">
<div class="stat-label">Lifetime</div>
<div class="stat-value" id="total" aria-live="polite">0</div>
</div>
</div>

<div class="controls">
<button class="btn btn-audio" id="btnAudio" title="Toggle sound" aria-label="Toggle sound on mala completion">
<span id="audioIcon">🔊</span> Sound
</button>
<button class="btn btn-reset" id="btnReset" aria-label="Reset session count">Reset</button>
<button class="btn btn-save" id="btnSave" aria-label="Save counts to server">Save</button>
</div>
</div>
</main>
</section>

<section class="content-section">
<article>
<h2 id="what-is">What is an Online Japa Counter?</h2>
<p>Think of it as digital prayer beads. A <strong>japa counter</strong> helps you keep track of how many times you've repeated a mantra during meditation—no need to worry about losing count when you go deep into practice.</p>
<p>Traditional japa mala has 108 beads (one for each repetition), and this online version gives you the same experience, plus some helpful extras like automatic tracking and visual feedback. Whether you're new to mantra meditation or have been practicing for years, it works the same simple way.</p>

<h2 id="features">Why People Like This Counter</h2>
<div class="feature-grid">
<div class="feature-card">
<h4>⚡ Loads Instantly</h4>
<p>No waiting around. The counter's ready the moment you open it, so you can start meditating right away.</p>
</div>
<div class="feature-card">
<h4>🔢 See Your Progress</h4>
<p>Watch each of the 108 beads light up as you count. It's satisfying to see a mala round complete.</p>
</div>
<div class="feature-card">
<h4>📊 Circular Visual</h4>
<p>The progress ring fills up as you chant, giving you a clear sense of where you are in the round.</p>
</div>
<div class="feature-card">
<h4>📅 Daily Goals</h4>
<p>Track how much you practice each day. Resets at midnight so you can build a consistent habit.</p>
</div>
<div class="feature-card">
<h4>⏱️ Built-in Timer</h4>
<p>See how long your sessions are. Sometimes it's nice to know you meditated for 20 minutes, sometimes an hour flies by.</p>
</div>
<div class="feature-card">
<h4>📱 Works Offline</h4>
<p>After it loads once, you're all set. No WiFi needed, so you can meditate anywhere without distractions.</p>
</div>
<div class="feature-card">
<h4>⌨️ Space Bar Works</h4>
<p>Just hit Space or Enter to count—no need to click. Keeps you in the flow when you're deep in meditation.</p>
</div>
<div class="feature-card">
<h4>📳 Gentle Feedback</h4>
<p>Your phone gives a tiny vibration with each count (if you have it on). It's subtle but reassuring.</p>
</div>
</div>

<h2 id="how-to-use">How to Use the Counter</h2>
<ol>
<li><strong>Click COUNT</strong> (or press Space/Enter) each time you complete a mantra</li>
<li><strong>Watch the beads light up</strong> as you progress through your 108 repetitions</li>
<li><strong>The timer starts automatically</strong> when you begin—no need to do anything</li>
<li><strong>You'll get a little celebration</strong> when you finish a full mala (108 counts)</li>
<li><strong>Everything saves automatically</strong> in your browser so you never lose your place</li>
<li><strong>Daily count resets at midnight</strong> but your lifetime total keeps growing</li>
<li><strong>Reset anytime</strong> to start a fresh session (your totals stay safe)</li>
<li><strong>Save to server</strong> if you want a backup</li>
</ol>

<h3>Why 108?</h3>
<p>The number 108 pops up everywhere in Eastern spiritual traditions. It's not random—there's something special about it:</p>
<ul>
<li>The distance from Earth to the Sun is roughly 108 times the Sun's diameter</li>
<li>There are 108 Upanishads (ancient Hindu texts)</li>
<li>Sanskrit has 54 letters, each with a masculine and feminine form—that's 108 total</li>
<li>In yoga, there are 108 energy lines that meet at the heart chakra</li>
<li>A traditional mala has 108 beads because of all this sacred significance</li>
</ul>

<h2 id="benefits">What Makes This Helpful</h2>
<ul>
<li><strong>Stop worrying about losing count</strong> when you slip into deep meditation—the counter remembers for you</li>
<li><strong>See your practice grow over time</strong>. It's motivating to watch those numbers add up day after day</li>
<li><strong>Meditate anywhere</strong> without carrying beads. Just pull out your phone and you're ready</li>
<li><strong>Perfect for long sessions</strong>. Going for 1,008 repetitions? The counter handles it easily</li>
<li><strong>Visual feedback keeps you engaged</strong> with the progress circle and bead display</li>
<li><strong>Daily tracking helps build habits</strong>. Seeing that today's count builds consistency</li>
<li><strong>Fast and lightweight</strong>. Works smoothly even on older phones or slow connections</li>
<li><strong>Genuinely free</strong>. No surprise costs, no ads interrupting your practice, no account needed</li>
<li><strong>Your data stays with you</strong>. Everything's on your device unless you choose to backup</li>
</ul>

<h2 id="faq">Common Questions</h2>
<div class="faq">
<div class="faq-item">
<div class="faq-question">Why is 108 significant in meditation?</div>
<div class="faq-answer">It's a sacred number across Hindu, Buddhist, and Jain traditions, representing spiritual wholeness. One complete mala round is 108 repetitions because the number appears throughout ancient texts, astronomy, and yoga philosophy. It's less about the exact reasons and more about honoring a tradition that's been meaningful for thousands of years.</div>
</div>
<div class="faq-item">
<div class="faq-question">Will this work without internet?</div>
<div class="faq-answer">Yes! Once the page loads that first time, everything works offline. Your counts get saved right in your browser, so you can meditate anywhere—on a plane, in the mountains, wherever—without worrying about WiFi.</div>
</div>
<div class="faq-item">
<div class="faq-question">How do I count faster?</div>
<div class="faq-answer">Use your Space bar or Enter key instead of clicking. This is especially nice when you're in a focused state and don't want to break the flow by moving your mouse around.</div>
</div>
<div class="faq-item">
<div class="faq-question">Is this really free?</div>
<div class="faq-answer">Completely. No ads, no sign-up forms, no "premium version" upsells. I built this because I wanted a simple, clean counter for my own practice, and figured others might appreciate it too.</div>
</div>
<div class="faq-item">
<div class="faq-question">Which mantras work with this?</div>
<div class="faq-answer">Any mantra you practice. Gayatri, Om Namah Shivaya, Hare Krishna, or something personal—it all works the same way. The counter doesn't care what you're saying, it just helps you keep track.</div>
</div>
<div class="faq-item">
<div class="faq-question">How does daily tracking work?</div>
<div class="faq-answer">Your daily count resets automatically at midnight, while everything else (session, total, malas) keeps going. It's helpful for building a consistent practice—you can see if you hit your daily goal or need to catch up tomorrow.</div>
</div>
<div class="faq-item">
<div class="faq-question">What are those little beads for?</div>
<div class="faq-answer">They're a visual representation of a traditional 108-bead mala. As you count, they light up green one by one, so you can see exactly where you are in the round. Some people find it more satisfying than just watching numbers go up.</div>
</div>
</div>
</article>
</section>

<section class="cta-section">
<h2>Ready to Start?</h2>
<p>Whether this is your first time or your thousandth mala, the counter's ready when you are</p>
<a href="#tool" class="btn" style="background:#fff;color:#667eea;padding:1rem 2rem;font-size:1.1rem;display:inline-block;margin-top:1rem;text-decoration:none;border-radius:12px;font-weight:600">Begin Counting</a>
</section>

<footer class="footer">
<div class="footer-links">
<a href="/">Home</a>
<a href="/blog/">Blog</a>
<a href="/about/">About</a>
<a href="/contact/">Contact</a>
</div>
<p>&copy; 2026 ChantingCounter.com</p>
</footer>

<div class="toast" id="toast" role="alert" aria-live="polite" aria-atomic="true"></div>

<script type="application/ld+json">
{
"@context":"https://schema.org",
"@type":"WebApplication",
"name":"Japa Counter",
"alternateName":["Digital Japa Counter","Mantra Counter","Naam Japa Counter","108 Mala Counter","जप माला गणक","मंत्र गणक"],
"url":"https://chantingcounter.com",
"description":"Free online japa counter for mantra chanting and naam japa. Digital japa mala counter with 108 beads tracking, visual progress indicator, daily tracking, and lifetime totals.",
"applicationCategory":"UtilityApplication",
"operatingSystem":"Any",
"offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},
"featureList":["108 mala tracking","Visual bead display","Circular progress indicator","Daily japa tracking","Built-in timer","Offline support","Keyboard shortcuts","Vibration feedback","Auto-save","Sound effects"],
"browserRequirements":"Requires JavaScript",
"author":{"@type":"Organization","name":"ChantingCounter.com","url":"https://chantingcounter.com"}
}
</script>
<script type="application/ld+json">
{
"@context":"https://schema.org",
"@type":"FAQPage",
"mainEntity":[
{"@type":"Question","name":"Why is 108 significant in meditation?","acceptedAnswer":{"@type":"Answer","text":"It's a sacred number across Hindu, Buddhist, and Jain traditions, representing spiritual wholeness. One complete mala round is 108 repetitions because the number appears throughout ancient texts, astronomy, and yoga philosophy."}},
{"@type":"Question","name":"Will this work without internet?","acceptedAnswer":{"@type":"Answer","text":"Yes! Once the page loads that first time, everything works offline. Your counts get saved right in your browser."}},
{"@type":"Question","name":"How do I count faster?","acceptedAnswer":{"@type":"Answer","text":"Use your Space bar or Enter key instead of clicking. This is especially nice when you're in a focused state."}},
{"@type":"Question","name":"Is this really free?","acceptedAnswer":{"@type":"Answer","text":"Completely. No ads, no sign-up forms, no premium version upsells. Built for practitioners who want a simple, clean counter."}},
{"@type":"Question","name":"Which mantras work with this?","acceptedAnswer":{"@type":"Answer","text":"Any mantra you practice. Gayatri, Om Namah Shivaya, Hare Krishna, or something personal—it all works the same way."}},
{"@type":"Question","name":"How does daily tracking work?","acceptedAnswer":{"@type":"Answer","text":"Your daily count resets automatically at midnight, while everything else keeps going. Helpful for building a consistent practice."}},
{"@type":"Question","name":"What are those little beads for?","acceptedAnswer":{"@type":"Answer","text":"They're a visual representation of a traditional 108-bead mala. As you count, they light up green one by one."}}
]
}
</script>
<script>
function toggleMenu(){const n=document.getElementById('nav'),h=document.getElementById('hamburger');n.classList.toggle('active');h.classList.toggle('active')}

const KEY_COUNT='chant_count',KEY_TOTAL='chant_total',KEY_MALAS='chant_malas',KEY_DAILY='chant_daily',KEY_DATE='chant_date';
const el={count:document.getElementById('count'),session:document.getElementById('session'),total:document.getElementById('total'),malas:document.getElementById('malas'),daily:document.getElementById('daily'),timer:document.getElementById('timer'),btnCount:document.getElementById('btnCount'),btnReset:document.getElementById('btnReset'),btnSave:document.getElementById('btnSave'),btnAudio:document.getElementById('btnAudio'),audioIcon:document.getElementById('audioIcon'),malaBadge:document.getElementById('mala-badge'),toast:document.getElementById('toast'),progress:document.getElementById('progress'),beads:document.getElementById('beads')};
let count=0,total=0,malas=0,daily=0,timerSeconds=0,timerInterval=null,audioEnabled=false;
const circumference=2*Math.PI*130;
el.progress.style.strokeDasharray=`${circumference} ${circumference}`;
el.progress.style.strokeDashoffset=circumference;

function initBeads(){for(let i=0;i<108;i++){const b=document.createElement('div');b.className='bead';b.id='bead-'+i;b.setAttribute('aria-hidden','true');el.beads.appendChild(b)}}

function updateBeads(){const current=count%108;for(let i=0;i<108;i++){const b=document.getElementById('bead-'+i);if(i<current)b.classList.add('completed');else b.classList.remove('completed')}}

function updateProgress(){const progress=(count%108)/108;const offset=circumference-(progress*circumference);el.progress.style.strokeDashoffset=offset}

function load(){const today=new Date().toISOString().split('T')[0];const lastDate=localStorage.getItem(KEY_DATE);try{count=parseInt(localStorage.getItem(KEY_COUNT)||'0',10);total=parseInt(localStorage.getItem(KEY_TOTAL)||'0',10);malas=parseInt(localStorage.getItem(KEY_MALAS)||'0',10);daily=parseInt(localStorage.getItem(KEY_DAILY)||'0',10);if(lastDate&&lastDate!==today){daily=0;localStorage.setItem(KEY_DAILY,'0');localStorage.setItem(KEY_DATE,today)}}catch(e){console.error('Load error:',e);count=0;total=0;malas=0;daily=0}render()}

function save(){const today=new Date().toISOString().split('T')[0];try{localStorage.setItem(KEY_COUNT,count.toString());localStorage.setItem(KEY_TOTAL,total.toString());localStorage.setItem(KEY_MALAS,malas.toString());localStorage.setItem(KEY_DAILY,daily.toString());localStorage.setItem(KEY_DATE,today)}catch(e){console.error('Save error:',e);showToast('Could not save locally')}}

function render(){el.count.textContent=count;el.session.textContent=count;el.total.textContent=total;el.malas.textContent=malas;el.daily.textContent=daily;updateBeads();updateProgress()}

function startTimer(){if(!timerInterval){timerInterval=setInterval(()=>{timerSeconds++;const h=Math.floor(timerSeconds/3600),m=Math.floor((timerSeconds%3600)/60),s=timerSeconds%60;el.timer.textContent=`${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:${String(s).padStart(2,'0')}`;},1000)}}

function playBeep(){if(!audioEnabled)return;try{const ctx=new(window.AudioContext||window.webkitAudioContext)();const osc=ctx.createOscillator();const gain=ctx.createGain();osc.connect(gain);gain.connect(ctx.destination);osc.frequency.value=800;gain.gain.value=0.1;osc.start();gain.gain.exponentialRampToValueAtTime(0.01,ctx.currentTime+0.1);osc.stop(ctx.currentTime+0.1)}catch(e){console.error('Audio error:',e)}}

function increment(){if(count===0)startTimer();count++;total++;daily++;el.count.classList.add('pulse');setTimeout(()=>el.count.classList.remove('pulse'),300);if(count%108===0&&count>0){malas=Math.floor(count/108);el.malaBadge.classList.add('show');setTimeout(()=>el.malaBadge.classList.remove('show'),2000);playBeep();showToast(`🙏 Mala Complete! ${malas} total`)}render();save();if(navigator.vibrate)navigator.vibrate(10)}

function reset(){if(count>0&&!confirm('Reset your session count? (Daily and lifetime totals stay safe)'))return;count=0;timerSeconds=0;el.timer.textContent='00:00:00';if(timerInterval){clearInterval(timerInterval);timerInterval=null}render();save();showToast('Session reset')}

function saveToServer(){el.btnSave.disabled=true;const originalText=el.btnSave.textContent;el.btnSave.textContent='Saving...';fetch('?action=save',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({count,total,malas,daily})}).then(r=>r.json()).then(d=>showToast(d.success?'Saved to server!':d.error||'Could not save')).catch(e=>{console.error('Save error:',e);showToast('Network error - check connection')}).finally(()=>{el.btnSave.disabled=false;el.btnSave.textContent=originalText})}

function toggleAudio(){audioEnabled=!audioEnabled;el.audioIcon.textContent=audioEnabled?'🔊':'🔇';showToast(audioEnabled?'Sound ON':'Sound OFF')}

function showToast(msg){el.toast.textContent=msg;el.toast.classList.add('show');setTimeout(()=>el.toast.classList.remove('show'),2500)}

el.btnCount.addEventListener('click',increment);
el.btnReset.addEventListener('click',reset);
el.btnSave.addEventListener('click',saveToServer);
el.btnAudio.addEventListener('click',toggleAudio);
document.addEventListener('keydown',e=>{if((e.key===' '||e.key==='Enter')&&e.target.tagName!=='BUTTON'&&e.target.tagName!=='A'){e.preventDefault();increment()}});

initBeads();
if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',load)}else{load()}
</script>
</body>
</html>