<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="lk.ijse.gdse.bean.ComplaintDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    List<ComplaintDTO> complaints = (List<ComplaintDTO>) request.getAttribute("complaintsList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Complaints | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link href="css/viewAll.css" rel="stylesheet">

</head>
<body>
<div class="container">
    <div class="glass-card">
        <h2 class="mb-4"><i class="bi bi-collection me-2"></i>All Complaints</h2>

        <% if (request.getParameter("deleted") != null) { %>
        <div class="alert alert-<%= "true".equals(request.getParameter("deleted")) ? "success" : "danger" %>">
            <%= "true".equals(request.getParameter("deleted")) ?
                    "Complaint deleted successfully" : "Failed to delete complaint" %>
        </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
            Error: <%= request.getParameter("error") %>
        </div>
        <% } %>

        <div class="d-flex gap-2 mb-3">
            <a href="${pageContext.request.contextPath}/viewAllComplaints" class="btn-glass">
                <i class="bi bi-arrow-clockwise"></i> Refresh
            </a>
            <a href="dashboard.jsp" class="btn-glass">
                <i class="bi bi-house-door"></i> Dashboard
            </a>
        </div>

        <% if (complaints == null || complaints.isEmpty()) { %>
        <div class="alert alert-info">No complaints found. Try refreshing the table.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Image</th>
                    <th>Remarks</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (ComplaintDTO complaint : complaints) { %>
                <tr>
                    <td><%= complaint.getTitle() %></td>
                    <td><%= complaint.getDescription() %></td>
                    <td>
                        <% if (complaint.getImage() != null) { %>
                        <img src="<%= complaint.getImage() %>" alt="Complaint Image" class="img-thumb">
                        <% } else { %>
                        <span class="text-muted">No image</span>
                        <% } %>
                    </td>
                    <td><%= complaint.getRemarks() != null ? complaint.getRemarks() : "No remarks" %></td>
                    <td>
                                <span class="badge bg-<%= complaint.getStatus().equalsIgnoreCase("resolved") ? "success" :
                                                        complaint.getStatus().equalsIgnoreCase("rejected") ? "danger" : "warning" %>">
                                    <%= complaint.getStatus().toUpperCase() %>
                                </span>
                    </td>
                    <td>
                        <a href="updateStatus?cid=<%= complaint.getCid() %>" class="btn btn-sm btn-outline-primary me-2">
                            <i class="bi bi-pencil-square"></i> Edit
                        </a>
                        <a href="delete-any-complaint?cid=<%= URLEncoder.encode(complaint.getCid(), "UTF-8") %>"
                           class="btn btn-sm btn-danger"
                           onclick="return confirm('Are you sure you want to delete this complaint?')">
                            <i class="bi bi-trash"></i> Delete
                        </a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
