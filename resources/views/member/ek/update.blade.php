@extends('dashboard')

@section('title', 'Update Children')

@section('content')

   <div class="container mt-4">
    <div class="card">
      <div class="card-header d-flex justify-content-between align-items-center bg-primary text-white">
            <h2 class="mb-0">Update Child Details</h2>
            <a href="{{ route('department.children') }}" class="btn btn-light btn-sm">Back</a>
        </div>

    {{-- Success message --}}
    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    <div class="card p-4" style="max-height: 85vh; overflow-y: auto;">
        {{-- Update Form --}}
        <form action="{{ route('update_children') }}" method="POST">
            @csrf
            <input type="hidden" name="id" value="{{ $child->id }}">

            <div class="row g-3">
                {{-- Full Name --}}
                <div class="col-md-6">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" value="{{ old('name', $child->name) }}" class="form-control" required>
                </div>

                {{-- Gender --}}
                <div class="col-md-6">
                    <label class="form-label">Gender</label>
                    <select name="gender" class="form-select" required>
                        <option value="Male" {{ $child->gender == 'Male' ? 'selected' : '' }}>Male</option>
                        <option value="Female" {{ $child->gender == 'Female' ? 'selected' : '' }}>Female</option>
                    </select>
                </div>

                {{-- Street --}}
                <div class="col-md-6">
                    <label class="form-label">Street</label>
                    <input type="text" name="street" value="{{ old('street', $child->street) }}" class="form-control" required>
                </div>

                {{-- Class Level --}}
                <div class="col-md-6">
                    <label class="form-label">Class Level</label>
                    <select class="form-select" name="class_level" required>
                        <option value="">Choose...</option>
                        @foreach(['Chekechea', 'Darasa la 1', 'Darasa la 2', 'Darasa la 3', 'Darasa la 4', 'Darasa la 5', 'Darasa la 6', 'Darasa la 7', 'Form 1', 'Form 2', 'Form 3', 'Form 4'] as $level)
                            <option value="{{ $level }}" {{ $child->class_level == $level ? 'selected' : '' }}>{{ $level }}</option>
                        @endforeach
                    </select>
                </div>

                {{-- School --}}
                <div class="col-md-6">
                    <label class="form-label">School</label>
                    <input type="text" name="school" value="{{ old('school', $child->school) }}" class="form-control">
                </div>

                {{-- Baptized --}}
                <div class="col-md-6">
                    <label class="form-label">Baptized</label>
                    <select name="baptized" class="form-select">
                        <option value="Yes" {{ $child->baptized == 'Yes' ? 'selected' : '' }}>Yes</option>
                        <option value="No" {{ $child->baptized == 'No' ? 'selected' : '' }}>No</option>
                    </select>
                </div>

                {{-- Guardian Name --}}
                <div class="col-md-6">
                    <label class="form-label">Guardian Name</label>
                    <input type="text" name="guardian_name" value="{{ old('guardian_name', $child->guardian_name) }}" class="form-control" required>
                </div>

                {{-- Phone --}}
                <div class="col-md-6">
                    <label class="form-label">Phone</label>
                    <input type="text" name="phone" value="{{ old('phone', $child->phone) }}" class="form-control" required>
                </div>

                {{-- Date of Birth --}}
                <div class="col-md-6">
                    <label class="form-label">Date of Birth</label>
                    <input type="date" name="dob" value="{{ old('dob', $child->dob) }}" class="form-control" required>
                </div>
            </div>

        {{-- Update and Delete Buttons --}}
<div class="row mt-4">
    <div class="col-md-6">
        <form action="{{ route('update_children') }}" method="POST">
            @csrf
            <input type="hidden" name="id" value="{{ $child->id }}">
          <button type="submit" class="btn btn-primary">
                <i class="fa fa-save"></i> Update
            </button>
        </form>
    </div>

    <div class="col-md-6 text-end">
        <form action="{{ route('children.destroy', $child->id) }}" method="POST" onsubmit="return confirm('Are you sure you want to delete this record?');">
            @csrf
            @method('DELETE')
            <button type="submit" class="btn btn-danger">
                <i class="fa fa-trash"></i> Delete
            </button>
        </form>
    </div>
</div>
</div>

    </div>
</div>
@endsection
