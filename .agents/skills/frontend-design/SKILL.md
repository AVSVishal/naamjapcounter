---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces that avoid generic AI slop aesthetics. Use bold typography, unique color schemes, intentional motion, and modern design patterns. Use for building UI components, pages, applications, or interfaces with exceptional attention to detail and bold creative choices.
---

# Frontend Design Skill

This skill governs ALL UI/UX development. Follow every section. Produce interfaces that are beautiful, functional, and unmistakably intentional — never generic.

---

## 1. Core Philosophy: Anti-AI Slop

AI agents default to safe, forgettable patterns. This skill exists to BREAK those patterns.

**BANNED — never use these:**
- Fonts: Inter, Roboto, Arial, Helvetica, system-ui, sans-serif as primary font
- Colors: Default Tailwind blue/gray palettes, generic purple-on-white gradients, rainbow gradients
- Layouts: Cookie-cutter SaaS landing pages, centered-everything with no spatial tension
- Icons: Emojis as UI icons (🎨 🚀 ⚙️ ✨ 💡) — these are lazy, not design
- Patterns: Hero + 3-column features + testimonials + CTA footer without variation

**MANDATED — always use these instead:**
- Typography: Unique Google Fonts — Space Grotesk, Outfit, Sora, Cabinet Grotesk, Clash Display, Satoshi, General Sans, Plus Jakarta Sans, DM Sans, Manrope, or similarly distinctive typefaces
- Colors: Custom HSL-based palettes built for the specific project context
- Motion: Intentional animations that communicate state and guide attention
- Composition: Unexpected spatial arrangements — asymmetry, overlap, diagonal flow, or bold negative space
- Code: Production-grade, fully functional — every button works, every state is handled

---

## 2. Design Thinking Process

BEFORE writing any UI code, work through these five steps:

### Step 1 — Purpose
What problem does this interface solve? Who uses it? What is the single most important action a user takes? Design around THAT action.

### Step 2 — Tone
Pick a bold direction and commit. Choose ONE:
- Brutally minimal
- Maximalist / dense
- Retro-futuristic
- Organic / natural
- Luxury / refined
- Playful / bouncy
- Editorial / magazine
- Glassmorphism
- Neomorphism
- Dark elegance

DO NOT pick "clean and modern" — that is not a direction, it is a default.

### Step 3 — Differentiation
Answer: what makes this UNFORGETTABLE compared to generic AI output? If the answer is "nothing," redesign. Every interface needs at least one distinctive choice — an unusual color, a bold type treatment, an unexpected layout, a memorable interaction.

### Step 4 — Color Strategy
Build a unique palette using HSL values. Start with a distinctive primary that is NOT default blue. Example:

```css
:root {
  --color-primary-h: 262;
  --color-primary-s: 83%;
  --color-primary-l: 58%;
  --color-primary: hsl(var(--color-primary-h), var(--color-primary-s), var(--color-primary-l));
  --color-primary-light: hsl(var(--color-primary-h), var(--color-primary-s), 72%);
  --color-primary-dark: hsl(var(--color-primary-h), var(--color-primary-s), 42%);

  --color-surface: hsl(220, 14%, 96%);
  --color-surface-elevated: hsl(0, 0%, 100%);
  --color-text: hsl(220, 20%, 12%);
  --color-text-muted: hsl(220, 10%, 46%);
  --color-border: hsl(220, 14%, 89%);
}

[data-theme="dark"] {
  --color-surface: hsl(220, 20%, 8%);
  --color-surface-elevated: hsl(220, 18%, 12%);
  --color-text: hsl(220, 10%, 93%);
  --color-text-muted: hsl(220, 8%, 58%);
  --color-border: hsl(220, 14%, 18%);
}
```

