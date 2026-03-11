<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\BusinessProfileController;
use App\Http\Controllers\AdminController;
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

Route::get('/about', function () { return \Inertia\Inertia::render('About'); })->name('about');
Route::get('/sectors', function () { return \Inertia\Inertia::render('Sectors'); })->name('sectors');
Route::get('/leadership', function () { return \Inertia\Inertia::render('Leadership'); })->name('leadership');
Route::get('/membership', function () { return \Inertia\Inertia::render('Membership'); })->name('membership');
Route::get('/strategic-goals', function () { return \Inertia\Inertia::render('StrategicGoals'); })->name('strategic-goals');
Route::get('/news', [AdminController::class, 'showNews'])->name('news');
Route::get('/directory', [BusinessProfileController::class, 'index'])->name('directory.index');
Route::middleware([IsAdminMiddleware::class])->group(function () {
    Route::get('/admin', [AdminController::class, 'dashboard'])->name('admin.dashboard');
    
    // Member Management
    Route::patch('/admin/members/{profile}/status', [AdminController::class, 'updateMemberStatus'])->name('admin.members.status');
    Route::delete('/admin/members/{profile}', [AdminController::class, 'deleteMember'])->name('admin.members.delete');
    
    // Events Management
    Route::post('/admin/events', [AdminController::class, 'storeEvent'])->name('admin.events.store');
    Route::match(['post', 'patch'], '/admin/events/{event}', [AdminController::class, 'updateEvent'])->name('admin.events.update');
    Route::delete('/admin/events/{event}', [AdminController::class, 'deleteEvent'])->name('admin.events.destroy');
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