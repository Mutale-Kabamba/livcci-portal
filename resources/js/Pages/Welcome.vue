<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    canLogin: {
        type: Boolean,
    },
    canRegister: {
        type: Boolean,
    },
    events: Array,
    approvedMembers: Array,
    content: {
        type: Object,
        default: () => ({})
    }
});

// Scroll animation state
const scrollY = ref(0);
const visibleElements = ref(new Set());
let heroIntervalId = null;
let observerInstance = null;

// Hero Carousel
const currentHeroIndex = ref(0);
const heroImages = [
    'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1540553016722-983e48a2cd10?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1444653614773-995cb1ef9efa?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80',
];

const heroStats = computed(() => [
    {
        label: 'Approved Members',
        value: props.approvedMembers?.length || 0,
    },
    {
        label: 'Upcoming Events',
        value: props.events?.length || 0,
    },
    {
        label: 'Core Sectors',
        value: homeSectors.value?.length || 0,
    },
]);

const defaultHeroContent = {
    badge: 'Together we make a difference for better business',
    title: "Driving Economic Growth in Zambia's Tourist Capital",
    description: "We are dedicated to fostering a thriving business environment. Partner with us for invaluable resources, cross-border networking, and powerful advocacy in Livingstone."
};

const defaultChairperson = {
    title: 'Welcome! from the Chairperson',
    greeting: 'Dear Members and Partners,',
    paragraph_one: 'It is with great pleasure that I welcome you to the Livingstone Chamber of Commerce and Industry. As the economic heartbeat of southern Zambia, our organization serves as a vital bridge between government, business, and communities.',
    paragraph_two: "Together, we champion policy reforms, facilitate trade missions, and empower entrepreneurs to achieve their dreams. Whether you're a startup, SME, or established corporation, we're here to support your growth journey.",
    signature: '- Chairperson, LiVCCI'
};

const defaultCoreValues = [
    {
        title: 'Policy Advocacy',
        description: 'We monitor the regulatory environment and lobby stakeholders to ensure a favorable climate for Livingstone businesses.'
    },
    {
        title: 'B2B Networking',
        description: 'Gain access to exclusive business breakfasts, annual awards, and high-level trade missions across the region.'
    },
    {
        title: 'Capacity Building',
        description: 'We partner with local and international experts to deliver mentorship and digital skills training for growing MSMEs.'
    }
];

const defaultHomeSectors = [
    { title: 'Tourism & Hospitality' },
    { title: 'Transport & Logistics' },
    { title: 'Agriculture & Export' },
    { title: 'Tech & Digital Media' },
];

