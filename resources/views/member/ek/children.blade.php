@extends('dashboard')

@section('title','EK department')

@section('content')
<div class="container mt-3">

  @if (session('success'))
    <div class="alert alert-success">{{ session('success') }}</div>
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

  <!-- Header and Register Button -->
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>EK Department</h2>
    @auth
      @if(auth()->user()->role==='leader')
        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#registerModal">
          <i class="fa fa-plus"></i> Register
        </button>
      @endif
    @endauth
  </div>

  @include('member.ek.riport')

  <!-- Export Buttons -->
  @auth
    @if(auth()->user()->role==='leader')
      <div class="d-flex justify-content-start mb-3 gap-2">
        <a href="{{ route('children.export.excel') }}" class="btn btn-outline-success">Export to Excel</a>
        <a href="{{ route('children.download.pdf') }}" class="btn btn-outline-danger">PDF</a>
      </div>
    @endif
  @endauth

  <!-- Children Table -->
  <div class="card p-3">
    <table id="childrenTable" class="table table-bordered table-striped" style="width: 100%;">
      <thead style="background-color: #f5f586; color: black;">
        <tr>
          <th>Name</th>
          <th>Gender</th>
          <th>Parent Name</th>
          <th>Parent Phone</th>
          <th>Street</th>
          <th>Class Level</th>
          <th>School</th>
          <th>Baptized</th>
          <th>Age</th>
          @if(auth()->user()->role === 'leader')
            <th>Action</th>
          @endif
        </tr>
      </thead>
      <tbody>
        @foreach ($records as $record)
        <tr style="background-color: #f2fbff;">
          <td>{{ $record->name }}</td>
          <td>{{ $record->gender }}</td>
          <td>{{ $record->guardian_name }}</td>
          <td>{{ $record->phone }}</td>
          <td>{{ $record->street }}</td>
          <td>{{ $record->class_level }}</td>
          <td>{{ $record->school }}</td>
          <td>{{ $record->baptized }}</td>
          <td>{{ \Carbon\Carbon::parse($record->dob)->age }} yrs</td>
          @if(auth()->user()->role === 'leader')
            <td>
        <a href="{{ route('children.edit', $record->id) }}" class="btn btn-sm btn-info">
        <i class="fa fa-eye"></i>
        </a>


             
            </td>
          @endif
        </tr>
        @endforeach
      </tbody>
    </table>
  </div>

  <!-- Register Modal -->
  <div class="modal fade" id="registerModal" tabindex="-1" aria-labelledby="registerModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">

        <div class="modal-header">
          <h5 class="modal-title" id="registerModalLabel">Children Registration</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <form method="POST" action="{{ route('children.store') }}">
          @csrf
          <div class="modal-body">
            <div class="mb-3">
              <label for="name" class="form-label">Full Name</label>
              <input type="text" class="form-control" name="name" required>
            </div>

            <div class="mb-3">
              <label class="form-label">Street</label>
              <input type="text" name="street" class="form-control" required>
            </div>

            <div class="mb-3">
              <label class="form-label">Gender</label>
              <select class="form-select" name="gender" required>
                <option value="">Choose...</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Class Level</label>
              <select class="form-select" name="class_level" required>
                <option value="">Choose...</option>
                <option value="Chekechea">Chekechea</option>
                <option value="Darasa la 1">Darasa la 1</option>
                <option value="Darasa la 2">Darasa la 2</option>
                <option value="Darasa la 3">Darasa la 3</option>
                <option value="Darasa la 4">Darasa la 4</option>
                <option value="Darasa la 5">Darasa la 5</option>
                <option value="Darasa la 6">Darasa la 6</option>
                <option value="Darasa la 7">Darasa la 7</option>
                <option value="Form 1">Form 1</option>
                <option value="Form 2">Form 2</option>
                <option value="Form 3">Form 3</option>
                <option value="Form 4">Form 4</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Baptized?</label>
              <select name="baptized" class="form-select">
                <option value="">Choose...</option>
                <option value="Yes">Yes</option>
                <option value="No">No</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label">Parent/Guardian Name</label>
              <input type="text" name="guardian_name" class="form-control">
            </div>

            <div class="mb-3">
              <label class="form-label">Parent/Guardian Phone</label>
              <input type="text" name="phone" class="form-control" required>
            </div>

            <div class="mb-3">
              <label class="form-label">School Name</label>
              <input type="text" name="school" class="form-control">
            </div>

            <div class="mb-3">
              <label class="form-label">Date of Birth</label>
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

@push('styles')
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
@endpush

@push('scripts')
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
  $(document).ready(function () {
    $('#childrenTable').DataTable({
      pageLength: 10,
      ordering: true,
      responsive: true,
    });
  });
</script>
@endpush
