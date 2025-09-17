<?php

namespace App\Http\Controllers\api;

use Illuminate\Routing\Controller;
use App\Http\Resources\ProductResources;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Symfony\Contracts\Service\Attribute\Required;

use function Laravel\Prompts\error;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::all();
        return ProductResources::collection($products);
    }

    public function show(Product $product)
    {
        return new ProductResources($product);
    }


    public function update(Request $request, Product $product){
 
        $validator = validator::make($request->all(),[
            'name'=>'Required|string|max:255',
            'price'=>'required|integer',
            'description'=>'string|required',
            'image'=>'required|nullable',
             'category_id' => 'nullable|exists:categories,id'

        ]);

        if($validator -> fails()){

        return response()->json([
        'errors'=>$validator->errors()
        
            ],401);

        }
         $product->update($validator->validated());

            return response()->json([
            'message' => 'product updated successfully',
            'data' => new ProductResources($product)
        ], 201);
    }
}
