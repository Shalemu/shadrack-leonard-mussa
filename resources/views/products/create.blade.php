@extends('layouts.app')

@section('title','Upload Product')

@section('content')

<form action="{{ route('products.store') }}" method="POST" enctype="multipart/form-data">
    
    @csrf
    <div class="form-section card mb-3 mt-5">
        <div class="card-body">

            {{-- Success Message --}}
            @if(session('success'))
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    {{ session('success') }}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            {{-- Validation Errors --}}
            @if($errors->any())
                <div class="alert alert-danger">
                    <ul class="mb-4">
                        @foreach($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            <h5 class="mb-3text-primary">Product</h5>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Product Name</label>
                    <input type="text" name="name" class="form-control" value="{{ old('name') }}" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Price</label>
                    <input type="number" name="price" class="form-control" step="0.01" min="0" value="{{ old('price', 0) }}" required>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Category</label>
                    <select name="category_id" class="form-select" required>
                        <option selected disabled>Choose...</option>
                        @foreach($categories as $category)
                            <option value="{{ $category->id }}" {{ old('category_id') == $category->id ? 'selected' : '' }}>
                                {{ $category->name }}
                            </option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" id="description" class="form-control" rows="3" required>{{ old('description') }}</textarea>
                </div>

                <div class="col-12 mb-3">
                    <label class="form-label">Upload Image</label>
                    <input type="file" name="image" class="form-control" accept=".jpg,.jpeg,.png">
                </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 btn-lg">
                <i class="fa fa-save"></i> Submit
            </button>
        </div>
    </div>
</form>

@endsection
