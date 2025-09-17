@extends('layouts.app')

@section('title', 'Create Category')

@section('content')


<div class="container min-vh-100 d-flex justify-content-center align-items-center">
    <div class="row w-100 justify-content-center">
        <div class="col-12 col-md-8">
            <div class="card mb-3">
                <div class="card-header ">
                    <h5 class="card-title mb-2">Category Form</h5>
                </div>

                <form action="{{ route('categories.store') }}" method="POST" enctype="multipart/form-data">
                    @csrf
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
                                <ul class="mb-0">
                                    @foreach($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <div class="row">
                            <!-- Category Name -->
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label">Category Name</label>
                                <input type="text" name="name" class="form-control" id="name" value="{{ old('name') }}" required>
                            </div>

                            <!-- Image -->
                            <div class="col-md-6 mb-3">
                                <label for="inputGroupFile02" class="form-label">Upload Image</label>
                                <input type="file" name="image" class="form-control" id="inputGroupFile02" accept=".jpg,.jpeg,.png">
                            </div>

                            <!-- Description -->
                            <div class="col-12 mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea id="description" name="description" rows="5" class="form-control" required>{{ old('description') }}</textarea>
                            </div>
                        </div>

                    </div>

                    <div class="card-footer text-center">
                        <button type="submit" class="btn btn-primary w-100">Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

@endsection
