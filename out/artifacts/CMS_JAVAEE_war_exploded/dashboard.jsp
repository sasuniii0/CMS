<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("role") == null) {
        response.sendRedirect("/index.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Complaint Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --glass-color: rgba(255, 255, 255, 0.15);
            --glass-border: 1px solid rgba(255, 255, 255, 0.2);
            --glass-blur: blur(10px);
            --glass-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
        }

        body {
            background:
                    linear-gradient(rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0.05)),
                    linear-gradient(135deg, #667eea 0%, #764ba2 100%) fixed;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            min-height: 100vh;
            color: white;
            padding-top: 3rem;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .glass-card {
            background: var(--glass-color);
            border: var(--glass-border);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            box-shadow: var(--glass-shadow);
            border-radius: 15px;
            transition: all 0.3s ease;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        .action-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            border: var(--glass-border);
        }

        .action-card:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }

        .btn-glass {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }

        .btn-glass:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
        }

        .user-info {
            background: rgba(0, 0, 0, 0.2);
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }

        .role-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="glass-card">
        <div class="user-info text-center mb-4">
            <h1 class="display-5 fw-bold">Welcome to the Dashboard</h1>
            <p class="lead">Logged in as: <strong><%= email %></strong>
                <span class="role-badge"><%= role %></span>
            </p>
        </div>

        <% if ("admin".equalsIgnoreCase(role)) { %>
        <div class="row">
            <h2 class="mb-4"><i class="bi bi-shield-lock me-2"></i>Admin Actions</h2>

            <div class="col-md-4">
                <a href="view-all-complaints.jsp" class="text-decoration-none">
                    <div class="action-card">
                        <h4><i class="bi bi-list-ul me-2"></i>View All Complaints</h4>
                        <p class="mb-0 text-white-50">View and manage all system complaints</p>
                    </div>
                </a>
            </div>

            <div class="col-md-4">
                <a href="update-status.jsp" class="text-decoration-none">
                    <div class="action-card">
                        <h4><i class="bi bi-pencil-square me-2"></i>Update Status</h4>
                        <p class="mb-0 text-white-50">Update complaint status and remarks</p>
                    </div>
                </a>
            </div>

            <div class="col-md-4">
                <a href="delete-complaint.jsp" class="text-decoration-none">
                    <div class="action-card">
                        <h4><i class="bi bi-trash me-2"></i>Delete Complaint</h4>
                        <p class="mb-0 text-white-50">Remove complaints from the system</p>
                    </div>
                </a>
            </div>
        </div>
        <% } else if ("employee".equalsIgnoreCase(role)) { %>
        <div class="row">
            <h2 class="mb-4"><i class="bi bi-person me-2"></i>Employee Actions</h2>

            <div class="col-md-4">
                <a href="submit-complaint.jsp" class="text-decoration-none">
                    <div class="action-card" id="submit">
                        <h4><i class="bi bi-plus-circle me-2"></i>Submit Complaint</h4>
                        <p class="mb-0 text-white-50">Create a new complaint ticket</p>
                    </div>
                </a>
            </div>

            <div class="col-md-4">
                <a href="view.jsp" class="text-decoration-none">
                    <div class="action-card" id="view">
                        <h4><i class="bi bi-pencil me-2"></i>Edit/Delete</h4>
                        <p class="mb-0 text-white-50">Manage your existing complaints</p>
                    </div>
                </a>
            </div>

            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/viewMyComplaints" class="text-decoration-none">
                    <div class="action-card" id="update">
                        <h4><i class="bi bi-collection me-2"></i>My Complaints</h4>
                        <p class="mb-0 text-white-50">View your submitted complaints</p>
                    </div>
                </a>
            </div>
        </div>
        <% } %>

        <div class="text-center mt-4">
            <form method="post" action="${pageContext.request.contextPath}/logout">
                <button type="submit" class="btn-glass">
                    <i class="bi bi-box-arrow-right me-2"></i>Logout
                </button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>