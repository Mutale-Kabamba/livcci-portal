<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    profiles: Array
});

// Scroll animation state
const scrollY = ref(0);
const dropdownOpen = ref(false);

const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Search and Filter Logic
const searchQuery = ref('');
const selectedCategories = ref([]);
const selectedSectors = ref([]);

const sectors = [
    'Tourism & Hospitality',
    'Trade & Commerce',
    'Financial Services',
    'Construction & Engineering',
    'Agriculture & Manufacturing',
    'Cooperatives & Social Enterprise',
    'IT & Creative Media'
];

const filteredProfiles = computed(() => {
    return props.profiles.filter(profile => {
        const matchesSearch = profile.company_name.toLowerCase().includes(searchQuery.value.toLowerCase()) || 
                              profile.member_category.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                              profile.short_description.toLowerCase().includes(searchQuery.value.toLowerCase());
        
        const matchesCategory = selectedCategories.value.length === 0 || selectedCategories.value.includes(profile.member_category);
        const matchesSector = selectedSectors.value.length === 0 || selectedSectors.value.includes(profile.industry_sector);
        
        return matchesSearch && matchesCategory && matchesSector;
    });
});

// Get unique categories sorted alphabetically
const categories = computed(() => {
    return [...new Set(props.profiles.map(p => p.member_category))].sort();
});

// Toggle category selection
const toggleCategory = (category) => {
    const index = selectedCategories.value.indexOf(category);
    if (index > -1) {
        selectedCategories.value.splice(index, 1);
    } else {
        selectedCategories.value.push(category);
    }
};

const toggleSector = (sector) => {
    const index = selectedSectors.value.indexOf(sector);
    if (index > -1) {
        selectedSectors.value.splice(index, 1);
    } else {
        selectedSectors.value.push(sector);
    }
};

// Get company logo or placeholder
const getCompanyLogo = (profile) => {
    return profile.logo_url || '/images/logo.png';
};

// Get company description
const getCompanyDescription = (profile) => {
    return profile.short_description || 'Professional ' + profile.member_category + ' services';
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
    <Head title="Member Directory - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900">
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
                        <Link :href="route('news')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">Member Directory</Link>
                        
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
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="Member Directory"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Connect & Collaborate
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    Member Directory
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Browse and connect with our chamber members across various sectors. Find the businesses and services you need to grow.
                </p>
            </div>
        </div>

        <div class="max-w-7xl mx-auto py-10 px-4">
            <div class="flex flex-col lg:flex-row gap-8">
                <!-- Left Sidebar - Filter Panel -->
                <div class="lg:w-64 flex-shrink-0">
                    <div class="sticky top-24 bg-[#F5E6D3] p-6 rounded-lg shadow-md">
                        <h3 class="text-lg font-bold text-[#1D2A68] mb-4">Filter Members</h3>
                        
                        <div>
                            <h4 class="font-semibold text-[#1D2A68] mb-3 text-sm">Filter by Category</h4>
                            <div class="space-y-2 max-h-96 overflow-y-auto">
                                <label v-for="category in categories" :key="category" class="flex items-center gap-2 cursor-pointer">
                                    <input 
                                        type="checkbox" 
                                        :checked="selectedCategories.includes(category)"
                                        @change="toggleCategory(category)"
                                        class="w-4 h-4 text-[#1876C3] rounded focus:ring-[#1876C3]"
                                    >
                                    <span class="text-sm text-[#1D2A68]">{{ category }}</span>
                                </label>
                            </div>
                        </div>

                        <div class="mt-6">
                            <h4 class="font-semibold text-[#1D2A68] mb-3 text-sm">Filter by Sector</h4>
                            <div class="space-y-2 max-h-80 overflow-y-auto">
                                <label v-for="sector in sectors" :key="sector" class="flex items-center gap-2 cursor-pointer">
                                    <input
                                        type="checkbox"
                                        :checked="selectedSectors.includes(sector)"
                                        @change="toggleSector(sector)"
                                        class="w-4 h-4 text-[#1876C3] rounded focus:ring-[#1876C3]"
                                    >
                                    <span class="text-sm text-[#1D2A68]">{{ sector }}</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Content - Grid of Cards -->
                <div class="flex-1">
                    <!-- Search Bar -->
                    <div class="mb-8">
                        <input 
                            v-model="searchQuery" 
                            type="text" 
                            placeholder="Search by company name or keyword..." 
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm focus:border-[#1876C3] focus:ring-2 focus:ring-[#1876C3] outline-none"
                        >
                    </div>

                    <!-- No Results Message -->
                    <div v-if="filteredProfiles.length === 0" class="text-center py-12">
                        <p class="text-lg text-gray-500">No matching businesses found.</p>
                        <p class="text-sm text-gray-400 mt-2">Try adjusting your filters or search terms.</p>
                    </div>

                    <!-- Grid of Member Cards -->
                    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <div 
                            v-for="profile in filteredProfiles" 
                            :key="profile.id"
                            class="bg-white rounded-lg border-2 border-gray-300 overflow-hidden hover:shadow-lg transition-shadow duration-300"
                        >
                            <!-- Company Logo -->
                            <div class="h-40 bg-gray-100 flex items-center justify-center overflow-hidden">
                                <img 
                                    :src="getCompanyLogo(profile)" 
                                    :alt="profile.company_name"
                                    class="w-full h-full object-contain p-4"
                                >
                            </div>

                            <!-- Card Content -->
                            <div class="p-5">
                                <h3 class="text-lg font-bold text-[#1D2A68] mb-2">{{ profile.company_name }}</h3>
                                <p class="text-sm text-gray-600 mb-4 line-clamp-3">{{ getCompanyDescription(profile) }}</p>
                                
                                <!-- Category Badge -->
                                <div class="bg-[#F4B223] text-black font-bold py-2 px-3 rounded text-center text-xs">
                                    CATEGORY: {{ profile.member_category }}
                                </div>

                                <!-- Contact Button -->
                                <a 
                                    v-if="profile.contact_email"
                                    :href="'mailto:' + profile.contact_email" 
                                    class="mt-4 w-full inline-block bg-[#1876C3] hover:bg-[#1460A0] text-white font-semibold py-2 rounded text-center text-sm transition-colors"
                                >
                                    Contact
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <footer class="bg-[#121A42] pt-16 pb-8 mt-auto">
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
                            <li><Link href="/" class="hover:text-white transition-colors">Home</Link></li>
                            <li><Link :href="route('about')" class="hover:text-white transition-colors">About Us</Link></li>
                            <li><Link :href="route('sectors')" class="hover:text-white transition-colors">Sectors</Link></li>
                            <li><Link :href="route('news')" class="hover:text-white transition-colors">News & Events</Link></li>
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

.animate-in {
    animation: slideInUp 0.6s ease-out forwards;
}
</style>