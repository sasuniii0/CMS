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
<html>
<head>
    <title>Delete Complaint</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { padding: 2rem; }
        .confirmation-card { max-width: 600px; margin: 0 auto; }
    </style>
</head>
<body>
<div class="container">
    <div class="card confirmation-card">
        <div class="card-header bg-danger text-white">
            <h4 class="mb-0">Confirm Deletion</h4>
        </div>
        <div class="card-body">
            <div class="alert alert-danger">
                <h5>Delete Complaint <%= cid %>?</h5>
                <p>This action cannot be undone.</p>
            </div>

            <form action="delete-any-complaint" method="post">
                <input type="hidden" name="cid" value="<%= cid %>">

                <div class="d-flex justify-content-between">
                    <a href="viewAllComplaints" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-danger">
                        Confirm Delete
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>