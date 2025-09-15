<?php


use App\Http\Controllers\api\AuthController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;




Route::apiResource('product',ProductController::class);
Route::apiResource('category',CategoryController::class);
Route::get('/user', function (Request $request) {
    return $request->user();

})->middleware('auth:sanctum');

Route::group(['middleware'=>'api', 'prefix'=>'auth'], function($router){
 Route::post('/register', [AuthController::class, 'register']);
 Route::post('/login', [AuthController::class, 'login']);
 Route::post('/profile', [AuthController::class, 'profile']);
 Route::post('/logout', [AuthController::class, 'logout']);

});
