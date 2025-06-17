<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>SignUp</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT"
      crossorigin="anonymous"
    />
    <style>
      body {
        background: url("assets/login-bg.jpg") no-repeat center center fixed;
        background-size: cover;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }

      .glass-card {
        max-width: 500px;
        margin: 80px auto;
        padding: 40px;
        background: rgba(255, 255, 255, 0.08);
        border-radius: 16px;
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.18);
        color: #fff;
      }

      h2 {
        text-align: center;
        margin-bottom: 30px;
        color: #fff;
      }

      .form-label {
        color: #fff;
      }

      .form-control {
        background-color: rgba(255, 255, 255, 0.1);
        border: none;
        color: #fff;
      }

      .form-control::placeholder {
        color: #ccc;
      }

      .btn-info {
        background-color: rgba(0, 123, 255, 0.7);
        border: none;
      }

      .btn-info:hover {
        background-color: rgba(0, 123, 255, 0.9);
      }
      select.form-control {
        background-color: rgba(255, 255, 255, 0.1);
        color: #fff;
      }

      select.form-control option {
        color: #000;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="glass-card">
        <h2>Create an Account</h2>
        <form method="get" action="/signup">
          <div class="mb-3">
            <label for="fullName" class="form-label">Full Name</label>
            <input
              type="text"
              class="form-control"
              id="fullName"
              placeholder="John Doe"
              name="fullName"
              required
            />
          </div>

          <div class="mb-3">
            <label for="email" class="form-label">Email address</label>
            <input
              type="email"
              class="form-control"
              id="email"
              placeholder="example@mail.com"
              name="email"
              required
            />
          </div>

          <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input
              type="password"
              class="form-control"
              id="password"
              placeholder="********"
              name="password"
              required
            />
          </div>

          <div class="mb-3">
            <label for="confirmPassword" class="form-label"
              >Confirm Password</label
            >
            <input
              type="password"
              class="form-control"
              id="confirmPassword"
              placeholder="********"
              name="confirmPassword"
              required
            />
          </div>

          <div class="mb-3">
            <label for="role" class="form-label">Select Role</label>
            <select class="form-control" id="role" name="role" required>
              <option value="" disabled selected>Select Role</option>
              <option value="admin">Admin</option>
              <option value="employee">Employee</option>
            </select>
          </div>

          <button type="submit" class="btn btn-info w-100 text-white">
            Sign Up
          </button>
        </form>
      </div>
    </div>

    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO"
      crossorigin="anonymous"
    ></script>
  </body>
</html>
