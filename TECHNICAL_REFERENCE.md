# LivCCI Portal - Technical Reference Guide

## For Developers, IT Staff, and Technical Stakeholders

---

## System Architecture

### Technology Stack

```
Frontend:
  ├─ Vue.js 3         (Modern JavaScript UI framework)
  ├─ Inertia.js       (Seamless Vue + Laravel bridge)
  ├─ Tailwind CSS     (Styling framework)
  └─ JavaScript ES6+  (Dynamic interactions)

Backend:
  ├─ Laravel 12       (PHP web framework)
  ├─ PHP 8.2+         (Server-side language)
  ├─ Composer         (PHP package manager)
  └─ Eloquent ORM     (Database query builder)

Database:
  ├─ SQLite (Local)   (For development)
  └─ MySQL (Cloud)    (For production)

Additional Services:
  ├─ Mailable          (Email system)
  ├─ File Storage      (PDF, Images)
  ├─ Authentication    (Laravel Breeze)
  ├─ DOMPDF           (PDF generation)
  └─ Socialite        (Google OAuth)
```

### Project Structure

```
livcci-portal/
│
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── AdminController.php      (Main admin logic)
│   │   │   ├── BusinessProfileController.php
│   │   │   ├── ProfileController.php
│   │   │   └── ReportController.php
│   │   ├── Middleware/
│   │   │   └── IsAdminMiddleware.php    (Admin access check)
│   │   └── Requests/
│   │       └── (Form validation rules)
│   │
│   ├── Models/
│   │   ├── User.php                 (User accounts)
│   │   ├── BusinessProfile.php       (Company info)
│   │   ├── Invoice.php              (Invoices)
│   │   ├── BusinessPayment.php       (Payment records)
│   │   ├── ChamberEvent.php          (Events)
│   │   ├── SiteContent.php           (Website content)
│   │   └── Setting.php               (Configuration)
│   │
│   ├── Mail/
│   │   ├── WelcomeMember.php
│   │   ├── PaymentReceiptMail.php
│   │   ├── InvoiceIssuedMail.php
│   │   └── (other automated emails)
│   │
│   ├── Services/
│   │   ├── BusinessProfileFileService.php
│   │   ├── NotificationAutomationService.php
│   │   └── (business logic)
│   │
│   └── Events/
│       └── PaymentThresholdReached.php
│
├── routes/
│   ├── web.php       (Web routes - Main application)
│   ├── auth.php      (Authentication routes)
│   └── console.php   (Artisan commands)
│
├── resources/
│   ├── js/
│   │   ├── Pages/
│   │   │   ├── Welcome.vue           (Homepage)
│   │   │   ├── Dashboard.vue         (Member dashboard)
│   │   │   ├── Admin/
│   │   │   │   ├── Dashboard.vue     (Admin dashboard)
│   │   │   │   ├── Accounts.vue
│   │   │   │   └── ReportsCenter.vue
│   │   │   ├── Auth/                 (Login/Register)
│   │   │   ├── BusinessProfile/      (Directory)
│   │   │   ├── About.vue
│   │   │   ├── Sectors.vue
│   │   │   ├── News.vue
│   │   │   └── (other pages)
│   │   └── Layouts/
│   │       └── GuestLayout.vue
│   │
│   ├── views/
│   │   ├── emails/               (Email templates)
│   │   │   ├── welcome-member.blade.php
│   │   │   ├── payment-receipt.blade.php
│   │   │   └── (other emails)
│   │   └── pdfs/                 (PDF templates)
│   │       ├── invoice.blade.php
│   │       ├── certificate.blade.php
│   │       └── reports/
│   │
│   └── css/
│       └── app.css               (Global styles)
│
├── database/
│   ├── migrations/               (Database structure)
│   │   ├── create_users_table
│   │   ├── create_business_profiles_table
│   │   ├── create_invoices_table
│   │   ├── create_business_payments_table
│   │   ├── create_chamber_events_table
│   │   └── (other tables)
│   │
│   ├── factories/
│   │   ├── UserFactory.php       (Test data)
│   │   └── BusinessProfileFactory.php
│   │
│   └── seeders/
│       └── DatabaseSeeder.php    (Initial data)
│
├── storage/
│   └── app/
│       └── (Uploaded files, PDFs, images)
│
├── config/
│   ├── app.php                   (Application config)
│   ├── database.php              (Database config)
│   ├── mail.php                  (Email config)
│   ├── filesystems.php           (Storage config)
│   └── (other configs)
│
├── .env                          (Environment variables)
├── composer.json                 (PHP dependencies)
├── package.json                  (JavaScript dependencies)
├── vite.config.js               (Frontend build config)
└── tailwind.config.js           (Tailwind config)
```

