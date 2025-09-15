<nav class="app-header navbar navbar-expand bg-white shadow-sm">
    <ul class="navbar-nav">
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="collapse" href="#sidebarMenu" role="button">
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
                {{ Auth::user()->name }}
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="#">Profile</a></li>
                <li><a class="dropdown-item" href="#">Sign out</a></li>
            </ul>
        </li>
    </ul>
</nav>







