<script setup>
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="About Us - LiVCCI" />

    <div class="min-h-screen bg-gray-50 font-sans text-gray-900 flex flex-col">
        
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
                        <Link :href="route('about')" class="text-sm font-bold text-[#1876C3] border-b-2 border-[#1876C3] pb-1">About Us</Link>
                        <Link :href="route('sectors')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Sectors</Link>
                        <Link :href="route('news')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">News & Events</Link>
                        <Link :href="route('directory.index')" class="text-sm font-semibold text-[#1D2A68] hover:text-[#1876C3] transition-colors">Member Directory</Link>
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

        <div class="bg-[#1D2A68] py-16 sm:py-24 border-b-4 border-[#F4B223]">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                <h1 class="text-4xl font-extrabold text-white sm:text-5xl tracking-tight mb-4">About LiVCCI</h1>
                <p class="max-w-2xl mx-auto text-xl text-blue-200">
                    The Livingstone Chamber of Commerce and Industry is an independent, membership-driven organization advocating for an enabling multi-sectoral business environment.
                </p>
            </div>
        </div>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 -mt-10">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div class="bg-white rounded-xl shadow-lg p-10 border-t-4 border-[#1876C3] relative overflow-hidden group hover:shadow-xl transition-shadow">
                    <div class="absolute top-0 right-0 -mt-4 -mr-4 w-24 h-24 bg-[#E8F1F8] rounded-full z-0 group-hover:scale-150 transition-transform duration-500"></div>
                    <div class="relative z-10">
                        <h2 class="text-2xl font-black text-[#1D2A68] mb-4 flex items-center gap-2">
                            <svg class="w-6 h-6 text-[#F4B223]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                            Our Mission
                        </h2>
                        <p class="text-lg text-gray-700 font-medium leading-relaxed">
                            To facilitate business through lobby, advocacy, and networking.
                        </p>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-lg p-10 border-t-4 border-[#1876C3] relative overflow-hidden group hover:shadow-xl transition-shadow">
                    <div class="absolute top-0 right-0 -mt-4 -mr-4 w-24 h-24 bg-[#E8F1F8] rounded-full z-0 group-hover:scale-150 transition-transform duration-500"></div>
                    <div class="relative z-10">
                        <h2 class="text-2xl font-black text-[#1D2A68] mb-4 flex items-center gap-2">
                            <svg class="w-6 h-6 text-[#F4B223]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                            Our Vision
                        </h2>
                        <p class="text-lg text-gray-700 font-medium leading-relaxed">
                            A thriving business community based on demand and client needs.
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="py-16 bg-white flex-grow">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h2 class="text-3xl font-extrabold text-[#1D2A68] mb-12">Strategic Objectives</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-start">
                    <!-- Left Column: Image -->
                    <div>
                        <div class="bg-gradient-to-br from-[#1876C3] to-[#1460A0] rounded-xl overflow-hidden shadow-lg h-96 flex items-center justify-center">
                            <svg class="w-32 h-32 text-white opacity-30" fill="currentColor" viewBox="0 0 24 24"><path d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                        </div>
                        <p class="text-gray-600 text-sm mt-4 text-center">Strategic initiatives driving business growth and regional development</p>
                    </div>

                    <!-- Right Column: Strategic Objectives -->
                    <div>
                        <div class="grid grid-cols-1 gap-4">
                            <div class="flex gap-4">
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Unlocking the potential for business growth</h4>
                                    </div>
                                </div>
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Market linkage</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Capacity building for MSMEs</h4>
                                    </div>
                                </div>
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Business Development Services (BDS)</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Lobby and Advocacy</h4>
                                    </div>
                                </div>
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Agri-Entrepreneurship</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Entrepreneurship</h4>
                                    </div>
                                </div>
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Information Technology Communication (ITC)</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Business Information</h4>
                                    </div>
                                </div>
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Business Incubation</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Access to finance</h4>
                                    </div>
                                </div>
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Enabling environment</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="flex gap-4">
                                <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-4 rounded-lg border border-blue-200 hover:border-[#1876C3] hover:shadow-md transition-all flex-1">
                                    <div class="flex items-start gap-3">
                                        <svg class="w-5 h-5 text-[#1876C3] flex-shrink-0 mt-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                        <h4 class="font-bold text-[#1D2A68] text-sm">Networking</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="py-16 bg-gray-50">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="text-center mb-12">
                    <h2 class="text-3xl font-extrabold text-[#1D2A68]">Membership Types</h2>
                    <p class="mt-4 text-gray-600 max-w-2xl mx-auto">Choose a membership type that best suits your business needs and budget.</p>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div class="bg-white rounded-lg shadow-md border border-gray-200 p-8 hover:shadow-lg transition-shadow">
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">Individual</h3>
                        <p class="text-3xl font-extrabold text-[#1876C3] mb-6">ZMW 500</p>
                        <p class="text-gray-600 text-sm">Perfect for solo entrepreneurs and business professionals.</p>
                    </div>

                    <div class="bg-white rounded-lg shadow-md border border-gray-200 p-8 hover:shadow-lg transition-shadow">
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">Co-operative</h3>
                        <p class="text-3xl font-extrabold text-[#1876C3] mb-6">ZMW 500</p>
                        <p class="text-gray-600 text-sm">Ideal for cooperative organizations and associations.</p>
                    </div>

                    <div class="bg-white rounded-lg shadow-md border border-gray-200 p-8 hover:shadow-lg transition-shadow">
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">Business</h3>
                        <p class="text-3xl font-extrabold text-[#1876C3] mb-6">ZMW 1,000</p>
                        <p class="text-gray-600 text-sm">Designed for small to medium-sized enterprises.</p>
                    </div>

                    <div class="bg-white rounded-lg shadow-md border border-gray-200 p-8 hover:shadow-lg transition-shadow">
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">Academia</h3>
                        <p class="text-3xl font-extrabold text-[#1876C3] mb-6">ZMW 2,000</p>
                        <p class="text-gray-600 text-sm">For colleges, universities, and educational institutions.</p>
                    </div>

                    <div class="bg-white rounded-lg shadow-md border border-gray-200 p-8 hover:shadow-lg transition-shadow">
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">Corporate</h3>
                        <p class="text-3xl font-extrabold text-[#1876C3] mb-6">ZMW 2,000</p>
                        <p class="text-gray-600 text-sm">Premium membership for large corporations and conglomerates.</p>
                    </div>

                    <div class="bg-white rounded-lg shadow-md border border-gray-200 p-8 hover:shadow-lg transition-shadow">
                        <h3 class="text-xl font-bold text-[#1D2A68] mb-3">Affiliate</h3>
                        <p class="text-3xl font-extrabold text-[#1876C3] mb-6">ZMW 1,000</p>
                        <p class="text-gray-600 text-sm">For partner organizations and affiliated entities.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="py-16 bg-white flex-grow">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="text-center mb-12">
                    <h2 class="text-3xl font-extrabold text-[#1D2A68]">Why Join LiVCCI?</h2>
                    <p class="mt-4 text-gray-600 max-w-2xl mx-auto">Membership offers exclusive benefits designed to help your business thrive.</p>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                    <div class="flex gap-6">
                        <div class="flex-shrink-0">
                            <svg class="h-8 w-8 text-[#1876C3]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"></path></svg>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold text-[#1D2A68] mb-2">Business Networking</h3>
                            <p class="text-gray-600">Connect with like-minded entrepreneurs, business leaders, and potential partners in a supportive community environment.</p>
                        </div>
                    </div>

                    <div class="flex gap-6">
                        <div class="flex-shrink-0">
                            <svg class="h-8 w-8 text-[#1876C3]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold text-[#1D2A68] mb-2">Advocacy & Representation</h3>
                            <p class="text-gray-600">We represent your business interests to government, regulatory bodies, and other stakeholders to create favorable policy environments.</p>
                        </div>
                    </div>

                    <div class="flex gap-6">
                        <div class="flex-shrink-0">
                            <svg class="h-8 w-8 text-[#1876C3]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C6.228 6.228 2 10.228 2 15s4.228 8.772 10 8.772c5.772 0 10-3.9 10-8.772 0-4.772-4.228-8.747-10-8.747z"></path></svg>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold text-[#1D2A68] mb-2">Training & Mentorship</h3>
                            <p class="text-gray-600">Access specialized training programs, workshops, and mentorship from industry experts to develop your business skills.</p>
                        </div>
                    </div>

                    <div class="flex gap-6">
                        <div class="flex-shrink-0">
                            <svg class="h-8 w-8 text-[#1876C3]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"></path></svg>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold text-[#1D2A68] mb-2">Access to Development Programs</h3>
                            <p class="text-gray-600">Leverage our suite of business development programs including BDS, business incubation, and capacity-building initiatives.</p>
                        </div>
                    </div>

                    <div class="flex gap-6">
                        <div class="flex-shrink-0">
                            <svg class="h-8 w-8 text-[#1876C3]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.856-1.487M15 10a3 3 0 11-6 0 3 3 0 016 0zM15 20h-8a3 3 0 00-3 3v2h14v-2a3 3 0 00-3-3z"></path></svg>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold text-[#1D2A68] mb-2">Market Linkage & Visibility</h3>
                            <p class="text-gray-600">Gain exposure through our member directory, events, and business forums to expand your market reach and client base.</p>
                        </div>
                    </div>
                </div>

                <div class="mt-16 text-center">
                    <Link :href="route('register')" class="bg-[#1876C3] text-white text-lg font-bold py-4 px-10 rounded-md hover:bg-[#1460A0] shadow-lg transition-colors inline-block">
                        Become a Member Today
                    </Link>
                </div>
            </div>
        </div>

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
                            <li><Link :href="route('about')" class="hover:text-white transition-colors">About Us</Link></li>
                            <li><Link :href="route('sectors')" class="hover:text-white transition-colors">Sectors</Link></li>
                            <li><Link :href="route('news')" class="hover:text-white transition-colors">News & Events</Link></li>
                            <li><Link :href="route('directory.index')" class="hover:text-white transition-colors">Member Directory</Link></li>
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