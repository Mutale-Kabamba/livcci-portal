<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

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

const defaultMembershipTiers = [
    {
        category: 'Corporate',
        amount: 2000.00,
        currency: 'ZMW',
        description: 'Ideal for established companies and large enterprises',
        features: [
            'Maximum voting rights',
            'Priority event attendance',
            'Board eligibility',
            'Prominence in directory',
            'Dedicated support contact'
        ]
    },
    {
        category: 'Ordinary',
        amount: 1000.00,
        currency: 'ZMW',
        description: 'Perfect for established businesses and professionals',
        features: [
            'Full voting rights',
            'Event attendance',
            'Networking opportunities',
            'Business directory listing',
            'Email updates'
        ]
    },
    {
        category: 'Associate | Cooperative',
        amount: 500.00,
        currency: 'ZMW',
        description: 'For startups, cooperatives, and emerging businesses',
        features: [
            'Limited voting rights',
            'Event access',
            'Networking opportunities',
            'Directory listing',
            'Monthly newsletter'
        ]
    },
];

const defaultMembershipBenefits = [
    {
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        title: 'Networking',
        description: 'Connect with business leaders and entrepreneurs in Livingstone'
    },
    {
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        title: 'Advocacy',
        description: 'Have your voice heard in policy discussions and business matters'
    },
    {
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        title: 'Training & Development',
        description: 'Access workshops, seminars, and capacity building programs'
    },
    {
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        title: 'Market Intelligence',
        description: 'Receive business reports and market analysis'
    },
    {
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        title: 'Business Directory',
        description: 'Get listed in our regional business directory'
    },
    {
        image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        title: 'Growth Support',
        description: 'Access resources and mentorship for business growth'
    },
];

const membershipTiers = props.content.tiers || defaultMembershipTiers;
const membershipBenefits = props.content.benefits || defaultMembershipBenefits;
const membershipHero = props.content.hero || {
    badge: 'Join LiVCCI',
    title: 'Membership at LiVCCI',
    description: 'Choose the membership category that best fits your business needs and unlock unprecedented opportunities.'
};
const registrationFee = props.content.registration_fee || {
    label: 'One-Time Fee',
    amount: '100.00 ZMW',
    subtitle: 'Registration Fee for All New Members',
    description: 'A one-time registration fee applies to all new members upon joining LiVCCI. This fee is separate from your annual membership subscription.'
};

const defaultRegistrationImage = 'https://images.unsplash.com/photo-1450101499163-c8917c7b60c0?ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80';
const registrationImageErrored = ref(false);

const getRegistrationImage = () => {
    return props.content?.registration_fee?.image || defaultRegistrationImage;
};

const onRegistrationImageError = () => {
    registrationImageErrored.value = true;
};
</script>

