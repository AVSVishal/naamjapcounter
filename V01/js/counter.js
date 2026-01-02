/**
 * ChantingCounter.com - Main Counter JavaScript V01
 * Optimized for Performance & Security
 */

(function() {
    'use strict';

    // Configuration
    const CONFIG = {
        STORAGE_PREFIX: 'chant_',
        KEYS: {
            COUNT: 'chant_count',
            TOTAL: 'chant_total',
            MALAS: 'chant_malas',
            DAILY: 'chant_daily',
            DATE: 'chant_date',
            AUDIO: 'chant_audio'
        },
        MALA_SIZE: 108,
        VIBRATION_DURATION: 10,
        TOAST_DURATION: 2500,
        MALA_BADGE_DURATION: 2000
    };

    // DOM Elements cache
    const elements = {
        count: document.getElementById('count'),
        session: document.getElementById('session'),
        total: document.getElementById('total'),
        malas: document.getElementById('malas'),
        daily: document.getElementById('daily'),
        timer: document.getElementById('timer'),
        btnCount: document.getElementById('btnCount'),
        btnReset: document.getElementById('btnReset'),
        btnSave: document.getElementById('btnSave'),
        btnAudio: document.getElementById('btnAudio'),
        audioIcon: document.getElementById('audioIcon'),
        malaBadge: document.getElementById('mala-badge'),
        toast: document.getElementById('toast'),
        progress: document.getElementById('progress'),
        beads: document.getElementById('beads')
    };

    // State
    let state = {
        count: 0,
        total: 0,
        malas: 0,
        daily: 0,
        timerSeconds: 0,
        timerInterval: null,
        audioEnabled: false,
        csrfToken: ''
    };

    // Progress circle setup
    const circumference = 2 * Math.PI * 130;
    if (elements.progress) {
        elements.progress.style.strokeDasharray = `${circumference} ${circumference}`;
        elements.progress.style.strokeDashoffset = circumference;
    }

    /**
     * Initialize beads display
     */
    function initBeads() {
        if (!elements.beads) return;
        
        const fragment = document.createDocumentFragment();
        for (let i = 0; i < CONFIG.MALA_SIZE; i++) {
            const bead = document.createElement('div');
            bead.className = 'bead';
            bead.id = 'bead-' + i;
            bead.setAttribute('aria-hidden', 'true');
            fragment.appendChild(bead);
        }
        elements.beads.appendChild(fragment);
    }

    /**
     * Update beads display
     */
    function updateBeads() {
        if (!elements.beads) return;
        
        const current = state.count % CONFIG.MALA_SIZE;
        for (let i = 0; i < CONFIG.MALA_SIZE; i++) {
            const bead = document.getElementById('bead-' + i);
            if (bead) {
                if (i < current) {
                    bead.classList.add('completed');
                } else {
                    bead.classList.remove('completed');
                }
            }
        }
    }

    /**
     * Update progress circle
     */
    function updateProgress() {
        if (!elements.progress) return;
        
        const progress = (state.count % CONFIG.MALA_SIZE) / CONFIG.MALA_SIZE;
        const offset = circumference - (progress * circumference);
        elements.progress.style.strokeDashoffset = offset;
    }

    /**
     * Get today's date in YYYY-MM-DD format
     */
    function getTodayDate() {
        return new Date().toISOString().split('T')[0];
    }

    /**
     * Load data from localStorage
     */
    function loadData() {
        const today = getTodayDate();
        const lastDate = localStorage.getItem(CONFIG.KEYS.DATE);

        try {
            state.count = parseInt(localStorage.getItem(CONFIG.KEYS.COUNT) || '0', 10);
            state.total = parseInt(localStorage.getItem(CONFIG.KEYS.TOTAL) || '0', 10);
            state.malas = parseInt(localStorage.getItem(CONFIG.KEYS.MALAS) || '0', 10);
            state.daily = parseInt(localStorage.getItem(CONFIG.KEYS.DAILY) || '0', 10);
            state.audioEnabled = localStorage.getItem(CONFIG.KEYS.AUDIO) === 'true';

            // Reset daily count if new day
            if (lastDate && lastDate !== today) {
                state.daily = 0;
                localStorage.setItem(CONFIG.KEYS.DAILY, '0');
                localStorage.setItem(CONFIG.KEYS.DATE, today);
            }
        } catch (error) {
            console.error('Error loading data:', error);
            resetState();
        }

        updateAudioIcon();
        render();
    }

    /**
     * Save data to localStorage
     */
    function saveData() {
        const today = getTodayDate();
        
        try {
            localStorage.setItem(CONFIG.KEYS.COUNT, state.count.toString());
            localStorage.setItem(CONFIG.KEYS.TOTAL, state.total.toString());
            localStorage.setItem(CONFIG.KEYS.MALAS, state.malas.toString());
            localStorage.setItem(CONFIG.KEYS.DAILY, state.daily.toString());
            localStorage.setItem(CONFIG.KEYS.DATE, today);
        } catch (error) {
            console.error('Error saving data:', error);
            showToast('Could not save locally. Storage full?');
        }
    }

    /**
     * Reset state to defaults
     */
    function resetState() {
        state.count = 0;
        state.total = 0;
        state.malas = 0;
        state.daily = 0;
    }

    /**
     * Render all UI elements
     */
    function render() {
        if (elements.count) elements.count.textContent = state.count;
        if (elements.session) elements.session.textContent = state.count;
        if (elements.total) elements.total.textContent = state.total;
        if (elements.malas) elements.malas.textContent = state.malas;
        if (elements.daily) elements.daily.textContent = state.daily;
        
        updateBeads();
        updateProgress();
    }

    /**
     * Start session timer
     */
    function startTimer() {
        if (state.timerInterval || !elements.timer) return;

        state.timerInterval = setInterval(() => {
            state.timerSeconds++;
            const hours = Math.floor(state.timerSeconds / 3600);
            const minutes = Math.floor((state.timerSeconds % 3600) / 60);
            const seconds = state.timerSeconds % 60;
            
            elements.timer.textContent = 
                String(hours).padStart(2, '0') + ':' +
                String(minutes).padStart(2, '0') + ':' +
                String(seconds).padStart(2, '0');
        }, 1000);
    }

    /**
     * Play mala completion sound
     */
    function playBeep() {
        if (!state.audioEnabled) return;

        try {
            const audioContext = new (window.AudioContext || window.webkitAudioContext)();
            const oscillator = audioContext.createOscillator();
            const gainNode = audioContext.createGain();

            oscillator.connect(gainNode);
            gainNode.connect(audioContext.destination);

            oscillator.frequency.value = 800;
            gainNode.gain.value = 0.1;

            oscillator.start();
            gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.1);
            oscillator.stop(audioContext.currentTime + 0.1);
        } catch (error) {
            console.error('Audio error:', error);
        }
    }

    /**
     * Trigger vibration feedback
     */
    function vibrate() {
        if (navigator.vibrate) {
            navigator.vibrate(CONFIG.VIBRATION_DURATION);
        }
    }

    /**
     * Increment count
     */
    function increment() {
        // Start timer on first count
        if (state.count === 0) {
            startTimer();
        }

        state.count++;
        state.total++;
        state.daily++;

        // Add pulse animation
        if (elements.count) {
            elements.count.classList.add('pulse');
            setTimeout(() => {
                elements.count.classList.remove('pulse');
            }, 300);
        }

        // Check for mala completion
        if (state.count % CONFIG.MALA_SIZE === 0 && state.count > 0) {
            state.malas = Math.floor(state.count / CONFIG.MALA_SIZE);
            
            // Show mala badge
            if (elements.malaBadge) {
                elements.malaBadge.classList.add('show');
                setTimeout(() => {
                    elements.malaBadge.classList.remove('show');
                }, CONFIG.MALA_BADGE_DURATION);
            }

            playBeep();
            showToast(`🙏 Mala Complete! ${state.malas} total`);
        }

        render();
        saveData();
        vibrate();
    }

    /**
     * Reset session count
     */
    function resetSession() {
        if (state.count > 0) {
            if (!confirm('Reset your session count? (Daily and lifetime totals stay safe)')) {
                return;
            }
        }

        state.count = 0;
        state.timerSeconds = 0;
        
        if (elements.timer) {
            elements.timer.textContent = '00:00:00';
        }

        if (state.timerInterval) {
            clearInterval(state.timerInterval);
            state.timerInterval = null;
        }

        render();
        saveData();
        showToast('Session reset');
    }

    /**
     * Get CSRF token from meta tag or cookie
     */
    function getCsrfToken() {
        // Try to get from meta tag first
        const metaToken = document.querySelector('meta[name="csrf-token"]');
        if (metaToken) {
            return metaToken.getAttribute('content');
        }

        // Try to get from cookie
        const cookies = document.cookie.split(';');
        for (let cookie of cookies) {
            const [name, value] = cookie.trim().split('=');
            if (name === 'csrf_token') {
                return value;
            }
        }

        return '';
    }

    /**
     * Save data to server
     */
    function saveToServer() {
        if (elements.btnSave) {
            elements.btnSave.disabled = true;
            const originalText = elements.btnSave.textContent;
            elements.btnSave.textContent = 'Saving...';

            const csrfToken = getCsrfToken();
            const payload = {
                count: state.count,
                total: state.total,
                malas: state.malas,
                daily: state.daily,
                csrf_token: csrfToken
            };

            fetch('?action=save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': csrfToken
                },
                body: JSON.stringify(payload)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showToast('Saved to server!');
                } else {
                    showToast(data.error || 'Could not save');
                }
            })
            .catch(error => {
                console.error('Save error:', error);
                showToast('Network error - check connection');
            })
            .finally(() => {
                if (elements.btnSave) {
                    elements.btnSave.disabled = false;
                    elements.btnSave.textContent = originalText;
                }
            });
        }
    }

    /**
     * Toggle audio on/off
     */
    function toggleAudio() {
        state.audioEnabled = !state.audioEnabled;
        localStorage.setItem(CONFIG.KEYS.AUDIO, state.audioEnabled.toString());
        updateAudioIcon();
        showToast(state.audioEnabled ? 'Sound ON' : 'Sound OFF');
    }

    /**
     * Update audio icon
     */
    function updateAudioIcon() {
        if (elements.audioIcon) {
            elements.audioIcon.textContent = state.audioEnabled ? '🔊' : '🔇';
        }
    }

    /**
     * Show toast notification
     */
    function showToast(message) {
        if (!elements.toast) return;

        elements.toast.textContent = message;
        elements.toast.classList.add('show');
        
        setTimeout(() => {
            elements.toast.classList.remove('show');
        }, CONFIG.TOAST_DURATION);
    }

    /**
     * Toggle mobile menu
     */
    function toggleMenu() {
        const nav = document.getElementById('nav');
        const hamburger = document.getElementById('hamburger');
        
        if (nav) nav.classList.toggle('active');
        if (hamburger) hamburger.classList.toggle('active');
    }

    /**
     * Handle keyboard shortcuts
     */
    function handleKeyboard(event) {
        // Space or Enter to increment
        if ((event.key === ' ' || event.key === 'Enter') && 
            event.target.tagName !== 'BUTTON' && 
            event.target.tagName !== 'A' &&
            event.target.tagName !== 'INPUT') {
            event.preventDefault();
            increment();
        }

        // R to reset (with Ctrl/Cmd)
        if ((event.ctrlKey || event.metaKey) && event.key === 'r') {
            event.preventDefault();
            resetSession();
        }
    }

    /**
     * Initialize app
     */
    function init() {
        // Initialize beads
        initBeads();

        // Load saved data
        loadData();

        // Setup event listeners
        if (elements.btnCount) {
            elements.btnCount.addEventListener('click', increment);
        }

        if (elements.btnReset) {
            elements.btnReset.addEventListener('click', resetSession);
        }

        if (elements.btnSave) {
            elements.btnSave.addEventListener('click', saveToServer);
        }

        if (elements.btnAudio) {
            elements.btnAudio.addEventListener('click', toggleAudio);
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', handleKeyboard);

        // Make toggleMenu available globally for inline onclick
        window.toggleMenu = toggleMenu;

        // Service Worker registration (if available)
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', () => {
                navigator.serviceWorker.register('/sw.js')
                    .then(registration => {
                        console.log('SW registered:', registration);
                    })
                    .catch(error => {
                        console.log('SW registration failed:', error);
                    });
            });
        }

        console.log('ChantingCounter initialized');
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

})();