---

## Database Schema

### User Roles & Permissions

```
Users Table
├── id (Primary Key)
├── name
├── email (Unique)
├── email_verified_at
├── password (Hashed)
├── role (Enum)
│   ├── admin
│   ├── member
│   └── staff
├── is_admin (Boolean)
├── permissions (JSON or separate table)
│   ├── manage_accounts
│   ├── manage_members
│   ├── manage_finance
│   ├── manage_content
│   └── view_reports
├── created_at
└── updated_at
```

### Business Profiles Table

```
BusinessProfiles Table
├── id (Primary Key)
├── user_id (Foreign Key → Users)
├── company_name
├── description
├── industry_sector
├── website
├── phone
├── email
├── location
├── logo_path
├── status (Enum)
│   ├── pending    (Awaiting approval)
│   ├── approved   (Active, in directory)
│   └── inactive   (Suspended/Deleted)
├── slug (URL-friendly name)
├── is_active (Boolean)
├── membership_tier
├── joined_date
├── subscription_expiry
├── last_payment_date
├── social_links (JSON)
│   ├── facebook
│   ├── linkedin
│   ├── twitter
│   └── instagram
├── financial_documents (JSON)
├── deleted_at (Soft delete)
├── created_at
└── updated_at
```

### Invoices Table

```
Invoices Table
├── id (Primary Key)
├── profile_id (Foreign Key → BusinessProfiles)
├── invoice_number (Unique)
├── amount
├── description
├── status (Enum)
│   ├── unpaid
│   ├── paid
│   └── cancelled
├── issue_date
├── due_date
├── paid_date (Nullable)
├── payment_reference (Nullable)
├── notes
├── created_at
└── updated_at
```

### Business Payments Table

```
BusinessPayments Table
├── id (Primary Key)
├── profile_id (Foreign Key → BusinessProfiles)
├── invoice_id (Foreign Key → Invoices)
├── amount
├── payment_date
├── payment_method (Enum)
│   ├── cash
│   ├── bank_transfer
│   ├── check
│   ├── online_payment
│   └── mobile_money
├── reference_number
├── receipt_path (PDF file path)
├── notes
├── created_at
└── updated_at
```

### Chamber Events Table

```
ChamberEvents Table
├── id (Primary Key)
├── title
├── description
├── event_date
├── event_time
├── location
├── image_path
├── external_link (Optional)
├── is_featured (Boolean)
├── status (Enum)
│   ├── scheduled
│   ├── completed
│   └── cancelled
├── created_at
└── updated_at
```

### Site Content Table

```
SiteContent Table
├── id (Primary Key)
├── key (Unique - identifier)
├── content (Text - HTML allowed)
├── section (Enum)
│   ├── homepage
│   ├── about
│   ├── membership
│   ├── footer
│   └── other
├── updated_by (Foreign Key → Users)
├── created_at
└── updated_at
```

### Settings Table

```
Settings Table
├── id (Primary Key)
├── key (Unique)
├── value
└── description
```

---

## Key Workflows (Technical)

### Workflow 1: Member Approval

```php
// AdminController.php - updateMemberStatus()

$profile = BusinessProfile::findOrFail($profileId);

// Validation
if ($profile->status === 'approved') {
    return back()->with('error', 'Already approved');
}

// Update Status
$profile->update(['status' => 'approved']);

// Send Email
Mail::to($profile->user->email)
    ->send(new WelcomeApprovedMember($profile->user, $profile));

// Update Directory
// (Profile automatically appears in /directory)

return back()->with('success', 'Member approved!');
```

### Workflow 2: Payment Recording

```php
// AdminController.php - recordPayment()

$profile = BusinessProfile::findOrFail($profileId);
$invoice = Invoice::findOrFail($invoiceId);

// Record Payment
$payment = BusinessPayment::create([
    'profile_id' => $profile->id,
    'invoice_id' => $invoice->id,
    'amount' => $request->amount,
    'payment_date' => $request->payment_date,
    'payment_method' => $request->method,
    'reference_number' => $request->reference,
]);

// Update Invoice Status
$invoice->update([
    'status' => 'paid',
    'paid_date' => $request->payment_date,
]);

// Extend Membership (Add 1 year)
$profile->update([
    'subscription_expiry' => now()->addYear()->toDateString(),
    'last_payment_date' => $request->payment_date,
]);

// Generate Receipt PDF
$pdf = PDF::loadView('pdfs.payment-receipt', [
    'invoice' => $invoice,
    'payment' => $payment,
]);
$payment->receipt_path = $pdf->save(storage_path('receipts/'));

// Send Confirmation Email
Mail::to($profile->user->email)
    ->send(new PaymentReceiptMail($profile, $payment));

return back()->with('success', 'Payment recorded!');
```

