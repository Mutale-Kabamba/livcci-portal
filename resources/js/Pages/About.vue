<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    content: {
        type: Object,
        default: () => ({})
    }
});

const aboutHero = computed(() => props.content.hero || {
    badge: 'Our Story',
    title: 'About the Chamber',
    description: 'Building a thriving business ecosystem for Livingstone and the Southern Region of Zambia.'
});

const aboutMission = computed(() => props.content.mission || {
    title: 'Our Mission',
    text: 'To provide exceptional value to our members through proactive advocacy, strategic partnerships, and innovative business support services that promote economic growth and sustainable development in Livingstone.'
});

const aboutVision = computed(() => props.content.vision || {
    title: 'Our Vision',
    text: 'To be the most influential, sustainable, and member-driven Chamber of Commerce in Zambia, fostering a thriving and globally competitive business environment in Livingstone.'
});

const aboutWhoWeAre = computed(() => props.content.who_we_are || {
    title: 'Who We Are',
    paragraph_one: 'The Livingstone Chamber of Commerce and Industry (LiVCCI) is a vibrant, member-led organization representing businesses and entrepreneurs across diverse sectors in Livingstone and the Southern Region of Zambia. Established as a beacon of economic collaboration, we unite businesses to harness opportunities, overcome challenges, and drive sustainable growth.',
    paragraph_two: "With Livingstone's strategic position at the epicenter of tourism, cross-border trade, and agricultural commerce, the Chamber serves as a critical bridge between government, business, civil society, and international partners-amplifying the voice of business and building an enabling environment for enterprise success."
});

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
    <Head title="About Us - LiVCCI" />

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
                        <Link :href="route('about')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">About Us</Link>
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
                    src="https://images.unsplash.com/photo-1552994406-5a2893f3b152?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="About Us"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    {{ aboutHero.badge }}
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    {{ aboutHero.title }}
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    {{ aboutHero.description }}
                </p>
            </div>
        </div>

        <!-- Content -->
        <div class="bg-white py-16 sm:py-20" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Mission & Vision Section -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-12 mb-20">
                    <div class="opacity-0 translate-y-10 transition-all duration-700 animate-in">
                        <h2 class="text-3xl font-bold text-[#1D2A68] mb-6">{{ aboutMission.title }}</h2>
                        <p class="text-gray-600 leading-relaxed text-lg">
                            {{ aboutMission.text }}
                        </p>
                    </div>

                    <div class="opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 100ms;">
                        <h2 class="text-3xl font-bold text-[#1D2A68] mb-6">{{ aboutVision.title }}</h2>
                        <p class="text-gray-600 leading-relaxed text-lg">
                            {{ aboutVision.text }}
                        </p>
                    </div>
                </div>

                <!-- Who We Are Section -->
                <div class="mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 200ms;">
                    <h2 class="text-3xl font-bold text-[#1D2A68] mb-8">{{ aboutWhoWeAre.title }}</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
                        <div>
                            <p class="text-gray-600 leading-relaxed mb-4">
                                {{ aboutWhoWeAre.paragraph_one }}
                            </p>
                            <p class="text-gray-600 leading-relaxed mb-4">
                                {{ aboutWhoWeAre.paragraph_two }}
                            </p>
                        </div>
                        <img src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="Chamber Office" class="rounded-lg shadow-lg">
                    </div>
                </div>

                <!-- Core Values Section -->
                <div class="mb-20 bg-gradient-to-r from-blue-50 to-blue-100 py-16 px-8 rounded-2xl opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 300ms;">
                    <h2 class="text-3xl font-bold text-[#1D2A68] mb-12 text-center">Our Core Values</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <!-- Integrity Card -->
                        <div class="bg-white rounded-xl p-8 shadow-md hover:shadow-lg transition-all text-center group">
                            <div class="flex justify-center mb-6">
                                <svg class="w-16 h-16 text-[#1876C3] group-hover:text-[#F4B223] transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                            </div>
                            <h3 class="text-xl font-bold text-[#1D2A68] mb-4">Integrity</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We uphold the highest ethical standards in all our actions and decisions.
                            </p>
                        </div>

                        <!-- Inclusivity Card -->
                        <div class="bg-white rounded-xl p-8 shadow-md hover:shadow-lg transition-all text-center group">
                            <div class="flex justify-center mb-6">
                                <svg class="w-16 h-16 text-[#1876C3] group-hover:text-[#F4B223] transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4.354a4 4 0 110 8.646 4 4 0 010-8.646zM9 8a3 3 0 106 0 3 3 0 00-6 0z" clip-rule="evenodd"></path>
                                </svg>
                            </div>
                            <h3 class="text-xl font-bold text-[#1D2A68] mb-4">Inclusivity</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We represent and support businesses of all sizes and sectors, ensuring every member has a voice.
                            </p>
                        </div>

                        <!-- Innovation Card -->
                        <div class="bg-white rounded-xl p-8 shadow-md hover:shadow-lg transition-all text-center group">
                            <div class="flex justify-center mb-6">
                                <svg class="w-16 h-16 text-[#1876C3] group-hover:text-[#F4B223] transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5.657 5.657l-.707.707M9 12a3 3 0 106 0 3 3 0 00-6 0z"></path>
                                </svg>
                            </div>
                            <h3 class="text-xl font-bold text-[#1D2A68] mb-4">Innovation</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We embrace new ideas and technologies to better serve our members and the community.
                            </p>
                        </div>

                        <!-- Excellence Card -->
                        <div class="bg-white rounded-xl p-8 shadow-md hover:shadow-lg transition-all text-center group">
                            <div class="flex justify-center mb-6">
                                <svg class="w-16 h-16 text-[#1876C3] group-hover:text-[#F4B223] transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                                </svg>
                            </div>
                            <h3 class="text-xl font-bold text-[#1D2A68] mb-4">Excellence</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We strive for quality in every service, program, and advocacy effort we undertake.
                            </p>
                        </div>

                        <!-- Collaboration Card -->
                        <div class="bg-white rounded-xl p-8 shadow-md hover:shadow-lg transition-all text-center group">
                            <div class="flex justify-center mb-6">
                                <svg class="w-16 h-16 text-[#1876C3] group-hover:text-[#F4B223] transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 20h5v-2a3 3 0 00-5.856-1.487M15 10a3 3 0 11-6 0 3 3 0 016 0zM4.318 20H2v-2a3 3 0 015.856-1.487M15 10a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                </svg>
                            </div>
                            <h3 class="text-xl font-bold text-[#1D2A68] mb-4">Collaboration</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We believe in the power of partnerships to achieve collective success.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- What We Do Section -->
                <div class="mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 400ms;">
                    <h2 class="text-3xl font-bold text-[#1D2A68] mb-12 text-center">What We Do</h2>
                    <div class="space-y-8">
                        <div class="border-l-4 border-[#1876C3] pl-8">
                            <h3 class="text-2xl font-bold text-[#1D2A68] mb-3">Policy Advocacy & Government Engagement</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We monitor policy developments, engage with government at all levels, and advocate for a favorable business environment. Our advocacy efforts focus on trade facilitation, tax reform, labor standards, and sectoral support for tourism, agriculture, logistics, and technology.
                            </p>
                        </div>

                        <div class="border-l-4 border-[#F4B223] pl-8">
                            <h3 class="text-2xl font-bold text-[#1D2A68] mb-3">Business Networking & Market Linkage</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We organize business breakfasts, annual awards ceremonies, trade missions, and B2B matchmaking events. These platforms connect entrepreneurs with suppliers, customers, and investors—opening doors to new markets and growth opportunities.
                            </p>
                        </div>

                        <div class="border-l-4 border-[#4CAF50] pl-8">
                            <h3 class="text-2xl font-bold text-[#1D2A68] mb-3">Capacity Building & Business Development</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We partner with experts to deliver training in business management, digital marketing, export procedures, and specialized sector knowledge. Our Business Development Services (BDS) support entrepreneurs in improving operations, accessing finance, and scaling their enterprises.
                            </p>
                        </div>

                        <div class="border-l-4 border-[#9C27B0] pl-8">
                            <h3 class="text-2xl font-bold text-[#1D2A68] mb-3">Business Incubation & Startup Support</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We are establishing a comprehensive Business Incubation Center to nurture startups and MSMEs through shared infrastructure, specialist mentorship, finance linkage, and networking—accelerating the growth of Livingstone's entrepreneurial ecosystem.
                            </p>
                        </div>

                        <div class="border-l-4 border-[#FF6B6B] pl-8">
                            <h3 class="text-2xl font-bold text-[#1D2A68] mb-3">Information & Intelligence Services</h3>
                            <p class="text-gray-600 leading-relaxed">
                                We provide timely business intelligence, market information, regulatory updates, and sector analysis to help our members make informed decisions and stay competitive.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Why Join Section -->
                <div class="bg-gradient-to-r from-[#1D2A68] to-[#1460A0] text-white rounded-xl p-12 mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 500ms;">
                    <h2 class="text-3xl font-bold mb-12 text-center">Why Join LiVCCI?</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">✓</div>
                            <div>
                                <h3 class="font-bold mb-2">Advocacy & Political Voice</h3>
                                <p class="text-blue-100">Your business interests represented at the highest levels of government and civil society</p>
                            </div>
                        </div>

                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">✓</div>
                            <div>
                                <h3 class="font-bold mb-2">Networking Opportunities</h3>
                                <p class="text-blue-100">Connect with peers, suppliers, customers, and investors through exclusive events</p>
                            </div>
                        </div>

                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">✓</div>
                            <div>
                                <h3 class="font-bold mb-2">Business Support Services</h3>
                                <p class="text-blue-100">Access training, mentorship, and consultancy to improve competitiveness</p>
                            </div>
                        </div>

                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">✓</div>
                            <div>
                                <h3 class="font-bold mb-2">Market Information</h3>
                                <p class="text-blue-100">Stay informed with business intelligence, market reports, and regulatory updates</p>
                            </div>
                        </div>

                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">✓</div>
                            <div>
                                <h3 class="font-bold mb-2">Trade & Investment Missions</h3>
                                <p class="text-blue-100">Participate in regional and international trade missions to expand your market reach</p>
                            </div>
                        </div>

                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">✓</div>
                            <div>
                                <h3 class="font-bold mb-2">Visibility & Credibility</h3>
                                <p class="text-blue-100">Build your brand reputation through chamber membership and participation</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Call to Action -->
                <div class="text-center bg-gray-50 rounded-xl p-12 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 600ms;">
                    <h2 class="text-3xl font-bold text-[#1D2A68] mb-6">Ready to Join the Chamber?</h2>
                    <p class="text-lg text-gray-600 mb-8 max-w-2xl mx-auto">
                        Become part of Livingstone's most dynamic business community and unlock opportunities for growth, networking, and success.
                    </p>
                    <Link :href="route('register')" class="inline-block bg-[#1876C3] text-white font-bold py-3 px-10 rounded-md hover:bg-[#1460A0] shadow-lg transition-colors text-lg">
                        Become a Member Today
                    </Link>
                </div>
            </div>
        </div>

        <!-- Footer -->
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
                            <li><Link :href="route('directory.index')" class="hover:text-white transition-colors">Member Directory</Link></li>
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