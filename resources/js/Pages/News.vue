<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    events: Array
});

const selectedCategory = ref('All Updates');

const categoryOptions = [
    'All Updates',
    'Meeting',
    'Workshop',
    'Expo',
    'News',
];

const analyticalCategories = ['Advocacy', 'Member Spotlights', 'Market Reports', 'Event Summaries'];

const isFutureEvent = (event) => {
    if (!event?.event_date) return false;
    const eventDate = new Date(event.event_date);
    const now = new Date();
    eventDate.setHours(23, 59, 59, 999);
    return eventDate >= now;
};

const inferCategory = (event) => {
    const explicitCategory = event?.category;
    if (explicitCategory && analyticalCategories.includes(explicitCategory)) {
        return explicitCategory;
    }

    const text = `${event?.title || ''} ${event?.description || ''}`.toLowerCase();

    if (text.includes('policy') || text.includes('advocacy') || text.includes('concession') || text.includes('regulation')) {
        return 'Advocacy';
    }

    if (text.includes('spotlight') || text.includes('member profile') || text.includes('member of the week')) {
        return 'Member Spotlights';
    }

    if (text.includes('market') || text.includes('report') || text.includes('data') || text.includes('insight')) {
        return 'Market Reports';
    }

    return 'Event Summaries';
};

const normalizedEvents = computed(() => {
    const rows = Array.isArray(props.events) ? props.events : [];
    return rows.map((event) => ({
        ...event,
        isUpcoming: isFutureEvent(event),
        contentType: isFutureEvent(event) ? 'Event' : 'News',
        category: inferCategory(event),
    }));
});

const getEventTags = (event) => {
    const raw = event?.tags ?? event?.tag ?? [];

    if (Array.isArray(raw)) {
        return raw.map((tag) => String(tag).trim().toLowerCase()).filter(Boolean);
    }

    if (typeof raw === 'string') {
        return raw
            .split(',')
            .map((tag) => tag.trim().toLowerCase())
            .filter(Boolean);
    }

    return [];
};

const hasUpdateTag = (event) => {
    return getEventTags(event).includes('update');
};

const isSidebarEligibleEvent = (event) => {
    const eventType = String(event?.type || '').toLowerCase();
    if (eventType === 'meeting' || eventType === 'workshop' || eventType === 'expo') {
        return true;
    }

    const text = `${event?.title || ''} ${event?.description || ''}`.toLowerCase();
    return /\b(meeting|workshop|expo)\b/.test(text);
};

const filteredEvents = computed(() => {
    if (selectedCategory.value === 'All Updates') {
        return normalizedEvents.value;
    }

    return normalizedEvents.value.filter((event) => {
        return String(event?.type || '').toLowerCase() === selectedCategory.value.toLowerCase();
    });
});

const upcomingEvents = computed(() => {
    return normalizedEvents.value
        .filter((event) => {
            if (!event.isUpcoming || !isSidebarEligibleEvent(event)) {
                return false;
            }

            const tags = getEventTags(event);
            // The current publication portal schema has no tags column,
            // so default to upcoming meetings/workshops/expos when tags are absent.
            return tags.length === 0 || tags.includes('update');
        })
        .sort((a, b) => new Date(a.event_date) - new Date(b.event_date))
        .slice(0, 6);
});

const formatSidebarDate = (date) => {
    if (!date) return { day: '--', month: '---' };
    const d = new Date(date);
    return {
        day: d.toLocaleDateString('en-US', { day: '2-digit' }),
        month: d.toLocaleDateString('en-US', { month: 'short' }).toUpperCase(),
    };
};

const mediaMentions = [
    { name: 'Lusaka Times', link: 'https://www.lusakatimes.com/' },
    { name: 'ZNBC', link: 'https://znbc.co.zm/' },
    { name: 'Times of Zambia', link: 'https://www.times.co.zm/' },
    { name: 'Daily Mail Zambia', link: 'https://www.daily-mail.co.zm/' },
];

const parseTradeValue = (text) => {
    if (!text) return 0;
    const normalized = String(text).replace(/\s+/g, ' ').toUpperCase();

    let total = 0;

    // Matches values like K2.5M, ZMW 2500000, 2.5 million
    const matches = normalized.matchAll(/(?:K|ZMW|KWACHA)?\s*([0-9]+(?:[.,][0-9]+)?)\s*(M|MILLION)?/g);
    for (const match of matches) {
        const numeric = Number.parseFloat(String(match[1]).replace(',', '.'));
        if (Number.isNaN(numeric) || numeric <= 0) continue;

        const isMillion = Boolean(match[2]);
        total += isMillion ? numeric * 1_000_000 : numeric;
    }

    return total;
};

