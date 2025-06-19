<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session == null || session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    String deleted = request.getParameter("deleted");
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
        .alert-danger {
            background-color: rgba(255, 107, 107, 0.2);
            border-color: rgba(255, 107, 107, 0.3);
            color: #ff6b6b;
        }
        .alert-success {
            background-color: rgba(85, 239, 196, 0.2);
            border-color: rgba(85, 239, 196, 0.3);
            color: #55efc4;
        }
        .complaint-image {
            max-width: 100%;
            max-height: 300px;
            border-radius: 8px;
            margin-bottom: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
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

            <% if (success != null) { %>
            <div class="alert alert-success alert-dismissible fade show mb-4">
                Complaint updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <% if (deleted != null) { %>
            <div class="alert alert-success alert-dismissible fade show mb-4">
                Complaint deleted successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <div class="card shadow">
                <div class="card-header">
                    <h4 class="mb-0"><i class="bi bi-pencil-square"></i> Edit Complaint</h4>
                </div>
                <div class="card-body">
                    <c:if test="${not empty complaint}">
                        <form action="${pageContext.request.contextPath}/update-complaint" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="${complaint.cid}">

                            <div class="mb-3">
                                <label class="form-label">Title</label>
                                <input type="text" name="title" class="form-control" value="${complaint.title}" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" rows="5" required>${complaint.description}</textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Status</label>
                                <select name="status" class="form-select" required>
                                    <option value="PENDING" ${complaint.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                    <option value="IN_PROGRESS" ${complaint.status == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                                    <option value="RESOLVED" ${complaint.status == 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                                    <option value="REJECTED" ${complaint.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Remarks</label>
                                <textarea name="remarks" class="form-control" rows="3">${complaint.remarks}</textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Current Image</label>
                                <c:if test="${not empty complaint.image}">
                                    <img src="${pageContext.request.contextPath}/${complaint.image}" class="complaint-image" alt="Complaint Image">
                                </c:if>
                                <c:if test="${empty complaint.image}">
                                    <p class="text-muted">No image uploaded</p>
                                </c:if>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Update Image (optional)</label>
                                <input type="file" name="image" class="form-control" accept="image/*">
                                <small class="text-muted">Leave blank to keep current image</small>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-between">
                                <a href="${pageContext.request.contextPath}/delete-complaint?cid=${complaint.cid}"
                                   class="btn btn-danger me-md-2"
                                   onclick="return confirm('Are you sure you want to delete this complaint?');">
                                    <i class="bi bi-trash"></i> Delete Complaint
                                </a>
                                <div>
                                    <a href="${pageContext.request.contextPath}/viewMyComplaints" class="btn btn-secondary me-md-2">
                                        <i class="bi bi-arrow-left"></i> Back to List
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save"></i> Update Complaint
                                    </button>
                                </div>
                            </div>
                        </form>
                    </c:if>
                    <c:if test="${empty complaint}">
                        <div class="alert alert-danger">
                            Complaint not found or you don't have permission to edit it.
                        </div>
                        <a href="${pageContext.request.contextPath}/viewMyComplaints" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Back to List
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>