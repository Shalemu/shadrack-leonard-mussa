@extends('layouts.app')

@section('title', 'Dashboard')

@section('content')
    <h1 class="mb-4">Welcome, {{ Auth::user()->name }} </h1>

    <div class="row">
        <div class="col-md-4">
            <div class="card shadow">
                <div class="card-body">
                    <h5 class="card-title">Users</h5>
                    <p class="card-text">Total registered users: {{ \App\Models\User::count() }}</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow">
                <div class="card-body">
                    <h5 class="card-title">Profile</h5>
                    <p class="card-text">Email: {{ Auth::user()->email }}</p>
                </div>
            </div>
        </div>
    </div>
@endsection
