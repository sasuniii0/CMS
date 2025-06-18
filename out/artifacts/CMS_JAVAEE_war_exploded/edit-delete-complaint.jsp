<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.ijse.gdse.dto.ComplaintDTO" %>
<%
    // Check session first
    if (session == null || session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Get complaint object
    ComplaintDTO complaint = (ComplaintDTO) request.getAttribute("complaint");

    // Handle null complaint properly
    if (complaint == null) {
        session.setAttribute("error", "Complaint not found or you don't have permission to access it.");
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Complaint</title>
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
        .status-badge {
            padding: 5px 12px;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .status-pending {
            background-color: rgba(255, 234, 167, 0.3);
            color: #ffeaa7;
        }
        .status-resolved {
            background-color: rgba(85, 239, 196, 0.3);
            color: #55efc4;
        }
        .status-rejected {
            background-color: rgba(250, 177, 160, 0.3);
            color: #fab1a0;
        }
        .current-image {
            max-width: 200px;
            border-radius: 10px;
            margin-bottom: 15px;
            display: block;
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
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="mb-0"><i class="bi bi-pencil-square"></i> Edit Complaint</h4>
                    <span class="status-badge
                        <%= "RESOLVED".equalsIgnoreCase(complaint.getStatus()) ? "status-resolved" :
                           "REJECTED".equalsIgnoreCase(complaint.getStatus()) ? "status-rejected" : "status-pending" %>">
                        <%= complaint.getStatus() != null ? complaint.getStatus() : "PENDING" %>
                    </span>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/update-complaint" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="cid" value="<%= complaint.getCid() %>">
                        <input type="hidden" name="userId" value="<%= complaint.getUser_id() %>">

                        <div class="mb-3">
                            <label class="form-label">Title</label>
                            <input type="text" name="title" class="form-control"
                                   value="<%= complaint.getTitle() != null ? complaint.getTitle() : "" %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="5" required><%= complaint.getDescription() != null ? complaint.getDescription() : "" %></textarea>
                        </div>

                        <% if (complaint.getImage() != null && !complaint.getImage().isEmpty()) { %>
                        <div class="mb-3">
                            <label class="form-label">Current Image</label>
                            <img src="${pageContext.request.contextPath}/<%= complaint.getImage() %>" class="current-image">
                        </div>
                        <% } %>

                        <div class="mb-3">
                            <label class="form-label"><%= complaint.getImage() != null ? "Replace Image" : "Add Image" %> (optional)</label>
                            <input type="file" name="image" class="form-control" accept="image/*">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select name="status" class="form-select" required>
                                <option value="PENDING" <%= "PENDING".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Pending</option>
                                <option value="RESOLVED" <%= "RESOLVED".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Resolved</option>
                                <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Rejected</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Remarks</label>
                            <textarea name="remarks" class="form-control" rows="3"><%= complaint.getRemarks() != null ? complaint.getRemarks() : "" %></textarea>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="dashboard.jsp" class="btn btn-secondary me-md-2">
                                <i class="bi bi-x-circle"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary me-md-2">
                                <i class="bi bi-check-circle"></i> Update
                            </button>
                            <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/delete-complaint" method="post">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title fw-bold text-uppercase">
                        <i class="bi bi-exclamation-triangle"></i> Confirm Delete
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="cid" value="<%= complaint.getCid() %>">
                    <p>Are you sure you want to delete this complaint? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>