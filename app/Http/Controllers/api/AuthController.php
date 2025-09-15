<?php

namespace App\Http\Controllers\api;
use Illuminate\Routing\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Facades\JWTAuth;
use App\Http\Resources\UserResource;

class AuthController extends Controller
{
   public function __construct() {
     $this->middleware('auth:api', ['except' => ['login', 'register']]); 
    }

    // Register new user
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'required|string|max:255',
            'email'    => 'required|email|string|unique:users',
            'password' => 'required|string|min:6|confirmed'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $user = User::create(array_merge(
            $validator->validated(),
            ['password' => bcrypt($request->password)]
        ));

        return response()->json([
            'message' => 'User successfully registered',
            'user'    => new UserResource($user)
        ], 201);
    }

    // Login existing user
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'    => 'required|email',
            'password' => 'required|string|min:6'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        if (!$token = JWTAuth::attempt($validator->validated())) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        // $user = auth('api')->user();
        $user = JWTAuth::setToken($token)->toUser();

        return response()->json([
            'message'      => 'User successfully logged in',
            'access_token' => $token,
            'token_type'   => 'bearer',
            'expires_in'   => JWTAuth::factory()->getTTL() * 60,
            'user'         => new UserResource($user)
        ], 200);
    }

    // Get profile of authenticated user
    public function profile()
    {
        return response()->json([
            'user' => new UserResource(auth('api')->user())
        ]);
    }

    // Logout user
    public function logout()
    {
        JWTAuth::parseToken()->invalidate();

        return response()->json(['message' => 'User successfully logged out']);
    }
}
