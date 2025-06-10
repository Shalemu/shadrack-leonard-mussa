<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;  // uppercase U
use Illuminate\Support\Facades\Auth;  // uppercase I
use Illuminate\Support\Facades\Hash;  // uppercase I

class AutoManager extends Controller
{
    public function login()
    {
        return view('login');
    }

    public function registration()
    {
        return view('registration');
    }

    public function loginPost(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials)) {
            return redirect()->intended(route('dashboard'));
        }

        return redirect(route('login'))->with('error', 'Login failed');
    }

    public function registrationPost(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users',
            'password' => 'required'
        ]);

        $data = [
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ];

        $user = User::create($data);

        if (!$user) {
            return redirect(route('registration'))->with('error', 'Registration failed');
        }

        return redirect(route('login'))->with('success', 'Successfully registered');
    }
}
