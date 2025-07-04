<%@ page import="lk.ijse.gdse.bean.ComplaintDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Admin authorization check
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    ComplaintDTO complaint = (ComplaintDTO) request.getAttribute("complaint");
    if (complaint == null) {
        response.sendRedirect("viewAllComplaints");

        return;
    }

    if (complaint.getStatus().equals("resolved") || complaint.getStatus().equals("rejected")) {
        if (complaint.getRemarks() == null || complaint.getRemarks().trim().isEmpty()) {
            response.sendRedirect("viewAllComplaints");
            return;
        }
    }

    String error = (String) request.getAttribute("error");

%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Complaint Status</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/update.css">

</head>
<body>
<div class="container">
    <div class="card complaint-card">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">Update Complaint Status</h4>
        </div>


        <div class="card-body">
            <form action="updateStatus" method="post">
                <input type="hidden" name="cid" value="<%= complaint.getCid() %>">

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Complaint ID</label>
                        <input type="text" class="form-control readonly-field"
                               value="<%= complaint.getCid() %>" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Current Status</label>
                        <div>
                                <span class="status-badge badge-<%= complaint.getStatus() %>">
                                    <%= complaint.getStatus().toUpperCase() %>
                                </span>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Title</label>
                    <input type="text" class="form-control readonly-field"
                           value="<%= complaint.getTitle() %>" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea class="form-control readonly-field" rows="3" readonly><%= complaint.getDescription() %></textarea>
                </div>

                <div class="mb-3">
                    <label for="status" class="form-label fw-bold">New Status</label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="pending" <%= "pending".equals(complaint.getStatus()) ? "selected" : "" %>>Pending</option>
                        <option value="resolved" <%= "resolved".equals(complaint.getStatus()) ? "selected" : "" %>>Resolved</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="remarks" class="form-label fw-bold">Remarks</label>
                    <textarea class="form-control" id="remarks" name="remarks" rows="3" required><%= complaint.getRemarks() != null ? complaint.getRemarks() : "" %></textarea>
                    <div class="form-text">Please provide details about the status update</div>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <a href="viewAllComplaints" class="btn btn-secondary px-4">Back to List</a>
                    <button type="submit" class="btn btn-primary px-4">Update Status</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/update.js" type="module"></script>
</body>
</html>