### Step 5 — Typography Pairing
Select TWO complementary fonts — one display/serif for headings, one sans-serif for body. Import from Google Fonts.

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Clash+Display:wght@400;500;600;700&family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
```

Good pairings:
- Clash Display + Space Grotesk
- Playfair Display + Plus Jakarta Sans
- Cabinet Grotesk + DM Sans
- Sora + Outfit
- General Sans + Satoshi

---

## 3. Professional UI Rules

Follow this table for EVERY interface. No exceptions.

| Rule | Do | Don't |
|---|---|---|
| **Icons** | Use SVG icons from Lucide, Heroicons, Phosphor, or Tabler | Use emojis like 🎨 🚀 ⚙️ as UI icons |
| **Typography** | Beautiful, unique Google Fonts with clear hierarchy | Inter, Roboto, Arial, system-ui as primary fonts |
| **Hover States** | Stable transitions (color, opacity, shadow, border) with 150–300ms duration | Scale transforms that shift layout; no hover feedback at all |
| **Cursor** | Add `cursor-pointer` to ALL interactive elements — buttons, links, cards, tabs, toggles | Leave default cursor on clickable elements |
| **Contrast** | Minimum 4.5:1 ratio for text, 3:1 for large text (WCAG AA) | Low-contrast "aesthetic" text that is unreadable |
| **Spacing** | Consistent spacing scale: 4px / 8px / 12px / 16px / 24px / 32px / 48px / 64px | Random spacing values, cramped or inconsistent layouts |
| **Border Radius** | Consistent radius system — sm: 4px, md: 8px, lg: 12px, xl: 16px, 2xl: 24px | Mixing random border-radius values across components |
| **Shadows** | Layered, subtle shadows for depth; use colored shadows that match the element | Heavy black box-shadows, single-layer flat shadows |
| **Loading States** | Skeleton screens, shimmer effects, progressive loading | Bare spinners or empty white screens |
| **Empty States** | Illustrated, helpful empty states with clear call-to-action | Blank screens with "No data" text |
| **Dark Mode** | Support both light and dark with proper contrast in both modes | Only light mode, or dark mode as an afterthought |
| **Animations** | Purposeful entrance animations, staggered reveals, micro-interactions | Animations on everything, or no animations at all |

---

## 4. Motion & Animation Guidelines

Motion communicates meaning. NEVER animate for decoration alone — every animation must signal a state change, guide focus, or provide feedback.

### Principles
- Prioritize CSS-only solutions (`transition`, `@keyframes`) wherever possible
- Use `framer-motion` or GSAP only when CSS cannot achieve the effect
- All animations MUST use `transform` and `opacity` — NEVER animate `width`, `height`, `top`, `left`, or `margin` (these trigger layout reflow)

### Timing
- **Micro-interactions** (hover, focus, toggle): 150–300ms, `ease-out`
- **Entrance animations** (fade-in, slide-up): 300–500ms, `ease-out` or `cubic-bezier(0.16, 1, 0.3, 1)`
- **Exit animations**: 150–250ms, `ease-in`
- **Page transitions**: 200–400ms, subtle fade or slide
- **Stagger delay** between list items: 50–100ms

### Entrance Pattern (CSS)
```css
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-in {
  animation: fadeInUp 0.4s cubic-bezier(0.16, 1, 0.3, 1) both;
}

.stagger-1 { animation-delay: 0ms; }
.stagger-2 { animation-delay: 60ms; }
.stagger-3 { animation-delay: 120ms; }
.stagger-4 { animation-delay: 180ms; }
```

### Scroll-Triggered Animations
Use Intersection Observer to trigger entrance animations on scroll:

```js
const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('animate-in');
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.15 }
);

