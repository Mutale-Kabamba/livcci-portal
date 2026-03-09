<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

const props = defineProps({
    profiles: Array
});

// Search and Filter Logic
const searchQuery = ref('');
const selectedCategories = ref([]);

const filteredProfiles = computed(() => {
    return props.profiles.filter(profile => {
        const matchesSearch = profile.company_name.toLowerCase().includes(searchQuery.value.toLowerCase()) || 
                              profile.member_category.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                              profile.short_description.toLowerCase().includes(searchQuery.value.toLowerCase());
        
        const matchesCategory = selectedCategories.value.length === 0 || selectedCategories.value.includes(profile.member_category);
        
        return matchesSearch && matchesCategory;
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

// Get company logo or placeholder
const getCompanyLogo = (profile) => {
    return profile.logo_url || '/images/logo.png';
};

// Get company description
const getCompanyDescription = (profile) => {
    return profile.short_description || 'Professional ' + profile.member_category + ' services';
};
</script>

<template>
    <Head title="Member Directory - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900">
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
                        <Link :href="route('news')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">Member Directory</Link>
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

        <div class="bg-[#1D2A68] py-12 px-4">
            <div class="max-w-7xl mx-auto">
                <h1 class="text-3xl font-bold text-white mb-4">Member Directory</h1>
                <p class="text-blue-200 mb-6">Browse and connect with our chamber members across various sectors</p>
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
                            <li><Link href="/" class="hover:text-white transition-colors">Home</Link></li>
                            <li><Link :href="route('about')" class="hover:text-white transition-colors">About Us</Link></li>
                            <li><Link :href="route('sectors')" class="hover:text-white transition-colors">Sectors</Link></li>
                            <li><Link :href="route('news')" class="hover:text-white transition-colors">News & Events</Link></li>
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