<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    content: {
        type: Object,
        default: () => ({})
    }
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

const defaultStrategicGoals = [
    {
        number: 1,
        title: 'Strengthened Governance and Institutional Capacity',
        description: 'Build robust governance structures, enhance institutional systems, and develop a capable management team to ensure sustainable operations and member accountability.',
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        detail_link: '/strategic-goals/goal-1'
    },
    {
        number: 2,
        title: 'Enhanced Member Services and Value Proposition',
        description: 'Expand and improve services offered to members, including training programs, networking events, business development support, and market intelligence to maximize member satisfaction and retention.',
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        detail_link: '/strategic-goals/goal-2'
    },
    {
        number: 3,
        title: 'Dynamic Advocacy and Strategic Partnerships',
        description: 'Strengthen advocacy efforts on behalf of members, develop strategic partnerships with government, development partners, and other organizations to create an enabling business environment.',
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        detail_link: '/strategic-goals/goal-3'
    },
    {
        number: 4,
        title: 'Financial Sustainability and Resource Mobilization',
        description: 'Diversify revenue streams, improve financial management, and mobilize resources through grants and partnerships to ensure long-term financial sustainability of the chamber.',
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        detail_link: '/strategic-goals/goal-4'
    },
    {
        number: 5,
        title: 'Communication, Publicity, and Research',
        description: 'Enhance communication channels, increase chamber visibility in the market, conduct business research, and provide timely information to members and stakeholders.',
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        detail_link: '/strategic-goals/goal-5'
    },
];

const strategicGoals = props.content.goals || defaultStrategicGoals;
const visibleGoalCount = ref(3);
const displayedGoals = computed(() => strategicGoals.slice(0, visibleGoalCount.value));
const hasMoreGoals = computed(() => visibleGoalCount.value < strategicGoals.length);

const showMoreGoals = () => {
    visibleGoalCount.value = strategicGoals.length;
};

const goalsHero = props.content.hero || {
    badge: '2026 - 2030',
    title: 'Strategic Goals',
    description: 'Our ambitious roadmap for transforming LiVCCI and advancing business growth in Livingstone.'
};
</script>

