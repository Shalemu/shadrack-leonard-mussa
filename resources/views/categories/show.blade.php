@extends('layouts.app')

@section('content')
<div class="container">
    <h1>{{ $category->name }}</h1>
    <p><strong>Description:</strong> {{ $category->description }}</p>

    @if($category->image)
        <img src="{{ asset('storage/' . $category->image) }}" alt="{{ $category->name }}" style="max-width: 300px;">
    @endif

    <a href="{{ route('categories.edit', $category->id) }}" class="btn btn-primary">Edit</a>
    <form action="{{ route('categories.destroy', $category->id) }}" method="POST" style="display:inline-block;">
        @csrf
        @method('DELETE')
        <button type="submit" class="btn btn-danger">Delete</button>
    </form>
</div>
@endsection