document.querySelectorAll('[data-animate]').forEach((el) => observer.observe(el));
```

### Loading Hierarchy
Skeleton screens > shimmer placeholders > progress indicators > spinners > nothing. ALWAYS provide visual feedback during async operations.

---

## 5. Spatial Composition & Layout

### Break the Grid
DO NOT default to symmetric, centered layouts. Use at least one of these techniques:
- **Asymmetric columns** — 60/40 or 70/30 splits instead of 50/50
- **Overlapping elements** — images or cards that break out of their container
- **Diagonal flow** — content that guides the eye in a non-linear path
- **Bold negative space** — intentionally large empty areas that create breathing room

### Layout Rules
- Use CSS Grid for complex, two-dimensional layouts
- Use Flexbox for simpler, one-dimensional arrangements
- Maximum content width: `1280px` with `clamp(16px, 4vw, 64px)` side padding
- Hero sections: fill viewport height (`min-height: 100vh` or `min-height: 100svh`)
- Cards: consistent internal padding (16–24px), subtle shadow, hover lift effect
- Section vertical spacing: `64px` minimum on mobile, `96–128px` on desktop

### Grid Example
```css
.layout-grid {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 24px;
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 clamp(16px, 4vw, 64px);
}
```

---

## 6. Color System Guidelines

### Building a Palette
1. Choose a distinctive primary hue — NOT blue (hue 220). Try deep teal (hue 172), warm coral (hue 12), rich violet (hue 270), forest green (hue 152), or burnt amber (hue 32).
2. Generate shades from light (95% lightness) to dark (15% lightness) in 10 steps.
3. Add a complementary or analogous accent color.
4. Define neutral grays with a slight color temperature (warm or cool).

### Semantic Colors
ALWAYS define semantic colors for feedback states:
- **Success**: green tones (hue 142–158)
- **Warning**: amber tones (hue 38–48)
- **Error**: red tones (hue 0–12)
- **Info**: blue tones (hue 210–220)

### Dark Mode
DO NOT simply invert colors. Redesign surfaces:
- Background: `hsl(220, 20%, 6%)` to `hsl(220, 18%, 10%)`
- Elevated surface: `hsl(220, 16%, 12%)` to `hsl(220, 14%, 16%)`
- Borders: reduce opacity or use subtle light borders (`hsl(220, 10%, 20%)`)
- Primary colors: increase lightness by 10–15% for readability on dark surfaces
- Text: `hsl(220, 10%, 93%)` for primary, `hsl(220, 8%, 58%)` for muted

### Gradients
Use gradients sparingly and intentionally:
- Subtle background gradients with low contrast (5–10% lightness difference)
- Accent gradients on CTAs with two related hues (30–60 degree hue shift)
- NEVER use rainbow gradients or default blue-to-purple

---

## 7. Typography System

### Font Selection
- **Heading font**: Display or serif — Clash Display, Cabinet Grotesk, Playfair Display, Fraunces, Epilogue
- **Body font**: Clean sans-serif — Space Grotesk, Outfit, Plus Jakarta Sans, DM Sans, Manrope, Satoshi

### Type Scale
Use a consistent scale with clear hierarchy:

| Token | Size | Weight | Line Height | Letter Spacing | Use |
|---|---|---|---|---|---|
| `text-xs` | 12px | 400 | 1.5 | 0.02em | Captions, labels |
| `text-sm` | 14px | 400 | 1.5 | 0 | Secondary text |
| `text-base` | 16px | 400 | 1.6 | 0 | Body text |
| `text-lg` | 18px | 500 | 1.5 | 0 | Lead paragraphs |
| `text-xl` | 20px | 500 | 1.4 | -0.01em | Card titles |
| `text-2xl` | 24px | 600 | 1.3 | -0.01em | Section subtitles |
| `text-3xl` | 30px | 600 | 1.25 | -0.02em | Section headings |
| `text-4xl` | 36px | 700 | 1.2 | -0.02em | Page titles |
| `text-5xl` | 48px | 700 | 1.15 | -0.02em | Hero subheadings |
| `text-6xl` | 64px | 800 | 1.1 | -0.03em | Hero headlines |

### Font Weight Rules
- `400` (Regular): Body text, descriptions
- `500` (Medium): Emphasis, navigation items, labels
- `600` (Semibold): Subheadings, button text
- `700` (Bold): Headings, page titles
- `800` (Extrabold): Hero headlines only

### Responsive Typography
Scale headings down on mobile. Use `clamp()` for fluid sizing:

```css
.hero-headline {
  font-size: clamp(2.5rem, 5vw + 1rem, 4.5rem);
  font-weight: 800;
  line-height: 1.1;
  letter-spacing: -0.03em;
}
```

---

## 8. Component Design Patterns

### Buttons
ALWAYS implement multiple variants:

```css
.btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  font-weight: 600;
  font-size: 14px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 200ms ease-out;
  border: 1.5px solid transparent;
}

.btn-primary {
  background: var(--color-primary);
  color: white;
}
.btn-primary:hover {
  background: var(--color-primary-dark);
  box-shadow: 0 4px 12px hsl(var(--color-primary-h), var(--color-primary-s), var(--color-primary-l), 0.3);
}

.btn-secondary {
  background: var(--color-surface-elevated);
  color: var(--color-text);
  border-color: var(--color-border);
}
.btn-secondary:hover {
  border-color: var(--color-primary);
  color: var(--color-primary);
}

