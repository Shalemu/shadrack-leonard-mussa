<style>
    .stat-card {
        display: flex;
        align-items: center;
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin: 15px 0;
        transition: 0.3s ease;
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
        margin-right: 15px;
    }

    .bg-blue { background: #4099ff; }
    .bg-pink { background: #FF5370; }
    .bg-green { background: #2ed8b6; }
    .bg-yellow { background: #FFB64D; }

    .stat-details h5 {
        margin: 0;
        font-size: 16px;
        color: #888;
    }

    .stat-details h3 {
        margin: 5px 0;
        font-size: 24px;
        color: #333;
    }

    .stat-details small {
        font-size: 12px;
        color: #4caf50;
    }

    .stat-details .down {
        color: #f44336;
    }
</style>

<div class="container">
    <div class="row">
        <!-- Male Youth -->
        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon bg-blue">
                    <i class="fa fa-mars"></i>
                </div>
                <div class="stat-details">
                    <h5>Male Youth</h5>
                    <h3>{{ $maleCount }}</h3>
                    <small>+4% from last week</small>
                </div>
            </div>
        </div>

        <!-- Female Youth -->
        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon bg-pink">
                    <i class="fa fa-venus"></i>
                </div>
                <div class="stat-details">
                    <h5>Female Youth</h5>
                    <h3>{{ $femaleCount }}</h3>
                    <small>+3% from last month</small>
                </div>
            </div>
        </div>

        <!-- Married Youth -->
        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon bg-green">
                    <i class="fa fa-ring"></i>
                </div>
                <div class="stat-details">
                    <h5>Married Youth</h5>
                    <h3>{{ $marriedCount }}</h3>
                    <small class="down">-2% from yesterday</small>
                </div>
            </div>
        </div>

        <!-- Unmarried Youth -->
        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon bg-yellow">
                    <i class="fa fa-user-times"></i>
                </div>
                <div class="stat-details">
                    <h5>Unmarried Youth</h5>
                    <h3>{{ $unmarriedCount }}</h3>
                    <small>+5% from yesterday</small>
                </div>
            </div>
        </div>
    </div>
</div>
