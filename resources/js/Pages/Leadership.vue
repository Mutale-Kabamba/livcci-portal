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

const defaultBoardMembers = [
    { position: 'President', name: 'Banwell Mwila', gender: 'male' },
    { position: 'Vice President', name: 'Anthony Ranjan', gender: 'male' },
    { position: 'Vice President', name: 'Peggy M. Hamukoma', gender: 'female' },
    { position: 'Secretary', name: 'Peter Katebe', gender: 'male' },
    { position: 'Vice Secretary', name: 'Steven Mwiinga', gender: 'male' },
    { position: 'Treasurer', name: 'Kennedy Chaile', gender: 'male' },
    { position: 'Marketing Officer', name: 'Petronella Mbesha', gender: 'female' },
    { position: 'Membership Officer', name: 'Isaac Kapya', gender: 'male' },
    { position: 'Research Officer', name: 'Diana Chipasha', gender: 'female' },
    { position: 'Trustee', name: 'Nyambe Mwangala', gender: 'male' },
    { position: 'Trustee', name: 'Dickson Mwika', gender: 'male' },
    { position: 'Trustee', name: 'Ruth Hansen', gender: 'female' },
];

const boardMembers = Array.isArray(props.content.board_members) && props.content.board_members.length > 0
    ? props.content.board_members
    : defaultBoardMembers;
const defaultContactLinks = {
    phone: '+260977105068',
    whatsapp: '260977105068',
    facebook: 'https://www.facebook.com/livcci',
    linkedin: 'https://www.linkedin.com/company/livcci'
};

const getContactLink = (member, type) => {
    const memberContact = member?.contact || {};
    const value = memberContact[type] || defaultContactLinks[type];

    if (!value) {
        return '#';
    }

    if (type === 'phone') {
        const phone = String(value).replace(/\s+/g, '');
        return phone.startsWith('tel:') ? phone : `tel:${phone}`;
    }

    if (type === 'whatsapp') {
        const phone = String(value).replace(/[^\d]/g, '');
        return String(value).includes('wa.me/') ? String(value) : `https://wa.me/${phone}`;
    }

    return value;
};

const leadershipHero = props.content.hero || {
    badge: 'Board of Directors',
    title: 'Chamber Leadership',
    description: 'Meet the elected board of directors guiding LiVCCI (Elected November 2024)'
};
</script>

