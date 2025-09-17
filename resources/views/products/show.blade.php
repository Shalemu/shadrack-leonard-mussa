@extends('layouts.app')

@section('content')
<div class="container">
    <h1>{{ $product->name }}</h1>
    <p><strong>Price:</strong> ${{ $product->price }}</p>
    <p><strong>Description:</strong> {{ $product->description }}</p>
    <p><strong>Category:</strong> {{ $product->category ? $product->category->name : 'N/A' }}</p>

    @if($product->image)
        <img src="{{ asset('storage/' . $product->image) }}" alt="{{ $product->name }}" style="max-width: 300px;">
    @endif

    <a href="{{ route('products.edit', $product->id) }}" class="btn btn-primary">Edit</a>
    <form action="{{ route('products.destroy', $product->id) }}" method="POST" style="display:inline-block;">
        @csrf
        @method('DELETE')
        <button type="submit" class="btn btn-danger">Delete</button>
    </form>
</div>
@endsection
