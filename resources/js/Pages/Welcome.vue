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

const sectorVisualCatalog = [
    {
        title: 'Tourism & Hospitality',
        subtitle: 'Hotels, travel services, and destination experiences',
        image: 'https://images.unsplash.com/photo-1439130490301-25e322d88054?auto=format&fit=crop&w=1200&q=80',
    },
    {
        title: 'Transport & Logistics',
        subtitle: 'Freight mobility, supply chains, and distribution',
        image: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1200&q=80',
    },
    {
        title: 'Agriculture & Export',
        subtitle: 'Agri-value chains, processing, and market access',
        image: 'https://images.unsplash.com/photo-1523741543316-beb7fc7023d8?auto=format&fit=crop&w=1200&q=80',
    },
    {
        title: 'Tech & Digital Media',
        subtitle: 'Digital services, innovation, and creative tech',
        image: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
    },
];

const heroContent = computed(() => props.content.hero || defaultHeroContent);
const chairperson = computed(() => props.content.chairperson || defaultChairperson);
const coreValues = computed(() => props.content.core_values || defaultCoreValues);
const homeSectors = computed(() => props.content.home_sectors || defaultHomeSectors);
const homeSectorCards = computed(() => {
    const sectors = Array.isArray(homeSectors.value) ? homeSectors.value : [];

    return sectors.map((sector, index) => {
        const fallback = sectorVisualCatalog[index % sectorVisualCatalog.length];

        return {
            title: sector?.title || fallback.title,
            subtitle: sector?.subtitle || fallback.subtitle,
            image: sector?.image || fallback.image,
        };
    });
});
const spotlightContent = computed(() => props.content.member_spotlight || {});

const spotlightProfile = computed(() => {
    const profileId = Number(spotlightContent.value?.profile_id || 0);
    const members = Array.isArray(props.approvedMembers) ? props.approvedMembers : [];
    if (profileId > 0) {
        return members.find((member) => Number(member.id) === profileId) || members[0] || null;
    }
    return members[0] || null;
});

const spotlightTitle = computed(() => spotlightContent.value?.title || 'Member (Business Profile) Spotlight');
const spotlightSubtitle = computed(() => spotlightContent.value?.subtitle || 'Featured chamber member of the week');
const spotlightBlurb = computed(() => spotlightContent.value?.blurb || 'Discover outstanding member businesses and connect with trusted companies in our network.');
const spotlightCta = computed(() => spotlightContent.value?.cta_text || 'View Full Profile');

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

const marqueeMembers = computed(() => {
    const members = Array.isArray(props.approvedMembers) ? props.approvedMembers : [];
    return members.length > 1 ? [...members, ...members] : members;
});

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

const getEventCardClass = (type) => {
    const styles = {
        Meeting: 'border-blue-200 hover:border-blue-400 hover:shadow-blue-100/60',
        Workshop: 'border-purple-200 hover:border-purple-400 hover:shadow-purple-100/60',
        Expo: 'border-green-200 hover:border-green-400 hover:shadow-green-100/60',
        News: 'border-orange-200 hover:border-orange-400 hover:shadow-orange-100/60',
    };
    return styles[type] || 'border-gray-200 hover:border-gray-300';
};

const getEventDateBarClass = (type) => {
    const styles = {
        Meeting: 'bg-blue-600 text-white',
        Workshop: 'bg-purple-600 text-white',
        Expo: 'bg-green-600 text-white',
        News: 'bg-orange-500 text-white',
    };
    return styles[type] || 'bg-[#F4B223] text-[#1D2A68]';
};

const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'short', 
        day: 'numeric' 
    });
};

