@extends('dashboard')

@section('title', 'User Profile')

@section('content')
<div class="container mt-4">
    <h2>User Profile</h2>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    <form action="{{ route('profile.update') }}" method="POST">
        @csrf
        <!-- Name -->
        <div class="mb-3">
            <label for="name" class="form-label">Full Name</label>
            <input type="text" name="name" value="{{ old('name', $user->name) }}" class="form-control" required>
            @error('name')<small class="text-danger">{{ $message }}</small>@enderror
        </div>

        <!-- Email -->
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" name="email" value="{{ old('email', $user->email) }}" class="form-control" required>
            @error('email')<small class="text-danger">{{ $message }}</small>@enderror
        </div>

        <!-- Role (readonly) -->
        <div class="mb-3">
            <label for="role" class="form-label">Role</label>
            <input type="text" value="{{ $user->role }}" class="form-control" readonly>
        </div>

        <button type="submit" class="btn btn-primary">Update Profile</button>
    </form>

    <hr>

    <!-- Logout form -->
    <form action="{{ route('logout') }}" method="POST">
        @csrf
        <button type="submit" class="btn btn-danger mt-3">Logout</button>
    </form>
</div>
@endsection
