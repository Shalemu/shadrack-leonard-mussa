<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Admin Dashboard')</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
        }
     /* Sidebar wrapper */
.app-sidebar {
    width: 250px;
    background-color: #343a40;
    color: #fff;
    flex-shrink: 0;
    transition: margin-left 0.3s ease;
}

/* Collapsed sidebar */
.app-sidebar.collapsed {
    margin-left: -250px;
}

/* Sidebar brand */
.app-sidebar .sidebar-brand {
    padding: 15px;
    font-size: 1rem;
    font-weight: 500;
    color: #fff;
    text-align: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

/* Section headers (like MANAGEMENT) */
.app-sidebar .nav-header {
    padding: 12px 20px;
    font-size: 0.75rem;
    color: #adb5bd;
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-top: 10px;
    margin-bottom: 5px;
}

/* Links */
.app-sidebar .nav-link {
    padding: 10px 15px;
    display: flex;
    align-items: center;
    gap: 12px; /* space between icon and text */
    font-size: 0.95rem;
    color: #c2c7d0;
    border-radius: 5px;
    margin: 4px 10px;
    transition: background 0.2s, color 0.2s;
}

/* Hover effect */
.app-sidebar .nav-link:hover {
    background-color: #495057;
    color: #fff;
}

/* Active link */
.app-sidebar .nav-link.active {
    background-color: #495057;
    color: #fff;
    font-weight: 500;
}

/* Icons */
.app-sidebar .nav-link i {
    font-size: 1.1rem;
    min-width: 20px;
    text-align: center;
}

        .app-header {
            height: 60px;
            background: #fff;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            align-items: center;
            padding: 0 15px;
        }
        .content-wrapper {
            flex: 1;
            background: #f4f6f9;
            padding: 20px;
        }
    </style>
</head>
<body>
    {{-- Sidebar --}}
    <aside id="sidebar" class="app-sidebar">
        <div class="sidebar-brand p-3 text-center border-bottom">
            <!-- <img src="/assets/img/AdminLTELogo.png" alt="Logo" class="img-fluid mb-2" style="width:40px;"> -->
            <span class="fw-light">DOUBLE H COSMETICS </span>
        </div>
        <nav class="mt-2">
            <ul class="nav flex-column">
                <li class="nav-header px-3 text-uppercase small">Management</li>
                <li class="nav-item">
                    <a href="{{ route('dashboard') }}" class="nav-link {{ request()->is('dashboard') ? 'active' : '' }}">
                        <i class="bi bi-house me-2"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a href="{{ route('products.index') }}" class="nav-link {{ request()->is('products*') ? 'active' : '' }}">
                        <i class="bi bi-box-seam me-2"></i> Products
                    </a>
                </li>
                <li class="nav-item">
                    <a href="{{ route('categories.index') }}" class="nav-link {{ request()->is('categories*') ? 'active' : '' }}">
                        <i class="bi bi-tags me-2"></i> Categories
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link {{ request()->is('orders*') ? 'active' : '' }}">
                        <i class="bi bi-basket me-2"></i> Orders
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link {{ request()->is('bookings*') ? 'active' : '' }}">
                        <i class="bi bi-calendar-check me-2"></i> Bookings
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link {{ request()->is('bookings*') ? 'active' : '' }}">
                        <i class="bi bi-calendar-check me-2"></i> Payment
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link {{ request()->is('users*') ? 'active' : '' }}">
                        <i class="bi bi-people me-2"></i> Users
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <div class="content-wrapper d-flex flex-column w-100">
        {{-- Navbar --}}
        <nav class="app-header navbar navbar-expand">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" id="menu-toggle" href="javascript:void(0)">
                        <i class="bi bi-list"></i>
                    </a>
                </li>
                <li class="nav-item d-none d-md-block"><a href="#" class="nav-link">Home</a></li>
                <!-- <li class="nav-item d-none d-md-block"><a href="#" class="nav-link">Contact</a></li> -->
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item dropdown">
                    <a class="nav-link" data-bs-toggle="dropdown" href="#">
                        <i class="bi bi-chat-text"></i>
                        <span class="badge bg-danger">3</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a href="#" class="dropdown-item">Message 1</a></li>
                        <li><a href="#" class="dropdown-item">Message 2</a></li>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown" href="#">
                        <i class="bi bi-person-circle fs-4 me-2"></i>
                        {{ Auth::user()->name ?? 'Admin' }}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#">Profile</a></li>
                        <li>
                    <form method="POST" action="{{ route('logout') }}">
                        @csrf
                        <button type="submit" class="dropdown-item">Sign out</button>
                    </form>
                </li>

                    </ul>
                </li>
            </ul>
        </nav>

        {{-- Page Content --}}
        <main class="flex-grow-1">
            @yield('content')
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('menu-toggle').addEventListener('click', function () {
            document.getElementById('sidebar').classList.toggle('collapsed');
        });
    </script>
</body>
</html>
