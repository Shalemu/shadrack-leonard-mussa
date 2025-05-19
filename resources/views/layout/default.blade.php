<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AICT</title>
    @vite('resources/css/app.css')
    @vite('resources/js/app.js')
    
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

</head>
<body class="bg-gray-100 p-6">
    <header>
            <!-- <img src="{{asset('images/shadrack.png')}}" alt=""> -->
            <!-- <img src="{{ asset('images/shadrack.png') }}" alt="Profile" class="w-40 h-40 rounded-lg object-cover"> -->
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <nav class="navbar navbar-expand-lg navbar-light bg-light">
                    <a class="navbar-brand ms-3" href="#"> [AICT] - TABATA</a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                    </button>
                    </nav>
                </div>
            </div>
            <div class="row">
            <div class="col-md-6">
                <div class="sidebar">
                    <a class="active" href="#home">Home</a>
                    <a href="#news">My Profile</a>
                    <a href="#contact">Announcements</a>
                    <a href="#about">Church Events</a>
                    <a href="#about">Departments</a>
                    <a href="#about">My Offerings</a>
                    <a href="#about">Submit Prayer Request</a>
                    <a href="#about">Contact Leaders</a>
                </div>
            </div>
            </div>
            
           
        </div>
   </div>
    <!-- <h1 class="text-red-500 text-3xl">AFRICA INLAND CHURCH TANZANIA</h1> -->


        @yield('header')
      
    </header>
    
    <main>
        <div class="col-md-9">
         <div class="contents">
            @yield('maincontent')
          </div>
        </div>
    </main>
    

    <footer>
    @yield('footer')
    </footer>
    
</body>
</html>
