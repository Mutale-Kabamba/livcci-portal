# Code Citations

## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: MIT
https://github.com/microweber/microweber/blob/032b7f030209520bb05d848cfdad1a49859e156e/src/MicroweberPackages/User/resources/views/components/welcome.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: unknown
https://github.com/Codeinwp/wp-maintenance-mode/blob/1959221a7db1ba2a358c6a6328de7e0bca4d50eb/views/settings.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: MIT
https://github.com/shopperlabs/shopper/blob/694a5c370f91f9c61a1e3f4df736533a1ef8577b/resources/views/livewire/settings/general.blade.php

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```


## License: unknown
https://github.com/gunkiddedy/e-catalogue-new-template/blob/5632c528c5129fd0243fec4aad5eee2cfd22f458/resources/js/components/ProductDetail.vue

```
I'll add hero sections with scroll animations to the News.vue page and create similar hero sections for the other pages. Let me update the News.vue file first:

````vue
// filepath: c:\Users\mukuk\livcci-portal\resources\js\Pages\News.vue
<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
};

// Get event type color
const getTypeColor = (type) => {
    const colors = {
        'Meeting': 'bg-blue-100 text-blue-700',
        'Workshop': 'bg-purple-100 text-purple-700',
        'Expo': 'bg-green-100 text-green-700',
        'News': 'bg-orange-100 text-orange-700'
    };
    return colors[type] || 'bg-gray-100 text-gray-700';
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observer.observe(el);
    });
    
    return () => {
        window.removeEventListener('scroll', handleScroll);
        observer.disconnect();
    };
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <!-- Navigation -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <Link href="/">
                            <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                        </Link>
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link href="/" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Home</Link>
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div class="flex items-center space-x-4">
                        <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] hidden sm:block">Member Login</Link>
                        <Link :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                            Join Chamber
                        </Link>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-96 sm:h-[500px]" data-scroll>
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="(event, index) in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom
```

