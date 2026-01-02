/**
 * Service Worker for ChantingCounter.com
 * Enables offline functionality and caching
 */

const CACHE_NAME = 'japa-counter-v1';
const ASSETS_TO_CACHE = [
    '/',
    '/index.php',
    '/css/style.min.css',
    '/js/counter.min.js',
    '/manifest.json'
];

// Install event - cache assets
self.addEventListener('install', (event) => {
    console.log('[SW] Installing service worker...');
    
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then((cache) => {
                console.log('[SW] Caching assets');
                return cache.addAll(ASSETS_TO_CACHE);
            })
            .then(() => self.skipWaiting())
    );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
    console.log('[SW] Activating service worker...');
    
    event.waitUntil(
        caches.keys()
            .then((cacheNames) => {
                return Promise.all(
                    cacheNames
                        .filter((name) => name !== CACHE_NAME)
                        .map((name) => caches.delete(name))
                );
            })
            .then(() => self.clients.claim())
    );
});

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', (event) => {
    // Skip non-GET requests
    if (event.request.method !== 'GET') {
        return;
    }

    // Skip API calls (let them go to network)
    if (event.request.url.includes('?action=')) {
        return;
    }

    event.respondWith(
        caches.match(event.request)
            .then((cachedResponse) => {
                if (cachedResponse) {
                    return cachedResponse;
                }

                return fetch(event.request)
                    .then((response) => {
                        // Don't cache non-successful responses
                        if (!response || response.status !== 200 || response.type !== 'basic') {
                            return response;
                        }

                        // Clone the response
                        const responseToCache = response.clone();

                        caches.open(CACHE_NAME)
                            .then((cache) => {
                                cache.put(event.request, responseToCache);
                            });

                        return response;
                    })
                    .catch(() => {
                        // Return offline page if available
                        return caches.match('/offline.html');
                    });
            })
    );
});

// Background sync (for future implementation)
self.addEventListener('sync', (event) => {
    if (event.tag === 'sync-counter-data') {
        event.waitUntil(syncCounterData());
    }
});

async function syncCounterData() {
    // Implement background sync logic here
    console.log('[SW] Background sync triggered');
}

// Push notifications (for future implementation)
self.addEventListener('push', (event) => {
    const options = {
        body: event.data ? event.data.text() : 'Time for your daily japa practice!',
        icon: '/icons/icon-192x192.png',
        badge: '/icons/icon-72x72.png',
        vibrate: [200, 100, 200],
        tag: 'japa-reminder',
        requireInteraction: false
    };

    event.waitUntil(
        self.registration.showNotification('Japa Counter', options)
    );
});

// Notification click handler
self.addEventListener('notificationclick', (event) => {
    event.notification.close();
    
    event.waitUntil(
        clients.openWindow('/')
    );
});
