<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

const scrollY = ref(0);
const dropdownOpen = ref(false);

const handleScroll = () => {
    scrollY.value = window.scrollY;
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
    <Head title="Economic Sectors - LiVCCI" />

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
                        <Link :href="route('sectors')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">Sectors</Link>
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
                    src="https://images.unsplash.com/photo-1552754525-46fcd00ae0ca?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="Economic Sectors"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Economic Hub of the South
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    Key Economic Sectors
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Livingstone is strategically positioned as Zambia's premier tourist destination and a vital cross-border trade corridor. Explore the industries driving our regional growth.
                </p>
            </div>
        </div>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 flex-grow">
            <!-- ECONOMIC SECTORS -->
            <div class="mb-12">
                <h3 class="text-2xl font-bold text-[#1D2A68] mb-8">Economic Sectors</h3>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                
                <div class="bg-white rounded-xl shadow-md border border-gray-100 overflow-hidden group hover:shadow-xl transition-all duration-300">
                    <div class="h-48 bg-[#1876C3] relative overflow-hidden">
                        <img src="https://images.unsplash.com/photo-1540553016722-983e48a2cd10?auto=format&fit=crop&w=800&q=80" alt="Tourism" class="w-full h-full object-cover opacity-50 mix-blend-multiply group-hover:scale-105 transition-transform duration-500">
                        <div class="absolute bottom-4 left-6">
                            <h2 class="text-3xl font-black text-white drop-shadow-md">Tourism & Hospitality</h2>
                        </div>
                    </div>
                    <div class="p-8">
                        <p class="text-gray-600 mb-6 leading-relaxed">
                            As the home of the mighty Victoria Falls, Livingstone's tourism and hospitality sector is the heartbeat of the local economy. We support hotels, lodges, tour operators, and cultural heritage enterprises in maintaining world-class service standards and advocating for favorable tourism policies.
                        </p>
                        <Link :href="route('directory.index')" class="text-[#1876C3] font-bold hover:text-[#1D2A68] flex items-center gap-2">
                            View Tourism Members <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                        </Link>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-md border border-gray-100 overflow-hidden group hover:shadow-xl transition-all duration-300">
                    <div class="h-48 bg-[#1D2A68] relative overflow-hidden">
                        <div class="absolute inset-0 bg-gradient-to-tr from-[#1D2A68] to-[#1876C3] opacity-80 z-10"></div>
                        <img src="https://images.unsplash.com/photo-1586528116311-ad8ed7c1590a?auto=format&fit=crop&w=800&q=80" alt="Logistics" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <div class="absolute bottom-4 left-6 z-20">
                            <h2 class="text-3xl font-black text-white drop-shadow-md">Transport & Logistics</h2>
                        </div>
                    </div>
                    <div class="p-8">
                        <p class="text-gray-600 mb-6 leading-relaxed">
                            With strategic access to the Kazungula Bridge and international borders, Livingstone is a critical logistics node. We champion the interests of freight forwarders, transport fleets, and supply chain operators to streamline cross-border trade and improve regional connectivity.
                        </p>
                        <Link :href="route('directory.index')" class="text-[#1876C3] font-bold hover:text-[#1D2A68] flex items-center gap-2">
                            View Logistics Members <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                        </Link>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-md border border-gray-100 overflow-hidden group hover:shadow-xl transition-all duration-300">
                    <div class="h-48 bg-[#4CAF50] relative overflow-hidden">
                        <div class="absolute inset-0 bg-green-800 opacity-60 z-10 mix-blend-multiply"></div>
                        <img src="https://images.unsplash.com/photo-1592982537447-6f2a6a0c6c1b?auto=format&fit=crop&w=800&q=80" alt="Agriculture" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <div class="absolute bottom-4 left-6 z-20">
                            <h2 class="text-3xl font-black text-white drop-shadow-md">Agriculture & Export</h2>
                        </div>
                    </div>
                    <div class="p-8">
                        <p class="text-gray-600 mb-6 leading-relaxed">
                            Southern Province is an agricultural powerhouse. From commercial farming to non-traditional exports and agro-processing, we assist local agribusinesses in expanding their market reach, navigating export regulations, and adopting sustainable farming technologies.
                        </p>
                        <Link :href="route('directory.index')" class="text-[#1876C3] font-bold hover:text-[#1D2A68] flex items-center gap-2">
                            View Agriculture Members <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                        </Link>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-md border border-gray-100 overflow-hidden group hover:shadow-xl transition-all duration-300">
                    <div class="h-48 bg-[#F4B223] relative overflow-hidden">
                        <div class="absolute inset-0 bg-orange-600 opacity-60 z-10 mix-blend-multiply"></div>
                        <img src="https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=800&q=80" alt="Technology" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <div class="absolute bottom-4 left-6 z-20">
                            <h2 class="text-3xl font-black text-white drop-shadow-md">Tech & Creative Services</h2>
                        </div>
                    </div>
                    <div class="p-8">
                        <p class="text-gray-600 mb-6 leading-relaxed">
                            Innovation drives modern business. We support Livingstone's growing ecosystem of IT specialists, digital marketers, software developers, and brand designers who are providing the essential digital infrastructure and creative services that local enterprises need to scale globally.
                        </p>
                        <Link :href="route('directory.index')" class="text-[#1876C3] font-bold hover:text-[#1D2A68] flex items-center gap-2">
                            View Tech Members <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                        </Link>
                    </div>
                </div>

            </div>

            <!-- KEY OFFERINGS SECTION -->
            <div class="mb-16 mt-20">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <!-- Business Development Services Column -->
                    <div>
                        <div class="bg-[#F4B223] text-white px-6 py-4 mb-6">
                            <h3 class="text-2xl font-bold">BUSINESS DEVELOPMENT SERVICES</h3>
                        </div>
                        <p class="text-gray-700 leading-relaxed mb-4">
                            LiVCCI delivers comprehensive Business Development Services (BDS) to enhance enterprise competitiveness. We provide mentorship, training, consultancy, market linkage facilitation, and access to digital tools. Our services support businesses at every stage—from startups to established enterprises—helping them improve operational efficiency, access markets, and achieve financial sustainability.
                        </p>
                        <p class="text-gray-700 leading-relaxed mb-4">
                            Through strategic partnerships with sector associations, government agencies, and private providers, we connect entrepreneurs with financial institutions, technology providers, and international markets to accelerate growth and position Livingstone's business community as a hub of innovation and enterprise excellence.
                        </p>
                        
                        <div class="mt-6 pt-6 border-t border-gray-200">
                            <p class="font-bold text-[#1D2A68] mb-3">Key Focus Areas:</p>
                            <ul class="space-y-2 text-sm text-gray-700">
                                <li class="flex items-start gap-2">
                                    <span class="text-[#F4B223] font-bold">•</span>
                                    <span>Mentorship & coaching programs</span>
                                </li>
                                <li class="flex items-start gap-2">
                                    <span class="text-[#F4B223] font-bold">•</span>
                                    <span>Market access and linkage strategies</span>
                                </li>
                                <li class="flex items-start gap-2">
                                    <span class="text-[#F4B223] font-bold">•</span>
                                    <span>Operational efficiency and process improvement</span>
                                </li>
                                <li class="flex items-start gap-2">
                                    <span class="text-[#F4B223] font-bold">•</span>
                                    <span>Sustainable production and marketing practices</span>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <!-- Blue Divider and Business Incubation Column -->
                    <div class="md:border-l-4 md:border-[#1876C3] md:pl-8">
                        <div class="bg-[#F4B223] text-white px-6 py-4 mb-6">
                            <h3 class="text-2xl font-bold">BUSINESS INCUBATION PROGRAM</h3>
                        </div>
                        <p class="text-gray-700 leading-relaxed mb-4">
                            LiVCCI is establishing a comprehensive Business Incubation Center to support MSMEs and startups during their critical early stages. We provide shared infrastructure, specialized business services, mentorship, financing access, and a supportive ecosystem where entrepreneurs can develop viable businesses and scale successfully.
                        </p>
                        <p class="text-gray-700 leading-relaxed mb-4">
                            Our incubation model focuses on three core pillars: business services (accounting, legal, administrative support), finance access and investor linkage, and networking between entrepreneurs, service providers, government agencies, and investors. This integrated approach strengthens Livingstone's economic base, creates employment, and attracts investment to the region.
                        </p>
                        
                        <div class="mt-6 pt-6 border-t border-gray-200">
                            <p class="font-bold text-[#1D2A68] mb-3">Strategic Focus:</p>
                            <ul class="space-y-2 text-sm text-gray-700">
                                <li class="flex items-start gap-2">
                                    <span class="text-[#F4B223] font-bold">•</span>
                                    <span>Business infrastructure and workspace access</span>
                                </li>
                                <li class="flex items-start gap-2">
                                    <span class="text-[#F4B223] font-bold">•</span>
                                    <span>Finance access and investor linkage</span>
                                </li>
                                <li class="flex items-start gap-2">
                                    <span class="text-[#F4B223] font-bold">•</span>
                                    <span>People and business connectivity networks</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-gray-100 py-16 border-t border-gray-200">
            <div class="max-w-4xl mx-auto px-4 text-center">
                <h2 class="text-2xl font-bold text-[#1D2A68] mb-4">Don't see your industry listed?</h2>
                <p class="text-gray-600 mb-8">The Chamber represents a diverse, multi-sectoral business environment. We welcome businesses of all sizes from every sector.</p>
                <Link :href="route('register')" class="bg-[#F4B223] text-[#1D2A68] text-lg font-bold py-3 px-8 rounded-md hover:bg-[#E0A11B] shadow-lg transition-colors inline-block">
                    Become a Member Today
                </Link>
            </div>
        </div>

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

.animate-in {
    animation: slideInUp 0.6s ease-out forwards;
}
</style>