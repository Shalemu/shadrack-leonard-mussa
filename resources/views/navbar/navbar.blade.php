  <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom mb-3">
          <div class="container-fluid">
            <button class="btn btn-dark" id="menu-toggle"><i class="fas fa-bars"></i></button>
            <span class="navbar-brand ms-3">Dashboard</span>
            <div class="ms-auto">
              @auth
                <span class="navbar-text"><i class="fas fa-user-circle me-1"></i> {{ auth()->user()->name }}</span>
              @else
                <span class="navbar-text">Guest</span>
              @endauth
            </div>
          </div>
        </nav>