<template>
    <Head title="Strategic Goals - LiVCCI" />

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
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
                        
                        <!-- More Dropdown -->
                        <div class="relative group">
                            <button class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1 flex items-center gap-1">
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
                    alt="Strategic Goals"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    {{ goalsHero.badge }}
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    {{ goalsHero.title }}
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    {{ goalsHero.description }}
                </p>
            </div>
        </div>

        <!-- Content -->
        <div class="bg-white py-16 sm:py-20" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Overview -->
                <div class="mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in">
                    <span class="text-[#1876C3] font-bold uppercase tracking-widest text-sm">2026 - 2030 ROADMAP</span>
                    <h2 class="text-4xl sm:text-5xl font-black text-[#1D2A68] mb-6 mt-4 leading-tight">
                        Strategic Goals For
                        <span class="bg-[#F4B223] text-white px-4 py-2 inline-block">Organizational Excellence</span>
                    </h2>
                    <p class="text-lg text-gray-700 max-w-3xl mt-8">
                        Over the next five years, LiVCCI is committed to achieving ambitious strategic goals that will strengthen our organization, enhance member value, and accelerate economic development in Livingstone.
                    </p>
                </div>

                <!-- Strategic Goals Flip Cards -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
                    <div
                        v-for="(goal, index) in displayedGoals"
                        :key="index"
                        :style="{ transitionDelay: `${index * 80}ms` }"
                        class="opacity-0 translate-y-10 transition-all duration-700 animate-in"
                    >
                        <div class="h-[420px] cursor-pointer group perspective">
                            <div class="relative w-full h-full transition-transform duration-500 transform-gpu group-hover:[transform:rotateY(180deg)]" style="transform-style: preserve-3d;">
                                <!-- Front of card -->
                                <div class="absolute w-full h-full rounded-xl overflow-hidden shadow-xl" style="backface-visibility: hidden;">
                                    <img :src="goal.image" :alt="goal.title" class="w-full h-full object-cover">
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/40 to-transparent"></div>
                                    <div class="absolute bottom-0 left-0 right-0 p-6 text-white">
                                        <p class="text-sm uppercase tracking-[0.2em] text-[#F4B223] font-bold">Goal {{ goal.number }}</p>
                                        <h3 class="text-2xl font-extrabold mt-2 leading-snug">{{ goal.title }}</h3>
                                    </div>
                                </div>

                                <!-- Back of card -->
                                <div class="absolute w-full h-full rounded-xl p-7 flex flex-col text-white shadow-xl bg-gradient-to-br from-[#1D2A68] via-[#1b4f8f] to-[#1876C3]" style="backface-visibility: hidden; transform: rotateY(180deg);">
                                    <p class="text-sm uppercase tracking-[0.2em] text-[#F4B223] font-bold">Goal {{ goal.number }}</p>
                                    <h3 class="font-extrabold text-2xl mt-3 leading-snug">{{ goal.title }}</h3>
                                    <p class="text-base leading-relaxed opacity-95 mt-4 flex-1">{{ goal.description }}</p>
                                    <a :href="goal.detail_link || `/strategic-goals/goal-${goal.number}`" class="inline-flex items-center justify-center bg-[#F4B223] text-[#1D2A68] font-bold text-base py-2.5 px-4 rounded-md hover:bg-[#e6a91f] transition-colors mt-6 w-fit">
                                        View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- More Details Button -->
                <div v-if="hasMoreGoals" class="flex justify-end mb-20">
                    <button @click="showMoreGoals" class="bg-[#F4B223] text-white font-bold py-3 px-8 rounded-lg hover:bg-[#1460A0] transition-colors uppercase text-sm tracking-wider shadow-lg">
                        More
                    </button>
                </div>

                <!-- Implementation Framework -->
                <div id="implementation" class="bg-gradient-to-r from-[#1D2A68] to-[#1460A0] text-white rounded-xl p-12 mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 500ms;">
                    <h2 class="text-3xl font-bold mb-8 text-center">Implementation Framework</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div class="bg-white/10 rounded-lg p-6 backdrop-blur">
                            <h3 class="text-xl font-bold mb-3">Annual Reviews</h3>
                            <p>Progress on each goal is reviewed quarterly and comprehensively assessed annually to ensure alignment and accountability.</p>
                        </div>

                        <div class="bg-white/10 rounded-lg p-6 backdrop-blur">
                            <h3 class="text-xl font-bold mb-3">Stakeholder Engagement</h3>
                            <p>Regular consultations with members, partners, and government to ensure our goals remain relevant and achievable.</p>
                        </div>

                        <div class="bg-white/10 rounded-lg p-6 backdrop-blur">
                            <h3 class="text-xl font-bold mb-3">Resource Allocation</h3>
                            <p>Strategic budgeting and resource mobilization to support the implementation of each goal effectively.</p>
                        </div>
                    </div>
                </div>

                <!-- Key Success Factors -->
                <div class="mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 600ms;">
                    <div class="text-center mb-12">
                        <p class="text-xs font-bold uppercase tracking-[0.2em] text-[#1876C3]">Strategic Enablers</p>
                        <h2 class="text-3xl sm:text-4xl font-black text-[#1D2A68] mt-3">Key Success Factors</h2>
                        <p class="text-gray-600 mt-3 max-w-2xl mx-auto">The core institutional capabilities that will determine how effectively LiVCCI delivers its five-year roadmap.</p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="group bg-white rounded-2xl p-8 shadow-sm border border-gray-200 hover:shadow-lg hover:border-[#1876C3]/40 transition-all">
                            <div class="flex items-start gap-4">
                                <div class="w-11 h-11 rounded-xl bg-[#e7f1fc] text-[#1876C3] flex items-center justify-center flex-shrink-0">
                                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                    </svg>
                                </div>
                                <div>
                                    <h3 class="text-2xl font-bold text-[#1D2A68]">Member-Centric Approach</h3>
                                    <p class="text-gray-600 mt-3 leading-7">Ensuring member needs and feedback drive our strategic direction and service improvements.</p>
                                </div>
                            </div>
                        </div>

                        <div class="group bg-white rounded-2xl p-8 shadow-sm border border-gray-200 hover:shadow-lg hover:border-[#F4B223]/50 transition-all">
                            <div class="flex items-start gap-4">
                                <div class="w-11 h-11 rounded-xl bg-[#fff5df] text-[#d79a12] flex items-center justify-center flex-shrink-0">
                                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                    </svg>
                                </div>
                                <div>
                                    <h3 class="text-2xl font-bold text-[#1D2A68]">Strategic Partnerships</h3>
                                    <p class="text-gray-600 mt-3 leading-7">Building and maintaining strong relationships with government, development partners, and private sector.</p>
                                </div>
                            </div>
                        </div>

                        <div class="group bg-white rounded-2xl p-8 shadow-sm border border-gray-200 hover:shadow-lg hover:border-green-500/50 transition-all">
                            <div class="flex items-start gap-4">
                                <div class="w-11 h-11 rounded-xl bg-green-50 text-green-600 flex items-center justify-center flex-shrink-0">
                                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                    </svg>
                                </div>
                                <div>
                                    <h3 class="text-2xl font-bold text-[#1D2A68]">Innovation & Adaptability</h3>
                                    <p class="text-gray-600 mt-3 leading-7">Embracing new technologies and business models to stay relevant in a dynamic business environment.</p>
                                </div>
                            </div>
                        </div>

                        <div class="group bg-white rounded-2xl p-8 shadow-sm border border-gray-200 hover:shadow-lg hover:border-yellow-500/50 transition-all">
                            <div class="flex items-start gap-4">
                                <div class="w-11 h-11 rounded-xl bg-yellow-50 text-yellow-600 flex items-center justify-center flex-shrink-0">
                                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                    </svg>
                                </div>
                                <div>
                                    <h3 class="text-2xl font-bold text-[#1D2A68]">Sustainability</h3>
                                    <p class="text-gray-600 mt-3 leading-7">Building a financially sustainable organization with diversified revenue streams and efficient operations.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Call to Action -->
                <div class="text-center bg-gray-50 rounded-xl p-12 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 700ms;">
                    <h2 class="text-3xl font-bold text-[#1D2A68] mb-6">Join Us in Shaping the Future</h2>
                    <p class="text-lg text-gray-600 mb-8 max-w-2xl mx-auto">
                        These strategic goals are ambitious, but with your support and participation, we believe we can achieve them and create a thriving business ecosystem in Livingstone.
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
                            <li><strong>Address:</strong> PO Box 4037, Livingstone</li>
                            <li><strong>Email:</strong> livcci@yahoo.com</li>
                            <li><strong>Tel:</strong> +260 977 105068</li>
                            <li><strong>Tel:</strong> +260 977 885959</li>
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

.animate-in {
    animation: slideInUp 0.6s ease-out forwards;
}

.perspective {
    perspective: 1000px;
}

/* Flip card 3D effect */
.group:hover [style*="preserve-3d"] {
    transform: rotateY(180deg);
}</style>
