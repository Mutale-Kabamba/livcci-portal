<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\BusinessProfileController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\ReportController;
use App\Http\Middleware\IsAdminMiddleware; 
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
Route::get('/', [AdminController::class, 'showHome'])->name('home');

Route::get('/dashboard', function () {
    $businessProfiles = auth()->check()
        ? \App\Models\BusinessProfile::with(['payments' => fn ($q) => $q->latest('payment_date')->latest('id')])
            ->where('user_id', auth()->id())
            ->latest()
            ->get()
        : collect();

    $profileIds = $businessProfiles->pluck('id');

    $unpaidInvoices = \App\Models\Invoice::query()
        ->whereIn('profile_id', $profileIds)
        ->where('status', 'Unpaid')
        ->get(['id', 'profile_id', 'amount']);

    return Inertia::render('Dashboard', [
        'businessProfiles' => $businessProfiles,
        'totalOutstandingDues' => (float) $unpaidInvoices->sum('amount'),
        'unpaidProfileIds' => $unpaidInvoices->pluck('profile_id')->unique()->values(),
    ]);
})->middleware(['auth', 'verified'])->name('dashboard');

Route::post('/dashboard/pay-all', function () {
    $profiles = \App\Models\BusinessProfile::where('user_id', auth()->id())->get(['id']);
    $profileIds = $profiles->pluck('id');

    if ($profileIds->isEmpty()) {
        return back()->with('error', 'No businesses found for this account.');
    }

    $unpaidInvoices = \App\Models\Invoice::query()
        ->whereIn('profile_id', $profileIds)
        ->where('status', 'Unpaid')
        ->get();

    if ($unpaidInvoices->isEmpty()) {
        return back()->with('message', 'No outstanding dues to pay.');
    }

    \App\Models\Invoice::query()
        ->whereIn('id', $unpaidInvoices->pluck('id'))
        ->update(['status' => 'Paid']);

    \App\Models\BusinessProfile::query()
        ->whereIn('id', $unpaidInvoices->pluck('profile_id')->unique())
        ->update([
            'last_payment_date' => now()->toDateString(),
            'subscription_expiry' => now()->addYear()->toDateString(),
        ]);

    return back()->with('message', 'All outstanding dues have been marked as paid.');
})->middleware(['auth', 'verified'])->name('dashboard.pay-all');

Route::get('/about', [AdminController::class, 'showAbout'])->name('about');
Route::get('/sectors', [AdminController::class, 'showSectors'])->name('sectors');
Route::get('/leadership', [AdminController::class, 'showLeadership'])->name('leadership');
Route::get('/membership', [AdminController::class, 'showMembership'])->name('membership');
Route::get('/strategic-goals', [AdminController::class, 'showStrategicGoals'])->name('strategic-goals');
Route::get('/strategic-goals/{slug}', [AdminController::class, 'showStrategicGoalDetail'])->name('strategic-goals.detail');
Route::get('/news', [AdminController::class, 'showNews'])->name('news');
Route::get('/directory', [BusinessProfileController::class, 'index'])->name('directory.index');
Route::middleware([IsAdminMiddleware::class])->group(function () {
    Route::get('/admin', [AdminController::class, 'dashboard'])->name('admin.dashboard');
    Route::get('/admin/accounts', [AdminController::class, 'accounts'])->middleware('can:manage_accounts')->name('admin.accounts.index');
    Route::patch('/admin/accounts/{user}/role', [AdminController::class, 'updateAccountRole'])->middleware('can:manage_accounts')->name('admin.accounts.role');
    Route::delete('/admin/accounts/{user}', [AdminController::class, 'deleteAccount'])->middleware('can:manage_accounts')->name('admin.accounts.delete');
    
    // Member Management
    Route::patch('/admin/members/{profile}/status', [AdminController::class, 'updateMemberStatus'])->middleware('can:manage_members')->name('admin.members.status');
    Route::post('/admin/members/{profile}/payments', [AdminController::class, 'recordPayment'])->middleware('can:manage_finance')->name('admin.members.payments.store');
    Route::delete('/admin/members/{profile}', [AdminController::class, 'deleteMember'])->middleware('can:manage_members')->name('admin.members.delete');
    Route::get('/admin/members/{profile}/certificate', [AdminController::class, 'downloadCertificate'])->middleware('can:manage_members')->name('admin.members.certificate');

    // Invoices Management
    Route::post('/admin/invoices', [AdminController::class, 'store'])->middleware('can:manage_finance')->name('admin.invoices.store');
    Route::post('/admin/invoices/{profile}/generate', [AdminController::class, 'generateInvoice'])->middleware('can:manage_finance')->name('admin.invoices.generate');
    Route::patch('/admin/invoices/{invoice}/paid', [AdminController::class, 'markAsPaid'])->middleware('can:manage_finance')->name('admin.invoices.paid');

    // Strategic Plan Tracker
    Route::post('/admin/strategic-plan', [AdminController::class, 'saveStrategicPlan'])->middleware('can:manage_members')->name('admin.strategic-plan.save');
    
    // Events Management
    Route::post('/admin/events', [AdminController::class, 'storeEvent'])->middleware('can:manage_content')->name('admin.events.store');
    Route::match(['post', 'patch'], '/admin/events/{event}', [AdminController::class, 'updateEvent'])->middleware('can:manage_content')->name('admin.events.update');
    Route::delete('/admin/events/{event}', [AdminController::class, 'deleteEvent'])->middleware('can:manage_content')->name('admin.events.destroy');

    // Frontend Content Management
    Route::put('/admin/content', [AdminController::class, 'upsertSiteContent'])->middleware('can:manage_content')->name('admin.content.upsert');
    Route::delete('/admin/content/{content}', [AdminController::class, 'deleteSiteContent'])->middleware('can:manage_content')->name('admin.content.delete');

    // Reports Center
    Route::get('/admin/reports', [ReportController::class, 'index'])->middleware('can:view_reports')->name('admin.reports.index');
    Route::post('/admin/reports/generate', [ReportController::class, 'generate'])->middleware('can:view_reports')->name('admin.reports.generate');
});
Route::middleware('auth')->group(function () { 
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
    Route::get('/directory/join', [BusinessProfileController::class, 'create'])->name('profile.business.create');
    Route::post('/directory/join', [BusinessProfileController::class, 'store'])->name('profile.business.store');
    Route::get('/directory/edit', [BusinessProfileController::class, 'edit'])->name('profile.business.edit');
    Route::patch('/directory/edit', [BusinessProfileController::class, 'update'])->name('profile.business.update');
    Route::delete('/directory/{profile}', [BusinessProfileController::class, 'destroy'])->name('profile.business.destroy');
    Route::get('/dashboard/business/{profile}/invoice', [BusinessProfileController::class, 'downloadInvoice'])->name('profile.business.invoice.download');
    Route::get('/dashboard/business/receipt/{payment}', [BusinessProfileController::class, 'downloadReceipt'])->name('profile.business.receipt.download');
});

// Place this after the more specific /directory routes so that
// /directory/join and /directory/edit are not shadowed by it.
Route::get('/directory/{profile:slug}', [BusinessProfileController::class, 'show'])->name('directory.show');

require __DIR__.'/auth.php';