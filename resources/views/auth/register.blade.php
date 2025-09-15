<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register - Double h</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family: 'Inter', sans-serif; }

    body {
        min-height: 100vh;
        background: url('https://images.unsplash.com/photo-1497294815431-9365093b7331?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80') no-repeat center center/cover;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .register-card {
        background: #fff;
        border-radius: 12px;
        width: 400px;
        box-shadow: 0 8px 30px rgba(0,0,0,0.3);
        overflow: hidden;
        text-align: center;
    }

    .register-card-header {
        background: linear-gradient(135deg, #333, #111);
        color: #fff;
        padding: 25px;
        font-size: 1.5rem;
        font-weight: bold;
    }

    .register-card-body {
        padding: 25px;
    }

    .register-card-body input {
        width: 100%;
        padding: 12px 15px;
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 1rem;
    }

    .register-card-body button {
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

    .register-card-body button:hover {
        background: #333;
    }

    .register-footer {
        margin-top: 15px;
        font-size: 0.9rem;
    }

    .register-footer a {
        color: #e91e63;
        text-decoration: none;
        font-weight: bold;
    }
</style>
</head>
<body>

<div class="register-card">
    <div class="register-card-header">Sign Up</div>
    <div class="register-card-body">
            <form method="POST" action="{{ route('register') }}">

            @csrf
            <input type="text" name="name" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="password" name="password_confirmation" placeholder="Confirm Password" required>
            <button type="submit">Create Account</button>
        </form>
        <div class="register-footer">
            Already have an account? <a href="{{ route('login') }}">Sign in</a>
        </div>
    </div>
</div>

</body>
</html>
