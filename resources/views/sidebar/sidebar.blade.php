<div id="sidebar-wrapper">
  <ul class="sidebar-nav">

    <li class="sidebar-brand">
      <a href="#"><i class="fas fa-cubes"></i> <span>Brand</span></a>
    </li>

    <li>
      <a href="{{ route('dashboard', ['section' => 'main']) }}"><i class="fas fa-home"></i> <span>Home</span></a>
    </li>

    <li>
      <a data-bs-toggle="collapse" href="#departmentSubmenu" role="button" aria-expanded="false" aria-controls="departmentSubmenu">
        <i class="fas fa-cog"></i> <span>Department</span>
      </a>
      <ul class="collapse list-unstyled ps-4" id="departmentSubmenu">
        <li><a href="{{ route('dashboard.youth') }}">Youth Department</a></li>
        <li><a href="#">Construction Department</a></li>
        <li><a href="#">EK</a></li>
      </ul>
    </li>

  


    <li>
      <a data-bs-toggle="collapse" href="#servicesSubmenu" role="button" aria-expanded="false" aria-controls="servicesSubmenu">
        <i class="fas fa-concierge-bell"></i> <span>Services</span>
      </a>
      <ul class="collapse list-unstyled ps-4" id="servicesSubmenu">
        <li><a href="#">Sunday Service</a></li>
        <li><a href="#">Wednesday Service</a></li>
        <li><a href="#">Thursday Service</a></li>
        <li><a href="#">Saturday Service</a></li>
      </ul>
    </li>

    <li>
      <a data-bs-toggle="collapse" href="#eventsSubmenu" role="button" aria-expanded="false" aria-controls="eventsSubmenu">
        <i class="fas fa-user"></i> <span>Events</span>
      </a>
      <ul class="collapse list-unstyled ps-4" id="eventsSubmenu">
        <li><a href="#">Fundraising Event</a></li>
        <li><a href="#">Overnight Event</a></li>
      </ul>
    </li>

    <li>
      <a data-bs-toggle="collapse" href="#offeringSubmenu" role="button" aria-expanded="false" aria-controls="offeringSubmenu">
        <i class="fas fa-gift"></i> <span>Offering</span>
      </a>
      <ul class="collapse list-unstyled ps-4" id="offeringSubmenu">
        <li><a href="#">Sunday Offering</a></li>
        <li><a href="#">Wednesday Offering</a></li>
        <li><a href="#">Thursday Offering</a></li>
        <li><a href="#">Friday Offering</a></li>
        <li><a href="#">Saturday Offering</a></li>
      </ul>
    </li>

    <li>
      <a href="#"> <i class="fas fa-users-cog"></i>  <span>Excom</span></a>
    </li>

  </ul>
</div>