### Workflow 3: Invoice Generation

```php
// AdminController.php - generateInvoice()

$profile = BusinessProfile::findOrFail($profileId);

// Create Invoice
$invoice = Invoice::create([
    'profile_id' => $profile->id,
    'invoice_number' => 'INV-' . date('Ymd') . '-' . uniqid(),
    'amount' => 500, // Annual fee
    'description' => 'Annual Membership Fee',
    'status' => 'unpaid',
    'issue_date' => now()->toDateString(),
    'due_date' => now()->addDays(30)->toDateString(),
]);

// Generate PDF
$pdf = PDF::loadView('pdfs.invoice', ['invoice' => $invoice]);
$invoice->pdf_path = $pdf->save(storage_path('invoices/'));

// Send Email
Mail::to($profile->user->email)
    ->send(new InvoiceIssuedMail($invoice));

return back()->with('success', 'Invoice generated!');
```

---

## API Endpoints (Routes)

### Public Routes (No Login)
```
GET  /                              → Homepage
GET  /about                         → About page
GET  /sectors                       → Sectors page
GET  /leadership                    → Leadership page
GET  /membership                    → Membership info
GET  /strategic-goals               → Strategic goals
GET  /strategic-goals/{slug}        → Goal detail
GET  /news                          → News & events
GET  /directory                     → Business directory
GET  /directory/{slug}              → Business profile
GET  /login                         → Login page
GET  /register                      → Registration page
```

### Authenticated Member Routes
```
GET  /dashboard                     → Member dashboard
GET  /profile                       → Edit profile
PATCH /profile                      → Update profile
DELETE /profile                     → Delete account
GET  /directory/join                → Join directory
POST /directory/join                → Submit for approval
GET  /directory/edit                → Edit business
PATCH /directory/edit               → Update business
DELETE /directory/{id}              → Delete business
GET  /dashboard/business/{id}/invoice    → Download invoice
GET  /dashboard/business/receipt/{id}    → Download receipt
```

### Admin Routes (Admin Only)
```
GET  /admin                         → Admin dashboard
GET  /admin/accounts                → Manage accounts
PATCH /admin/accounts/{id}/role     → Change role
DELETE /admin/accounts/{id}         → Delete account
PATCH /admin/members/{id}/status    → Approve/Reject
POST /admin/members/{id}/payments   → Record payment
DELETE /admin/members/{id}          → Delete member
GET  /admin/members/{id}/certificate → Download certificate
POST /admin/invoices                → Create invoice
POST /admin/invoices/{id}/generate  → Generate invoice
PATCH /admin/invoices/{id}/paid     → Mark as paid
POST /admin/events                  → Create event
PATCH /admin/events/{id}            → Update event
DELETE /admin/events/{id}           → Delete event
PUT  /admin/content                 → Update website content
DELETE /admin/content/{id}          → Delete content
GET  /admin/reports                 → Reports page
POST /admin/reports/generate        → Generate report
```

---

## Middleware & Authentication

### Middleware Stack

```php
// IsAdminMiddleware
→ Check if user is admin
→ If not admin, return 403 Forbidden
→ If admin, check specific permission
  ├─ manage_accounts
  ├─ manage_members
  ├─ manage_finance
  ├─ manage_content
  └─ view_reports
```

### Authentication Flow

```
1. User submits login form
   ├─ Email
   └─ Password

2. Laravel checks database
   ├─ Email exists?
   ├─ Password matches hash?
   └─ Email verified?

3. If valid:
   ├─ Create session
   ├─ Set auth cookie
   └─ Redirect to dashboard

4. If invalid:
   └─ Return error message

5. On subsequent requests:
   ├─ Check auth cookie
   ├─ Verify session
   └─ Load user data
```

---

## Email System

### Automated Emails

