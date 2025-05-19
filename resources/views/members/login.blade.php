
@extends('layout.Form')
@section('maincontent')
<!-- <section class="vh-100" style="background-color: #9A616D;"> -->
<section class="vh-100 gradient-custom">
  <div class="container py-5 h-100">
    <div class="row d-flex justify-content-center align-items-center h-100">
      <div class="col col-xl-8">
        <div class="card" style="border-radius: 1rem;">
          <div class="row g-0">
            <div class="col-md-6 col-lg-5 d-none d-md-block">
              <img src="{{ asset('images/login.jpg') }}"
                alt="login form" class="img-fluid" style="border-radius: 1rem 0 0 1rem;" />
            </div>
            <div class="col-md-0 col-lg-7 d-flex align-items-center">
              <div class="card-body p-2 p-lg-4 text-black">

              <form action="{{ route('formsubmitted') }}" method="POST">
                @csrf

               <div class="d-flex align-items-center mb-1 pb-1">
                <i class="fas fa-cubes fa-2x me-3" style="color: #ff6219;"></i>
                <img src="{{ asset('images/logo.png') }}"
                    alt="login form"
                    style="width: 80px; height: 80px; margin-left: 150px;" />
                
                </div>



                  <h5 class="fw-normal mb-3 pb-3" style="letter-spacing: 1px; margin-left: 90px;">Sign into your account</h5>

                  <div data-mdb-input-init class="form-outline mb-4">
                  <label class="form-label" for="form2Example17">Email address</label>
                    <input type="email" id="form2Example17" class="form-control form-control-lg" />
                  
                  </div>

                  <div data-mdb-input-init class="form-outline mb-4">
                  <label class="form-label" for="password">Password</label> 
                    <input type="password" id="password" class="form-control form-control-lg"  name="password" />
                  
                  </div>
                  <div class="d-grid gap-2 col-6 mx-auto">
                    <button class="btn btn-primary" type="button">Login</button>
                   
                    </div>

                  <!-- <div class="pt-1 mb-4">
                    <button data-mdb-button-init data-mdb-ripple-init class="btn btn-dark btn-lg btn-block" type="button">Login</button>
                  </div> -->

                  <a class="small text-muted" href="#!" style="margin-left:160px">Forgot password?</a>
                  <p class="mb-5 pb-lg-2" style="color: #393f81; margin-left:80">Don't have an account? <a href="#!"
                      style="color: #393f81;">Register here</a></p>
                  <!-- <a href="#!" class="small text-muted">Terms of use.</a>
                  <a href="#!" class="small text-muted">Privacy policy</a> -->
                </form>
              

              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  @endsection
</section>

</body>

@section('footer')
<footer class="mt-5">
    <p class="text-center text-muted">© 2025 AICT TABATA</p>
</footer>
@endsection
</html>