<template>
    <Head title="Leadership - LiVCCI" />

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
                    alt="Leadership"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    {{ leadershipHero.badge }}
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    {{ leadershipHero.title }}
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    {{ leadershipHero.description }}
                </p>
            </div>
        </div>

        <!-- Content -->
        <div class="bg-white py-16 sm:py-20" data-scroll>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Board Members Grid -->
                <div class="mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in">
                    <h2 class="text-3xl font-bold text-[#1D2A68] mb-12 text-center">Elected Leadership</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                        <div 
                            v-for="(member, index) in boardMembers" 
                            :key="index"
                            :style="{ transitionDelay: `${index * 50}ms` }"
                            class="opacity-0 translate-y-10 transition-all duration-700 animate-in px-2"
                        >
                            <!-- Photo -->
                            <div class="w-56 h-56 mb-5 mx-auto flex items-center justify-center overflow-hidden rounded-full group">
                                <img 
                                    :src="member.image_url || `/images/leader/${member.gender === 'male' ? 'man.png' : 'woman.png'}`"
                                    :alt="member.name"
                                    class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                                >
                            </div>
                            
                            <!-- Member Info -->
                            <div class="text-center">
                                <h3 class="text-lg font-bold text-orange-600 mb-1 uppercase tracking-wide">{{ member.name }}</h3>
                                <p class="text-gray-600 text-sm font-medium">{{ member.position }}</p>
                                <div class="mt-6 flex items-center justify-center gap-4 text-[#d11a1a]">
                                    <a :href="getContactLink(member, 'phone')" class="hover:text-[#1876C3] transition-colors" title="Call">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" aria-hidden="true">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M3 5a2 2 0 012-2h2.2a1 1 0 01.98.804l.57 2.86a1 1 0 01-.27.92l-1.2 1.2a16 16 0 007.94 7.94l1.2-1.2a1 1 0 01.92-.27l2.86.57A1 1 0 0121 16.8V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                                        </svg>
                                    </a>
                                    <a :href="getContactLink(member, 'whatsapp')" target="_blank" rel="noopener noreferrer" class="hover:text-[#1876C3] transition-colors" title="WhatsApp">
                                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M20.52 3.48A11.84 11.84 0 0012.07 0C5.5 0 .17 5.33.17 11.9c0 2.1.55 4.16 1.6 5.98L0 24l6.3-1.64a11.88 11.88 0 005.77 1.47h.01c6.56 0 11.9-5.34 11.9-11.9 0-3.18-1.24-6.16-3.46-8.45zM12.08 21.8h-.01a9.9 9.9 0 01-5.04-1.38l-.36-.21-3.74.97 1-3.64-.24-.38a9.87 9.87 0 01-1.52-5.26c0-5.45 4.44-9.9 9.9-9.9 2.64 0 5.12 1.03 6.99 2.9a9.82 9.82 0 012.91 6.99c0 5.45-4.45 9.9-9.9 9.9zm5.43-7.43c-.3-.15-1.77-.87-2.05-.96-.27-.1-.47-.15-.67.15-.2.3-.77.96-.95 1.15-.17.2-.35.22-.65.08-.3-.15-1.24-.46-2.36-1.47-.88-.78-1.47-1.75-1.64-2.05-.17-.3-.02-.47.13-.62.13-.13.3-.35.45-.52.15-.17.2-.3.3-.5.1-.2.05-.37-.03-.52-.07-.15-.67-1.62-.92-2.22-.24-.57-.48-.5-.67-.51h-.57c-.2 0-.52.08-.8.37-.27.3-1.05 1.03-1.05 2.5s1.08 2.9 1.23 3.1c.15.2 2.12 3.23 5.12 4.53.72.31 1.29.5 1.73.63.72.23 1.37.2 1.88.12.57-.08 1.77-.72 2.02-1.42.25-.7.25-1.3.17-1.42-.07-.12-.27-.2-.57-.35z"/>
                                        </svg>
                                    </a>
                                    <a :href="getContactLink(member, 'facebook')" target="_blank" rel="noopener noreferrer" class="hover:text-[#1876C3] transition-colors" title="Facebook">
                                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M24 12.073c0-6.627-5.373-12-12-12S0 5.446 0 12.073c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.49 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                                        </svg>
                                    </a>
                                    <a :href="getContactLink(member, 'linkedin')" target="_blank" rel="noopener noreferrer" class="hover:text-[#1876C3] transition-colors" title="LinkedIn">
                                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.475-2.236-1.986-2.236-1.08 0-1.722.722-2.004 1.418-.103.249-.129.597-.129.946v5.441H9.22s.047-8.733 0-9.652h3.554v1.366c.43-.664 1.199-1.61 2.919-1.61 2.136 0 3.734 1.39 3.734 4.38v5.516zM5.337 8.855c-1.144 0-1.915-.762-1.915-1.715 0-.953.77-1.715 1.958-1.715 1.188 0 1.915.762 1.915 1.715 0 .953-.726 1.715-1.958 1.715zm1.608 11.597H3.73V9.097h3.215v11.355zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.225 0z"/>
                                        </svg>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Leadership Structure Section -->
                <div class="bg-gradient-to-r from-[#1D2A68] to-[#1460A0] text-white rounded-xl p-12 mb-20 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 100ms;">
                    <h2 class="text-3xl font-bold mb-8 text-center">Board Structure</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">1</div>
                            <div>
                                <h3 class="font-bold mb-2">Executive Committee</h3>
                                <p class="text-blue-100">President, Vice Presidents, Secretary, Treasurer</p>
                            </div>
                        </div>

                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">2</div>
                            <div>
                                <h3 class="font-bold mb-2">Officers</h3>
                                <p class="text-blue-100">Marketing, Membership, Research, and Support Officers</p>
                            </div>
                        </div>

                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">3</div>
                            <div>
                                <h3 class="font-bold mb-2">Trustees</h3>
                                <p class="text-blue-100">Providing oversight and fiduciary responsibility</p>
                            </div>
                        </div>

                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-8 h-8 bg-[#F4B223] rounded-full flex items-center justify-center font-bold">4</div>
                            <div>
                                <h3 class="font-bold mb-2">Mission-Driven</h3>
                                <p class="text-blue-100">Committed to advancing LiVCCI's vision and strategic goals</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Call to Action -->
                <div class="text-center bg-gray-50 rounded-xl p-12 opacity-0 translate-y-10 transition-all duration-700 animate-in" style="transition-delay: 200ms;">
                    <h2 class="text-3xl font-bold text-[#1D2A68] mb-6">Join the Chamber Community</h2>
                    <p class="text-lg text-gray-600 mb-8 max-w-2xl mx-auto">
                        Work alongside our dedicated leadership and connect with Livingstone's most influential business community.
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
