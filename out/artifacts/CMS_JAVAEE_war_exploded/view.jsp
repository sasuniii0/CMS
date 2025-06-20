<%@ page import="java.util.List" %>
<%@ page import="lk.ijse.gdse.bean.ComplaintDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session == null || session.getAttribute("user_id") == null) {
    response.sendRedirect("index.jsp");
    return;
  }

  List<ComplaintDTO> complaints = (List<ComplaintDTO>) request.getAttribute("complaint");
  String error = request.getParameter("error");
  String success = request.getParameter("success");
  String deleted = request.getParameter("deleted");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Complaints</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <link href="css/view.css" rel="stylesheet">
</head>
<body>
<div class="container">
  <div class="glass-card">
    <% if (error != null) { %>
    <div class="alert alert-danger"><strong>Error:</strong> <%= error %></div>
    <% } %>

    <% if (success != null) { %>
    <div class="alert alert-success">Complaint updated successfully!</div>
    <% } %>

    <% if ("true".equals(deleted)) { %>
    <div class="alert alert-success">Complaint deleted successfully!</div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mb-4">
      <h3><i class="bi bi-list-ul"></i> My Complaints</h3>
      <div class="d-flex gap-2">
        <a href="dashboard.jsp" class="btn-glass"><i class="bi bi-back"></i> Dashboard</a>
        <a href="viewMyComplaints" class="btn-glass"><i class="bi bi-arrow-clockwise"></i> Refresh</a>
        <a href="submit-complaint.jsp" class="btn-glass"><i class="bi bi-plus-circle"></i> New</a>
      </div>
    </div>

    <div class="table-responsive">
      <table class="table table-hover align-middle">
        <thead>
        <tr>
          <th>Title</th>
          <th>Description</th>
          <th>Image</th>
          <th>Status</th>
          <th>Remarks</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (complaints != null && !complaints.isEmpty()) {
          for (ComplaintDTO complaint : complaints) { %>
        <tr>
          <td><%= complaint.getTitle() %></td>
          <td><%= complaint.getDescription() %></td>
          <td>
            <% if (complaint.getImage() != null && !complaint.getImage().isEmpty()) { %>
            <img src="<%= request.getContextPath() + "/" + complaint.getImage() %>" class="complaint-image-thumb" alt="Image">
            <% } else { %>
            <span class="text-muted">No image</span>
            <% } %>
          </td>
          <td>
            <% if ("PENDING".equals(complaint.getStatus())) { %>
            <span class="status-badge status-pending">Pending</span>
            <% } else if ("RESOLVED".equals(complaint.getStatus())) { %>
            <span class="status-badge status-resolved">Resolved</span>
            <% } else { %>
            <span class="status-badge"><%= complaint.getStatus() %></span>
            <% } %>
          </td>
          <td><%= (complaint.getRemarks() != null && !complaint.getRemarks().isEmpty()) ? complaint.getRemarks() : "No remarks" %></td>
          <td class="action-buttons">
            <% if ("PENDING".equals(complaint.getStatus())) { %>
            <form action="update-complaint" method="post">
              <input type="hidden" name="cid" value="<%= complaint.getCid() %>">
              <button type="submit" class="btn btn-sm btn-primary">
                <i class="bi bi-pencil"></i> Edit
              </button>
            </form>
            <form action="delete-complaint" method="post" onsubmit="return confirm('Are you sure?');">
              <input type="hidden" name="cid" value="<%= complaint.getCid() %>">
              <button type="submit" class="btn btn-sm btn-danger">
                <i class="bi bi-trash"></i> Delete
              </button>
            </form>
            <% } else { %>
            <span class="text-muted">No actions</span>
            <% } %>
          </td>
        </tr>
        <% } } else { %>
        <tr>
          <td colspan="6" class="text-center text-white">No complaints found.</td>
        </tr>
        <% } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
