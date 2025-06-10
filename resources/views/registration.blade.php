@extends('layout')
@section('title', 'registration')

@section('content')
<div class="container">
  <div class="mt-5">

    {{-- Validation Errors --}}
    @if($errors->any())
      <div class="d-flex justify-content-center">
        <div class="w-50">
          @foreach($errors->all() as $error)
            <div class="alert alert-danger alert-dismissible fade show text-center" role="alert">
              {{ $error }}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
          @endforeach
        </div>
      </div>
    @endif

    {{-- Session Error --}}
    @if(session()->has('error'))
      <div class="d-flex justify-content-center">
        <div class="alert alert-danger alert-dismissible fade show w-50 text-center" role="alert">
          {{ session('error') }}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </div>
    @endif

    {{-- Session Success --}}
    @if(session()->has('success'))
      <div class="d-flex justify-content-center">
        <div class="alert alert-success alert-dismissible fade show w-50 text-center" role="alert">
          {{ session('success') }}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </div>
    @endif

  </div>
</div>

  </div>
  <div class="bg-white p-2 rounded shadow w-50 mx-auto mt-4">
<form action="{{route('registration.post')}}" method="POST" class="ms-auto me-auto mt-5" style="width: 460px; height: 420px">
    @csrf
     <h4 style="text-align: center; font-size:20px;" class="mb-4">Create new account</h4>
  <div class="mb-3">
    <label for="exampleInputEmail1" class="form-label">Full name</label>
    <input type="text" class="form-control" name="name" aria-describedby="emailHelp">
   
  </div>
  <div class="mb-3">
    <label for="exampleInputEmail1" class="form-label">Email address</label>
    <input type="email" class="form-control" name="email" aria-describedby="emailHelp">
   
  </div>
  <div class="mb-3">
    <label for="exampleInputPassword1" class="form-label">Password</label>
    <input type="password" class="form-control"name="password">
  </div>
  <!-- <div class="mb-3">
    <label for="exampleInputPassword1" class="form-label">Confirm Password</label>
    <input type="password" class="form-control"name="password">
  </div> -->
  <div class="mb-3 form-check">
    <input type="checkbox" class="form-check-input" id="exampleCheck1">
    <label class="form-check-label" for="exampleCheck1">Check me out</label>
  </div>
  <div class="d-grid gap-2">
  <button class="btn btn-primary" type="submit">Register</button>

  </div>
 
</div>
</form>
<div class="text-center mt-3">
        <p>Already have account? <a href="#!">Sign in</a></p>
      </div>

</div>
@endsection