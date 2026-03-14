# LiVCCI Member Portal

LiVCCI Member Portal is a role-aware business membership platform for the Livingstone Chamber of Commerce and Industry. It supports member onboarding, directory visibility, invoicing, payment/receipt workflows, admin operations, reporting, and scheduled communications.

## System Overview

The platform has two main experiences:

1. Public portal (home, directory, static pages, news/events)
2. Authenticated portal (member dashboard + admin dashboard with role-based modules)

Key business flows:

1. User registration and email verification
2. Business profile submission and validation
3. Invoice issuance and payment capture
4. Financial activation threshold tracking (directory eligibility)
5. Automated communication (welcome, invoices, receipts, reminders, digest updates)

## Tech Stack

Backend:

1. Laravel 12
2. PHP 8.2+
3. MySQL
4. Inertia Laravel
5. DomPDF (`barryvdh/laravel-dompdf`)

Frontend:

1. Vue 3
2. Inertia Vue 3
3. Vite
4. Tailwind CSS
5. SweetAlert2 (styled confirmations/alerts)

## Architecture at a Glance

Core layers:

1. Controllers: Business logic and page data composition
2. Form Requests: Input validation and conditional rules
3. Models: Relationships, computed attributes, financial status, slug generation
4. Middleware: Inertia shared auth/permissions and admin guard behavior
5. Mailables: Transactional + scheduled email communication
6. Scheduler: Daily automation jobs

## Role and Access Model

Admin roles are stored on `users.role` with `users.is_admin` as admin eligibility.

Implemented role gates:

1. `manage_finance`
2. `manage_content`
3. `manage_members`
4. `view_reports`
5. `manage_accounts`

Roles currently mapped:

1. `super_admin` (full access)
2. `finance` / `finance_officer`
3. `media` / `media_officer` / `media_communication`
4. `secretariat`

Portal mode switching:

1. Admin-capable users choose mode at login (`admin` vs `ordinary`)
2. Admin routes require `portal_mode=admin`
3. Users can switch mode from the authenticated navigation menu

## Main Features

### 1. Authentication and Verification

1. Laravel Breeze auth scaffolding with Inertia
2. Email verification enforced for member dashboard routes
3. Password reset routes and mail flow enabled
4. Post-verification welcome email flow with optional invoice attachment

### 2. Business Profiles

1. Create/edit/destroy member business profiles
2. Clean profile slugs generated from company name
3. Public directory uses slug URLs
4. Industry sector-specific business activity tags
5. Financial activation based on minimum payment threshold

### 3. Financial Workflows

1. Invoice generation (admin + initial onboarding)
2. Payment recording with receipt PDF generation
3. Invoice settlement and membership financial updates
4. Automatic receipt/invoice emails

### 4. Admin Operations

1. Role-filtered dashboard modules
2. Member status management and certificate downloads
3. Events/news publishing
4. Leadership and site content updates
5. Reports center with permission checks

### 5. Automated Communication

Scheduled email automation includes:

1. Verification reminders
2. News & events digest updates
3. Renewal reminders (30 days before expiry)

Transactional emails include:

1. Welcome emails
2. Membership approval/eligibility notifications
3. Invoice issuance
4. Payment receipts

## Validation Rules (Important)

### Auth/Login

Password rule is strict:

1. Minimum 8 characters
2. Must include uppercase letter
3. Must include number
4. Must include symbol

Login UI includes show/hide password and a real-time requirement checklist.

### Business Profile

1. TPIN: exactly 10 digits
2. Phone: Zambian format (`+260`, `260`, or `09...` / `07...`)
3. PACRA: required unless membership type is Associate
4. Logo: `jpg/png/jpeg`, max 2MB
5. Proof of payment: `pdf/jpg/jpeg/png`, max 5MB
6. Business activities: 1-6 selections

## Deliverability and Email Compliance

System emails are configured to:

1. Use `LiVCCI Secretariat` as sender name
2. Send from configured mail address (`MAIL_FROM_ADDRESS`)
3. Include physical footer address line
4. Include notification management line
5. Include meaningful text content (not image-only emails)

## Routes Summary

Public routes:

1. Home page
2. About / Sectors / Leadership / Membership / Strategic Goals / News
3. Member directory and profile detail by slug

Authenticated member routes:

1. Dashboard and pay-all
2. Profile management
3. Business profile create/edit/delete
4. Invoice/receipt downloads

Admin routes (guarded by middleware + gates):

1. Admin dashboard
2. Accounts and role management
3. Member lifecycle actions
4. Invoices and payments
5. Content/events management
6. Reports

## Scheduler and Cron

Defined scheduled tasks:

1. Verification reminders: daily at 09:00
2. Renewal reminders: daily at 08:00
3. News digest: daily at 17:00

cPanel cron example:

```bash
/usr/local/bin/php /home/oristudio/public_html/artisan schedule:run >> /dev/null 2>&1
```

## Local Setup

### Prerequisites

1. PHP 8.2+
2. Composer
3. Node.js 18+
4. MySQL

### Installation

```bash
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
npm install
```

### Run Development

Option A (all services in one):

```bash
composer run dev
```

Option B (separate terminals):

```bash
php artisan serve
php artisan queue:listen --tries=1 --timeout=0
npm run dev
```

### Production Build

```bash
npm run build
php artisan optimize
```

## Required Environment Configuration

Example mail settings:

```env
MAIL_MAILER=smtp
MAIL_HOST=oristudiozm.com
MAIL_PORT=465
MAIL_USERNAME=livcci@oristudiozm.com
MAIL_PASSWORD="<your-password>"
MAIL_ENCRYPTION=ssl
MAIL_FROM_ADDRESS="livcci@oristudiozm.com"
MAIL_FROM_NAME="LiVCCI Secretariat"
```

Recommended after env changes:

```bash
php artisan optimize:clear
php artisan config:clear
```

## Queue, Cache, and Session Notes

Typical production values used by this project:

1. `QUEUE_CONNECTION=database`
2. `CACHE_STORE=database`
3. `SESSION_DRIVER=database`

If queue is database-backed, ensure a queue worker is running in production.

## Operational Commands

Useful maintenance commands:

```bash
php artisan route:list
php artisan schedule:list
php artisan optimize:clear
php artisan config:clear
php artisan cache:clear
```

## Testing and Quality

Run backend tests:

```bash
php artisan test
```

Run frontend build check:

```bash
npm run build
```

## Key Project Files

Core backend:

1. `app/Http/Controllers/AdminController.php`
2. `app/Http/Controllers/BusinessProfileController.php`
3. `app/Http/Middleware/IsAdminMiddleware.php`
4. `app/Http/Middleware/HandleInertiaRequests.php`
5. `app/Providers/AppServiceProvider.php`
6. `app/Services/NotificationAutomationService.php`

Routing and schedule:

1. `routes/web.php`
2. `routes/auth.php`
3. `routes/console.php`

Frontend:

1. `resources/js/Pages/Admin/Dashboard.vue`
2. `resources/js/Pages/Dashboard.vue`
3. `resources/js/Layouts/AuthenticatedLayout.vue`
4. `resources/js/Pages/Auth/Login.vue`

## Deployment Checklist (cPanel/VPS)

1. Configure `.env` (DB, APP_URL, MAIL, queue/session/cache)
2. Run migrations
3. Build frontend assets (`npm run build`)
4. Clear and warm caches
5. Ensure `storage` permissions and `php artisan storage:link`
6. Set up scheduler cron
7. Run queue worker (if queue is not `sync`)

## License

This project follows the Laravel MIT licensing model unless otherwise specified by your organization policy.
