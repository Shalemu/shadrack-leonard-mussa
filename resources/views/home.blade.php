
@extends('layout.default')

@section('header')
   
    <h1 class="text-3xl text-center text-red-500 mb-4">AFRICA INLAND CHURCH TANZANIA</h1>

    @endsection
    
  
    @section('maincontent')
    <div class="text-center">
        <a href="{{ url('/About') }}" class="text-blue-600 hover:underline text-lg">Go to About Me</a>



        <form action="{{route('formsubmitted')}}" method="Post">
            @csrf
            <label for="full name">Fullname</label><br>
            <input type="text" id="fullname" name="fullname" placeholder="Enter the name"> <br>
            <label for="email">Email</label><br>
            <input type="text" id = "email" name="email" placeholder="Enter email">
            <br>
            <button type="submit"> submit</button>
        </form>
    </div>
    @endsection
   
  @section('footer')
    <footer>
        <!-- This is footer -->
    </footer>
    @endsection
    


