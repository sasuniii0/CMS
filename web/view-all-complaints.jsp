<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="lk.ijse.gdse.dto.ComplaintDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%
    // Authorization check
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Get data from servlet
    List<ComplaintDTO> complaints = (List<ComplaintDTO>) request.getAttribute("complaintsList");
    System.out.println(complaints);


 if (request.getParameter("deleted") != null) { %>
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

<!DOCTYPE html>
<html>
<head>
    <title>Complaints List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 50px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            min-height: 100vh;
            color: #fff;
            font-family: 'Segoe UI', sans-serif;
            backdrop-filter: blur(4px);
        }

        .table {
            color: white;
            margin-bottom: 0;
        }
        .table th {
            border-bottom: 1px solid rgba(255, 255, 255, 0.15);
        }
        .table td {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            vertical-align: middle;
        }
        .btn-light {
            background-color: #a29bfe;
            color: #fff;
            border: none;
        }
        .btn-light:hover {
            background-color: #6c5ce7;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">All Complaints</h2>
    <div>
        <a href="${pageContext.request.contextPath}/viewAllComplaints" class="btn btn-light mb-3"><i class="bi bi-plus-circle me-2"></i>Refresh All Complaints</a></a>
        <a href="dashboard.jsp" class="btn btn-secondary mb-3" >Back to Dashboard</a>
    </div>




    <% if (complaints == null || complaints.isEmpty()) { %>
    <div class="alert alert-info">Refresh The Table</div>
    <% } else { %>
    <table class="table table-hover">
        <thead>
        <tr>
            <th>Complaint ID</th>
            <th>Title</th>
            <th>Description</th>
            <th>Image</th>
            <th>Status</th>
            <th>Actions</th> <!-- Add this column header -->
        </tr>
        </thead>
        <tbody>
        <% for (ComplaintDTO complaint : complaints) { %>
        <tr>
            <td><%= complaint.getCid() %></td>
            <td><%= complaint.getTitle() %></td>
            <td><%= complaint.getDescription() %></td>
            <td>
                <% if (complaint.getImage() != null) { %>
                <img src="<%= complaint.getImage() %>" alt="Complaint Image" class="img-fluid" width="100">
                <% } else { %>
                <span class="text-muted">No image available</span>
                <% } %>
            </td>
            <td>
                <span class="badge bg-<%= complaint.getStatus().equals("resolved") ? "success" :
                                       complaint.getStatus().equals("rejected") ? "danger" : "warning" %>">
                    <%= complaint.getStatus().toUpperCase() %>
                </span>
            </td>
            <td>
                <!-- Edit button -->
                <a href="updateStatus?cid=<%= complaint.getCid() %>"
                   class="btn btn-sm btn-outline-primary me-2">
                    Edit
                </a>

                <!-- Delete button - ADD THIS -->
                <a href="delete-any-complaint?cid=<%= URLEncoder.encode(complaint.getCid(), "UTF-8") %>"
                   class="btn btn-sm btn-danger"
                   onclick="return confirm('Are you sure you want to delete this complaint?')">
                    Delete
                </a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>

</div>
</body>
</html>