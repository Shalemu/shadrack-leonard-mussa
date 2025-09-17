<?php

namespace App\Http\Middleware;

use Closure;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;

class JwtMiddleware
{
    public function handle($request, Closure $next)
    {
        try {
            // Attempt to parse token and authenticate
            $user = JWTAuth::parseToken()->authenticate();
        } catch (TokenExpiredException $e) {
            return response()->json([
                'detail' => 'Given token not valid for any token type',
                'code' => 'token_not_valid',
                'messages' => [
                    [
                        'token_class' => 'AccessToken',
                        'token_type' => 'access',
                        'message' => 'Token is expired'
                    ]
                ]
            ], 401);
        } catch (TokenInvalidException $e) {
            return response()->json([
                'detail' => 'Given token not valid for any token type',
                'code' => 'token_not_valid',
                'messages' => [
                    [
                        'token_class' => 'AccessToken',
                        'token_type' => 'access',
                        'message' => 'Token is invalid'
                    ]
                ]
            ], 401);
        } catch (JWTException $e) {
            return response()->json([
                'detail' => 'Given token not valid for any token type',
                'code' => 'token_not_valid',
                'messages' => [
                    [
                        'token_class' => 'AccessToken',
                        'token_type' => 'access',
                        'message' => 'Token not provided'
                    ]
                ]
            ], 401);
        }

        return $next($request);
    }
}
