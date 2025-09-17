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
    $categories = Category::paginate(6); 
    return view('categories.index', compact('categories'));

}


    /**
     * Show the form for creating a new category
     */
    public function create()
    {
        return view('categories.create');
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
        return view('categories.show', compact('category'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Category $category)
    {
        return view('categories.edit', compact('category'));
    }

    /**
     * Update the specified resource in storage.
     */
   public function update(Request $request, Category $category)
{
    $validated = $request->validate([
        'name'        => 'required|string|max:255',
        'description' => 'nullable|string',
        'image'       => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
    
    ]);

    // Handle image upload if present
    if ($request->hasFile('image')) {
        $imagePath = $request->file('image')->store('categories', 'public');
        $validated['image'] = $imagePath;
    }

    $category->update($validated);
   

    return redirect()->route('categories.edit', $category->id)
                     ->with('success', 'Category updated successfully!');
}

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Category $category)
    {
       return view('categories.delete');
    }
}
