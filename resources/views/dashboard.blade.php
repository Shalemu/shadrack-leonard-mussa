<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>@yield('title', 'Laravel')</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
      body {
        overflow-x: hidden;
         margin: 0;
        padding: 0;
        height: 100%;
        overflow: hidden;
      }

      #wrapper {
        display: flex;
        transition: all 0.6s ease;
      }

      #sidebar-wrapper {
        width: 250px;
        background-color: #312A25 !important;
        min-height: 100vh;
        transition: all 0.5s ease;
      }

      #sidebar-wrapper .sidebar-nav {
        padding: 0;
        list-style: none;
        margin: 0;
        padding-top: 100px;
      }

      .sidebar-nav li {
        line-height: 40px;
        padding-left: 20px;
        
      }

      .sidebar-nav li a {
        color: #999;
        display: block;
        text-decoration: none;
      }

      .sidebar-nav li a:hover {
        background-color: #3e3530;
        color: #fff;
      }

      #page-content-wrapper {
        flex: 1;
        padding: 20px;
        transition: all 0.5s ease;
      }

      #wrapper.toggled #sidebar-wrapper {
        width: 60px;
      }

      #wrapper.toggled .sidebar-nav span {
        display: none;
      }

      @media (max-width: 768px) {
        #sidebar-wrapper {
          width: 200px;
          position: fixed;
          z-index: 1000;
          left: -200px;
        }

        #wrapper.toggled #sidebar-wrapper {
          left: 0;
        }

        #page-content-wrapper {
          margin-left: 0;
        }
      }
       .card-hover:hover {
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
    transform: scale(1.02);
    transition: all 0.3s ease-in-out;
  }
    </style>
  </head>
  <body>

    <div id="wrapper">
      
      <!-- Sidebar -->
        @include('sidebar.sidebar')
   

      <!-- Page Content -->
      <div id="page-content-wrapper">
        
        <!-- Top Navbar -->
          @include('navbar.navbar')
         

<div class="container mt-3">
  
  
    
  @section('content')
    @include('contents.main')
  @endsection

  </div>

  @yield('content')
  <footer class="d-flex justify-content-between align-items-center px-5 py-3" style="position: absolute; bottom: 0; width: 85%;">
    <h5 class="mb-0">
      <span style="color: red;">AICT TABATA</span> <span style="color: black;">@2025</span>
    </h5>
    <h6 class="mb-0">
      <span style="color: black;">Designed & Developed by </span> <span style="color: red;"> ICT Committee </span>
    </h6>
</footer>   
</div>
</div>
      
</div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      document.getElementById("menu-toggle").addEventListener("click", function (e) {
        e.preventDefault();
        document.getElementById("wrapper").classList.toggle("toggled");
      });
    </script>

  </body>

</html>
