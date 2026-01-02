<?php
header('Content-Type: text/html; charset=utf-8');
header('Cache-Control: public, max-age=300');
?><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>About Chanting Counter - Free Online Japa Counter</title>
<meta name="description" content="Learn about ChantingCounter.com - a free, fast, and privacy-focused online japa counter for mantra meditation. Our mission is to support spiritual practitioners worldwide.">
<link rel="canonical" href="https://chantingcounter.com/about/">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:system-ui,-apple-system,sans-serif;line-height:1.6;color:#333;background:#f5f5f5}
.header{background:#fff;box-shadow:0 2px 5px rgba(0,0,0,.1);padding:1rem 0;position:sticky;top:0;z-index:100}
.header-content{max-width:1200px;margin:0 auto;padding:0 1rem;display:flex;justify-content:space-between;align-items:center}
.logo{font-size:1.5rem;font-weight:700;color:#667eea;text-decoration:none}
.nav{display:flex;gap:2rem;list-style:none}
.nav a{color:#333;text-decoration:none;font-weight:500}
.nav a:hover{color:#667eea}
.container{max-width:800px;margin:2rem auto;padding:2rem;background:#fff;border-radius:12px;box-shadow:0 2px 10px rgba(0,0,0,.1)}
h1{font-size:2.5rem;color:#667eea;margin-bottom:1rem}
h2{font-size:1.8rem;color:#333;margin:2rem 0 1rem;padding-left:1rem;border-left:4px solid #667eea}
p{margin-bottom:1rem;font-size:1.05rem}
ul{margin:1rem 0 1rem 2rem}
li{margin:.5rem 0}
.btn{display:inline-block;background:#667eea;color:#fff;padding:.75rem 1.5rem;border-radius:8px;text-decoration:none;font-weight:600;margin-top:1rem}
.btn:hover{background:#5568d3}
.footer{background:#333;color:#fff;padding:2rem 1rem;text-align:center;margin-top:3rem}
.footer a{color:#fff;opacity:.8;text-decoration:none}
.footer a:hover{opacity:1}
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
<li><a href="/">Home</a></li>
<li><a href="/blog.php">Blog</a></li>
<li><a href="/about.php">About</a></li>
<li><a href="/contact.php">Contact</a></li>
</ul>
</div>
</header>

<div class="container">
<h1>About Chanting Counter</h1>
<p>Welcome to <strong>ChantingCounter.com</strong> - your trusted companion for mantra meditation and japa practice. We created this tool to help spiritual practitioners around the world maintain their meditation practice with ease and focus.</p>

<h2>Our Mission</h2>
<p>Our mission is simple: to provide a fast, free, and privacy-focused digital japa counter that works for everyone - from beginners starting their spiritual journey to experienced practitioners counting thousands of mantras daily.</p>
<p>We believe that spiritual tools should be accessible to all, without barriers of cost, complexity, or privacy concerns. That's why ChantingCounter is completely free, works offline, and respects your privacy by keeping your data on your device.</p>

<h2>Why We Built This</h2>
<p>Traditional mala beads are beautiful and meaningful, but they're not always practical for modern practitioners. You might forget your mala at home, lose count during deep meditation, or want to track your long-term progress.</p>
<p>We noticed that most online japa counters were either slow, cluttered with ads, required signup, or were overly complicated. We wanted to create something different:</p>
<ul>
<li><strong>Lightning Fast</strong> - Loads in under 50ms, 7x faster than WordPress alternatives</li>
<li><strong>Privacy-First</strong> - Your data stays on your device, no tracking or analytics</li>
<li><strong>Works Offline</strong> - Practice anywhere without internet connection</li>
<li><strong>Free Forever</strong> - No ads, no premium features, completely free</li>
<li><strong>Simple & Focused</strong> - Clean interface that doesn't distract from your practice</li>
</ul>

<h2>Features for Every Practitioner</h2>
<p>Whether you're chanting the Gayatri Mantra 108 times daily or working towards 10,000 repetitions of a personal mantra, our counter supports your practice with:</p>
<ul>
<li>Visual bead display (108 beads) for traditional mala experience</li>
<li>Circular progress indicator to see your journey through each mala</li>
<li>Daily tracking to build consistent meditation habits</li>
<li>Session tracking for individual practice sessions</li>
<li>Lifetime totals to see your spiritual growth over time</li>
<li>Built-in timer to track meditation duration</li>
<li>Keyboard shortcuts for hands-free counting</li>
<li>Vibration and sound feedback for confirmation</li>
</ul>

<h2>Built for Speed</h2>
<p>We're passionate about performance. Our counter is built with pure PHP and vanilla JavaScript - no bloated frameworks or WordPress overhead. This means:</p>
<ul>
<li>30-50ms load time (compared to 300-500ms for competitors)</li>
<li>Works smoothly on older phones and slow connections</li>
<li>Minimal battery drain for long meditation sessions</li>
<li>Instant counting with no lag or delays</li>
</ul>

<h2>Respecting Tradition</h2>
<p>While we embrace modern technology, we deeply respect the spiritual traditions behind japa meditation. The number 108 appears throughout Hindu, Buddhist, and Jain traditions as a sacred number representing spiritual completion.</p>
<p>Our counter incorporates this wisdom while making it accessible to modern practitioners. The visual bead display, mala completion celebrations, and traditional 108-count tracking all honor the ancient practice of japa meditation.</p>

<h2>Who We Serve</h2>
<p>ChantingCounter is designed for anyone who practices mantra meditation, including:</p>
<ul>
<li>Hindu devotees chanting Gayatri Mantra, Om Namah Shivaya, or deity mantras</li>
<li>Krishna consciousness practitioners chanting the Hare Krishna Maha Mantra</li>
<li>Buddhist practitioners with mala meditation</li>
<li>Sikh followers practicing Naam Simran</li>
<li>Anyone interested in mantra meditation and japa practice</li>
</ul>

<h2>Our Commitment to Privacy</h2>
<p>Unlike many free tools online, we don't track you, sell your data, or show ads. Your meditation practice is personal and sacred - we respect that. All your counts are stored locally in your browser, and we only save to our server when you explicitly choose to backup your data.</p>

<h2>Open to Feedback</h2>
<p>We're constantly improving ChantingCounter based on feedback from practitioners like you. If you have suggestions, find bugs, or want to share your experience, we'd love to hear from you.</p>

<a href="/contact.php" class="btn">Contact Us</a>
<a href="/" class="btn">Try the Counter</a>
</div>

<footer class="footer">
<p>&copy; 2026 ChantingCounter.com - Supporting spiritual practitioners worldwide</p>
<p><a href="/">Home</a> | <a href="/blog.php">Blog</a> | <a href="/about.php">About</a> | <a href="/contact.php">Contact</a></p>
</footer>
<script>
function toggleMenu(){const n=document.getElementById('nav'),h=document.getElementById('hamburger');if(n)n.classList.toggle('active');if(h)h.classList.toggle('active')}
</script>
</body>
</html>