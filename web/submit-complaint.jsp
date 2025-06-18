<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Submit Complaint</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            padding-top: 50px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            min-height: 100vh;
            color: #fff;
            font-family: 'Segoe UI', sans-serif;
            backdrop-filter: blur(4px);
        }
        .card {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            color: white;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35);
        }
        .card-header {
            border-bottom: 1px solid rgba(255, 255, 255, 0.15);
        }
        .form-control, .form-select {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }
        .btn-light {
            background-color: #a29bfe;
            color: #fff;
            border: none;
        }
        .btn-light:hover {
            background-color: #6c5ce7;
        }
        .btn-outline-primary {
            border-color: #a29bfe;
            color: #a29bfe;
        }
        .btn-outline-primary:hover {
            background-color: #a29bfe;
            color: #fff;
        }
        .alert-danger {
            background-color: rgba(255, 107, 107, 0.2);
            border-color: rgba(255, 107, 107, 0.3);
            color: #ff6b6b;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show mb-4">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <div class="card shadow">
                <div class="card-header">
                    <h4 class="mb-0"><i class="bi bi-plus-circle"></i> Submit New Complaint</h4>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/complaint" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="save">
                        <input type="hidden" name="userId" value="${sessionScope.user_id}">

                        <div class="mb-3">
                            <label class="form-label">Title</label>
                            <input type="text" name="title" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="5" required></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Image (optional)</label>
                            <input type="file" name="image" class="form-control" accept="image/*">
                            <small class="text-muted">Max file size: 2MB</small>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="dashboard.jsp" class="btn btn-secondary me-md-2">
                                <i class="bi bi-arrow-left"></i> Back to Dashboard
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send"></i> Submit Complaint
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>