@extends('layout.default')



@section('maincontent')
<div class="text-center">
    <!-- <h1>welcome to about us page</h1> -->
    

    @isset($fullname)
    <p>Name: {{$fullname}}</p>
    <p>Email:{{$email}}</p>

    @else
    <p>
        No user data
    </p>
    @endisset
    </div>
    @endsection



