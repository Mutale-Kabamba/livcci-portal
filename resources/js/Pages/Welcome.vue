<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

defineProps({
    canLogin: {
        type: Boolean,
    },
    canRegister: {
        type: Boolean,
    },
    events: Array,
    approvedMembers: Array,
});

// Hero Carousel
const currentHeroIndex = ref(0);
const heroImages = [
    'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1540553016722-983e48a2cd10?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80',
];

// Auto-advance hero carousel
setInterval(() => {
    currentHeroIndex.value = (currentHeroIndex.value + 1) % heroImages.length;
}, 5000);

// Members Carousel
const membersScrollPosition = ref(0);
const scrollMembersLeft = () => {
    const container = document.getElementById('members-carousel');
    if (container) {
        container.scrollBy({ left: -300, behavior: 'smooth' });
    }
};
const scrollMembersRight = () => {
    const container = document.getElementById('members-carousel');
    if (container) {
        container.scrollBy({ left: 300, behavior: 'smooth' });
    }
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

const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'short', 
        day: 'numeric' 
    });
};
</script>

<template>
    <Head title="Home - Livingstone Chamber of Commerce & Industry" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900">
        
        <nav class="bg-white border-b border-gray-100 shadow-sm sticky top-0 z-50">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-20 items-center">
                    <div class="flex-shrink-0 flex items-center gap-3">
                        <img src="/images/logo.png" alt="LiVCCI Logo" class="h-16 w-auto object-contain">
                    </div>

                    <div class="hidden md:flex space-x-8 items-center">
                        <Link :href="route('about')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                    </div>

                    <div v-if="canLogin" class="flex items-center space-x-4">
                        <Link v-if="$page.props.auth.user" :href="route('dashboard')" class="text-sm font-bold text-[#1876C3] hover:text-[#1D2A68]">
                            Member Dashboard
                        </Link>
                        <template v-else>
                            <Link :href="route('login')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3]">Login</Link>
                            <Link v-if="canRegister" :href="route('register')" class="bg-[#1876C3] text-white text-sm font-bold py-2.5 px-5 rounded-md hover:bg-[#1460A0] shadow-md transition-colors">
                                Apply for Membership
                            </Link>
                        </template>
                    </div>
                </div>
            </div>
        </nav>

        <!-- HERO SECTION WITH CAROUSEL -->
        <div class="relative bg-[#1D2A68] overflow-hidden h-screen">
            <!-- Carousel Background -->
            <div class="absolute inset-0 transition-opacity duration-1000">
                <img 
                    :src="heroImages[currentHeroIndex]" 
                    class="w-full h-full object-cover opacity-30 mix-blend-overlay" 
                    :alt="'Hero ' + currentHeroIndex"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-24 px-4 sm:py-32 sm:px-6 lg:px-8 flex flex-col items-start justify-center h-full">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-5">
                    Together we make a difference for better business
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-2xl leading-tight">
                    Driving Economic Growth in Zambia's Tourist Capital
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-3xl">
                    We are dedicated to fostering a thriving business environment. Partner with us for invaluable resources, cross-border networking, and powerful advocacy in Livingstone.
                </p>
                <div class="mt-10 flex space-x-4">
                    <Link :href="route('register')" class="bg-[#F4B223] text-[#1D2A68] font-black py-3 px-8 rounded-md hover:bg-[#E0A11B] shadow-lg text-lg transition-all">
                        Join the Chamber
                    </Link>
                    <Link :href="route('directory.index')" class="bg-transparent border-2 border-[#F6EED8] text-[#F6EED8] font-bold py-3 px-8 rounded-md hover:bg-white/10 transition-all text-lg">
                        Explore Directory
                    </Link>
                </div>
            </div>

            <!-- Carousel Indicators -->
            <div class="absolute bottom-8 left-1/2 transform -translate-x-1/2 flex space-x-2">
                <button 
                    v-for="(_, index) in heroImages" 
                    :key="index"
                    @click="currentHeroIndex = index"
                    :class="['w-3 h-3 rounded-full transition-all', currentHeroIndex === index ? 'bg-[#F4B223] w-8' : 'bg-white/50']"
                ></button>
            </div>
        </div>

        <!-- CHAIRPERSON MESSAGE -->
        <div class="py-16 bg-white">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
                    <div>
                        <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60" alt="Chairperson" class="w-full rounded-lg shadow-lg">
                    </div>
                    <div>
                        <h2 class="text-3xl font-extrabold text-[#1D2A68] mb-4">Welcome from the Chairperson</h2>
                        <p class="text-lg text-gray-700 mb-4">
                            Dear Members and Partners,
                        </p>
                        <p class="text-gray-600 mb-4 leading-relaxed">
                            It is with great pleasure that I welcome you to the Livingstone Chamber of Commerce and Industry. As the economic heartbeat of southern Zambia, our organization serves as a vital bridge between government, business, and communities.
                        </p>
                        <p class="text-gray-600 mb-6 leading-relaxed">
                            Together, we champion policy reforms, facilitate trade missions, and empower entrepreneurs to achieve their dreams. Whether you're a startup, SME, or established corporation, we're here to support your growth journey.
                        </p>
                        <p class="text-lg font-semibold text-[#1D2A68]">
                            - Chairperson, LiVCCI
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- FEATURED NEWS & EVENTS -->
        <div class="py-16 bg-gray-50">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-end mb-12">
                    <div>
                        <h2 class="text-3xl font-extrabold text-[#1D2A68]">Latest News & Upcoming Events</h2>
                        <p class="mt-2 text-gray-600">Stay informed about what's happening in the chamber</p>
                    </div>
                    <Link :href="route('news')" class="text-[#1876C3] font-semibold hover:underline">View All →</Link>
                </div>

                <div v-if="events && events.length > 0" class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div v-for="event in events" :key="event.id" class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow border-l-4 border-[#1876C3]">
                        <div class="p-6">
                            <div class="flex justify-between items-start gap-4 mb-3">
                                <h3 class="text-xl font-bold text-[#1D2A68] flex-1">{{ event.title }}</h3>
                                <span :class="['px-3 py-1 rounded-full text-xs font-bold whitespace-nowrap', getTypeColor(event.type)]">
                                    {{ event.type }}
                                </span>
                            </div>
                            <p class="text-gray-600 mb-4">{{ event.description.substring(0, 120) }}...</p>
                            <div class="flex items-center justify-between">
                                <p class="text-sm text-gray-500">
                                    <span v-if="event.event_date">📅 {{ formatDate(event.event_date) }}</span>
                                </p>
                                <Link :href="route('news')" class="text-[#1876C3] hover:text-[#1460A0] font-semibold text-sm">Read More →</Link>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-else class="text-center py-12 bg-white rounded-lg">
                    <p class="text-gray-500">No events published yet. Check back soon!</p>
                </div>
            </div>
        </div>

        <!-- CORE VALUES -->
        <div class="py-16 bg-white">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="text-center mb-16">
                    <h2 class="text-3xl font-extrabold text-[#1D2A68]">Our Core Values</h2>
                    <p class="mt-4 text-lg text-gray-500">The principles that guide everything we do</p>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-10">
                    <div class="p-8 border border-gray-100 rounded-xl shadow-sm hover:shadow-md hover:border-[#F4B223] transition-all bg-gray-50 group">
                        <div class="w-12 h-12 bg-[#E8F1F8] text-[#1876C3] rounded-lg flex items-center justify-center mb-6 group-hover:bg-[#1876C3] group-hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z"></path></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">Policy Advocacy</h3>
                        <p class="text-gray-600">We monitor the regulatory environment and lobby stakeholders to ensure a favorable climate for Livingstone businesses.</p>
                    </div>

                    <div class="p-8 border border-gray-100 rounded-xl shadow-sm hover:shadow-md hover:border-[#F4B223] transition-all bg-gray-50 group">
                        <div class="w-12 h-12 bg-[#E8F1F8] text-[#1876C3] rounded-lg flex items-center justify-center mb-6 group-hover:bg-[#1876C3] group-hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">B2B Networking</h3>
                        <p class="text-gray-600">Gain access to exclusive business breakfasts, annual awards, and high-level trade missions across the region.</p>
                    </div>

                    <div class="p-8 border border-gray-100 rounded-xl shadow-sm hover:shadow-md hover:border-[#F4B223] transition-all bg-gray-50 group">
                        <div class="w-12 h-12 bg-[#E8F1F8] text-[#1876C3] rounded-lg flex items-center justify-center mb-6 group-hover:bg-[#1876C3] group-hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">Capacity Building</h3>
                        <p class="text-gray-600">We partner with local and international experts to deliver mentorship and digital skills training for growing MSMEs.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- KEY SECTORS -->
        <div class="py-16 bg-gray-50 border-t border-gray-200">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-end mb-10">
                    <div>
                        <h2 class="text-3xl font-extrabold text-[#1D2A68]">Key Economic Sectors</h2>
                        <p class="mt-2 text-gray-600">Connecting industries for sustainable regional development</p>
                    </div>
                    <Link :href="route('sectors')" class="text-[#1876C3] font-semibold hover:underline">Explore More →</Link>
                </div>

                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <Link :href="route('sectors')" class="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-center hover:border-[#F4B223] transition-colors cursor-pointer group">
                        <h4 class="font-bold text-[#1D2A68] group-hover:text-[#1876C3] transition-colors">Tourism & Hospitality</h4>
                    </Link>
                    <Link :href="route('sectors')" class="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-center hover:border-[#F4B223] transition-colors cursor-pointer group">
                        <h4 class="font-bold text-[#1D2A68] group-hover:text-[#1876C3] transition-colors">Transport & Logistics</h4>
                    </Link>
                    <Link :href="route('sectors')" class="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-center hover:border-[#F4B223] transition-colors cursor-pointer group">
                        <h4 class="font-bold text-[#1D2A68] group-hover:text-[#1876C3] transition-colors">Agriculture & Export</h4>
                    </Link>
                    <Link :href="route('sectors')" class="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-center hover:border-[#F4B223] transition-colors cursor-pointer group">
                        <h4 class="font-bold text-[#1D2A68] group-hover:text-[#1876C3] transition-colors">Tech & Digital Media</h4>
                    </Link>
                </div>
            </div>
        </div>

        <!-- OUR MEMBERS CAROUSEL -->
        <div class="py-16 bg-white">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-end mb-10">
                    <div>
                        <h2 class="text-3xl font-extrabold text-[#1D2A68]">Our Members</h2>
                        <p class="mt-2 text-gray-600">Proud to represent Livingstone's leading businesses</p>
                    </div>
                    <Link :href="route('directory.index')" class="text-[#1876C3] font-semibold hover:underline">View All Members →</Link>
                </div>

                <div v-if="approvedMembers && approvedMembers.length > 0" class="relative">
                    <!-- Carousel Container -->
                    <div id="members-carousel" class="flex overflow-x-auto scroll-smooth gap-6 pb-4">
                        <div v-for="member in approvedMembers" :key="member.id" class="flex-shrink-0 w-48 h-40 bg-gray-100 rounded-lg shadow-md border-2 border-gray-200 hover:border-[#1876C3] transition-colors flex items-center justify-center overflow-hidden">
                            <img 
                                v-if="member.logo_url" 
                                :src="member.logo_url" 
                                :alt="member.company_name"
                                class="w-full h-full object-contain p-4"
                            >
                            <div v-else class="text-center p-4">
                                <p class="font-bold text-[#1D2A68] text-sm">{{ member.company_name }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Carousel Controls -->
                    <button @click="scrollMembersLeft" class="absolute left-0 top-1/2 -translate-y-1/2 -translate-x-4 bg-[#1876C3] text-white p-2 rounded-full hover:bg-[#1460A0] shadow-lg">
                        ← 
                    </button>
                    <button @click="scrollMembersRight" class="absolute right-0 top-1/2 -translate-y-1/2 translate-x-4 bg-[#1876C3] text-white p-2 rounded-full hover:bg-[#1460A0] shadow-lg">
                        →
                    </button>
                </div>
                <div v-else class="text-center py-12 bg-gray-50 rounded-lg">
                    <p class="text-gray-500">No approved members yet.</p>
                </div>
            </div>
        </div>

        <!-- LEADERSHIP SECTION -->
        <div class="py-16 bg-gray-50">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h2 class="text-3xl font-extrabold text-[#1D2A68] mb-12 text-center">Our Leadership</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
                        <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60" alt="Chairperson" class="w-full h-64 object-cover">
                        <div class="p-6 text-center">
                            <h3 class="text-xl font-bold text-[#1D2A68]">Chairperson</h3>
                            <p class="text-gray-600 text-sm mt-2">Leading our organization with vision and integrity</p>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
                        <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60" alt="Vice Chairperson" class="w-full h-64 object-cover">
                        <div class="p-6 text-center">
                            <h3 class="text-xl font-bold text-[#1D2A68]">Vice Chairperson</h3>
                            <p class="text-gray-600 text-sm mt-2">Supporting strategic initiatives and member advocacy</p>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
                        <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60" alt="Executive Director" class="w-full h-64 object-cover">
                        <div class="p-6 text-center">
                            <h3 class="text-xl font-bold text-[#1D2A68]">Executive Director</h3>
                            <p class="text-gray-600 text-sm mt-2">Managing operations and member services</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- CTA & CONTACT SECTION -->
        <div class="py-16 bg-[#1D2A68] text-white">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                    <!-- CTA -->
                    <div>
                        <h2 class="text-3xl font-extrabold mb-6">Ready to Join?</h2>
                        <p class="text-blue-200 mb-8 text-lg">
                            Become part of Livingstone's most dynamic business community. Access exclusive resources, networking opportunities, and business growth support.
                        </p>
                        <Link :href="route('register')" class="inline-block bg-[#F4B223] hover:bg-[#E0A11B] text-[#1D2A68] font-bold py-3 px-8 rounded-md shadow-lg transition-colors">
                            Start Your Membership
                        </Link>
                    </div>

                    <!-- Contact Form -->
                    <div class="bg-white/10 backdrop-blur-sm rounded-xl p-8">
                        <h3 class="text-2xl font-bold mb-6">Get in Touch</h3>
                        <form class="space-y-4">
                            <div>
                                <input type="text" placeholder="Your Name" class="w-full px-4 py-2 rounded-lg text-gray-900 focus:ring-2 focus:ring-[#F4B223]">
                            </div>
                            <div>
                                <input type="email" placeholder="Your Email" class="w-full px-4 py-2 rounded-lg text-gray-900 focus:ring-2 focus:ring-[#F4B223]">
                            </div>
                            <div>
                                <textarea placeholder="Your Message" rows="3" class="w-full px-4 py-2 rounded-lg text-gray-900 focus:ring-2 focus:ring-[#F4B223]"></textarea>
                            </div>
                            <button type="submit" class="w-full bg-[#F4B223] hover:bg-[#E0A11B] text-[#1D2A68] font-bold py-2 rounded-lg transition-colors">
                                Send Message
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <footer class="bg-[#121A42] pt-16 pb-8">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-12 border-b border-[#1D2A68] pb-12">
                    <div class="col-span-1 md:col-span-2">
                        <div class="flex items-center gap-3 mb-6 text-white">
                            <img src="/images/logo-white.png" alt="LiVCCI Logo" class="h-12 w-auto">
                            <span class="text-xl font-black tracking-tight text-[#F6EED8]">LiVCCI</span>
                        </div>
                        <p class="text-blue-200 max-w-sm mb-6">The Livingstone Chamber of Commerce and Industry is committed to promoting an enabling multi-sectoral business environment.</p>
                        <Link :href="route('admin.dashboard')" class="text-[#F4B223] hover:text-[#E8A01A] font-semibold transition-colors">Admin Login</Link>
                    </div>
                    
                    <div>
                        <h4 class="text-[#F4B223] font-bold mb-4">Quick Links</h4>
                        <ul class="space-y-2 text-blue-200">
                            <li><Link :href="route('about')" class="hover:text-white transition-colors">About Us</Link></li>
                            <li><Link :href="route('sectors')" class="hover:text-white transition-colors">Sectors</Link></li>
                            <li><Link :href="route('news')" class="hover:text-white transition-colors">News & Events</Link></li>
                            <li><Link :href="route('directory.index')" class="hover:text-white transition-colors">Member Directory</Link></li>
                            <li><Link :href="route('register')" class="hover:text-white transition-colors">Join the Chamber</Link></li>
                        </ul>
                    </div>

                    <div>
                        <h4 class="text-[#F4B223] font-bold mb-4">Contact</h4>
                        <ul class="space-y-2 text-blue-200 text-sm">
                            <li>Livingstone, Zambia</li>
                            <li>info@livcci.org</li>
                            <li>+260 977 885 959</li>
                        </ul>
                    </div>
                </div>
                
                <div class="flex flex-col md:flex-row justify-between items-center mt-8 text-sm text-blue-300">
                    <p>&copy; 2026 Livingstone Chamber of Commerce & Industry. All rights reserved.</p>
                    <p class="mt-4 md:mt-0">Designed & Developed by <span class="font-bold text-[#F4B223]">Ori Studio Limited</span></p>
                </div>
            </div>
        </footer>

    </div>
</template>