<?php
/**
 * ChantingCounter.com - Main Page V01
 * Improved Performance, Security & Mobile UX
 */

// Security headers
header('Content-Type: text/html; charset=utf-8');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: SAMEORIGIN');
header('X-XSS-Protection: 1; mode=block');
header('Referrer-Policy: strict-origin-when-cross-origin');

// Generate CSRF token
session_start();
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}
$csrfToken = $_SESSION['csrf_token'];

// Handle API actions
$action = $_GET['action'] ?? '';
$response = ['success' => false];

if ($action === 'save' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    // Verify CSRF token
    $data = json_decode(file_get_contents('php://input'), true);
    $submittedToken = $data['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
    
    if (!hash_equals($csrfToken, $submittedToken)) {
        $response = ['success' => false, 'error' => 'Invalid security token'];
    } else if (isset($data['count']) && isset($data['total']) && isset($data['malas']) && isset($data['daily'])) {
        // Validate data
        $count = filter_var($data['count'], FILTER_VALIDATE_INT);
        $total = filter_var($data['total'], FILTER_VALIDATE_INT);
        $malas = filter_var($data['malas'], FILTER_VALIDATE_INT);
        $daily = filter_var($data['daily'], FILTER_VALIDATE_INT);
        
        if ($count !== false && $total !== false && $malas !== false && $daily !== false) {
            $today = date('Y-m-d');
            $save = [
                'count' => $count,
                'total' => $total,
                'malas' => $malas,
                'daily' => $daily,
                'lastDate' => $today,
                'timestamp' => time()
            ];
            
            // Save to data directory (not public root)
            $dataFile = __DIR__ . '/data/counter_' . session_id() . '.json';
            if (@file_put_contents($dataFile, json_encode($save), LOCK_EX) === false) {
                $response = ['success' => false, 'error' => 'Could not save data'];
            } else {
                $response = ['success' => true];
            }
        } else {
            $response = ['success' => false, 'error' => 'Invalid data'];
        }
    } else {
        $response = ['success' => false, 'error' => 'Missing data'];
    }
    
    header('Content-Type: application/json; charset=utf-8');
    header('Cache-Control: no-cache, no-store, must-revalidate');
    echo json_encode($response);
    exit;
}

if ($action === 'load') {
    $dataFile = __DIR__ . '/data/counter_' . session_id() . '.json';
    if (file_exists($dataFile) && is_readable($dataFile)) {
        $response = json_decode(file_get_contents($dataFile), true);
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

// Set cache header for HTML
header('Cache-Control: public, max-age=300');
?><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#667eea">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

<title>Free Online Japa Counter - Track Your 108 Mala Meditation</title>
<meta name="description" content="Simple digital japa counter for mantra meditation. Track your 108 mala rounds with visual beads, daily goals, and lifetime stats. Works offline, no signup needed.">
<meta name="keywords" content="japa counter online, 108 mala counter, naam japa counter, digital mala counter, mantra counter, free japa counter, meditation counter">
<meta name="author" content="ChantingCounter.com">
<meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1">

<link rel="canonical" href="https://chantingcounter.com/">

<!-- Open Graph -->
<meta property="og:locale" content="en_US">
<meta property="og:type" content="website">
<meta property="og:title" content="Free Online Japa Counter - 108 Mala Tracker">
<meta property="og:description" content="Digital japa counter with 108 mala tracking. Track your mantra meditation practice with visual beads and daily stats.">
<meta property="og:url" content="https://chantingcounter.com/">
<meta property="og:site_name" content="ChantingCounter.com">
<meta property="og:image" content="https://chantingcounter.com/og-image.jpg">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="Japa Counter - Digital Mantra Meditation Tool">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Free Online Japa Counter - 108 Mala Tracker">
<meta name="twitter:description" content="Digital japa counter with 108 mala tracking. Free online mantra counter.">
<meta name="twitter:image" content="https://chantingcounter.com/twitter-image.jpg">
<meta name="twitter:image:alt" content="Free Online Japa Counter for Mantra Chanting">

<!-- PWA Manifest -->
<link rel="manifest" href="/manifest.json">

<!-- Preconnect for performance -->
<link rel="preconnect" href="https://chantingcounter.com">
<link rel="dns-prefetch" href="https://chantingcounter.com">

<!-- Optimized CSS - External for caching -->
<link rel="stylesheet" href="/css/style.min.css">

<!-- CSRF Token -->
<meta name="csrf-token" content="<?php echo htmlspecialchars($csrfToken); ?>">

<!-- Critical CSS inline for above-the-fold content -->
<style>
body{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);min-height:100vh;margin:0;padding:0}
.container{background:rgba(255,255,255,.98);border-radius:24px;max-width:540px;margin:1rem auto;padding:1.5rem}
.count-display{font-size:3.5rem;font-weight:700;color:#333}
.btn-count{width:160px;height:160px;border-radius:50%;background:linear-gradient(135deg,#ff6b35,#f7931e);color:#fff;font-size:1.5rem;font-weight:700;border:none;cursor:pointer}
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

<!-- MOBILE UX FIX: Counter and button together in viewport -->
<div class="count-display-wrapper">
<div class="progress-circle">
<svg class="progress-ring" width="100%" height="100%" viewBox="0 0 280 280">
<circle class="progress-ring-circle" cx="140" cy="140" r="130"></circle>
<circle class="progress-ring-progress" id="progress" cx="140" cy="140" r="130"></circle>
</svg>
<div class="count-display" id="count" aria-live="polite" aria-atomic="true">0</div>
</div>

<button class="btn-count" id="btnCount" aria-label="Count one mantra repetition">COUNT</button>
</div>

<div class="beads-container" id="beads" aria-label="108 mala beads visualization"></div>

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
<h2 id="what-is">What is a Japa Counter?</h2>
<p>It's basically digital prayer beads. I built this after I kept losing count during my morning meditation - super frustrating when you're trying to hit 108 repetitions and have no idea if you're at 47 or 74.</p>
<p>Traditional japa malas have 108 beads (you move one bead for each mantra), and this online version does the same thing, plus it tracks your progress over time. Whether you've been practicing for years or just starting out, it's pretty straightforward to use.</p>

<h2 id="features">Why People Use This</h2>
<div class="feature-grid">
<div class="feature-card">
<h4>⚡ Loads Fast</h4>
<p>No waiting. Opens instantly so you can start your practice right away.</p>
</div>
<div class="feature-card">
<h4>🔢 Visual Progress</h4>
<p>Watch the 108 beads light up as you count. Feels good to see a mala complete.</p>
</div>
<div class="feature-card">
<h4>📊 Circle Tracker</h4>
<p>The progress ring fills up as you chant - gives you a clear sense of where you are.</p>
</div>
<div class="feature-card">
<h4>📅 Daily Tracking</h4>
<p>See how much you practice each day. Resets at midnight to help build consistency.</p>
</div>
<div class="feature-card">
<h4>⏱️ Session Timer</h4>
<p>Tracks how long you've been meditating. Sometimes 20 minutes feels like 5.</p>
</div>
<div class="feature-card">
<h4>📱 Works Offline</h4>
<p>After it loads once, no WiFi needed. Meditate anywhere without distractions.</p>
</div>
<div class="feature-card">
<h4>⌨️ Keyboard Friendly</h4>
<p>Hit Space or Enter to count - no clicking needed. Keeps you in the flow.</p>
</div>
<div class="feature-card">
<h4>📳 Haptic Feedback</h4>
<p>Your phone vibrates gently with each count. Subtle but reassuring.</p>
</div>
</div>

<h2 id="how-to-use">How to Use It</h2>
<ol>
<li><strong>Click COUNT</strong> (or press Space/Enter) after each mantra repetition</li>
<li><strong>The beads light up green</strong> as you progress through 108 repetitions</li>
<li><strong>Timer starts automatically</strong> when you begin - no setup needed</li>
<li><strong>You'll get a notification</strong> when you finish a full mala (108 counts)</li>
<li><strong>Everything saves automatically</strong> in your browser - you won't lose your place</li>
<li><strong>Daily count resets at midnight</strong> but lifetime total keeps growing</li>
<li><strong>Hit Reset anytime</strong> to start a fresh session (your totals stay safe)</li>
<li><strong>Use Save button</strong> if you want a backup on the server</li>
</ol>

<h3>Why 108?</h3>
<p>The number 108 shows up everywhere in Eastern spirituality. Here's why it's considered special:</p>
<ul>
<li>The distance from Earth to the Sun is roughly 108 times the Sun's diameter</li>
<li>There are 108 Upanishads (ancient Hindu texts)</li>
<li>Sanskrit has 54 letters, each with masculine and feminine forms - that's 108 total</li>
<li>In yoga philosophy, 108 energy lines converge at the heart chakra</li>
<li>Traditional malas have 108 beads because of all this sacred significance</li>
</ul>

<h2 id="benefits">What Makes This Useful</h2>
<ul>
<li><strong>Never lose count again</strong> - the counter remembers for you when you go deep into meditation</li>
<li><strong>Track your growth over time</strong> - watching those numbers add up day after day is surprisingly motivating</li>
<li><strong>Meditate anywhere</strong> - no need to carry physical beads everywhere</li>
<li><strong>Handle long sessions easily</strong> - going for 1,008 repetitions? The counter's got you</li>
<li><strong>Visual feedback helps</strong> - progress circle and beads make it more engaging</li>
<li><strong>Build daily habits</strong> - seeing today's count helps you stay consistent</li>
<li><strong>Fast and lightweight</strong> - works smoothly even on older phones</li>
<li><strong>Actually free</strong> - no hidden costs, no ads, no signup required</li>
<li><strong>Your data stays yours</strong> - everything's on your device unless you choose to backup</li>
</ul>

<h2 id="faq">Common Questions</h2>
<div class="faq">
<div class="faq-item">
<div class="faq-question">Why is 108 significant in meditation?</div>
<div class="faq-answer">It's a sacred number across Hindu, Buddhist, and Jain traditions, representing spiritual wholeness. One complete mala is 108 repetitions because the number appears throughout ancient texts, astronomy, and yoga philosophy. Honestly, the exact reasons matter less than honoring a tradition that's been meaningful for thousands of years.</div>
</div>
<div class="faq-item">
<div class="faq-question">Will this work without internet?</div>
<div class="faq-answer">Yes! Once the page loads that first time, everything works offline. Your counts save right in your browser, so you can meditate on a plane, in the mountains, wherever - no WiFi needed.</div>
</div>
<div class="faq-item">
<div class="faq-question">How do I count faster?</div>
<div class="faq-answer">Use your Space bar or Enter key instead of clicking. This is especially nice when you're focused and don't want to break concentration by moving your mouse around.</div>
</div>
<div class="faq-item">
<div class="faq-question">Is this really free?</div>
<div class="faq-answer">Completely. No ads, no sign-up forms, no "premium version" trying to upsell you. I built this for my own meditation practice and figured others might find it useful too.</div>
</div>
<div class="faq-item">
<div class="faq-question">Which mantras work with this?</div>
<div class="faq-answer">Any mantra you practice. Gayatri, Om Namah Shivaya, Hare Krishna, or something personal - it all works the same way. The counter doesn't care what you're chanting, it just helps you keep track.</div>
</div>
<div class="faq-item">
<div class="faq-question">How does daily tracking work?</div>
<div class="faq-answer">Your daily count resets automatically at midnight, while everything else (session, total, malas) keeps going. It helps you see if you're hitting your daily practice goals or need to catch up tomorrow.</div>
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
<p>&copy; 2026 ChantingCounter.com | Made with 🙏 for practitioners</p>
</footer>

<div class="toast" id="toast" role="alert" aria-live="polite" aria-atomic="true"></div>

<!-- Schema.org structured data -->
<script type="application/ld+json">
{
"@context": "https://schema.org",
"@type": "WebApplication",
"name": "Japa Counter",
"alternateName": ["Digital Japa Counter", "Mantra Counter", "Naam Japa Counter", "108 Mala Counter", "जप माला गणक", "मंत्र गणक"],
"url": "https://chantingcounter.com",
"description": "Free online japa counter for mantra chanting and naam japa. Digital japa mala counter with 108 beads tracking, visual progress indicator, daily tracking, and lifetime totals.",
"applicationCategory": "UtilityApplication",
"operatingSystem": "Any",
"offers": {
"@type": "Offer",
"price": "0",
"priceCurrency": "USD"
},
"featureList": ["108 mala tracking", "Visual bead display", "Circular progress indicator", "Daily japa tracking", "Built-in timer", "Offline support", "Keyboard shortcuts", "Vibration feedback", "Auto-save", "Sound effects"],
"browserRequirements": "Requires JavaScript",
"author": {
"@type": "Organization",
"name": "ChantingCounter.com",
"url": "https://chantingcounter.com"
}
}
</script>

<script type="application/ld+json">
{
"@context": "https://schema.org",
"@type": "FAQPage",
"mainEntity": [
{
"@type": "Question",
"name": "Why is 108 significant in meditation?",
"acceptedAnswer": {
"@type": "Answer",
"text": "It's a sacred number across Hindu, Buddhist, and Jain traditions, representing spiritual wholeness. One complete mala round is 108 repetitions because the number appears throughout ancient texts, astronomy, and yoga philosophy."
}
},
{
"@type": "Question",
"name": "Will this work without internet?",
"acceptedAnswer": {
"@type": "Answer",
"text": "Yes! Once the page loads that first time, everything works offline. Your counts get saved right in your browser."
}
},
{
"@type": "Question",
"name": "How do I count faster?",
"acceptedAnswer": {
"@type": "Answer",
"text": "Use your Space bar or Enter key instead of clicking. This is especially nice when you're in a focused state."
}
},
{
"@type": "Question",
"name": "Is this really free?",
"acceptedAnswer": {
"@type": "Answer",
"text": "Completely. No ads, no sign-up forms, no premium version upsells. Built for practitioners who want a simple, clean counter."
}
},
{
"@type": "Question",
"name": "Which mantras work with this?",
"acceptedAnswer": {
"@type": "Answer",
"text": "Any mantra you practice. Gayatri, Om Namah Shivaya, Hare Krishna, or something personal - it all works the same way."
}
},
{
"@type": "Question",
"name": "How does daily tracking work?",
"acceptedAnswer": {
"@type": "Answer",
"text": "Your daily count resets automatically at midnight, while everything else keeps going. Helpful for building a consistent practice."
}
},
{
"@type": "Question",
"name": "What are those little beads for?",
"acceptedAnswer": {
"@type": "Answer",
"text": "They're a visual representation of a traditional 108-bead mala. As you count, they light up green one by one."
}
}
]
}
</script>

<!-- Load optimized JavaScript -->
<script src="/js/counter.min.js" defer></script>

<!-- Google Analytics or other analytics can be added here -->

</body>
</html>
