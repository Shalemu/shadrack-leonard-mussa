<?php

namespace App\Http\Controllers;
use App\Models\Childrens; 
use Carbon\Carbon;
use Barryvdh\DomPDF\Facade\Pdf;
use Spatie\SimpleExcel\SimpleExcelWriter;


use Illuminate\Http\Request;

class EKController extends Controller
{

     public function store(Request $request)
{
    // Validate and save the form data
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'dob' => 'required|date',
        'gender' => 'required|string',
        'class_level' => 'required|string',
        'street' => 'required|string|max:255',
        'phone' => 'required|string|max:15',
        'guardian_name' => 'required|string|max:255',
        'school' => 'string|max:255',
        'baptized' => 'required|string'
    ]);
   

    // Save to DB (assuming you have a Youth model)
    Childrens::create($validated);

    return redirect()->back()->with('success', 'Children registered successfully!');
}


public function children()
{
    $today = Carbon::today();

    // Fetch all children
    $records = Childrens::all();

    // Report Data
    $age_0_10 = Childrens::whereDate('dob', '>=', $today->copy()->subYears(10))->count();

    $age_11_18 = Childrens::whereBetween('dob', [
        $today->copy()->subYears(18),
        $today->copy()->subYears(11)
    ])->count();

    $maleCount = Childrens::where('gender', 'Male')->count();
    $femaleCount = Childrens::where('gender', 'Female')->count();

    $primaryCount = Childrens::whereIn('class_level', [
        'Darasa la 1', 'Darasa la 2', 'Darasa la 3', 'Darasa la 4',
        'Darasa la 5', 'Darasa la 6', 'Darasa la 7'
    ])->count();

    $secondaryCount = Childrens::whereIn('class_level', [
        'Form 1', 'Form 2', 'Form 3', 'Form 4'
    ])->count();

    $baptizedCount = Childrens::where('baptized', 'Yes')->count();
    $notBaptizedCount = Childrens::where('baptized', 'No')->count();

    return view('member.ek.children', compact(
        'records',
        'age_0_10',
        'age_11_18',
        'maleCount',
        'femaleCount',
        'primaryCount',
        'secondaryCount',
        'baptizedCount',
        'notBaptizedCount'
    ));
}
public function edit($id)
{
    $child = Childrens::findOrFail($id);
    return view('member.ek.update', compact('child'));
}


public function updateChildren(Request $request)
{
    $request->validate([
        'id' => 'required|exists:childrens,id',
        'name' => 'required|string|max:255',
        'dob' => 'required|date',
        'gender' => 'required|string',
        'class_level' => 'required|string',
        'street' => 'required|string|max:255',
        'phone' => 'required|string|max:15',
        'guardian_name' => 'required|string|max:255',
        'school' => 'nullable|string|max:255',
        'baptized' => 'required|string',
    ]);

    $child = Childrens::findOrFail($request->id);
    $child->update($request->except('_token', 'id'));

     return redirect()->route('department.children')->with('success', 'Child updated successfully!');

    
}




public function exportExcel()
{
    $children = Childrens::all();

    $writer = SimpleExcelWriter::streamDownload('children.xlsx');

    foreach ($children as $child) {
        $writer->addRow([
            'Name' => $child->name,
            'DOB' => $child->dob,
            'Gender' => $child->gender,
            'Class Level' => $child->class_level,
            'Street' => $child->street,
            'Phone' => $child->phone,
            'Guardian' => $child->guardian_name,
            'School' => $child->school,
            'Baptized' => $child->baptized,
        ]);
    }

    return $writer->toBrowser();
}



public function downloadPdf()
{
    $records = \App\Models\Childrens::all();

    $pdf = Pdf::loadView('exports.children-pdf', compact('records'));
    return $pdf->download('children-report.pdf');
}



public function destroy($id)
{
    $child = Childrens::findOrFail($id);
    $child->delete();

  return redirect()->route('department.children')->with('success', 'Child record deleted successfully!');

}

}
