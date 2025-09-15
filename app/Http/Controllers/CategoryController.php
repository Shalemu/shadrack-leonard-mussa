<?php

namespace App\Http\Controllers;
use App\Http\Resources\CategoryResources;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
public function index(Request $request)
{
    $categories = Category::all();

    return response()->json([
        'message' => 'Categories retrieved successfully',
        'data'    => CategoryResources::collection($categories),
    ], 200);
}


    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('category.create');
    }

    /**
     * Store a newly created resource in storage.
     */
   public function store(Request $request)
{
    $validator = Validator::make($request->all(), [
        'name'        => 'required|string|max:255',
        'description' => 'required|string',
        'image'       => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
    ]);

    if ($validator->fails()) {
        if ($request->expectsJson()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors'  => $validator->messages(),
            ], 422);
        }

        return redirect()->back()
            ->withErrors($validator)
            ->withInput();
    }

    // Handle image upload
    $imagePath = null;
    if ($request->hasFile('image')) {
        $imagePath = $request->file('image')->store('category', 'public');
    }

    $category = Category::create([
        'name'        => $request->name,
        'description' => $request->description,
        'image'       => $imagePath,
    ]);

    // If request is JSON → return API response
    if ($request->expectsJson()) {
        return response()->json([
            'message' => 'Category created successfully',
            'data'    => new CategoryResources($category),
        ], 201);
    }

    // Otherwise → redirect back in Blade
    return redirect()->route('categories.create')
        ->with('success', 'Category created successfully!');
}


    /**
     * Display the specified resource.
     */
    public function show(Category $category)
    {
        return view('category.show');
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Category $category)
    {
        return view('category.edit');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Category $category)
    {
        return view('category.update');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Category $category)
    {
       return view('category.delete');
    }
}
