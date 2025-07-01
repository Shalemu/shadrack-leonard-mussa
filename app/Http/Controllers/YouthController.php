<?php

namespace App\Http\Controllers;
use App\Models\Youth; 

use Illuminate\Http\Request;

class YouthController extends Controller
{
 public function store(Request $request)
{
    // Validate and save the form data
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'street' => 'required|string|max:255',
        'gender' => 'required|string',
        'marital_status' => 'required|string',
        'email' => 'nullable|email',
        'phone' => 'required|string|max:15',
        'dob' => 'required|date',
    ]);

    // Save to DB (assuming you have a Youth model)
    Youth::create($validated);

    return redirect()->back()->with('success', 'Youth registered successfully!');
}

public function member()
{
    $records = Youth::all(); // get all youth records
    $maleCount = Youth::where('gender', 'Male')->count();
    $femaleCount = Youth::where('gender', 'Female')->count();
    $marriedCount = Youth::where('marital_status', 'Married')->count();
    $unmarriedCount = Youth::where('marital_status', 'Single')->count();

    return view('Department.Youth', compact(
        'records',
         'maleCount',
          'femaleCount',
           'marriedCount',
            'unmarriedCount'
        ));
}



}