const heroContent = computed(() => props.content.hero || defaultHeroContent);
const chairperson = computed(() => props.content.chairperson || defaultChairperson);
const coreValues = computed(() => props.content.core_values || defaultCoreValues);
const homeSectors = computed(() => props.content.home_sectors || defaultHomeSectors);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Intersection Observer for fade-in animations
onMounted(() => {
    window.addEventListener('scroll', handleScroll);

    heroIntervalId = setInterval(() => {
        currentHeroIndex.value = (currentHeroIndex.value + 1) % heroImages.length;
    }, 5000);
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    observerInstance = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                visibleElements.value.add(entry.target);
            }
        });
    }, observerOptions);
    
    // Observe all elements with data-scroll attribute
    document.querySelectorAll('[data-scroll]').forEach(el => {
        observerInstance.observe(el);
    });
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
    if (heroIntervalId) {
        clearInterval(heroIntervalId);
    }
    if (observerInstance) {
        observerInstance.disconnect();
    }
});

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
        
        <!-- Navigation with scroll effect -->
        <nav :class="['bg-white border-b border-gray-100 sticky top-0 z-50 transition-all duration-300', scrollY > 10 ? 'shadow-lg' : 'shadow-sm']">
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
                        
                        <!-- More Dropdown -->
                        <div class="relative group">
                            <button class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors flex items-center gap-1">
                                More
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"/>
                                </svg>
                            </button>
                            <div class="absolute left-0 mt-0 w-48 bg-white shadow-lg rounded-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50 border border-gray-100">
                                <Link :href="route('leadership')" class="block px-4 py-3 text-sm text-gray-700 hover:bg-blue-50 hover:text-[#1876C3] transition-colors">Leadership</Link>
                                <Link :href="route('membership')" class="block px-4 py-3 text-sm text-gray-700 hover:bg-blue-50 hover:text-[#1876C3] transition-colors border-t border-gray-100">Membership</Link>
                                <Link :href="route('strategic-goals')" class="block px-4 py-3 text-sm text-gray-700 hover:bg-blue-50 hover:text-[#1876C3] transition-colors border-t border-gray-100">Strategic Goals</Link>
                            </div>
                        </div>
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
        <div class="relative bg-[#1D2A68] overflow-hidden h-screen" data-scroll>
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
            <div class="relative max-w-7xl mx-auto py-24 px-4 sm:py-32 sm:px-6 lg:px-8 flex flex-col items-start justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-5">
                    {{ heroContent.badge }}
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-2xl leading-tight">
                    {{ heroContent.title }}
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-3xl">
                    {{ heroContent.description }}
                </p>
                <div class="mt-10 flex space-x-4">
                    <Link :href="route('register')" class="bg-[#F4B223] text-[#1D2A68] font-black py-3 px-8 rounded-md hover:bg-[#E0A11B] shadow-lg text-lg transition-all">
                        Join the Chamber
                    </Link>
                    <Link :href="route('directory.index')" class="bg-transparent border-2 border-[#F6EED8] text-[#F6EED8] font-bold py-3 px-8 rounded-md hover:bg-white/10 transition-all text-lg">
                        Explore Directory
                    </Link>
                </div>

                <div class="mt-10 grid grid-cols-1 sm:grid-cols-3 gap-3 w-full max-w-3xl">
                    <div v-for="item in heroStats" :key="item.label" class="rounded-xl border border-white/20 bg-white/10 backdrop-blur-sm px-4 py-3">
                        <div class="text-blue-100 text-xs uppercase tracking-wide">{{ item.label }}</div>
                        <div class="text-white text-2xl font-black mt-1">{{ item.value }}</div>
                    </div>
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

        <!-- QUICK ACTIONS -->
        <div class="py-10 bg-white border-b border-gray-200" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <Link :href="route('register')" class="rounded-xl border border-gray-200 p-5 hover:border-[#1876C3] hover:shadow-md transition-all duration-300">
                        <p class="text-xs font-bold uppercase tracking-wide text-[#1876C3]">New Member</p>
                        <h3 class="mt-2 text-lg font-extrabold text-[#1D2A68]">Start Membership Application</h3>
                        <p class="mt-1 text-sm text-gray-600">Apply online and join the chamber network.</p>
                    </Link>
                    <Link :href="route('directory.index')" class="rounded-xl border border-gray-200 p-5 hover:border-[#1876C3] hover:shadow-md transition-all duration-300">
                        <p class="text-xs font-bold uppercase tracking-wide text-[#1876C3]">Find Partners</p>
                        <h3 class="mt-2 text-lg font-extrabold text-[#1D2A68]">Browse Member Directory</h3>
                        <p class="mt-1 text-sm text-gray-600">Discover verified local businesses by sector.</p>
                    </Link>
                    <Link :href="route('news')" class="rounded-xl border border-gray-200 p-5 hover:border-[#1876C3] hover:shadow-md transition-all duration-300">
                        <p class="text-xs font-bold uppercase tracking-wide text-[#1876C3]">Stay Current</p>
                        <h3 class="mt-2 text-lg font-extrabold text-[#1D2A68]">See News & Events</h3>
                        <p class="mt-1 text-sm text-gray-600">Track chamber updates, workshops, and expos.</p>
                    </Link>
                </div>
            </div>
        </div>

        <!-- CHAIRPERSON MESSAGE -->
        <div class="py-16 bg-white" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
                    <div class="opacity-0 -translate-x-10 transition-all duration-700 animate-in">
                        <img src="images/leader/man2.png" alt="Chairperson" >
                    </div>
                    <div class="opacity-0 translate-x-10 transition-all duration-700 animate-in">
                        <h2 class="text-3xl font-extrabold text-[#1D2A68] mb-4">{{ chairperson.title }}</h2>
                        <p class="text-lg text-gray-700 mb-4">
                            {{ chairperson.greeting }}
                        </p>
                        <p class="text-gray-600 mb-4 leading-relaxed">
                            {{ chairperson.paragraph_one }}
                        </p>
                        <p class="text-gray-600 mb-6 leading-relaxed">
                            {{ chairperson.paragraph_two }}
                        </p>
                        <p class="text-lg font-semibold text-[#1D2A68]">
                            {{ chairperson.signature }}
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- FEATURED NEWS & EVENTS -->
        <div class="py-16 bg-gray-50" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-end mb-12">
                    <div class="opacity-0 translate-y-10 transition-all duration-700 animate-in">
                        <h2 class="text-3xl font-extrabold text-[#1D2A68]">Latest News & Upcoming Events</h2>
                        <p class="mt-2 text-gray-600">Stay informed about what's happening in the chamber</p>
                    </div>
                    <Link :href="route('news')" class="text-[#1876C3] font-semibold hover:underline">View All →</Link>
                </div>

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
                            <div class="absolute bottom-0 left-0 right-0 bg-[#F4B223] text-[#1D2A68] py-2 px-4 text-center font-bold text-sm">
                                {{ formatDate(event.event_date) }}
                            </div>
                        </div>

                        <!-- Content -->
                        <div class="p-6">
                            <h3 class="text-lg font-bold text-[#1D2A68] mb-2 line-clamp-2 group-hover:text-[#1876C3] transition-colors">{{ event.title }}</h3>
                            <p class="text-gray-600 text-sm mb-4 line-clamp-2">{{ event.description }}</p>
                            <div class="flex items-center justify-between">
                                <span :class="['px-3 py-1 rounded text-xs font-bold', getTypeColor(event.type)]">
                                    {{ event.type }}
                                </span>
                                <a 
                                    v-if="event.external_link"
                                    :href="event.external_link"
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    class="text-[#1876C3] font-semibold text-sm hover:underline cursor-pointer"
                                >
                                    Read More →
                                </a>
                                <span v-else class="text-gray-400 font-semibold text-sm">Read More →</span>
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
        <div class="py-16 bg-white" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="text-center mb-16 opacity-0 translate-y-10 transition-all duration-700 animate-in">
                    <h2 class="text-3xl font-extrabold text-[#1D2A68]">Our Core Values</h2>
                    <p class="mt-4 text-lg text-gray-500">The principles that guide everything we do</p>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-10">
                    <div v-for="(value, index) in coreValues" :key="index" class="p-8 border border-gray-100 rounded-xl shadow-sm hover:shadow-md hover:border-[#F4B223] transition-all bg-gray-50 group opacity-0 scale-95 transition-all duration-700 animate-in" :style="{ transitionDelay: `${index * 150}ms` }">
                        <div class="w-12 h-12 bg-[#E8F1F8] text-[#1876C3] rounded-lg flex items-center justify-center mb-6 group-hover:bg-[#1876C3] group-hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z"></path></svg>
                        </div>
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">{{ value.title }}</h3>
                        <p class="text-gray-600">{{ value.description }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- KEY SECTORS -->
        <div class="py-16 bg-gray-50 border-t border-gray-200" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-end mb-10">
                    <div class="opacity-0 translate-y-10 transition-all duration-700 animate-in">
                        <h2 class="text-3xl font-extrabold text-[#1D2A68]">Key Economic Sectors</h2>
                        <p class="mt-2 text-gray-600">Connecting industries for sustainable regional development</p>
                    </div>
                    <Link :href="route('sectors')" class="text-[#1876C3] font-semibold hover:underline">Explore More →</Link>
                </div>

                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <Link v-for="(sector, index) in homeSectors" :key="index" :href="route('sectors')" class="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-center hover:border-[#F4B223] transition-all opacity-0 translate-y-10 animate-in" :style="{ transitionDelay: `${index * 100}ms` }">
                        <h4 class="font-bold text-[#1D2A68] hover:text-[#1876C3] transition-colors">{{ sector.title }}</h4>
                    </Link>
                </div>
            </div>
        </div>

        <!-- OUR MEMBERS CAROUSEL -->
        <div class="py-16 bg-white" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-end mb-10">
                    <div class="opacity-0 translate-y-10 transition-all duration-700 animate-in">
                        <h2 class="text-3xl font-extrabold text-[#1D2A68]">Our Members</h2>
                        <p class="mt-2 text-gray-600">Proud to represent Livingstone's leading businesses</p>
                    </div>
                    <Link :href="route('directory.index')" class="text-[#1876C3] font-semibold hover:underline">View All Members →</Link>
                </div>

                <div v-if="approvedMembers && approvedMembers.length > 0" class="relative">
                    <!-- Carousel Container -->
                    <div id="members-carousel" class="flex overflow-x-auto scroll-smooth gap-6 pb-4">
                        <div
                            v-for="member in approvedMembers"
                            :key="member.id"
                            class="flex-shrink-0 w-48 h-40 bg-white rounded-lg transition-all hover:scale-105 flex items-center justify-center overflow-hidden"
                        >
                            <img
                                :src="member.logo_url || '/images/member.png'"
                                :alt="member.company_name"
                                class="w-full h-full object-contain p-4 transition-transform duration-300"
                            >
                        </div>
                    </div>

                    <!-- Carousel Controls -->
                    <button @click="scrollMembersLeft" class="absolute left-0 top-1/2 -translate-y-1/2 -translate-x-4 bg-[#1876C3] text-white p-2 rounded-full hover:bg-[#1460A0] shadow-lg transition-all hover:scale-110">
                        ← 
                    </button>
                    <button @click="scrollMembersRight" class="absolute right-0 top-1/2 -translate-y-1/2 translate-x-4 bg-[#1876C3] text-white p-2 rounded-full hover:bg-[#1460A0] shadow-lg transition-all hover:scale-110">
                        →
                    </button>
                </div>
                <div v-else class="text-center py-12 bg-gray-50 rounded-lg">
                    <p class="text-gray-500">No approved members yet.</p>
                </div>
            </div>
        </div>

        <!-- LEADERSHIP SECTION -->
        <div class="py-16 bg-gray-50" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h2 class="text-3xl font-extrabold text-[#1D2A68] mb-12 text-center opacity-0 translate-y-10 transition-all duration-700 animate-in">Our Leadership</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <div v-for="(leader, index) in 3" :key="index" class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-all opacity-0 -translate-y-10 animate-in" :style="{ transitionDelay: `${index * 150}ms` }">
                        <img :src="['https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60'][index]" :alt="['Chairperson', 'Vice Chairperson', 'Executive Director'][index]" class="w-full h-64 object-cover">
                        <div class="p-6 text-center">
                            <h3 class="text-xl font-bold text-[#1D2A68]">{{ ['Chairperson', 'Vice Chairperson', 'Executive Director'][index] }}</h3>
                            <p class="text-gray-600 text-sm mt-2">{{ ['Leading our organization with vision and integrity', 'Supporting strategic initiatives and member advocacy', 'Managing operations and member services'][index] }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- CTA & CONTACT SECTION -->
        <div class="py-16 bg-[#1D2A68] text-white" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                    <!-- CTA -->
                    <div class="opacity-0 -translate-x-10 transition-all duration-700 animate-in">
                        <h2 class="text-3xl font-extrabold mb-6">Ready to Join?</h2>
                        <p class="text-blue-200 mb-8 text-lg">
                            Become part of Livingstone's most dynamic business community. Access exclusive resources, networking opportunities, and business growth support.
                        </p>
                        <Link :href="route('register')" class="inline-block bg-[#F4B223] hover:bg-[#E0A11B] text-[#1D2A68] font-bold py-3 px-8 rounded-md shadow-lg transition-all hover:scale-105">
                            Start Your Membership
                        </Link>
                    </div>

                    <!-- Contact Form -->
                    <div class="bg-white/10 backdrop-blur-sm rounded-xl p-8 opacity-0 translate-x-10 transition-all duration-700 animate-in">
                        <h3 class="text-2xl font-bold mb-6">Get in Touch</h3>
                        <form class="space-y-4">
                            <div>
                                <input type="text" placeholder="Your Name" class="w-full px-4 py-2 rounded-lg text-gray-900 focus:ring-2 focus:ring-[#F4B223] transition-all">
                            </div>
                            <div>
                                <input type="email" placeholder="Your Email" class="w-full px-4 py-2 rounded-lg text-gray-900 focus:ring-2 focus:ring-[#F4B223] transition-all">
                            </div>
                            <div>
                                <textarea placeholder="Your Message" rows="3" class="w-full px-4 py-2 rounded-lg text-gray-900 focus:ring-2 focus:ring-[#F4B223] transition-all"></textarea>
                            </div>
                            <button type="submit" class="w-full bg-[#F4B223] hover:bg-[#E0A11B] text-[#1D2A68] font-bold py-2 rounded-lg transition-all hover:shadow-lg">
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
                <div class="grid grid-cols-1 md:grid-cols-5 gap-8 md:gap-12 border-b border-[#1D2A68] pb-12">
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
                        <h4 class="text-[#F4B223] font-bold mb-4">Important Links</h4>
                        <ul class="space-y-2 text-blue-200 text-sm">
                            <li><a href="https://www.pacra.org.zm/" target="_blank" rel="noopener noreferrer" class="hover:text-white transition-colors">PACRA</a></li>
                            <li><a href="https://www.zra.org.zm/" target="_blank" rel="noopener noreferrer" class="hover:text-white transition-colors">ZRA</a></li>
                            <li><a href="https://www.ceec.org.zm/" target="_blank" rel="noopener noreferrer" class="hover:text-white transition-colors">CEEC</a></li>
                            <li><a href="https://zambiachamber.org/" target="_blank" rel="noopener noreferrer" class="hover:text-white transition-colors">ZACCI</a></li>
                            <li><a href="https://www.boz.zm/" target="_blank" rel="noopener noreferrer" class="hover:text-white transition-colors">BOZ</a></li>
                        </ul>
                    </div>

                    <div>
                        <h4 class="text-[#F4B223] font-bold mb-4">Contact</h4>
                        <ul class="space-y-2 text-blue-200 text-sm">
                            <li>PO Box 4037, Livingstone</li>
                            <li>livcci@yahoo.com</li>
                            <li>+260 977 105068</li>
                            <li>+260 977 885959</li>
                        </ul>
                        <!-- Social Media Icons -->
                        <div class="flex gap-4 mt-6">
                            <a href="https://www.facebook.com/livcci" target="_blank" rel="noopener noreferrer" class="text-blue-200 hover:text-[#F4B223] transition-colors" title="Follow us on Facebook">
                                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                                </svg>
                            </a>
                            <a href="https://www.linkedin.com/company/livcci" target="_blank" rel="noopener noreferrer" class="text-blue-200 hover:text-[#F4B223] transition-colors" title="Follow us on LinkedIn">
                                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.475-2.236-1.986-2.236-1.081 0-1.722.722-2.004 1.418-.103.249-.129.597-.129.946v5.441h-3.554s.047-8.733 0-9.652h3.554v1.366c.43-.664 1.199-1.61 2.920-1.61 2.135 0 3.733 1.39 3.733 4.38v5.516zM5.337 8.855c-1.144 0-1.915-.762-1.915-1.715 0-.953.77-1.715 1.958-1.715 1.188 0 1.915.762 1.915 1.715 0 .953-.726 1.715-1.958 1.715zm1.608 11.597H3.73V9.097h3.215v11.355zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.225 0z"/>
                                </svg>
                            </a>
                        </div>
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

<style scoped>
@keyframes slideInUp {
    from {
        opacity: 0;
        transform: translateY(40px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes slideInLeft {
    from {
        opacity: 0;
        transform: translateX(-40px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes slideInRight {
    from {
        opacity: 0;
        transform: translateX(40px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes scaleIn {
    from {
        opacity: 0;
        transform: scale(0.95);
    }
    to {
        opacity: 1;
        transform: scale(1);
    }
}

.animate-in {
    animation: slideInUp 0.6s ease-out forwards;
}
</style>