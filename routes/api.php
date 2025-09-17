<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\api\AuthController;
use App\Http\Controllers\api\ProductController;
use App\Http\Controllers\api\CategoryController;

// ------------------------
// Public routes (no login required)
// ------------------------
Route::post('auth/register', [AuthController::class, 'register']);
Route::post('auth/login', [AuthController::class, 'login']);

// Anyone can view products and categories
Route::get('product', [ProductController::class, 'index']);
Route::put('product/{product}', [ProductController::class, 'update']);
Route::delete('product/{product}', [ProductController::class, 'destroy']);
Route::get('product/{product}', [ProductController::class, 'show']);

Route::get('category', [CategoryController::class, 'index']);
Route::put('category', [CategoryController::class, 'update']);
Route::delete('category/{category}', [CategoryController::class, 'destroy']);
Route::get('category/{category}', [CategoryController::class, 'show']);
// Get all products of a specific category 
Route::get('category/{category}/products', [CategoryController::class, 'products']);



// ------------------------
// Protected routes (JWT required)
// ------------------------
Route::middleware([\App\Http\Middleware\JwtMiddleware::class])->group(function () {
    
    // Auth routes
    Route::post('auth/profile', [AuthController::class, 'profile']);
    Route::post('auth/logout', [AuthController::class, 'logout']);

    // Products (admin actions)
    Route::post('product', [ProductController::class, 'store']);
    Route::put('product/{product}', [ProductController::class, 'update']);
    Route::delete('product/{product}', [ProductController::class, 'destroy']);

    // Categories (admin actions)
    Route::post('category', [CategoryController::class, 'store']);
    Route::put('category/{category}', [CategoryController::class, 'update']);
    Route::delete('category/{category}', [CategoryController::class, 'destroy']);
});
