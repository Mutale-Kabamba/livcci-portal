<template>
  <div class="min-h-screen bg-gradient-to-b from-[#f6eed8] to-gray-50 py-12 px-4">
    <div class="max-w-4xl mx-auto">
      <!-- Header -->
      <div class="bg-gradient-to-r from-[#1D2A68] to-[#1876C3] text-white rounded-t-lg p-8 text-center shadow-lg">
        <h1 class="text-4xl font-bold mb-2">🏛️ LivCCI Membership Application</h1>
        <p class="text-lg text-blue-100">Join the Livci Chamber of Commerce and Industry - Your Gateway to Business Excellence</p>
      </div>

      <!-- Form -->
      <form @submit.prevent="submitForm" enctype="multipart/form-data" class="bg-white rounded-b-lg shadow-lg p-8 border-t-4 border-[#F4B223]">
        <!-- Account Creation Section -->
        <div class="mb-8 pb-8 border-b-2">
          <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">
            👤 Create Your Account
          </h2>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Full Name <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.full_name"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1876C3] focus:border-transparent"
                placeholder="Your full name"
                @blur="clearError('full_name')"
              />
              <p v-if="errors.full_name" class="text-[#DC2626] text-sm mt-1">{{ errors.full_name }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
              Email Address <span class="text-[#1876C3] font-bold">*</span>
              </label>
              <input
                v-model="form.email"
                type="email"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1876C3] focus:border-transparent"
                placeholder="your.email@example.com"
                @blur="clearError('email')"
              />
              <p v-if="errors.email" class="text-[#DC2626] text-sm mt-1">{{ errors.email }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Password <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.password"
                type="password"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1876C3] focus:border-transparent"
                placeholder="••••••••"
                @blur="clearError('password')"
              />
              <p class="text-gray-500 text-xs mt-1">Min 8 chars, uppercase, lowercase, number, symbol</p>
              <p v-if="errors.password" class="text-[#DC2626] text-sm mt-1">{{ errors.password }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
              Confirm Password <span class="text-[#1876C3] font-bold">*</span>
              </label>
              <input
                v-model="form.password_confirmation"
                type="password"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent"
                placeholder="••••••••"
                @blur="clearError('password_confirmation')"
              />
              <p v-if="errors.password_confirmation" class="text-[#DC2626] text-sm mt-1">{{ errors.password_confirmation }}</p>
            </div>
          </div>
        </div>

        <!-- Business Information Section -->
        <div class="mb-8 pb-8 border-b-2">
          <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">
            🏢 Business Information
          </h2>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Business Name <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.company_name"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Enter your business name"
                @blur="clearError('company_name')"
              />
              <p v-if="errors.company_name" class="text-[#DC2626] text-sm mt-1">{{ errors.company_name }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Contact Email <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.contact_email"
                type="email"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="company@example.com"
                @blur="clearError('contact_email')"
              />
              <p v-if="errors.contact_email" class="text-[#DC2626] text-sm mt-1">{{ errors.contact_email }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Street Address <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.address"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Enter complete business address"
                @blur="clearError('address')"
              />
              <p v-if="errors.address" class="text-[#DC2626] text-sm mt-1">{{ errors.address }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Telephone Number <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.phone"
                type="tel"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="+260 XXX XXX XXX"
                @blur="clearError('phone')"
              />
              <p v-if="errors.phone" class="text-[#DC2626] text-sm mt-1">{{ errors.phone }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Website URL
              </label>
              <input
                v-model="form.website_url"
                type="url"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="https://example.com"
                @blur="clearError('website_url')"
              />
              <p v-if="errors.website_url" class="text-[#DC2626] text-sm mt-1">{{ errors.website_url }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Company Logo
              </label>
              <input
                type="file"
                accept="image/jpeg,image/jpg,image/png"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                @change="handleLogoUpload"
              />
              <p class="text-gray-500 text-xs mt-1">JPG, PNG, or GIF (Max 2MB)</p>
              <p v-if="errors.logo" class="text-[#DC2626] text-sm mt-1">{{ errors.logo }}</p>
            </div>
          </div>

          <div class="mt-6">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Nature of Business <span class="text-[#DC2626]">*</span>
            </label>
            <textarea
              v-model="form.short_description"
              rows="3"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg"
              placeholder="Describe what your business does"
              @blur="clearError('short_description')"
            ></textarea>
            <p v-if="errors.short_description" class="text-[#DC2626] text-sm mt-1">{{ errors.short_description }}</p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Business Sector <span class="text-[#DC2626]">*</span>
              </label>
              <select
                v-model="form.industry_sector"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                @blur="clearError('industry_sector')"
              >
                <option value="">Select your business sector</option>
                <option>Tourism & Hospitality</option>
                <option>Trade & Commerce</option>
                <option>Financial Services</option>
                <option>Construction & Engineering</option>
                <option>Agriculture & Manufacturing</option>
                <option>Cooperatives & Social Enterprise</option>
                <option>IT & Creative Media</option>
              </select>
              <p v-if="errors.industry_sector" class="text-[#DC2626] text-sm mt-1">{{ errors.industry_sector }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Number of Employees <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model.number="form.number_of_employees"
                type="number"
                min="1"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Enter number of employees"
                @blur="clearError('number_of_employees')"
              />
              <p v-if="errors.number_of_employees" class="text-[#DC2626] text-sm mt-1">{{ errors.number_of_employees }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Annual Turnover (ZMW)
              </label>
              <input
                v-model.number="form.annual_turnover"
                type="number"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Enter annual turnover"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Membership Type <span class="text-[#DC2626]">*</span>
              </label>
              <select
                v-model="form.member_type"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                @change="clearError('member_type')"
              >
                <option value="">Select membership type</option>
                <option>Corporate</option>
                <option>Ordinary</option>
                <option>Associate</option>
                <option>Cooperative</option>
              </select>
              <p v-if="errors.member_type" class="text-[#DC2626] text-sm mt-1">{{ errors.member_type }}</p>
            </div>
          </div>
        </div>

        <!-- Contact Persons Section -->
        <div class="mb-8 pb-8 border-b-2">
          <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">
            👥 Contact Persons
          </h2>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Owner/Director Name <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.owner_director_name"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Full name of owner/director"
                @blur="clearError('owner_director_name')"
              />
              <p v-if="errors.owner_director_name" class="text-[#DC2626] text-sm mt-1">{{ errors.owner_director_name }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Owner/Director Mobile <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.owner_director_phone"
                type="tel"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="+260 XXX XXX XXX"
                @blur="clearError('owner_director_phone')"
              />
              <p v-if="errors.owner_director_phone" class="text-[#DC2626] text-sm mt-1">{{ errors.owner_director_phone }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Alternative Contact Person Name
              </label>
              <input
                v-model="form.contact_person_name"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Alternative contact person"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Alternative Contact Person Mobile
              </label>
              <input
                v-model="form.contact_person_phone"
                type="tel"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="+260 XXX XXX XXX"
              />
            </div>
          </div>
        </div>

        <!-- Registration Numbers Section -->
        <div class="mb-8 pb-8 border-b-2">
          <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">
            📋 Registration Numbers
          </h2>
          <div class="bg-yellow-50 border border-yellow-200 rounded p-4 mb-6">
            <p class="text-yellow-800 text-sm">
              🔒 Confidential Information: All particulars given are treated confidential (only for internal LivCCI use)
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Business Registration Number
              </label>
              <input
                v-model="form.business_reg_number"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Enter business registration number"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                ZRA TPIN Number <span class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.tpin"
                type="text"
                maxlength="10"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Enter ZRA TPIN number"
                @blur="clearError('tpin')"
              />
              <p v-if="errors.tpin" class="text-[#DC2626] text-sm mt-1">{{ errors.tpin }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                PACRA Registration Number <span v-if="form.member_type !== 'Associate'" class="text-[#DC2626]">*</span>
              </label>
              <input
                v-model="form.pacra_reg_no"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Enter PACRA registration number"
                @blur="clearError('pacra_reg_no')"
              />
              <p v-if="errors.pacra_reg_no" class="text-[#DC2626] text-sm mt-1">{{ errors.pacra_reg_no }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                NAPSA Registration Number
              </label>
              <input
                v-model="form.napsa_reg_number"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Enter NAPSA registration number"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                WCFCB Number
              </label>
              <input
                v-model="form.wcfcb_number"
                type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                placeholder="Enter WCFCB number"
              />
            </div>
          </div>
        </div>

        <!-- Membership Category & Fees -->
        <div class="mb-8 pb-8 border-b-2">
          <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">
            💰 Membership Category & Fees
          </h2>

          <div class="bg-blue-50 border border-blue-200 rounded p-4 mb-6">
            <p class="text-blue-800 text-sm">
              Your membership category is automatically suggested based on employee count, but you can select a different category if needed.
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <label class="flex items-center p-4 border rounded cursor-pointer hover:bg-gray-50">
              <input v-model="form.member_category" type="radio" value="Category A: Up to 10 employees" class="mr-3" />
              <span>Category A: Up to 10 employees - <strong>K1,800</strong></span>
            </label>

            <label class="flex items-center p-4 border rounded cursor-pointer hover:bg-gray-50">
              <input v-model="form.member_category" type="radio" value="Category B: 11-30 Employees" class="mr-3" />
              <span>Category B: 11-30 Employees - <strong>K3,000</strong></span>
            </label>

            <label class="flex items-center p-4 border rounded cursor-pointer hover:bg-gray-50">
              <input v-model="form.member_category" type="radio" value="Category C: 31-50 Employees" class="mr-3" />
              <span>Category C: 31-50 Employees - <strong>K3,600</strong></span>
            </label>

            <label class="flex items-center p-4 border rounded cursor-pointer hover:bg-gray-50">
              <input v-model="form.member_category" type="radio" value="Category D: Above 50 Employees" class="mr-3" />
              <span>Category D: Above 50 Employees - <strong>K6,000</strong></span>
            </label>
          </div>

          <p v-if="errors.member_category" class="text-[#DC2626] text-sm mt-2">{{ errors.member_category }}</p>

          <div class="mt-6 bg-yellow-50 border border-yellow-200 rounded p-4">
            <p class="text-yellow-800 text-sm">
              <strong>Annual Membership Terms:</strong> I understand that applicants who join the Chamber within the current financial year will be fully invoiced within the first six months (Jan-June) for 12 months and new members after 1st July will be 50% invoiced.
            </p>
            <label class="flex items-center mt-2">
              <input v-model="form.terms_agreed" type="checkbox" class="mr-2" />
              <span class="text-sm">I agree to the annual membership terms</span>
            </label>
            <p v-if="errors.terms_agreed" class="text-[#DC2626] text-sm mt-1">{{ errors.terms_agreed }}</p>
          </div>
        </div>

        <!-- Required Documents Upload -->
        <div class="mb-8 pb-8 border-b-2">
          <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">
            📄 Required Documents Upload
          </h2>

          <div class="bg-yellow-50 border border-yellow-200 rounded p-4 mb-6">
            <p class="text-yellow-800 text-sm">
              <strong>Required Documents:</strong> Copies of all registration documents as follows: Certificate of Incorporation, ZRA Tax Clearance, NAPSA, Workers compensation Fund Control Board certificate (WCFCB) and a brief company Profile need to be attached to the application form.
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Certificate of Incorporation <span class="text-[#DC2626]">*</span>
              </label>
              <input
                type="file"
                accept="application/pdf,image/jpeg,image/png"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                @change="(e) => handleFileUpload(e, 'certificate_of_incorporation')"
              />
              <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG format</p>
              <p v-if="errors.certificate_of_incorporation" class="text-[#DC2626] text-sm mt-1">{{ errors.certificate_of_incorporation }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                TPIN Certificate <span class="text-[#DC2626]">*</span>
              </label>
              <input
                type="file"
                accept="application/pdf,image/jpeg,image/png"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                @change="(e) => handleFileUpload(e, 'tpin_certificate')"
              />
              <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG format</p>
              <p v-if="errors.tpin_certificate" class="text-[#DC2626] text-sm mt-1">{{ errors.tpin_certificate }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                ZRA Tax Clearance <span class="text-[#DC2626]">*</span>
              </label>
              <input
                type="file"
                accept="application/pdf,image/jpeg,image/png"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                @change="(e) => handleFileUpload(e, 'zra_tax_clearance')"
              />
              <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG format</p>
              <p v-if="errors.zra_tax_clearance" class="text-[#DC2626] text-sm mt-1">{{ errors.zra_tax_clearance }}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                NAPSA Certificate
              </label>
              <input
                type="file"
                accept="application/pdf,image/jpeg,image/png"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                @change="(e) => handleFileUpload(e, 'napsa_certificate')"
              />
              <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG format (Optional)</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                WCFCB Certificate
              </label>
              <input
                type="file"
                accept="application/pdf,image/jpeg,image/png"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                @change="(e) => handleFileUpload(e, 'wcfcb_certificate')"
              />
              <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG format (Optional)</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Company Profile <span class="text-[#DC2626]">*</span>
              </label>
              <input
                type="file"
                accept="application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg"
                @change="(e) => handleFileUpload(e, 'company_profile')"
              />
              <p class="text-gray-500 text-xs mt-1">PDF, DOC, or DOCX format</p>
              <p v-if="errors.company_profile" class="text-[#DC2626] text-sm mt-1">{{ errors.company_profile }}</p>
            </div>
          </div>
        </div>

        <!-- Declaration -->
        <div class="mb-8">
          <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">
            ✍️ Declaration
          </h2>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Full Name <span class="text-[#1876C3] font-bold">*</span>
            </label>
            <input
              type="text"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg bg-gray-100"
              :value="form.full_name"
              disabled
            />
          </div>

          <div class="mt-4">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Application Date
            </label>
            <input
              type="text"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg bg-gray-100"
              :value="today"
              disabled
            />
          </div>

          <div class="mt-6 bg-gray-50 border border-gray-300 rounded p-4">
            <label class="flex items-start">
              <input v-model="form.declaration_agreed" type="checkbox" class="mt-1 mr-3" />
              <span class="text-sm text-gray-700">
                <strong>Declaration:</strong> I certify that the particulars submitted in this application form are correct and accurate. I agree to abide by the Code of Conduct and the Constitution of the Chamber, its rules, and by-laws, as amended from time to time.
              </span>
            </label>
            <p v-if="errors.declaration_agreed" class="text-[#DC2626] text-sm mt-2">{{ errors.declaration_agreed }}</p>
          </div>
        </div>

        <!-- Submit Button -->
        <div class="flex justify-center">
          <button
            type="submit"
            :disabled="loading"
            class="bg-[#F4B223] hover:bg-[#E0A11B] disabled:bg-gray-400 text-[#1D2A68] font-bold py-3 px-8 rounded-lg flex items-center transition-colors shadow-lg"
          >
            <span v-if="!loading">🚀 Submit Application</span>
            <span v-else>Processing...</span>
          </button>
        </div>

        <p class="text-center text-gray-600 text-sm mt-4">
          By submitting this application, you agree to the LivCCI Code of Conduct and Constitution
        </p>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useForm } from '@inertiajs/vue3'

const today = new Date().toLocaleDateString('en-US', { 
  year: 'numeric', 
  month: '2-digit', 
  day: '2-digit' 
})

const loading = ref(false)
const errors = ref({})

const form = useForm({
  // Account fields
  full_name: '',
  email: '',
  password: '',
  password_confirmation: '',

  // Business Information
  company_name: '',
  contact_email: '',
  phone: '',
  address: '',
  website_url: '',
  short_description: '',
  industry_sector: '',
  number_of_employees: '',
  annual_turnover: '',
  member_type: '',
  member_category: '',
  
  // Contact Persons
  owner_director_name: '',
  owner_director_phone: '',
  contact_person_name: '',
  contact_person_phone: '',

  // Registration Numbers
  business_reg_number: '',
  tpin: '',
  pacra_reg_no: '',
  napsa_reg_number: '',
  wcfcb_number: '',

  // Files
  logo: null,
  proof_of_payment: null,
  certificate_of_incorporation: null,
  tpin_certificate: null,
  zra_tax_clearance: null,
  napsa_certificate: null,
  wcfcb_certificate: null,
  company_profile: null,

  // Declaration
  declaration_agreed: false,
  terms_agreed: false,

  // Social links
  social_links: {
    linkedin: '',
    facebook: '',
    x: '',
    instagram: '',
    whatsapp: ''
  }
})

const handleLogoUpload = (e) => {
  form.logo = e.target.files[0]
  clearError('logo')
}

const handleFileUpload = (e, fieldName) => {
  form[fieldName] = e.target.files[0]
  clearError(fieldName)
}

const clearError = (field) => {
  if (errors.value[field]) {
    delete errors.value[field]
  }
}

const submitForm = () => {
  loading.value = true
  form.post(route('application.store'), {
    onError: (err) => {
      errors.value = err
      loading.value = false
      window.scrollTo(0, 0)
    },
    onSuccess: () => {
      loading.value = false
    }
  })
}
</script>
