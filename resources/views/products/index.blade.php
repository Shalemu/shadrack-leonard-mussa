@extends('layouts.app')

@section('content')
<div class="container ">
    <br>
    <div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="h3 mt-5"></h1>
    <a href="{{ route('products.create') }}" class="btn btn-success">
        <i class="bi bi-plus-circle me-1"></i> Add Product
    </a>
</div>


    @if($products->count())
        <div class="card">
            <div class="card-header bg-dark text-white p-4">
                Products Table
            </div>
            <div class="card-body p-0">
                <table class="table mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Image</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Category</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($products as $product)
                        <tr>
                            <td>
                                @if($product->image)
                                    <img src="{{ asset('storage/' . $product->image) }}" alt="{{ $product->name }}" width="50" height="50" class="rounded-circle">
                                @else
                                    <img src="https://via.placeholder.com/50" alt="No Image" class="rounded-circle">
                                @endif
                            </td>
                            <td>{{ $product->name }}</td>
                            <td>{{ number_format($product->price, 2) }}</td>
                            <td>{{ $product->category ? $product->category->name : 'N/A' }}</td>
                            <td>
                                <a href="{{ route('products.show', $product->id) }}" class="btn btn-outline-info">View</a>
                                <a href="{{ route('products.edit', $product->id) }}" 
                                class="btn btn-outline-secondary">Edit</a>
                                <form action="{{ route('products.destroy', $product->id) }}" method="POST" style="display:inline-block;">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="btn btn-outline-danger">Delete</button>
                                </form>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>

        <div class="mt-3 d-flex justify-content-center">
            {{ $products->links('pagination::bootstrap-5') }}
        </div>

            </div>
        </div>
    @else
        <p class="text-center mt-3">No products found.</p>
    @endif
</div>
@endsection
