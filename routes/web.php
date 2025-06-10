<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AutoManager;
use App\Http\Controllers\dashboard;
use App\Http\Controllers\YouthController;

// Default route
Route::get('/', function () {
    return view('welcome');
})->name('home');

// Login & Registration
Route::get('/login', [AutoManager::class, 'login'])->name('login');
Route::post('/login', [AutoManager::class, 'loginPost'])->name('login.post');

Route::get('/registration', [AutoManager::class, 'registration'])->name('registration');
Route::post('/registration', [AutoManager::class, 'registrationPost'])->name('registration.post');

// Dashboard route with optional section query

Route::get('/dashboard', [dashboard::class, 'index'])->name('dashboard');
Route::get('/dashboard/youth', [dashboard::class, 'youth'])->name('dashboard.youth');

Route::post('/youth/store', [YouthController::class, 'store'])->name('youth.store');


