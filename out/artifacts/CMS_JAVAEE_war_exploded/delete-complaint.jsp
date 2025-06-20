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
    <style>
        :root {
            --glass-color: rgba(255, 255, 255, 0.1);
            --glass-border: 1px solid rgba(255, 255, 255, 0.2);
            --glass-blur: blur(14px);
            --glass-shadow: 0 8px 32px rgba(0, 0, 0, 0.35);
        }

        body {
            background: linear-gradient(135deg, #667eea, #764ba2);
            min-height: 100vh;
            color: white;
            padding-top: 5rem;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .glass-card {
            background: var(--glass-color);
            border: var(--glass-border);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            box-shadow: var(--glass-shadow);
            border-radius: 16px;
            padding: 2rem;
            max-width: 600px;
            width: 100%;
        }

        .btn-glass {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 50px;
            padding: 0.4rem 1.2rem;
            transition: all 0.3s ease;
        }

        .btn-glass:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
        }

        .alert-danger {
            background-color: rgba(255, 0, 0, 0.15);
            color: #ff6b6b;
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 12px;
        }

        h4, h5 {
            color: #fff;
        }

    </style>
</head>
<body>

<div class="glass-card text-center">
    <h4><i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Confirm Deletion</h4>
    <div class="alert alert-danger mt-4">
        <h5>Are you sure you want to delete complaint <strong><%= cid %></strong>?</h5>
        <p>This action is irreversible and will permanently remove the complaint from the system.</p>
    </div>

    <form action="delete-any-complaint" method="post">
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
