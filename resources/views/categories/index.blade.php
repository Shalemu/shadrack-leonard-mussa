@extends('layouts.app')

@section('content')
<div class="container">
    <br>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h3 mt-5">Categories</h1>
        <a href="{{ route('categories.create') }}" class="btn btn-success">
            <i class="bi bi-plus-circle me-1"></i> Add Category
        </a>
    </div>

    @if($categories->count())
        <div class="card">
            <div class="card-header bg-dark text-white p-4">
                Categories Table
            </div>
            <div class="card-body p-0">
                <table class="table table-striped table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col">Image</th>
                            <th scope="col">Name</th>
                            <th scope="col" class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($categories as $category)
                        <tr>
                            <td style="width: 60px;">
                                @if($category->image)
                                    <img src="{{ asset('storage/' . $category->image) }}" alt="{{ $category->name }}" width="50" height="50" class="rounded">
                                @else
                                    <img src="https://via.placeholder.com/50" alt="No Image" class="rounded">
                                @endif
                            </td>
                            <td>{{ $category->name }}</td>
                            <td class="text-center" style="width: 120px;">
                                <div class="d-flex justify-content-center gap-1">
                                    <!-- View -->
                                    <a href="{{ route('categories.show', $category->id) }}" class="btn btn-sm btn-outline-info" title="View">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <!-- Edit -->
                                    <a href="{{ route('categories.edit', $category->id) }}" class="btn btn-sm btn-outline-secondary" title="Edit">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <!-- Delete -->
                                    <form action="{{ route('categories.destroy', $category->id) }}" method="POST" onsubmit="return confirm('Are you sure?');">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>

                <div class="mt-3 d-flex justify-content-center">
                    {{ $categories->links('pagination::bootstrap-5') }}
                </div>
            </div>
        </div>
    @else
        <p class="text-center mt-3">No categories found.</p>
    @endif
</div>
@endsection