const formatKwacha = (amount) => {
    if (amount >= 1_000_000) {
        const millions = (amount / 1_000_000).toFixed(1).replace('.0', '');
        return `K${millions}M+`;
    }

    if (amount >= 1_000) {
        const thousands = Math.round(amount / 1_000);
        return `K${thousands}K+`;
    }

    return amount > 0 ? `K${Math.round(amount)}+` : 'K0';
};

const advocacyStats = computed(() => {
    const now = new Date();
    const currentYear = now.getFullYear();

    const advocacyEvents = normalizedEvents.value.filter((event) => event.category === 'Advocacy');

    const policyWins = advocacyEvents.filter((event) => {
        const text = `${event?.title || ''} ${event?.description || ''}`.toLowerCase();
        return /(win|won|approved|adopted|concession|policy change|milestone|secured)/.test(text);
    }).length || advocacyEvents.length;

    const tradeValue = advocacyEvents.reduce((sum, event) => {
        const text = `${event?.title || ''} ${event?.description || ''}`;
        return sum + parseTradeValue(text);
    }, 0);

    const stakeholderMeetings = normalizedEvents.value.filter((event) => {
        if (!event?.event_date) return false;
        const d = new Date(event.event_date);
        const isSameMonth = d.getFullYear() === now.getFullYear() && d.getMonth() === now.getMonth();
        if (!isSameMonth) return false;

        const text = `${event?.title || ''} ${event?.description || ''}`.toLowerCase();
        return String(event?.type || '').toLowerCase() === 'meeting' || /(stakeholder|roundtable|consultation|dialogue|engagement)/.test(text);
    }).length;

    return [
        { label: `Policy Wins in ${currentYear}`, value: String(policyWins) },
        { label: 'Trade Value Impacted', value: formatKwacha(tradeValue) },
        { label: 'Stakeholder Meetings this month', value: String(stakeholderMeetings) },
    ];
});

// Scroll animation state
const scrollY = ref(0);

// Handle scroll events
const handleScroll = () => {
    scrollY.value = window.scrollY;
};

