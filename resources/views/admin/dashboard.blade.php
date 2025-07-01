<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>@yield('title', 'Dashboard')</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <style>
        html, body {
            height: 100%;
            margin: 0;
            overflow: hidden; /* Prevent whole page scrolling */
        }

        body {
            display: flex;
            flex-direction: column;
            height: 100vh; /* Fill viewport height */
        }

        #wrapper {
            display: flex;
            flex: 1;
            height: 100vh; /* Fill viewport height */
        }

        #sidebar-wrapper {
            width: 250px;
            background-color: #312A25;
            min-height: 100vh; /* Full viewport height */
            overflow: hidden; /* No scroll on sidebar */
        }

        #page-content-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh; /* Full viewport height */
        }

        /* Scrollable content area */
        .content-container {
            flex: 1;
            padding: 20px;
            overflow-y: auto; /* Scroll only here */
        }

        footer {
            background-color: #f8f9fa;
            padding: 10px 30px;
            flex-shrink: 0; /* Prevent footer shrinking */
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
    @include('sidebar.sidebar')

    <div id="page-content-wrapper">
        @include('navbar.navbar')

        <div class="content-container container mt-3">
            @hasSection('content')
                @yield('content')
            @else
                @include('contents.main')
            @endif
        </div>

        <footer class="d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <span style="color: red;">AICT TABATA</span> <span style="color: black;">@2025</span>
            </h5>
            <h6 class="mb-0">
                <span style="color: black;">Designed & Developed by </span> <span style="color: red;">ICT Committee</span>
            </h6>
        </footer>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById("menu-toggle")?.addEventListener("click", function (e) {
        e.preventDefault();
        document.getElementById("wrapper").classList.toggle("toggled");
    });
</script>

</body>
</html>
