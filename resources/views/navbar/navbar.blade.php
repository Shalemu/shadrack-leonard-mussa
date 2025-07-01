    <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom mb-3">
  <div class="container-fluid">
    <button class="btn btn-dark" id="menu-toggle"><i class="fas fa-bars"></i></button>

    {{-- Change based on role --}}
    @auth
      <span class="navbar-brand ms-3">
        @if(auth()->user()->role === 'leader')
          Admin
        @elseif(auth()->user()->role === 'member')
          Dashboard
        @else
          Dashboard
        @endif
      </span>
    @else
      <span class="navbar-brand ms-3">Dashboard</span>
    @endauth

    <div class="ms-auto dropdown">
  @auth
   
    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
      <li><a class="dropdown-item" href="{{ route('profile') }}">Profile</a></li>
     

      <li>
        <form method="POST" action="{{ route('logout') }}">
          @csrf
          <button class="dropdown-item" type="submit">Logout</button>
        </form>
      </li>
    </ul>
     <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
      <i class="fas fa-user-circle me-1"></i> {{ auth()->user()->name }}
    </a>
  @else
    <span class="navbar-text">Guest</span>
  @endauth
</div>

  </div>
</nav>