// Format date for display
const formatDate = (date) => {
    if (!date) return '';
    return new Date(date).toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
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

const getFilterPillClass = (category) => {
    const selected = selectedCategory.value === category;

    if (category === 'All Updates') {
        return selected
            ? 'bg-[#1D2A68] text-white border-[#1D2A68]'
            : 'bg-white text-[#1D2A68] border-gray-300 hover:border-[#1D2A68]';
    }

    const selectedMap = {
        Meeting: 'bg-blue-600 text-white border-blue-600',
        Workshop: 'bg-purple-600 text-white border-purple-600',
        Expo: 'bg-green-600 text-white border-green-600',
        News: 'bg-orange-500 text-white border-orange-500',
    };

    const unselectedMap = {
        Meeting: 'bg-blue-50 text-blue-700 border-blue-200 hover:border-blue-400',
        Workshop: 'bg-purple-50 text-purple-700 border-purple-200 hover:border-purple-400',
        Expo: 'bg-green-50 text-green-700 border-green-200 hover:border-green-400',
        News: 'bg-orange-50 text-orange-700 border-orange-200 hover:border-orange-400',
    };

    return selected ? selectedMap[category] : unselectedMap[category];
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
    <Head title="News & Events - LiVCCI" />

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
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">News & Events</Link>
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
            <!-- Background Image -->
            <div class="absolute inset-0">
                <img 
                    src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80" 
                    class="w-full h-full object-cover opacity-25 mix-blend-overlay" 
                    alt="News & Events"
                >
                <div class="absolute inset-0 bg-gradient-to-r from-[#1D2A68] to-[#1D2A68]/70 mix-blend-multiply"></div>
            </div>
            
            <!-- Hero Content -->
            <div class="relative max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 flex flex-col justify-center h-full opacity-0 translate-y-10 transition-all duration-700 animate-in">
                <span class="px-3 py-1 rounded-full bg-[#1876C3]/40 text-[#F6EED8] text-sm font-semibold tracking-wide border border-[#1876C3] mb-4 inline-block w-fit">
                    Stay Connected
                </span>
                <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl max-w-3xl leading-tight">
                    News & Events
                </h1>
                <p class="mt-6 text-xl text-blue-100 max-w-2xl">
                    Discover the latest updates, upcoming events, and business opportunities from the Livingstone Chamber of Commerce & Industry.
                </p>
            </div>
        </div>

        <!-- Advocacy Impact Bar -->
        <div class="bg-white border-b border-gray-200">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div v-for="item in advocacyStats" :key="item.label" class="rounded-xl bg-[#f8fbff] border border-[#dbeafe] px-5 py-4">
                        <p class="text-2xl font-black text-[#1D2A68]">{{ item.value }}</p>
                        <p class="text-sm text-[#1876C3] font-semibold mt-1">{{ item.label }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content Section -->
        <div class="bg-white py-16 sm:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
                    <div class="lg:col-span-2">
                        <!-- Category Filters -->
                        <div class="mb-8 flex flex-wrap gap-2">
                            <button
                                v-for="category in categoryOptions"
                                :key="category"
                                @click="selectedCategory = category"
                                :class="[
                                    'px-4 py-2 rounded-full text-sm font-bold transition-colors border',
                                    getFilterPillClass(category)
                                ]"
                            >
                                {{ category }}
                            </button>
                        </div>

                        <div v-if="filteredEvents.length > 0" class="grid grid-cols-1 md:grid-cols-2 gap-8">
                            <div v-for="(event, index) in filteredEvents" :key="event.id" :class="['bg-white rounded-lg border shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 group opacity-0 translate-y-10 animate-in', getEventCardClass(event.type)]" :style="{ transitionDelay: `${index * 100}ms` }">
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
                            <p class="text-gray-600 text-sm mb-4 line-clamp-3">{{ event.description }}</p>
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-2 flex-wrap">
                                    <span :class="['px-3 py-1 rounded text-xs font-bold', getTypeColor(event.type)]">
                                        {{ event.type }}
                                    </span>
                                    <span class="px-3 py-1 rounded text-xs font-bold" :class="event.isUpcoming ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-700'">
                                        {{ event.contentType }}
                                    </span>
                                    <span class="px-3 py-1 rounded text-xs font-bold bg-[#eef4ff] text-[#1D2A68]">
                                        {{ event.category }}
                                    </span>
                                </div>

                                <a 
                                    v-if="event.external_link"
                                    :href="event.external_link"
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    class="text-[#1876C3] font-semibold text-sm hover:underline cursor-pointer whitespace-nowrap"
                                >
                                    Read More →
                                </a>
                                <span v-else class="text-gray-400 font-semibold text-sm whitespace-nowrap">Read More →</span>
                            </div>
                        </div>
                    </div>
                        </div>

                        <div v-else class="text-center py-16 bg-gray-50 rounded-lg border border-gray-200">
                            <p class="text-lg text-gray-600 mb-2">No items for this category yet</p>
                            <p class="text-gray-500">Try another filter or check back soon.</p>
                        </div>
                    </div>

                    <!-- Sidebar -->
                    <aside class="space-y-8">
                        <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-6">
                            <h3 class="text-xl font-black text-[#1D2A68] mb-1">Save the Date</h3>
                            <p class="text-sm text-gray-500 mb-5">Upcoming business mixers, AGMs, and trade missions.</p>

                            <div v-if="upcomingEvents.length > 0" class="space-y-4">
                                <div v-for="event in upcomingEvents" :key="`upcoming-${event.id}`" class="flex gap-3 items-start border-b border-gray-100 pb-4 last:border-b-0 last:pb-0">
                                    <div class="min-w-[62px] rounded-lg border border-[#dbeafe] bg-[#f8fbff] text-center px-2 py-2">
                                        <p class="text-xl font-black text-[#1D2A68] leading-none">{{ formatSidebarDate(event.event_date).day }}</p>
                                        <p class="text-xs font-bold text-[#1876C3] mt-1">{{ formatSidebarDate(event.event_date).month }}</p>
                                    </div>
                                    <div>
                                        <p class="text-sm font-bold text-[#1D2A68] leading-snug">{{ event.title }}</p>
                                        <span :class="['inline-flex mt-1 px-2 py-0.5 rounded text-xs font-bold', getTypeColor(event.type)]">{{ event.type }}</span>
                                    </div>
                                </div>
                            </div>
                            <p v-else class="text-sm text-gray-500">No upcoming events scheduled yet.</p>
                        </div>

                        <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-6">
                            <h3 class="text-xl font-black text-[#1D2A68] mb-1">Chamber in the Media</h3>
                            <p class="text-sm text-gray-500 mb-5">As Seen On</p>
                            <div class="space-y-3">
                                <a
                                    v-for="media in mediaMentions"
                                    :key="media.name"
                                    :href="media.link"
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    class="flex items-center justify-between rounded-lg border border-gray-200 px-4 py-3 hover:border-[#1876C3] hover:bg-[#f8fbff] transition-colors"
                                >
                                    <span class="text-sm font-bold text-[#1D2A68]">{{ media.name }}</span>
                                    <span class="text-[#1876C3] text-sm font-bold">↗</span>
                                </a>
                            </div>
                        </div>
                    </aside>
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
</style>