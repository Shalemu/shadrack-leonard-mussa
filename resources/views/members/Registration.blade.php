@extends('layout.Form')

@section('maincontent')
<section class="vh-100 gradient-custom">
    <div class="container py-5 h-100">
      <div class="row justify-content-center align-items-center h-100">
        <div class="col-12 col-lg-9 col-xl-7">
          <div class="card shadow-2-strong card-registration" style="border-radius: 15px;">
            <div class="card-body p-4 p-md-5">
              
              
<h3 class="mb-4 pb-2 pb-md-0 mb-md-5">Registration Form</h3>
<form action="{{ route('formsubmitted') }}" method="POST">
  @csrf
 

  <div class="row">
    <div class="col-md-6 mb-4">
      <div class="form-outline">
      <label class="form-label" for="firstName">First Name</label>
        <input type="text" id="firstName" name="firstName" class="form-control form-control-lg" placeholder="" />
      
      </div>
    </div>

    <div class="col-md-6 mb-4">
      <div class="form-outline">
      <label class="form-label" for="lastName">Last Name</label>
        <input type="text" id="lastName" name="lastName" class="form-control form-control-lg" placeholder="" />
       
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-md-6 mb-4 d-flex align-items-center">
      <div class="form-outline w-100">
      <label class="form-label" for="emailAddress">Email</label>
      <input type="text" id="email" name="email" class="form-control form-control-lg" placeholder="" />
        <!-- <input type="date" class="form-control form-control-lg" id="birthdayDate" name="birthday" /> -->
      
      </div>
    </div>
    <div class="col-md-6 mb-4">
      <div class="form-outline">
      <label class="form-label" for="phoneNumber">Phone Number</label>
        <input type="text" id="phoneNumber" name="phoneNumber" class="form-control form-control-lg" placeholder="" />
       
      </div>
    </div>

    <!-- <div class="col-md-6 mb-4">
      <h6 class="mb-2 pb-1">Gender:</h6>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="gender" id="femaleGender" value="female" checked />
        <label class="form-check-label" for="femaleGender">Female</label>
      </div>

      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="gender" id="maleGender" value="male" />
        <label class="form-check-label" for="maleGender">Male</label>
      </div>

      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="gender" id="otherGender" value="other" />
        <label class="form-check-label" for="otherGender">Other</label>
      </div>
    </div> -->
  </div>

  <div class="row">
    <div class="col-md-6 mb-4 pb-2">
      <div class="form-outline">
      <label class="form-label" for="password">Password</label>
        <input type="password" id="password" name="password" class="form-control form-control-lg" placeholder="" />
      
      </div>
    </div>

    <div class="col-md-6 mb-4 pb-2">
      <div class="form-outline">
      <label class="form-label" for="password">Confirm Password</label>
        <input type="password" id="password" name="password" class="form-control form-control-lg" placeholder="" />
       
      </div>
    </div>
  </div>

  <!-- <div class="row">
    <div class="col-12">
      <select name="subject" class="form-select form-select-lg mb-3" required>
        <option disabled selected value="">Choose Subject</option>
        <option value="subject1">Subject 1</option>
        <option value="subject2">Subject 2</option>
        <option value="subject3">Subject 3</option>
      </select>
    </div>
  </div> -->
  <div class="form-check">
  <input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
  <label class="form-check-label" for="flexCheckDefault">
  I agree all atatement in term of service
  </label><br><br>
</div>
<div class="d-grid gap-2 col-6 mx-auto">
  <button class="btn btn-primary" type="submit">Submit</button>

</div>
<br>
<center>
<p class="mb-5 pb-lg-2" style="color: #393f81;">Have already an account? <a href="#!"
style="color: #393f81;">Login</a></p>
</center>

  <!-- <div class="mt-4 pt-2">
    <input class="btn btn-primary btn-lg" type="submit" value="Submit" />
  </div> -->
</form>
</div>
      </div>
    </div>
  </section>
@endsection

@section('footer')
<footer class="mt-5">
    <p class="text-center text-muted">© 2025 AICT TABATA</p>
</footer>
@endsection
