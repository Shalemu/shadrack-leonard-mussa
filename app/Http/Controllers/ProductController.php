<?php

namespace App\Http\Controllers;

use App\Http\Resources\ProductResources;
use App\Models\Product;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

use function Pest\Laravel\delete;

class ProductController extends Controller
{
    // Display all products
    public function index()
    {
       

   $products = Product::with('category')->paginate(6); 
    return view('products.index', compact('products'));
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
            'description' => 'string|nullable',
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

         return view('products.show', compact('product'));
    }

    // Edit, Update, Destroy (optional)
    public function edit(Product $product) {

    $categories = Category::all(); 
    return view('products.edit', compact('product', 'categories'));
    }

  public function update(Request $request, Product $product)
{
    $validated = $request->validate([
        'name'        => 'required|string|max:255',
        'price'       => 'required|numeric|min:0',
        'description' => 'nullable|string',
        'image'       => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        'category_id' => 'nullable|exists:categories,id'
    ]);

    // Handle image upload if present
    if ($request->hasFile('image')) {
        $imagePath = $request->file('image')->store('products', 'public');
        $validated['image'] = $imagePath;
    }

    $product->update($validated);
    $product->load('category');

    return redirect()->route('products.edit', $product->id)
                     ->with('success', 'Product updated successfully!');
}


    public function destroy(Product $product) {

        $product -> delete();

        return redirect()->route('products.index')
                     ->with('success', 'Product deleted successfully!');
        
    }
}
