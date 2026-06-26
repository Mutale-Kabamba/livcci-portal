<template>
  <Head title="Add Business Profile" />
  <AuthenticatedLayout>
    <div class="min-h-screen bg-gradient-to-b from-[#f6eed8] to-gray-50 py-12 px-4">
      <div class="max-w-4xl mx-auto">

        <!-- Header -->
        <div class="bg-gradient-to-r from-[#1D2A68] to-[#1876C3] text-white rounded-t-lg p-8 shadow-lg">
          <div class="flex items-center justify-between mb-4">
            <Link :href="route('dashboard')" class="inline-flex items-center gap-1.5 text-sm font-semibold text-blue-200 hover:text-white transition">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M10 19l-7-7m0 0l7-7m-7 7h18" /></svg>
              Back to Dashboard
            </Link>
          </div>
          <div class="text-center">
            <h1 class="text-4xl font-bold mb-2">🏢 Add Business Profile</h1>
            <p class="text-lg text-blue-100">Register your business with the Livingstone Chamber of Commerce and Industry</p>
          </div>
        </div>

        <!-- Validation Errors -->
        <div v-if="Object.keys(form.errors).length > 0" class="mt-4 bg-red-50 border border-red-300 text-red-800 rounded-lg p-4 text-sm">
          <strong>Please fix the following errors:</strong>
          <ul class="mt-2 space-y-1 list-disc list-inside">
            <li v-for="(error, field) in form.errors" :key="field">{{ Array.isArray(error) ? error[0] : error }}</li>
          </ul>
        </div>

        <!-- Form -->
        <form @submit.prevent="submitForm" enctype="multipart/form-data" class="bg-white rounded-b-lg shadow-lg p-8 border-t-4 border-[#F4B223]">

          <!-- ── Business Information ── -->
          <div class="mb-8 pb-8 border-b-2">
            <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">🏢 Business Information</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Business Name <span class="text-[#DC2626]">*</span></label>
                <input v-model="form.company_name" type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#1876C3] focus:border-transparent" placeholder="Enter your business name" />
                <p v-if="form.errors.company_name" class="text-[#DC2626] text-sm mt-1">{{ form.errors.company_name }}</p>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Contact Email <span class="text-[#DC2626]">*</span></label>
                <input v-model="form.contact_email" type="email" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="company@example.com" />
                <p v-if="form.errors.contact_email" class="text-[#DC2626] text-sm mt-1">{{ form.errors.contact_email }}</p>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Street Address <span class="text-[#DC2626]">*</span></label>
                <input v-model="form.address" type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Enter complete business address" />
                <p v-if="form.errors.address" class="text-[#DC2626] text-sm mt-1">{{ form.errors.address }}</p>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Telephone Number <span class="text-[#DC2626]">*</span></label>
                <input v-model="form.phone" type="tel" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="+260 XXX XXX XXX" />
                <p v-if="form.errors.phone" class="text-[#DC2626] text-sm mt-1">{{ form.errors.phone }}</p>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Website URL</label>
                <input v-model="form.website_url" type="url" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="https://example.com" />
                <p v-if="form.errors.website_url" class="text-[#DC2626] text-sm mt-1">{{ form.errors.website_url }}</p>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Company Logo</label>
                <input type="file" accept="image/jpeg,image/jpg,image/png" class="w-full px-4 py-2 border border-gray-300 rounded-lg" @change="handleLogoUpload" />
                <p class="text-gray-500 text-xs mt-1">JPG or PNG (Max 2MB)</p>
                <p v-if="form.errors.logo" class="text-[#DC2626] text-sm mt-1">{{ form.errors.logo }}</p>
              </div>
            </div>

            <div class="mt-6">
              <label class="block text-sm font-medium text-gray-700 mb-2">Nature of Business <span class="text-[#DC2626]">*</span></label>
              <textarea v-model="form.short_description" rows="3" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Describe what your business does"></textarea>
              <p v-if="form.errors.short_description" class="text-[#DC2626] text-sm mt-1">{{ form.errors.short_description }}</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Business Sector <span class="text-[#DC2626]">*</span></label>
                <select v-model="form.industry_sector" class="w-full px-4 py-2 border border-gray-300 rounded-lg">
                  <option value="">Select your business sector</option>
                  <option>Tourism &amp; Hospitality</option>
                  <option>Trade &amp; Commerce</option>
                  <option>Financial Services</option>
                  <option>Construction &amp; Engineering</option>
                  <option>Agriculture &amp; Manufacturing</option>
                  <option>Cooperatives &amp; Social Enterprise</option>
                  <option>IT &amp; Creative Media</option>
                </select>
                <p v-if="form.errors.industry_sector" class="text-[#DC2626] text-sm mt-1">{{ form.errors.industry_sector }}</p>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Number of Employees <span class="text-[#DC2626]">*</span></label>
                <input v-model.number="form.number_of_employees" type="number" min="1" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Enter number of employees" />
                <p v-if="form.errors.number_of_employees" class="text-[#DC2626] text-sm mt-1">{{ form.errors.number_of_employees }}</p>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Annual Turnover (ZMW)</label>
                <input v-model.number="form.annual_turnover" type="number" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Enter annual turnover" />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Membership Type <span class="text-[#DC2626]">*</span></label>
                <select v-model="form.member_type" class="w-full px-4 py-2 border border-gray-300 rounded-lg">
                  <option value="">Select membership type</option>
                  <option>Corporate</option>
                  <option>Ordinary</option>
                  <option>Associate</option>
                  <option>Cooperative</option>
                </select>
                <p v-if="form.errors.member_type" class="text-[#DC2626] text-sm mt-1">{{ form.errors.member_type }}</p>
              </div>
            </div>

            <!-- Business Activities -->
            <div class="mt-6">
              <label class="block text-sm font-medium text-gray-700 mb-2">Business Activities <span class="text-[#DC2626]">*</span></label>
              <p class="text-gray-500 text-xs mb-3">Select up to 6 activities that best describe your business (select a sector first).</p>
              <div v-if="!form.industry_sector" class="border border-dashed border-gray-300 rounded-lg p-4 text-center text-gray-400 text-sm">
                Select a business sector above to see available activities.
              </div>
              <div v-else class="flex flex-wrap gap-2">
                <button v-for="activity in filteredActivities" :key="activity" type="button" @click="toggleActivity(activity)"
                  :class="['px-3 py-1.5 rounded-full text-sm font-medium border transition-colors',
                    form.selectedActivities.includes(activity) ? 'bg-[#1876C3] text-white border-[#1876C3]' : 'bg-white text-gray-700 border-gray-300 hover:border-[#1876C3]']">
                  {{ activity }}
                </button>
              </div>
              <p v-if="activitiesWarning" class="text-yellow-600 text-sm mt-2">{{ activitiesWarning }}</p>
              <p v-if="form.selectedActivities.length > 0" class="text-gray-500 text-xs mt-2">Selected ({{ form.selectedActivities.length }}/6): {{ form.selectedActivities.join(', ') }}</p>
              <p v-if="form.errors.business_activities" class="text-[#DC2626] text-sm mt-1">{{ form.errors.business_activities }}</p>
            </div>
          </div>

          <!-- ── Contact Persons ── -->
          <div class="mb-8 pb-8 border-b-2">
            <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">👥 Contact Persons</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Owner/Director Name <span class="text-[#DC2626]">*</span></label>
                <input v-model="form.owner_director_name" type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Full name of owner/director" />
                <p v-if="form.errors.owner_director_name" class="text-[#DC2626] text-sm mt-1">{{ form.errors.owner_director_name }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Owner/Director Mobile <span class="text-[#DC2626]">*</span></label>
                <input v-model="form.owner_director_phone" type="tel" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="+260 XXX XXX XXX" />
                <p v-if="form.errors.owner_director_phone" class="text-[#DC2626] text-sm mt-1">{{ form.errors.owner_director_phone }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Alternative Contact Person Name</label>
                <input v-model="form.contact_person_name" type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Alternative contact person" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Alternative Contact Person Mobile</label>
                <input v-model="form.contact_person_phone" type="tel" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="+260 XXX XXX XXX" />
              </div>
            </div>
          </div>

          <!-- ── Registration Numbers ── -->
          <div class="mb-8 pb-8 border-b-2">
            <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">📋 Registration Numbers</h2>
            <div class="bg-yellow-50 border border-yellow-200 rounded p-4 mb-6">
              <p class="text-yellow-800 text-sm">🔒 Confidential Information: All particulars given are treated confidential (only for internal LivCCI use)</p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Business Registration Number</label>
                <input v-model="form.business_reg_number" type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Enter business registration number" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">ZRA TPIN Number <span class="text-[#DC2626]">*</span></label>
                <input v-model="form.tpin" type="text" maxlength="10" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="10-digit TPIN" />
                <p v-if="form.errors.tpin" class="text-[#DC2626] text-sm mt-1">{{ form.errors.tpin }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  PACRA Registration Number <span v-if="form.member_type !== 'Associate'" class="text-[#DC2626]">*</span>
                </label>
                <input v-model="form.pacra_reg_no" type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Enter PACRA registration number" />
                <p v-if="form.errors.pacra_reg_no" class="text-[#DC2626] text-sm mt-1">{{ form.errors.pacra_reg_no }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">NAPSA Registration Number</label>
                <input v-model="form.napsa_reg_number" type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Enter NAPSA registration number" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">WCFCB Number</label>
                <input v-model="form.wcfcb_number" type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg" placeholder="Enter WCFCB number" />
              </div>
            </div>
          </div>

          <!-- ── Membership Category & Fees ── -->
          <div class="mb-8 pb-8 border-b-2">
            <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">💰 Membership Category &amp; Fees</h2>
            <div class="bg-blue-50 border border-blue-200 rounded p-4 mb-6">
              <p class="text-blue-800 text-sm">Your membership category is automatically suggested based on employee count, but you can select a different category if needed.</p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <label class="flex items-center p-4 border rounded cursor-pointer hover:bg-gray-50">
                <input v-model="form.member_category" type="radio" value="Category A: Up to 10 employees" class="mr-3" />
                <span>Category A: Up to 10 employees — <strong>K1,800</strong></span>
              </label>
              <label class="flex items-center p-4 border rounded cursor-pointer hover:bg-gray-50">
                <input v-model="form.member_category" type="radio" value="Category B: 11-30 Employees" class="mr-3" />
                <span>Category B: 11–30 Employees — <strong>K3,000</strong></span>
              </label>
              <label class="flex items-center p-4 border rounded cursor-pointer hover:bg-gray-50">
                <input v-model="form.member_category" type="radio" value="Category C: 31-50 Employees" class="mr-3" />
                <span>Category C: 31–50 Employees — <strong>K3,600</strong></span>
              </label>
              <label class="flex items-center p-4 border rounded cursor-pointer hover:bg-gray-50">
                <input v-model="form.member_category" type="radio" value="Category D: Above 50 Employees" class="mr-3" />
                <span>Category D: Above 50 Employees — <strong>K6,000</strong></span>
              </label>
            </div>
            <p v-if="form.errors.member_category" class="text-[#DC2626] text-sm mt-2">{{ form.errors.member_category }}</p>

            <div class="mt-6 bg-yellow-50 border border-yellow-200 rounded p-4">
              <p class="text-yellow-800 text-sm"><strong>Annual Membership Terms:</strong> I understand that applicants who join the Chamber within the current financial year will be fully invoiced within the first six months (Jan–June) for 12 months and new members after 1st July will be 50% invoiced.</p>
              <label class="flex items-center mt-2">
                <input v-model="form.terms_agreed" type="checkbox" class="mr-2" />
                <span class="text-sm">I agree to the annual membership terms</span>
              </label>
              <p v-if="form.errors.terms_agreed" class="text-[#DC2626] text-sm mt-1">{{ form.errors.terms_agreed }}</p>
            </div>
          </div>

          <!-- ── Document Uploads ── -->
          <div class="mb-8 pb-8 border-b-2">
            <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">📄 Required Documents Upload</h2>
            <div class="bg-yellow-50 border border-yellow-200 rounded p-4 mb-6">
              <p class="text-yellow-800 text-sm"><strong>Required Documents:</strong> Copies of: Certificate of Incorporation, ZRA Tax Clearance, NAPSA, WCFCB certificate, and a brief company profile.</p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Certificate of Incorporation</label>
                <input type="file" accept="application/pdf,image/jpeg,image/png" class="w-full px-4 py-2 border border-gray-300 rounded-lg" @change="(e) => handleFileUpload(e, 'certificate_of_incorporation')" />
                <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG</p>
                <p v-if="form.errors.certificate_of_incorporation" class="text-[#DC2626] text-sm mt-1">{{ form.errors.certificate_of_incorporation }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">TPIN Certificate</label>
                <input type="file" accept="application/pdf,image/jpeg,image/png" class="w-full px-4 py-2 border border-gray-300 rounded-lg" @change="(e) => handleFileUpload(e, 'tpin_certificate')" />
                <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG</p>
                <p v-if="form.errors.tpin_certificate" class="text-[#DC2626] text-sm mt-1">{{ form.errors.tpin_certificate }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">ZRA Tax Clearance</label>
                <input type="file" accept="application/pdf,image/jpeg,image/png" class="w-full px-4 py-2 border border-gray-300 rounded-lg" @change="(e) => handleFileUpload(e, 'zra_tax_clearance')" />
                <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG</p>
                <p v-if="form.errors.zra_tax_clearance" class="text-[#DC2626] text-sm mt-1">{{ form.errors.zra_tax_clearance }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">NAPSA Certificate</label>
                <input type="file" accept="application/pdf,image/jpeg,image/png" class="w-full px-4 py-2 border border-gray-300 rounded-lg" @change="(e) => handleFileUpload(e, 'napsa_certificate')" />
                <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG (Optional)</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">WCFCB Certificate</label>
                <input type="file" accept="application/pdf,image/jpeg,image/png" class="w-full px-4 py-2 border border-gray-300 rounded-lg" @change="(e) => handleFileUpload(e, 'wcfcb_certificate')" />
                <p class="text-gray-500 text-xs mt-1">PDF, JPG, or PNG (Optional)</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Company Profile</label>
                <input type="file" accept="application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document" class="w-full px-4 py-2 border border-gray-300 rounded-lg" @change="(e) => handleFileUpload(e, 'company_profile')" />
                <p class="text-gray-500 text-xs mt-1">PDF, DOC, or DOCX</p>
                <p v-if="form.errors.company_profile" class="text-[#DC2626] text-sm mt-1">{{ form.errors.company_profile }}</p>
              </div>
            </div>
          </div>

          <!-- ── Declaration ── -->
          <div class="mb-8">
            <h2 class="text-2xl font-bold text-[#1D2A68] mb-6 flex items-center">✍️ Declaration</h2>
            <div class="mt-4">
              <label class="block text-sm font-medium text-gray-700 mb-2">Application Date</label>
              <input type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg bg-gray-100" :value="today" disabled />
            </div>
            <div class="mt-6 bg-gray-50 border border-gray-300 rounded p-4">
              <label class="flex items-start">
                <input v-model="form.declaration_agreed" type="checkbox" class="mt-1 mr-3" />
                <span class="text-sm text-gray-700"><strong>Declaration:</strong> I certify that the particulars submitted in this application form are correct and accurate. I agree to abide by the Code of Conduct and the Constitution of the Chamber, its rules, and by-laws, as amended from time to time.</span>
              </label>
              <p v-if="form.errors.declaration_agreed" class="text-[#DC2626] text-sm mt-2">{{ form.errors.declaration_agreed }}</p>
            </div>
          </div>

          <!-- Submit -->
          <div class="flex justify-center">
            <button type="submit" :disabled="form.processing" class="bg-[#F4B223] hover:bg-[#E0A11B] disabled:bg-gray-400 text-[#1D2A68] font-bold py-3 px-8 rounded-lg flex items-center transition-colors shadow-lg">
              <span v-if="!form.processing">🚀 Submit Business Profile</span>
              <span v-else>Processing...</span>
            </button>
          </div>
          <p class="text-center text-gray-600 text-sm mt-4">By submitting, you agree to the LivCCI Code of Conduct and Constitution</p>
        </form>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { computed, ref, watch } from 'vue';
import { INDUSTRY_ACTIVITIES } from '@/constants/industryActivities';

const today = new Date().toLocaleDateString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit' });

const activitiesWarning = ref('');
const MAX_ACTIVITIES = 6;

const form = useForm({
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

  // Business Activities
  selectedActivities: [],
  business_activities: '',

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
  social_links: {},
});

// Activities
const filteredActivities = computed(() => INDUSTRY_ACTIVITIES[form.industry_sector] || []);

const toggleActivity = (activity) => {
  const current = [...form.selectedActivities];
  const exists = current.includes(activity);
  if (exists) { form.selectedActivities = current.filter(a => a !== activity); activitiesWarning.value = ''; return; }
  if (current.length >= MAX_ACTIVITIES) { activitiesWarning.value = 'You can select up to 6 activities only.'; return; }
  form.selectedActivities = [...current, activity];
  activitiesWarning.value = '';
};

watch(() => form.selectedActivities, (activities) => { form.business_activities = JSON.stringify(activities || []); }, { deep: true, immediate: true });
watch(() => form.industry_sector, () => { form.selectedActivities = []; activitiesWarning.value = ''; });

// Auto-suggest category
watch(() => form.number_of_employees, (count) => {
  const n = parseInt(count);
  if (!n || n < 1) return;
  if (n <= 10) form.member_category = 'Category A: Up to 10 employees';
  else if (n <= 30) form.member_category = 'Category B: 11-30 Employees';
  else if (n <= 50) form.member_category = 'Category C: 31-50 Employees';
  else form.member_category = 'Category D: Above 50 Employees';
});

const handleLogoUpload = (e) => { form.logo = e.target.files[0]; };
const handleFileUpload = (e, fieldName) => { form[fieldName] = e.target.files[0]; };

const submitForm = () => {
  form.post(route('profile.business.store'), {
    onError: () => window.scrollTo(0, 0),
    onSuccess: () => window.scrollTo(0, 0),
  });
};
</script>
