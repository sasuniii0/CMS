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
    <link rel="stylesheet" href="css/dashboard.css">

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