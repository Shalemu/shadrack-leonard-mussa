
@extends('dashboard')

@section('title','Sunday service')

@section('content')
<div class="container mt-3">



  <!-- Header and Register Button -->
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Sunday services</h2>
    @auth
      @if(auth()->user()->role==='leader')
        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#registerModal">
          <i class="fa fa-plus"></i> Upload Details
        </button>
      @endif
    @endauth

   
  </div>
</div>
   @include('services.riport');
   
  
@endsection

