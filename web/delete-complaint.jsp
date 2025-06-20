<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder" %>
<%
    // Admin authorization check
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    String cid = (String) request.getAttribute("cid");
    if (cid == null || cid.trim().isEmpty()) {
        response.sendRedirect("viewAllComplaints?error=missing_id");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Confirm Deletion | Complaint</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/delete-complaint.css">
</head>
<body>

<div class="glass-card text-center">
    <h4><i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Confirm Deletion</h4>
    <div class="alert alert-danger mt-4">
        <h5>Are you sure you want to delete complaint <strong><%= cid %></strong>?</h5>
        <p>This action is irreversible and will permanently remove the complaint from the system.</p>
    </div>

    <form action="${pageContext.request.contextPath}/delete-any-complaint" method="post">
        <input type="hidden" name="cid" value="<%= cid %>">
        <div class="d-flex justify-content-between mt-4">
            <a href="viewAllComplaints" class="btn-glass">
                <i class="bi bi-x-circle"></i> Cancel
            </a>
            <button type="submit" class="btn btn-danger">
                <i class="bi bi-trash-fill"></i> Confirm Delete
            </button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
