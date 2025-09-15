<?php

namespace App\Http\Controllers;

use App\Http\Resources\ProductResources;
use App\Models\Product;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProductController extends Controller
{
    // Display all products
    public function index()
    {
        $products = Product::all();

        if ($products->count() > 0) {
            return ProductResources::collection($products);
        }

        return response()->json(['message' => 'No record available'], 200);
    }

    // Show create form
    public function create()
    {
        $categories = Category::all(); // fetch all categories
        return view('products.create', compact('categories'));
    }

    // Store new product
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric|min:0',
            'category_id' => 'required|exists:categories,id',
            'image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        if ($validator->fails()) {
            return redirect()->back()
                ->withErrors($validator)
                ->withInput();
        }

        // Handle image upload
        $imagePath = null;
        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('products', 'public');
        }

        $product = Product::create([
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'category_id' => $request->category_id,
            'image' => $imagePath,
        ]);

        return redirect()->route('products.create')
            ->with('success', 'Product created successfully!');
    }

    // Show a single product
    public function show(Product $product)
    {
        return new ProductResources($product);
    }

    // Edit, Update, Destroy (optional)
    public function edit(Product $product) {

    }
    public function update(Request $request, Product $product) {}

    public function destroy(Product $product) {
        
    }
}
