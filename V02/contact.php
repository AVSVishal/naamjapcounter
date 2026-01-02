<?php
header('Content-Type: text/html; charset=utf-8');
header('Cache-Control: public, max-age=300');
?><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Contact - Japa Counter Online</title>
<meta name="description" content="Get in touch with ChantingCounter.com. Questions, feedback, or support? We're here to help with your japa meditation practice.">
<link rel="canonical" href="https://chantingcounter.com/contact/">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:system-ui,-apple-system,sans-serif;line-height:1.6;color:#333;background:#f5f5f5}
.header{background:#fff;box-shadow:0 2px 5px rgba(0,0,0,.1);padding:1rem 0;position:sticky;top:0;z-index:100}
.header-content{max-width:1200px;margin:0 auto;padding:0 1rem;display:flex;justify-content:space-between;align-items:center}
.logo{font-size:1.5rem;font-weight:700;color:#667eea;text-decoration:none}
.nav{display:flex;gap:2rem;list-style:none}
.nav a{color:#333;text-decoration:none;font-weight:500}
.nav a:hover{color:#667eea}
.container{max-width:600px;margin:2rem auto;padding:2rem;background:#fff;border-radius:12px;box-shadow:0 2px 10px rgba(0,0,0,.1)}
h1{font-size:2.5rem;color:#667eea;margin-bottom:1rem}
p{margin-bottom:1rem;font-size:1.05rem}
.form-group{margin-bottom:1.5rem}
label{display:block;margin-bottom:.5rem;font-weight:600;color:#333}
input,textarea{width:100%;padding:.75rem;border:1px solid #ddd;border-radius:8px;font-size:1rem;font-family:inherit}
input:focus,textarea:focus{outline:none;border-color:#667eea;box-shadow:0 0 0 3px rgba(102,126,234,.1)}
textarea{resize:vertical;min-height:150px}
.btn{background:#667eea;color:#fff;padding:.75rem 1.5rem;border:none;border-radius:8px;font-size:1rem;font-weight:600;cursor:pointer;transition:all .2s}
.btn:hover{background:#5568d3}
.success{background:#d4edda;color:#155724;padding:1rem;border-radius:8px;margin-bottom:1rem}
.footer{background:#333;color:#fff;padding:2rem 1rem;text-align:center;margin-top:3rem}
.footer a{color:#fff;opacity:.8;text-decoration:none}
.footer a:hover{opacity:1}
@media(max-width:768px){
.nav{display:none}
.container{padding:1.5rem;margin:1rem}
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
<h1>Get in Touch</h1>
<p>Have questions about the japa counter? Found a bug? Want to share your feedback? We'd love to hear from you.</p>
<p>Drop us a message and we'll get back to you within 24 hours.</p>

<form action="/contact/" method="POST">
<div class="form-group">
<label for="name">Your Name</label>
<input type="text" id="name" name="name" required placeholder="Enter your name">
</div>

<div class="form-group">
<label for="email">Email Address</label>
<input type="email" id="email" name="email" required placeholder="your@email.com">
</div>

<div class="form-group">
<label for="subject">Subject</label>
<input type="text" id="subject" name="subject" required placeholder="What's this about?">
</div>

<div class="form-group">
<label for="message">Message</label>
<textarea id="message" name="message" required placeholder="Share your thoughts, questions, or feedback..."></textarea>
</div>

<button type="submit" class="btn">Send Message</button>
</form>

<p style="margin-top:2rem;padding-top:2rem;border-top:1px solid #eee;color:#666;font-size:.95rem">
You can also reach us at: <strong>support@chantingcounter.com</strong>
</p>
</div>

<footer class="footer">
<p>&copy; 2026 ChantingCounter.com - Supporting spiritual practitioners worldwide</p>
<p><a href="/">Home</a> | <a href="/blog/">Blog</a> | <a href="/about/">About</a> | <a href="/contact/">Contact</a></p>
</footer>
</body>
</html>