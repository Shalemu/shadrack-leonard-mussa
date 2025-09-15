<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - Double h</title>
<style>
    /* Basic Reset */
    * { margin:0; padding:0; box-sizing:border-box; font-family: 'Inter', sans-serif; }

    body {
        min-height: 100vh;
        background: url('https://images.unsplash.com/photo-1497294815431-9365093b7331?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80') no-repeat center center/cover;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .login-card {
        background: #fff;
        border-radius: 12px;
        width: 380px;
        box-shadow: 0 8px 30px rgba(0,0,0,0.3);
        overflow: hidden;
        text-align: center;
    }

    .login-card-header {
        background: linear-gradient(135deg, #333, #111);
        color: #fff;
        padding: 25px;
        font-size: 1.5rem;
        font-weight: bold;
    }

    .social-buttons {
        display: flex;
        justify-content: center;
        margin-top: 10px;
        gap: 15px;
    }

    .social-buttons a {
        display: inline-block;
        width: 40px; height: 40px;
        line-height: 40px;
        border-radius: 50%;
        background: #555;
        color: #fff;
        text-decoration: none;
        font-size: 1.1rem;
        transition: all 0.3s ease;
    }

    .social-buttons a:hover {
        background: #000;
    }

    .login-card-body {
        padding: 25px;
    }

    .login-card-body input[type="email"],
    .login-card-body input[type="password"] {
        width: 100%;
        padding: 12px 15px;
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 1rem;
    }

    .remember {
        display: flex;
        align-items: center;
        margin: 15px 0;
        font-size: 0.9rem;
        gap: 10px;
    }

    .login-card-body button {
        width: 100%;
        padding: 12px;
        border: none;
        border-radius: 8px;
        background: #111;
        color: #fff;
        font-size: 1rem;
        cursor: pointer;
        transition: 0.3s ease;
    }

    .login-card-body button:hover {
        background: #333;
    }

    .login-footer {
        margin-top: 15px;
        font-size: 0.9rem;
    }

    .login-footer a {
        color: #e91e63;
        text-decoration: none;
        font-weight: bold;
    }

</style>
</head>
<body>

<div class="login-card">
    <div class="login-card-header">Sign In</div>
    <!-- <div class="social-buttons">
        <a href="#"><i class="fa fa-facebook"></i></a>
        <a href="#"><i class="fa fa-github"></i></a>
        <a href="#"><i class="fa fa-google"></i></a>
    </div> -->
    <div class="login-card-body">
    
         <form method="POST" action="{{ route('login.submit') }}">


               @csrf
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <div class="remember">
                <input type="checkbox" name="remember" id="rememberMe" checked>
                <label for="rememberMe">Remember me</label>
            </div>
            <button type="submit">Sign In</button>
        </form>
        <div class="login-footer">
            Don't have an account? <a href="{{ route('register') }}">Sign up</a>
        </div>
    </div>
</div>

<!-- Font Awesome for icons -->
<script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>

</body>
</html>
