<?php

namespace App\Http\Controllers\api;

use Illuminate\Routing\Controller;
use Illuminate\Http\Request;
use App\Models\Category;
use App\Http\Resources\CategoryResources;
use Illuminate\Support\Facades\Validator;

class CategoryController extends Controller
{
    // List all categories
    public function index()
    {
        $categories = Category::all();
        return CategoryResources::collection($categories);
    }

    // Show a single category
    public function show(Category $category)
    {
        return new CategoryResources($category);
        
    }

    // Store new category
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $category = Category::create($validator->validated());

        return response()->json([
            'message' => 'Category created successfully',
            'data' => new CategoryResources($category)
        ], 201);
    }

    // Update category
    public function update(Request $request, Category $category)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $category->update($validator->validated());

        return response()->json([
            'message' => 'Category updated successfully',
            'data' => new CategoryResources($category)
        ]);
    }

    // Delete category
    public function destroy(Category $category)
    {
        $category->delete();

        return response()->json([
            'message' => 'Category deleted successfully'
        ]);
    }

    public function products(Category $category)
{
    // Load products of this category
    $products = $category->products; // thanks to hasMany relationship

    return response()->json([
        'category' => $category->name,
        'data' => $products->map(function($product) {
            return [
                'id' => $product->id,
                'Product_name' => $product->name,
                'description' => $product->description,
                'price' => $product->price,
                'image_url' => $product->image ? url('storage/' . $product->image) : null,
                'category_id' => $product->category_id,
            ];
        })
    ]);
}

}