const onMemberLogoError = (event) => {
    const fallbackSrc = '/images/member.png';
    if (event?.target && event.target.src !== fallbackSrc) {
        event.target.onerror = null;
        event.target.src = fallbackSrc;
    }
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
                    <Link :href="route('register')" class="group rounded-xl border border-gray-200 bg-white p-5 hover:border-[#1876C3] hover:shadow-md transition-all duration-300 h-full flex flex-col">
                        <p class="text-xs font-bold uppercase tracking-wide text-[#1876C3]">New Member</p>
                        <h3 class="mt-2 text-lg font-extrabold text-[#1D2A68]">Start Membership Application</h3>
                        <p class="mt-1 text-sm text-gray-600">Apply online and join the chamber network.</p>
                        <span class="mt-5 inline-flex items-center gap-2 text-sm font-bold text-[#1876C3] group-hover:text-[#1460A0]">
                            Apply Now
                            <span class="transform transition-transform duration-300 group-hover:translate-x-1">→</span>
                        </span>
                    </Link>
                    <Link :href="route('directory.index')" class="group rounded-xl border border-gray-200 bg-white p-5 hover:border-[#1876C3] hover:shadow-md transition-all duration-300 h-full flex flex-col">
                        <p class="text-xs font-bold uppercase tracking-wide text-[#1876C3]">Find Partners</p>
                        <h3 class="mt-2 text-lg font-extrabold text-[#1D2A68]">Browse Member Directory</h3>
                        <p class="mt-1 text-sm text-gray-600">Discover verified local businesses by sector.</p>
                        <span class="mt-5 inline-flex items-center gap-2 text-sm font-bold text-[#1876C3] group-hover:text-[#1460A0]">
                            View Directory
                            <span class="transform transition-transform duration-300 group-hover:translate-x-1">→</span>
                        </span>
                    </Link>
                    <Link :href="route('news')" class="group rounded-xl border border-gray-200 bg-white p-5 hover:border-[#1876C3] hover:shadow-md transition-all duration-300 h-full flex flex-col">
                        <p class="text-xs font-bold uppercase tracking-wide text-[#1876C3]">Stay Current</p>
                        <h3 class="mt-2 text-lg font-extrabold text-[#1D2A68]">See News & Events</h3>
                        <p class="mt-1 text-sm text-gray-600">Track chamber updates, workshops, and expos.</p>
                        <span class="mt-5 inline-flex items-center gap-2 text-sm font-bold text-[#1876C3] group-hover:text-[#1460A0]">
                            Read Updates
                            <span class="transform transition-transform duration-300 group-hover:translate-x-1">→</span>
                        </span>
                    </Link>
                </div>
            </div>
        </div>

        <!-- CHAIRPERSON MESSAGE -->
        <div class="py-20 bg-gradient-to-b from-white to-[#f8fafc] border-y border-gray-100" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-10 lg:gap-14 items-center">
                    <div class="opacity-0 -translate-x-10 transition-all duration-700 animate-in rounded-2xl bg-[#eef4ff] border border-[#dbe7ff] p-6 lg:p-8">
                        <img src="images/leader/man2.png" alt="Chairperson" class="w-full max-h-[520px] object-contain drop-shadow-xl" >
                    </div>

                    <div class="opacity-0 translate-x-10 transition-all duration-700 animate-in bg-white rounded-2xl border border-gray-200 shadow-sm p-7 lg:p-9">
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-[#1876C3]">Leadership Message</p>
                        <h2 class="text-3xl lg:text-4xl font-extrabold text-[#1D2A68] mt-3 mb-5 leading-tight">{{ chairperson.title }}</h2>

                        <p class="text-xl text-gray-700 font-medium mb-5">
                            {{ chairperson.greeting }}
                        </p>

                        <p class="text-gray-600 mb-5 leading-8 text-[1.05rem]">
                            {{ chairperson.paragraph_one }}
                        </p>

                        <p class="text-gray-600 mb-7 leading-8 text-[1.05rem]">
                            {{ chairperson.paragraph_two }}
                        </p>

                        <div class="pt-5 border-t border-gray-200">
                            <p class="text-xl font-bold text-[#1D2A68] tracking-tight">
                                {{ chairperson.signature }}
                            </p>
                        </div>
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
                    <div v-for="(event, index) in events" :key="event.id" :class="['bg-white rounded-lg border shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in', getEventCardClass(event.type)]" :style="{ transitionDelay: `${index * 100}ms` }">
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
                            <div :class="['absolute bottom-0 left-0 right-0 py-2 px-4 text-center font-bold text-sm', getEventDateBarClass(event.type)]">
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
                        <p class="text-xs font-bold uppercase tracking-[0.2em] text-[#1876C3]">Sector Intelligence</p>
                        <h2 class="text-3xl md:text-4xl font-extrabold text-[#1D2A68] mt-2">Key Economic Sectors</h2>
                        <p class="mt-3 text-gray-600 max-w-2xl">Connecting industries for sustainable regional development through stronger partnerships, visibility, and investment readiness.</p>
                    </div>
                    <Link :href="route('sectors')" class="text-[#1876C3] font-semibold hover:underline">Explore More →</Link>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Link
                        v-for="(sector, index) in homeSectorCards"
                        :key="index"
                        :href="route('sectors')"
                        class="group relative rounded-2xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-500 opacity-0 translate-y-10 animate-in min-h-[280px]"
                        :style="{ transitionDelay: `${index * 100}ms` }"
                    >
                        <img
                            :src="sector.image"
                            :alt="sector.title"
                            class="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                        >
                        <div class="absolute inset-0 bg-gradient-to-t from-[#121a42]/95 via-[#1d2a68]/70 to-[#1d2a68]/20"></div>

                        <div class="relative h-full p-5 flex flex-col justify-end">
                            <h4 class="text-white text-lg font-extrabold leading-tight">{{ sector.title }}</h4>
                            <p class="text-blue-100 text-sm mt-2 leading-relaxed">{{ sector.subtitle }}</p>
                            <span class="mt-4 inline-flex items-center text-[#F4B223] text-sm font-bold tracking-wide">
                                View Sector
                                <span class="ml-2 transform transition-transform duration-300 group-hover:translate-x-1">→</span>
                            </span>
                        </div>
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

                <div v-if="approvedMembers && approvedMembers.length > 0" class="relative overflow-hidden py-2">
                    <div class="pointer-events-none absolute inset-y-0 left-0 w-16 bg-gradient-to-r from-white to-transparent z-10"></div>
                    <div class="pointer-events-none absolute inset-y-0 right-0 w-16 bg-gradient-to-l from-white to-transparent z-10"></div>

                    <div class="member-marquee-track">
                        <div
                            v-for="(member, index) in marqueeMembers"
                            :key="`${member.id}-${index}`"
                            :aria-hidden="index >= approvedMembers.length"
                            class="flex-shrink-0 w-48 h-32 bg-white rounded-lg transition-all hover:scale-105 flex items-center justify-center overflow-hidden mx-3"
                        >
                            <img
                                :src="member.logo_url || '/images/member.png'"
                                :alt="member.company_name"
                                @error="onMemberLogoError"
                                class="w-full h-full object-contain p-4 transition-transform duration-300"
                            >
                        </div>
                    </div>
                </div>
                <div v-else class="text-center py-12 bg-gray-50 rounded-lg">
                    <p class="text-gray-500">No approved members yet.</p>
                </div>
            </div>
        </div>

        <!-- MEMBER SPOTLIGHT SECTION -->
        <div class="py-16 bg-gray-50" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="bg-[#eef4ff] rounded-sm p-8 md:p-10 border border-[#dbeafe] opacity-0 translate-y-10 transition-all duration-700 animate-in">
                    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-8">
                        <div>
                            <p class="text-[#1876C3] text-3xl font-bold uppercase tracking-wide">Member Spotlight</p>
                            <div class="mt-3 flex items-center gap-3 flex-wrap">
                                <span class="text-[#1D2A68] text-3xl md:text-5xl font-black tracking-tight">LiVCCI</span>
                                <span class="bg-[#1D2A68] text-[#F4B223] text-2xl md:text-4xl font-black px-4 py-1 leading-none">Member Spotlight</span>
                            </div>
                        </div>

                        <div class="flex gap-3 text-[#F4B223]">
                            <svg v-for="star in 5" :key="star" class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 2l2.938 6.017 6.639.974-4.807 4.73 1.134 6.7L12 17.29l-5.904 3.131 1.134-6.7L2.423 8.99l6.639-.974L12 2z"/>
                            </svg>
                        </div>
                    </div>

                    <div class="bg-gradient-to-br from-[#1D2A68] to-[#1876C3] rounded-sm shadow-xl p-6 md:p-8">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8 items-stretch">
                            <div class="bg-white rounded-md overflow-hidden min-h-[260px] flex items-center justify-center">
                                <img
                                    v-if="spotlightProfile?.logo_url"
                                    :src="spotlightProfile.logo_url"
                                    :alt="spotlightProfile.company_name"
                                    @error="onMemberLogoError"
                                    class="w-full h-full object-contain p-6"
                                >
                                <img v-else src="/images/member.png" alt="Member" class="w-full h-full object-contain p-6">
                            </div>

                            <div class="text-white">
                                <div class="bg-white rounded-md inline-flex items-center justify-center px-4 py-2 mb-5">
                                    <img
                                        v-if="spotlightProfile?.logo_url"
                                        :src="spotlightProfile.logo_url"
                                        :alt="`${spotlightProfile.company_name} logo`"
                                        @error="onMemberLogoError"
                                        class="h-16 w-auto object-contain"
                                    >
                                    <img v-else src="/images/member.png" alt="Member" class="h-16 w-auto object-contain">
                                </div>

                                <h3 class="text-2xl font-extrabold leading-tight">{{ spotlightProfile?.company_name || 'No Spotlight Selected' }}</h3>
                                <p class="text-blue-100 mt-1 text-sm">{{ spotlightProfile?.industry_sector || 'Industry not specified' }}</p>
                                <p class="text-blue-100 mt-4 leading-relaxed">{{ spotlightBlurb }}</p>
                                <p class="text-blue-100 mt-2 leading-relaxed" v-if="spotlightProfile?.short_description">{{ spotlightProfile.short_description }}</p>

                                <div class="mt-6 flex gap-3 flex-wrap">
                                    <Link
                                        v-if="spotlightProfile"
                                        :href="route('directory.show', spotlightProfile.id)"
                                        class="inline-flex items-center bg-[#F4B223] hover:bg-[#E0A11B] text-[#1D2A68] font-bold py-2.5 px-5 rounded-sm transition"
                                    >
                                        {{ spotlightCta }}
                                    </Link>
                                    <a
                                        v-if="spotlightProfile?.website_url"
                                        :href="spotlightProfile.website_url"
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        class="inline-flex items-center bg-white/20 hover:bg-white/30 text-white font-bold py-2.5 px-5 rounded-sm transition"
                                    >
                                        Visit Website
                                    </a>
                                </div>
                            </div>
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
                    <p class="mt-4 md:mt-0">
                        Designed & Developed by
                        <a href="https://oristudiozm.com/" target="_blank" rel="noopener noreferrer" class="font-bold text-[#F4B223] hover:text-[#f9cb63] transition-colors">
                            Ori Studio Limited
                        </a>
                    </p>
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

@keyframes membersMarquee {
    0% {
        transform: translateX(0);
    }
    100% {
        transform: translateX(-50%);
    }
}

.member-marquee-track {
    display: flex;
    width: max-content;
    animation: membersMarquee 18s linear infinite;
    will-change: transform;
}

.member-marquee-track:hover {
    animation-play-state: paused;
}
</style>