.btn-ghost {
  background: transparent;
  color: var(--color-text-muted);
}
.btn-ghost:hover {
  background: var(--color-surface);
  color: var(--color-text);
}
```

Include icon support (left/right), loading spinner state, and disabled state for every button variant.

### Cards
```css
.card {
  background: var(--color-surface-elevated);
  border: 1px solid var(--color-border);
  border-radius: 12px;
  padding: 20px;
  transition: transform 200ms ease-out, box-shadow 200ms ease-out;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px hsl(220, 20%, 10%, 0.08);
}
```

### Form Inputs
```css
.input {
  width: 100%;
  padding: 10px 14px;
  font-size: 15px;
  border: 1.5px solid var(--color-border);
  border-radius: 8px;
  background: var(--color-surface);
  color: var(--color-text);
  transition: border-color 200ms ease-out, box-shadow 200ms ease-out;
}

.input:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px hsl(var(--color-primary-h), var(--color-primary-s), var(--color-primary-l), 0.15);
}

.input-error {
  border-color: hsl(0, 72%, 51%);
}

.input-error:focus {
  box-shadow: 0 0 0 3px hsl(0, 72%, 51%, 0.15);
}
```

ALWAYS include: visible labels (top-aligned or floating), placeholder text, focus ring, error state with message, disabled state.

### Modals
- Backdrop: `background: hsl(0, 0%, 0%, 0.5)` with `backdrop-filter: blur(4px)`
- Container: centered, `max-width: 480px`, `border-radius: 16px`, padding `24–32px`
- Enter animation: fade-in backdrop + scale-up modal (0.95 → 1.0)
- Exit animation: fade-out + scale-down (faster than enter)
- ALWAYS trap focus inside the modal and close on Escape key

### Navigation
- Sticky header with `backdrop-filter: blur(12px)` and semi-transparent background
- Active state: underline, background highlight, or color change — make it OBVIOUS
- Mobile: hamburger icon that opens a full-screen or slide-in drawer
- Transition the hamburger icon to an X on open

### Tables
- Alternating row backgrounds for readability
- Sticky header row on vertical scroll
- Horizontal scroll container on mobile with `-webkit-overflow-scrolling: touch`
- Sort indicators on sortable columns

### Toasts / Notifications
- Position: top-right or bottom-right, stacked with 8px gap
- Auto-dismiss after 4–6 seconds with a progress bar
- Swipe-to-dismiss on mobile
- Color-coded by type: success (green), error (red), warning (amber), info (blue)
- Include a close button

---

## 9. Responsive Design Rules

### Approach
ALWAYS design mobile-first. Start with the smallest viewport and progressively enhance.

### Breakpoints
```css
/* Mobile-first breakpoints */
/* sm */  @media (min-width: 640px)  { }
/* md */  @media (min-width: 768px)  { }
/* lg */  @media (min-width: 1024px) { }
/* xl */  @media (min-width: 1280px) { }
/* 2xl */ @media (min-width: 1536px) { }
```

### Rules
- Touch targets: minimum `44x44px` on mobile — NEVER smaller
- NO horizontal scroll on any viewport width
- Test at these widths: 375px (iPhone SE), 390px (iPhone 14), 768px (iPad), 1024px (iPad landscape), 1440px (Desktop)
- Navigation: hamburger menu below `768px`, full nav at `768px` and above
- Typography: scale down hero text by 30–40% on mobile using `clamp()`
- Images: use `object-fit: cover` and responsive `srcset` where possible
- Stack columns on mobile — DO NOT just shrink a 3-column desktop layout to 3 tiny columns

### Mobile-Specific
- Use `100svh` instead of `100vh` to account for mobile browser chrome
- Add `-webkit-tap-highlight-color: transparent` to remove tap flash
- Increase button padding by 4px on touch devices
- Use `scroll-snap-type` for carousels and horizontal scrolling sections

---

## 10. Aesthetic Directions Reference

Use these as starting points when selecting a tone in Step 2 of the Design Thinking Process.

### Glassmorphism
Frosted glass effects with `backdrop-filter: blur(16px)`, semi-transparent white or dark surfaces (`rgba(255,255,255,0.08)`), subtle 1px light borders, layered depth. Works best on colorful or gradient backgrounds.

### Neomorphism
Soft inset and outset shadows on a muted, same-hue background. Elements appear extruded from or pressed into the surface. Use sparingly — full neomorphic UIs have accessibility issues.

### Brutalist
Monospace or heavy slab-serif fonts, harsh black-and-white contrast, raw borders (2–4px solid black), intentional roughness. The design looks "unfinished" but every choice is deliberate.

### Editorial / Magazine
Grid-based layouts with strong columns, oversized serif headlines, generous whitespace, high-quality imagery, clear content hierarchy. Think NYT or Bloomberg Businessweek.

### Luxury / Refined
Dark backgrounds (near-black), gold or champagne accent colors, serif typography (Playfair Display, Cormorant), generous letter-spacing in uppercase labels, subtle fade animations, minimal UI chrome.

### Retro-Futuristic
Neon accent colors on dark backgrounds, chrome/metallic gradients, scanline or CRT effects, 80s-inspired color palettes (cyan, magenta, electric blue), pixel or monospace secondary fonts.

### Playful
Rounded corners (`border-radius: 16–24px`), bright pastel colors, bouncy spring animations (`cubic-bezier(0.34, 1.56, 0.64, 1)`), fun illustrations or hand-drawn elements, friendly sans-serif fonts.

### Dark Elegance
Deep charcoal or near-black backgrounds (`hsl(220, 20%, 6%)`), subtle glow effects on accent elements, sophisticated type pairings, smooth fade animations, muted color palette with one vibrant accent.

---

## 11. Pre-Delivery Checklist

BEFORE delivering any UI code, verify EVERY item below. Do not skip any.

### Visual Quality
- [ ] **No emojis as icons** — SVG icons only (Lucide, Heroicons, Phosphor, Tabler)
- [ ] **Typography is distinctive** — NOT Inter, Roboto, Arial, or system defaults
- [ ] **Color scheme is unique** — custom palette, NOT default Tailwind blue/gray
- [ ] **Hover states** exist on ALL interactive elements with smooth 150–300ms transitions
- [ ] **Loading states** are designed — skeleton screens or shimmer, not bare spinners
- [ ] **Empty states** are designed — helpful message with illustration and CTA

### UX & Accessibility
- [ ] **cursor-pointer** on ALL interactive elements (buttons, links, cards, tabs, toggles)
- [ ] **Form inputs have visible labels** — never placeholder-only
- [ ] **Images have alt text** — descriptive for content images, empty for decorative
- [ ] **Text contrast** meets WCAG AA — 4.5:1 minimum for normal text, 3:1 for large
- [ ] **Keyboard navigable** — logical tab order, visible focus indicators, Escape closes modals
- [ ] **Responsive** at all breakpoints — 375px, 768px, 1024px, 1440px
- [ ] **No horizontal scroll** on any viewport

### Code Quality
- [ ] **Semantic HTML** — proper heading hierarchy, landmarks, lists
- [ ] **Consistent styling approach** — one methodology (CSS Modules, Tailwind, styled-components), not mixed
- [ ] **Dark mode supported** if applicable — tested with proper contrast
- [ ] **Animations are performant** — only `transform` and `opacity` are animated, never layout properties
- [ ] **Images optimized** — compressed, lazy-loaded with `loading="lazy"`, responsive sizes

---

## Quick Reference: Shadow System

Use layered shadows for realistic depth:

```css
:root {
  --shadow-xs: 0 1px 2px hsl(220, 20%, 10%, 0.05);
  --shadow-sm: 0 1px 3px hsl(220, 20%, 10%, 0.08), 0 1px 2px hsl(220, 20%, 10%, 0.06);
  --shadow-md: 0 4px 6px hsl(220, 20%, 10%, 0.06), 0 2px 4px hsl(220, 20%, 10%, 0.04);
  --shadow-lg: 0 10px 15px hsl(220, 20%, 10%, 0.08), 0 4px 6px hsl(220, 20%, 10%, 0.04);
  --shadow-xl: 0 20px 25px hsl(220, 20%, 10%, 0.1), 0 8px 10px hsl(220, 20%, 10%, 0.04);
}
```

## Quick Reference: Transition Defaults

```css
:root {
  --ease-out: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-in: cubic-bezier(0.7, 0, 0.84, 0);
  --ease-bounce: cubic-bezier(0.34, 1.56, 0.64, 1);
  --duration-fast: 150ms;
  --duration-normal: 200ms;
  --duration-slow: 300ms;
  --duration-entrance: 400ms;
}

* {
  transition-timing-function: var(--ease-out);
}
```
