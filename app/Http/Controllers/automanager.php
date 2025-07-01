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
        $request->session()->regenerate(); 
        $user = Auth::user(); 
        if($user->role === 'member'){
      
           return redirect()->route('dashboard');

        }
        else if
        ($user->role === 'leader'){
            return redirect()->route('Admin.dashboard');
        }
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

        public function profile()
    {
        $user = Auth::user();
        return view('profile', compact('user'));
    }
    
        public function updateProfile(Request $request)
    {
        $user = Auth::user();

        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:users,email,' . $user->id,
        ]);

        $user->name = $request->name;
        $user->email = $request->email;
        
        // Role is NOT editable
        // $user->save();

     return redirect()->route('dashboard')->with('success', 'Profile updated successfully!');
    }
      public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route('login');
    }
}
