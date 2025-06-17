<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>LogIn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <style>
        body {
            background: url("assets/login-bg.jpg") no-repeat center center fixed;
            background-size: cover;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .glass-card {
            max-width: 400px;
            margin: 100px auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: white;
        }
        .form-control {
            background-color: rgba(255, 255, 255, 0.1);
            border: none;
            color: #fff;
        }

        .form-control::placeholder {
            color: #ccc;
        }

        h1 {
            text-align: center;
            color: #fff;
            margin-bottom: 30px;
        }

        .btn-info {
            background-color: rgba(0, 123, 255, 0.7);
            border: none;
        }

        .btn-info:hover {
            background-color: rgba(0, 123, 255, 0.9);
        }
    </style>
</head>
<body>

<section class="container">
    <div class="glass-card">
        <h1>Login</h1>
        <form method="get" action="${pageContext.request.contextPath}/signin">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" placeholder="email@gmail.com" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="****" required>
            </div>
            <button type="submit" class="btn btn-primary w-100 mb-2">Login</button>
            <a href="signup.jsp" class="btn btn-info w-100 text-white">Sign Up</a>
        </form>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>

</body>
</html>
