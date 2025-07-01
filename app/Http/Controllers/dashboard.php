<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class Dashboard extends Controller
{
    public function index()
    {
        return view('dashboard'); // this will show main content
    }

    public function youth()
    {
       return view('Department.Youth');

    }
    public function Admin(){
        return view('Admin.dashboard');
    }
}


