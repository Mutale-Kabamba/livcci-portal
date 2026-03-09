<script setup>
import { Head, Link } from '@inertiajs/vue3';

const props = defineProps({
    events: Array
});

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
</script>

<template>
    <Head title="News & Events - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">

        <nav class="bg-white border-b border-gray-100 shadow-sm sticky top-0 z-50">
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

        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="text-center mb-12">
                    <p class="text-[#F4B223] text-lg font-bold uppercase tracking-wide mb-2">NEWS & INSIGHTS</p>
                    <h1 class="text-4xl sm:text-5xl font-black text-[#1D2A68] mb-4">Stay Informed. Stay Ahead.</h1>
                </div>

                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="event in events" :key="event.id" class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow group">
                        <!-- Image Container -->
                        <div class="relative h-64 bg-gray-200 overflow-hidden">
                            <img 
                                v-if="event.image_url"
                                :src="`/storage/${event.image_url}`"
                                :alt="event.title"
                                class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#1876C3] to-[#1460A0] flex items-center justify-center">
                                <svg class="w-20 h-20 text-white opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <!-- Date Bar Overlay -->
                            <div class="absolute bottom-0 left-0 right-0 bg-[#F4B223] text-white py-2 px-4 text-center font-bold">
                                {{ formatDate(event.event_date) }}
                            </div>
                        </div>

                        <!-- Content -->
                        <div class="p-6">
                            <h3 class="text-lg font-bold text-[#1D2A68] mb-2 line-clamp-2">{{ event.title }}</h3>
                            <p class="text-gray-600 text-sm mb-4 line-clamp-2">{{ event.description }}</p>
                            <div class="flex items-center justify-between">
                                <span :class="['px-3 py-1 rounded text-xs font-bold', getTypeColor(event.type)]">
                                    {{ event.type }}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-else class="text-center py-16">
                    <p class="text-lg text-gray-600 mb-2">No events yet</p>
                    <p class="text-gray-500">Check back soon for upcoming news and events.</p>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="bg-[#1D2A68] text-white mt-auto">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                    <div class="col-span-1 md:col-span-2">
                        <div class="flex items-center gap-3 mb-4">
                            <img src="/images/logo-white.png" alt="LiVCCI Logo" class="h-12 w-auto object-contain">
                            <div>
                                <h3 class="text-xl font-bold">LiVCCI</h3>
                                <p class="text-sm text-blue-200">Livingstone Chamber of Commerce & Industry</p>
                            </div>
                        </div>
                        <p class="text-blue-200 mb-4">
                            Promoting business growth and economic development in Livingstone and beyond.
                        </p>
                        <Link :href="route('admin.dashboard')" class="text-[#F4B223] hover:text-[#E8A01A] font-semibold transition-colors">Admin Login</Link>
                    </div>

                    <div>
                        <h4 class="text-lg font-semibold mb-4">Quick Links</h4>
                        <ul class="space-y-2">
                            <li><Link href="/" class="hover:text-white transition-colors">Home</Link></li>
                            <li><Link :href="route('about')" class="hover:text-white transition-colors">About Us</Link></li>
                            <li><Link :href="route('sectors')" class="hover:text-white transition-colors">Sectors</Link></li>
                            <li><Link :href="route('news')" class="hover:text-white transition-colors">News & Events</Link></li>
                            <li><Link :href="route('directory.index')" class="hover:text-white transition-colors">Member Directory</Link></li>
                        </ul>
                    </div>

                    <div>
                        <h4 class="text-lg font-semibold mb-4">Contact</h4>
                        <ul class="space-y-2 text-blue-200">
                            <li>Livingstone, Zambia</li>
                            <li>info@livcci.org.zm</li>
                            <li>+260 123 456 789</li>
                        </ul>
                    </div>
                </div>

                <div class="border-t border-blue-800 mt-8 pt-8 text-center text-blue-200">
                    <p>&copy; 2026 Livingstone Chamber of Commerce & Industry. All rights reserved.</p>
                </div>
            </div>
        </footer>
    </div>
</template>