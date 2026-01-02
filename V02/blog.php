<?php
header('Content-Type: text/html; charset=utf-8');
header('Cache-Control: public, max-age=600');
?><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Blog - Japa Counter & Meditation Guides</title>
<meta name="description" content="Learn about japa meditation, mantra chanting techniques, and spiritual practices. Free guides for beginners and experienced practitioners.">
<link rel="canonical" href="https://chantingcounter.com/blog/">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:system-ui,-apple-system,sans-serif;line-height:1.6;color:#333;background:#f5f5f5}
.header{background:#fff;box-shadow:0 2px 5px rgba(0,0,0,.1);padding:1rem 0;position:sticky;top:0;z-index:100}
.header-content{max-width:1200px;margin:0 auto;padding:0 1rem;display:flex;justify-content:space-between;align-items:center}
.logo{font-size:1.5rem;font-weight:700;color:#667eea;text-decoration:none}
.nav{display:flex;gap:2rem;list-style:none}
.nav a{color:#333;text-decoration:none;font-weight:500}
.nav a:hover{color:#667eea}
.container{max-width:900px;margin:2rem auto;padding:2rem}
h1{font-size:2.5rem;color:#667eea;margin-bottom:1rem;text-align:center}
.intro{text-align:center;max-width:700px;margin:0 auto 3rem;font-size:1.1rem;color:#666}
.article-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:2rem}
.article-card{background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 2px 10px rgba(0,0,0,.1);transition:transform .2s,box-shadow .2s;text-decoration:none;display:block;color:#333}
.article-card:hover{transform:translateY(-5px);box-shadow:0 4px 20px rgba(0,0,0,.15)}
.article-img{width:100%;height:200px;background:linear-gradient(135deg,#667eea,#764ba2);display:flex;align-items:center;justify-content:center;font-size:3rem;color:#fff}
.article-content{padding:1.5rem}
.article-meta{font-size:.85rem;color:#999;margin-bottom:.5rem}
.article-title{font-size:1.3rem;font-weight:700;color:#333;margin-bottom:.75rem}
.article-excerpt{color:#666;line-height:1.6;font-size:.95rem}
.coming-soon{text-align:center;padding:4rem 1rem;background:#fff;border-radius:12px;margin:2rem 0}
.coming-soon h2{color:#667eea;margin-bottom:1rem}
.footer{background:#333;color:#fff;padding:2rem 1rem;text-align:center;margin-top:3rem}
.footer a{color:#fff;opacity:.8;text-decoration:none}
.footer a:hover{opacity:1}
@media(max-width:768px){
.nav{display:none}
.article-grid{grid-template-columns:1fr;gap:1.5rem}
}
</style>
</head>
<body>
<header class="header">
<div class="header-content">
<a href="/" class="logo">🕉️ Japa Counter</a>
<ul class="nav">
<li><a href="/">Home</a></li>
<li><a href="/blog/">Blog</a></li>
<li><a href="/about/">About</a></li>
<li><a href="/contact/">Contact</a></li>
</ul>
</div>
</header>

<div class="container">
<h1>Japa Meditation Blog</h1>
<p class="intro">Learn about mantra meditation, japa techniques, and deepen your spiritual practice. Free guides and tips for practitioners at all levels.</p>

<div class="coming-soon">
<h2>📝 Articles Coming Soon!</h2>
<p>We're working on creating helpful content about japa meditation, mantra meanings, and meditation techniques.</p>
<p style="margin-top:1rem">Topics we'll cover:</p>
<ul style="max-width:500px;margin:1rem auto;text-align:left">
<li style="margin:.5rem 0">• How to get started with japa meditation</li>
<li style="margin:.5rem 0">• Understanding the significance of 108 malas</li>
<li style="margin:.5rem 0">• Popular mantras and their meanings</li>
<li style="margin:.5rem 0">• Building a daily meditation practice</li>
<li style="margin:.5rem 0">• Traditional vs digital counting methods</li>
</ul>
<p style="margin-top:2rem"><a href="/" style="display:inline-block;background:#667eea;color:#fff;padding:.75rem 1.5rem;border-radius:8px;text-decoration:none;font-weight:600">Try the Japa Counter</a></p>
</div>
</div>

<footer class="footer">
<p>&copy; 2026 ChantingCounter.com - Supporting spiritual practitioners worldwide</p>
<p><a href="/">Home</a> | <a href="/blog/">Blog</a> | <a href="/about/">About</a> | <a href="/contact/">Contact</a></p>
</footer>
</body>
</html>