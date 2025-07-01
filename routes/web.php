<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AutoManager;
use App\Http\Controllers\dashboard;
use App\Http\Controllers\YouthController;
use App\Http\Controllers\EKController;
use App\Http\Controllers\sundayController;

// Default route
Route::get('/', function () {
    return view('login');
})->name('login');

Route::get('/login', [AutoManager::class, 'login'])->name('login');
Route::post('/login', [AutoManager::class, 'loginPost'])->name('login.post');
Route::get('/registration', [AutoManager::class, 'registration'])->name('registration');
Route::post('/registration', [AutoManager::class, 'registrationPost'])->name('registration.post');

// Dashboard
Route::get('/dashboard', [Dashboard::class, 'index'])->name('dashboard');
Route::get('/Admin', [Dashboard::class, 'Admin'])->name('Admin.dashboard');

// Youth
Route::get('/dashboard/youth', [YouthController::class, 'member'])->name('department.youth');
Route::get('/member/ek', [EKController::class, 'children'])->name('department.children');
Route::post('/youth/store', [YouthController::class, 'store'])->name('youth.store');
Route::post('/children/store', [EKController::class, 'store'])->name('children.store');


Route::get('/children/{id}/edit', [EKController::class, 'edit'])->name('children.edit');
Route::delete('/children/{id}', [EKController::class, 'destroy'])->name('children.destroy');

Route::get('/profile', [AutoManager::class, 'profile'])->name('profile');

Route::post('/logout', [AutoManager::class, 'logout'])->name('logout');
Route::post('/profile/update', [AutoManager::class, 'updateProfile'])->name('profile.update');
Route::get('/children/{id}/edit', [EKController::class, 'edit'])->name('children.edit');
Route::post('/children/update', [EKController::class, 'updateChildren'])->name('update_children');






Route::get('/children/download-pdf', [EKController::class, 'downloadPdf'])->name('children.download.pdf');
Route::get('/children/export-excel', [EKController::class, 'exportExcel'])->name('children.export.excel');
//sunday
Route::get('/sunday', [sundayController::class, 'sunday'])->name('sunday');








