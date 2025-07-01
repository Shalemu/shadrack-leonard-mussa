@extends('layout')
@section('title', 'login')

@section('content')
<div class="container">
<div class="mt-5">
@if ($errors->any())
  <div class="col-12">
    @foreach ($errors->all() as $error)
    <div class="d-flex justify-content-center">
    <div class="alert alert-danger alert-dismissible fade show w-50 text-center" role="alert">
        {{ $error }}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    @endforeach
  </div>
  </div>
@endif


@if (session()->has('error'))
<div class="d-flex justify-content-center">
  <div class="alert alert-danger alert-dismissible fade show w-50 text-center" role="alert">
    {{ session('error') }}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
</div>

@endif

@if (session()->has('success'))
<div class="d-flex justify-content-center">
  <div class="alert alert-success alert-dismissible fade show  w-50 text-center" role="alert">
    {{ session('success') }}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
@endif
 <div class="bg-white p-3 rounded shadow w-50 mx-auto mt-4">
  <form action="{{route('login.post')}}" method="POST" class="ms-auto me-auto mt-4" style="width: 440px; height: 400px">
      @csrf
      <h4 style="text-align: center; font-size:20px;" class="mb-5">Sign in to your account</h4>
    <div class="mb-3">
      <label for="exampleInputEmail1" class="form-label">Email address</label>
      <input type="email" class="form-control" name="email">
      <div id="emailHelp" class="form-text">We'll never share your email with anyone else.</div>
    </div>
    <div class="mb-3">
      <label for="exampleInputPassword1" class="form-label">Password</label>
      <input type="password" class="form-control" name="password">
    </div>
    <div class="mb-3 d-flex justify-content-between align-items-center">
  <div class="form-check">
    <input type="checkbox" class="form-check-input">
    <label class="form-check-label" for="exampleCheck1">Check me out</label>
  </div>
  
  <div>
    <a href="#!">Forgot password?</a>
  </div>
</div>
  <div class="d-grid gap-2">
  <button class="btn btn-primary" type="submit">Login</button>

</div>

</div>
  </form>
    <div class="text-center mt-3">
        <p>Don't have account yet? <a href="#!">Register</a></p>
      </div>
</div>
</div>
@endsection