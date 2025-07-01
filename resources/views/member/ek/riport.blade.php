<style>
    .stat-card {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin: 15px 0;
        transition: 0.3s ease;
        height: 180px; /* fixed height */
        width: 100%;   /* full width inside column */
        text-align: center;
    }

    .stat-card:hover {
        transform: translateY(-3px);
    }

    .stat-icon {
        width: 50px;
        height: 50px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        font-size: 24px;
        margin-bottom: 10px;
    }

    .bg-blue { background: #4099ff; }
    .bg-pink { background: #FF5370; }
    .bg-green { background: #2ed8b6; }
    .bg-yellow { background: #FFB64D; }

    .stat-details h5 {
        margin: 0;
        font-size: 14px;
        color: #888;
    }

    .stat-details h3 {
        margin: 5px 0;
        font-size: 22px;
        color: #333;
    }

    .stat-details small {
        font-size: 11px;
        color: #4caf50;
    }
</style>

<div class="container mt-4">
  <div class="row">
    <!-- Age 0-10 -->
    <div class="col-md-4 col-lg-2">
      <div class="stat-card">
        <div class="stat-icon bg-blue">
          <i class="fa fa-child"></i>
        </div>
        <div class="stat-details">
          <h5>Age 0–10</h5>
          <h3>{{ $age_0_10 }}</h3>
          <small>based on DOB</small>
        </div>
      </div>
    </div>

    <!-- Age 11–18 -->
    <div class="col-md-4 col-lg-2">
      <div class="stat-card">
        <div class="stat-icon bg-yellow">
          <i class="fa fa-user-graduate"></i>
        </div>
        <div class="stat-details">
          <h5>Age 11–18</h5>
          <h3>{{ $age_11_18 }}</h3>
          <small>based on DOB</small>
        </div>
      </div>
    </div>

    <!-- Primary (Darasa la 1-7) -->
    <div class="col-md-4 col-lg-2">
      <div class="stat-card">
        <div class="stat-icon bg-green">
          <i class="fa fa-school"></i>
        </div>
        <div class="stat-details">
          <h5>Primary Level</h5>
          <h3>{{ $primaryCount }}</h3>
          <small>Darasa la 1–7</small>
        </div>
      </div>
    </div>

    <!-- Secondary (Form 1-4) -->
    <div class="col-md-4 col-lg-2">
      <div class="stat-card">
        <div class="stat-icon bg-pink">
          <i class="fa fa-chalkboard-teacher"></i>
        </div>
        <div class="stat-details">
          <h5>Secondary Level</h5>
          <h3>{{ $secondaryCount }}</h3>
          <small>Form 1–4</small>
        </div>
      </div>
    </div>

    <!-- Baptized -->
    <div class="col-md-4 col-lg-2">
      <div class="stat-card">
        <div class="stat-icon bg-blue">
          <i class="fa fa-cross"></i>
        </div>
        <div class="stat-details">
          <h5>Baptized</h5>
          <h3>{{ $baptizedCount }}</h3>
          <small>Children</small>
        </div>
      </div>
    </div>

    <!-- Not Baptized -->
    <div class="col-md-4 col-lg-2">
      <div class="stat-card">
        <div class="stat-icon bg-yellow">
          <i class="fa fa-times-circle"></i>
        </div>
        <div class="stat-details">
          <h5>Not Baptized</h5>
          <h3>{{ $notBaptizedCount }}</h3>
          <small>Children</small>
        </div>
      </div>
    </div>
  </div>
</div>
