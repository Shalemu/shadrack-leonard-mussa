<?php

namespace App\Http\Controllers\api;

use Illuminate\Routing\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Facades\JWTAuth;
use App\Http\Resources\UserResource;


class AuthController extends Controller
{
    // Register user
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => bcrypt($request->password),
        ]);

        return response()->json([
            'message' => 'User successfully registered',
            'user' => new UserResource($user)
        ], 201);
    }


    // Login user
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        if (!$token = JWTAuth::attempt($credentials)) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $user = JWTAuth::setToken($token)->toUser(); // get user from token

        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => JWTAuth::factory()->getTTL() * 60,
            'user' => new UserResource($user)
        ]);
    }

    // Get profile
    public function profile()
    {
        $user = JWTAuth::parseToken()->authenticate(); // parse token
        return response()->json([
            'user' => new UserResource($user)
        ]);
    }

    // Logout user
    public function logout()
    {
        JWTAuth::parseToken()->invalidate();
        return response()->json(['message' => 'User successfully logged out']);
    }
}