<template>
    <Head title="Membership - LiVCCI" />

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
                    alt="Membership"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    {{ membershipHero.badge }}
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    {{ membershipHero.title }}
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    {{ membershipHero.description }}
                </p>
            </div>
        </div>

        <!-- Content -->
        <div class="bg-white py-16 sm:py-20" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Membership Tiers -->
                <div class="mb-20">
                    <h2 class="text-3xl font-bold text-[#1D2A68] mb-12 text-center opacity-0 translate-y-10 transition-all duration-700 animate-in">Membership Categories & Pricing</h2>
                    
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div 
                            v-for="(tier, index) in membershipTiers" 
                            :key="index"
                            :style="{ transitionDelay: `${index * 100}ms` }"
                            :class="[
                                'rounded-xl shadow-lg hover:shadow-2xl transition-all border-2 overflow-hidden opacity-0 translate-y-10 animate-in',
                                index === 0
                                    ? 'bg-gradient-to-br from-[#f7f9ff] to-[#e8f0ff] border-[#1D2A68] hover:shadow-[#1D2A68]/20'
                                    : index === 1
                                        ? 'bg-gradient-to-br from-[#f6fbff] to-[#e8f4ff] border-[#1876C3] hover:shadow-[#1876C3]/20'
                                        : 'bg-gradient-to-br from-[#fffdf6] to-[#fff3d6] border-[#F4B223] hover:shadow-[#F4B223]/25'
                            ]"
                        >
                            <div
                                :class="[
                                    'text-white p-8 text-center',
                                    index === 0
                                        ? 'bg-gradient-to-r from-[#1D2A68] to-[#243b8e]'
                                        : index === 1
                                            ? 'bg-gradient-to-r from-[#1876C3] to-[#1460A0]'
                                            : 'bg-gradient-to-r from-[#D79A12] to-[#F4B223]'
                                ]"
                            >
                                <h3 class="text-2xl font-bold mb-2">{{ tier.category }}</h3>
                                <p :class="['text-sm', index === 2 ? 'text-[#1D2A68]/85 font-medium' : 'text-blue-100']">{{ tier.description }}</p>
                            </div>
                            
                            <div class="p-8">
                                <div class="text-center mb-8">
                                    <p :class="['text-5xl font-bold', index === 2 ? 'text-[#A66E00]' : 'text-[#1D2A68]']">{{ tier.amount.toLocaleString() }}</p>
                                    <p class="text-gray-600 mt-2">{{ tier.currency }} per year</p>
                                </div>

                                <div class="mb-8 space-y-4">
                                    <h4 :class="['font-bold mb-4', index === 2 ? 'text-[#A66E00]' : 'text-[#1D2A68]']">Membership Benefits:</h4>
                                    <ul class="space-y-3">
                                        <li v-for="(feature, fIndex) in tier.features" :key="fIndex" class="flex items-start gap-3">
                                            <svg :class="['w-5 h-5 flex-shrink-0 mt-0.5', index === 0 ? 'text-[#1D2A68]' : index === 1 ? 'text-[#1876C3]' : 'text-[#D79A12]']" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                                            </svg>
                                            <span class="text-gray-600">{{ feature }}</span>
                                        </li>
                                    </ul>
                                </div>

                                <Link
                                    :href="route('register')"
                                    :class="[
                                        'w-full block text-center text-white font-bold py-3 rounded-md transition-colors',
                                        index === 0
                                            ? 'bg-[#1D2A68] hover:bg-[#15204f]'
                                            : index === 1
                                                ? 'bg-[#1876C3] hover:bg-[#1460A0]'
                                                : 'bg-[#F4B223] hover:bg-[#E0A11B] text-[#1D2A68]'
                                    ]"
                                >
                                    Join Now
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Registration Fee Info -->
                <div class="bg-gradient-to-r from-[#1D2A68] via-[#1876C3] to-[#1460A0] p-0 rounded-2xl mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in overflow-hidden shadow-2xl border border-[#2a4e9a]/40" style="transition-delay: 300ms;">
                    <div class="grid grid-cols-1 md:grid-cols-5 gap-0 items-stretch">
                        <div class="p-8 md:p-12 md:col-span-3">
                            <span class="inline-block px-4 py-2 bg-[#F4B223]/20 text-[#F4B223] text-xs font-bold rounded-full mb-4 uppercase tracking-widest">{{ registrationFee.label }}</span>
                            <h3 class="text-4xl md:text-5xl font-black text-white mb-4">{{ registrationFee.amount }}</h3>
                            <p class="text-blue-100 text-lg mb-6">{{ registrationFee.subtitle }}</p>
                            <p class="text-blue-50 mb-8 max-w-xl">{{ registrationFee.description }}</p>
                            <Link :href="route('register')" class="inline-block bg-[#F4B223] text-[#1D2A68] font-bold py-3 px-8 rounded-lg hover:bg-[#f8cb58] transition-colors shadow-lg">
                                Start Registration →
                            </Link>
                        </div>

                        <div class="h-64 md:h-auto md:min-h-[340px] overflow-hidden md:col-span-2 relative">
                            <img 
                                v-if="!registrationImageErrored"
                                :src="getRegistrationImage()"
                                alt="Registration Process"
                                class="w-full h-full object-cover"
                                @error="onRegistrationImageError"
                            >
                            <div v-else class="w-full h-full bg-gradient-to-br from-[#0f1d52] to-[#1d4a97] flex flex-col items-center justify-center p-8 text-center">
                                <svg class="w-16 h-16 text-[#F4B223] mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                                </svg>
                                <p class="text-white font-bold text-lg">Fast Digital Registration</p>
                                <p class="text-blue-100 text-sm mt-2">Submit your membership application online and receive onboarding guidance from our team.</p>
                            </div>
                            <div class="absolute inset-0 bg-gradient-to-t from-[#0c1a49]/30 to-transparent pointer-events-none"></div>
                        </div>
                    </div>
                </div>

                <!-- Membership Benefits -->
                <div class="mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 400ms;">
                    <h2 class="text-3xl font-bold text-[#1D2A68] mb-12 text-center">Why Choose LiVCCI?</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                        <div v-for="(benefit, index) in membershipBenefits" :key="index" class="rounded-lg overflow-hidden shadow-lg hover:shadow-2xl transition-all group transform hover:-translate-y-2 duration-300">
                            <div class="relative h-48 overflow-hidden bg-gray-200">
                                <img 
                                    :src="benefit.image" 
                                    :alt="benefit.title"
                                    class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                                >
                                <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                            </div>
                            <div class="bg-white p-6">
                                <h3 class="text-xl font-bold text-[#1D2A68] mb-3">{{ benefit.title }}</h3>
                                <p class="text-gray-600">{{ benefit.description }}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Call to Action -->
                <div class="bg-gradient-to-r from-[#1D2A68] to-[#1460A0] text-white rounded-xl p-12 text-center opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 500ms;">
                    <h2 class="text-3xl font-bold mb-6">Ready to Join?</h2>
                    <p class="text-lg text-blue-100 mb-8 max-w-2xl mx-auto">
                        Start your membership today and become part of Livingstone's most dynamic and influential business community.
                    </p>
                    <Link :href="route('register')" class="inline-block bg-[#F4B223] text-[#1D2A68] font-bold py-3 px-10 rounded-md hover:bg-[#E8A01A] transition-colors text-lg">
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
</style>