```
Mail Classes (app/Mail/):
├── WelcomeMember.php
│   └─ Sent when: New account created
│   └─ Contains: Welcome message, next steps
│
├── WelcomeApprovedMember.php
│   └─ Sent when: Member approved
│   └─ Contains: Approval confirmation, benefits
│
├── InvoiceIssuedMail.php
│   └─ Sent when: Invoice created
│   └─ Contains: Invoice details, payment instructions
│
├── PaymentReceiptMail.php
│   └─ Sent when: Payment recorded
│   └─ Contains: Receipt, new expiry date
│
├── RenewalReminderMail.php
│   └─ Sent when: Membership expiring soon
│   └─ Contains: Expiry date, renewal instructions
│
├── MemberDirectoryEligibilityMail.php
│   └─ Sent when: Member eligible for directory
│   └─ Contains: Directory eligibility info
│
└── NewsUpdateDigestMail.php
    └─ Sent when: News updates published
    └─ Contains: Latest news & events
```

### Email Templates

```
resources/views/emails/
├── welcome-member.blade.php           → HTML email template
├── welcome-approved-member.blade.php
├── invoice-issued.blade.php
├── payment-receipt.blade.php
├── renewal-reminder.blade.php
├── member-directory-eligibility.blade.php
└── news-update-digest.blade.php
```

---

## File Storage

### Upload Directories

```
storage/app/
├── business-logos/               (Company logos)
├── business-documents/           (Financial docs)
├── invoices/                     (Invoice PDFs)
├── receipts/                     (Receipt PDFs)
├── certificates/                 (Membership certificates)
└── reports/                      (Generated reports)
```

---

## Development Setup

### Installation Steps

```bash
# 1. Clone repository
git clone https://github.com/Mutale-Kabamba/livcci-portal.git
cd livcci-portal

# 2. Install PHP dependencies
composer install

# 3. Install JavaScript dependencies
npm install

# 4. Create .env file
cp .env.example .env

# 5. Generate app key
php artisan key:generate

# 6. Create database
php artisan migrate

# 7. Seed sample data (optional)
php artisan db:seed

# 8. Run development servers
# Terminal 1:
npm run dev

# Terminal 2:
php artisan serve

# Access at http://127.0.0.1:8000
```

### Environment Variables (.env)

```env
APP_NAME=LivCCI
APP_ENV=local
APP_DEBUG=true
APP_KEY=base64:xxxxx
APP_URL=http://localhost:8000

DB_CONNECTION=sqlite
DB_DATABASE=database/database.sqlite

MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_FROM_ADDRESS=info@livcci.com
MAIL_FROM_NAME="LivCCI"
```

---

## Deployment (Laravel Cloud)

### Deployment Checklist

```
✓ Update .env with production values
✓ Run migrations: php artisan migrate --force
✓ Cache config: php artisan config:cache
✓ Cache views: php artisan view:cache
✓ Build assets: npm run build
✓ Set permissions: chmod -R 775 storage
✓ Restart queue: php artisan queue:restart
✓ Health check: Visit /health endpoint
```

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| 500 error | Syntax error in PHP | Check logs: `storage/logs/laravel.log` |
| Email not sent | Mail config wrong | Check `config/mail.php` |
| Files not uploading | Storage permissions | `chmod -R 775 storage/` |
| Database error | Migration not run | `php artisan migrate` |
| Assets not loading | Frontend not built | `npm run dev` or `npm run build` |
| Login not working | Cache issue | `php artisan cache:clear` |

---

## Testing

### Running Tests

```bash
# Run all tests
php artisan test

# Run specific test file
php artisan test tests/Feature/AdminTest.php

# Run with coverage
php artisan test --coverage
```

---

## Performance Optimization

### Implemented Optimizations

- ✓ Database query eager loading (N+1 prevention)
- ✓ View caching for admin dashboards
- ✓ Asset minification (CSS/JavaScript)
- ✓ Database indexing on common queries
- ✓ Pagination for large lists

### Recommendations

- Add Redis cache layer for sessions
- Implement CDN for static assets
- Use database replication for high traffic
- Add rate limiting for API endpoints
- Monitor with tools like New Relic

---

## Security Measures

```
Implemented:
├─ CSRF token protection on forms
├─ SQL injection prevention (Eloquent ORM)
├─ XSS prevention (Vue template escaping)
├─ Password hashing (bcrypt)
├─ Role-based access control
├─ Email verification on signup
├─ Soft deletes for data preservation
└─ Audit logging of admin actions

Recommendations:
├─ Enable two-factor authentication
├─ Use HTTPS/SSL certificate
├─ Regular security audits
├─ Keep dependencies updated
└─ Monitor access logs
```

---

## Support & Documentation

- **Laravel Docs**: https://laravel.com/docs
- **Vue.js Docs**: https://vuejs.org
- **Inertia.js Docs**: https://inertiajs.com
- **Tailwind CSS Docs**: https://tailwindcss.com

