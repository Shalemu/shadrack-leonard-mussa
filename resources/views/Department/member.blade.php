@extends('dashboard')

@section('title','Youth department')

@section('content')
<div class="container mt-3">
  @if (session('success'))
  <div class="alert alert-success">
    {{ session('success') }}
  </div>
@endif

@if ($errors->any())
  <div class="alert alert-danger">
    <ul class="mb-0">
      @foreach ($errors->all() as $error)
        <li>{{ $error }}</li>
      @endforeach
    </ul>
  </div>
@endif


  <!-- Header and Button -->
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Youth Department</h2>
    <!-- Register Button to Open Modal -->
    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#registerModal">
      <i class="fa fa-plus"></i> Register
    </button>
  </div>

  <p>Welcome to the Youth page content area.</p>

  <!-- Modal Form -->
  <div class="modal fade" id="registerModal" tabindex="-1" aria-labelledby="registerModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        
        <div class="modal-header">
          <h5 class="modal-title" id="registerModalLabel">Youth Registration</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <form method="POST" action="{{ route('youth.store') }}">
          @csrf
          <div class="modal-body">
            <!-- Name -->
            <div class="mb-3">
              <label for="name" class="form-label">Full Name</label>
              <input type="text" class="form-control" name="name" required>
            </div>

            <!-- Mtaa -->
            <div class="mb-3">
              <label for="mtaa" class="form-label">Street</label>
              <input type="text" class="form-control" name="street" required>
            </div>

            <!-- Gender -->
            <div class="mb-3">
              <label class="form-label">Gender</label>
              <select class="form-select" name="gender" required>
                <option value="">Choose...</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
              </select>
            </div>

            <!-- Marital Status -->
            <div class="mb-3">
              <label class="form-label">Marital Status</label>
              <select class="form-select" name="marital_status" required>
                <option value="">Choose...</option>
                <option value="Single">Single</option>
                <option value="Married">Married</option>
              </select>
            </div>

            <!-- Email -->
            <div class="mb-3">
              <label for="email" class="form-label">Email (optional)</label>
              <input type="email" class="form-control" name="email">
            </div>

            <!-- Phone -->
            <div class="mb-3">
              <label for="phone" class="form-label">Phone Number</label>
              <input type="text" class="form-control" name="phone" required>
            </div>

            <!-- DOB -->
            <div class="mb-3">
              <label for="dob" class="form-label">Date of Birth</label>
              <input type="date" class="form-control" name="dob" required>
            </div>

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary">Register</button>
          </div>
        </form>

      </div>
    </div>
  </div>

</div>
@endsection
