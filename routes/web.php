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
    return Inertia::render('Dashboard', [
        // This line fetches the profile linked to the logged-in user
        'businessProfile' => auth()->user()?->businessProfile 
    ]);
})->middleware(['auth', 'verified'])->name('dashboard');

Route::get('/about', [AdminController::class, 'showAbout'])->name('about');
Route::get('/sectors', [AdminController::class, 'showSectors'])->name('sectors');
Route::get('/leadership', [AdminController::class, 'showLeadership'])->name('leadership');
Route::get('/membership', [AdminController::class, 'showMembership'])->name('membership');
Route::get('/strategic-goals', [AdminController::class, 'showStrategicGoals'])->name('strategic-goals');
Route::get('/news', [AdminController::class, 'showNews'])->name('news');
Route::get('/directory', [BusinessProfileController::class, 'index'])->name('directory.index');
Route::middleware([IsAdminMiddleware::class])->group(function () {
    Route::get('/admin', [AdminController::class, 'dashboard'])->name('admin.dashboard');
    Route::get('/admin/accounts', [AdminController::class, 'accounts'])->name('admin.accounts.index');
    Route::patch('/admin/accounts/{user}/role', [AdminController::class, 'updateAccountRole'])->name('admin.accounts.role');
    Route::delete('/admin/accounts/{user}', [AdminController::class, 'deleteAccount'])->name('admin.accounts.delete');
    
    // Member Management
    Route::patch('/admin/members/{profile}/status', [AdminController::class, 'updateMemberStatus'])->name('admin.members.status');
    Route::delete('/admin/members/{profile}', [AdminController::class, 'deleteMember'])->name('admin.members.delete');
    Route::get('/admin/members/{profile}/certificate', [AdminController::class, 'downloadCertificate'])->name('admin.members.certificate');

    // Invoices Management
    Route::post('/admin/invoices', [AdminController::class, 'store'])->name('admin.invoices.store');
    Route::post('/admin/invoices/{profile}/generate', [AdminController::class, 'generateInvoice'])->name('admin.invoices.generate');
    Route::patch('/admin/invoices/{invoice}/paid', [AdminController::class, 'markAsPaid'])->name('admin.invoices.paid');

    // Strategic Plan Tracker
    Route::post('/admin/strategic-plan', [AdminController::class, 'saveStrategicPlan'])->name('admin.strategic-plan.save');
    
    // Events Management
    Route::post('/admin/events', [AdminController::class, 'storeEvent'])->name('admin.events.store');
    Route::match(['post', 'patch'], '/admin/events/{event}', [AdminController::class, 'updateEvent'])->name('admin.events.update');
    Route::delete('/admin/events/{event}', [AdminController::class, 'deleteEvent'])->name('admin.events.destroy');

    // Frontend Content Management
    Route::put('/admin/content', [AdminController::class, 'upsertSiteContent'])->name('admin.content.upsert');
    Route::delete('/admin/content/{content}', [AdminController::class, 'deleteSiteContent'])->name('admin.content.delete');

    // Reports Center
    Route::get('/admin/reports', [ReportController::class, 'index'])->name('admin.reports.index');
    Route::post('/admin/reports/generate', [ReportController::class, 'generate'])->name('admin.reports.generate');
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
});

// Place this after the more specific /directory routes so that
// /directory/join and /directory/edit are not shadowed by it.
Route::get('/directory/{profile}', [BusinessProfileController::class, 'show'])->name('directory.show');

require __DIR__.'/auth.php';