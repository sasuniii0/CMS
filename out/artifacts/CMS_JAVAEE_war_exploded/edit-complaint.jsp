<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.ijse.gdse.bean.ComplaintDTO" %>
<%
    ComplaintDTO complaint = (ComplaintDTO) request.getAttribute("complaint");
    if (complaint == null) {
        response.sendRedirect(request.getContextPath() + "/viewMyComplaints?error=complaint_not_found");
        return;
    }

    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Complaint</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .preview-image {
            max-width: 300px;
            max-height: 200px;
            margin-top: 10px;
        }
    </style>
</head>
<body class="bg-light py-5">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Update Complaint</h4>
                </div>

                <% if (error != null) { %>
                <div class="alert alert-danger m-3">
                    <%= switch(error) {
                        case "required_fields" -> "Please fill all required fields";
                        case "update_failed" -> "Failed to update complaint";
                        case "server_error" -> "Server error occurred";
                        default -> "An error occurred";
                    } %>
                </div>
                <% } %>

                <% if (success != null) { %>
                <div class="alert alert-success m-3">
                    Complaint updated successfully!
                </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/update-complaint" method="post" enctype="multipart/form-data">
                    <div class="card-body">
                        <input type="hidden" name="cid" value="<%= complaint.getCid() %>">

                        <div class="mb-3">
                            <label for="title" class="form-label">Title *</label>
                            <input type="text" id="title" name="title" class="form-control"
                                   value="<%= complaint.getTitle() %>" required maxlength="100">
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Description *</label>
                            <textarea id="description" name="description" class="form-control"
                                      rows="5" required><%= complaint.getDescription() %></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="status" class="form-label">Status</label>
                            <select id="status" name="status" class="form-select" required>
                                <option value="PENDING" <%= "PENDING".equals(complaint.getStatus()) ? "selected" : "" %>>Pending</option>
                                <option value="RESOLVED" <%= "RESOLVED".equals(complaint.getStatus()) ? "selected" : "" %>>Resolved</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="remarks" class="form-label">Remarks</label>
                            <textarea id="remarks" name="remarks" class="form-control" rows="3"><%=
                            complaint.getRemarks() != null ? complaint.getRemarks() : ""
                            %></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="image" class="form-label">Update Image</label>
                            <input type="file" id="image" name="image" class="form-control" accept="image/*">

                            <% if (complaint.getImage() != null && !complaint.getImage().isEmpty()) { %>
                            <div class="mt-3">
                                <p>Current Image:</p>
                                <img src="<%= request.getContextPath() %>/<%= complaint.getImage() %>"
                                     class="img-thumbnail preview-image" alt="Current complaint image">
                            </div>
                            <% } %>

                            <div id="imagePreview" class="mt-3"></div>
                        </div>
                    </div>

                    <div class="card-footer text-end">
                        <a href="<%= request.getContextPath() %>/viewMyComplaints" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">Update Complaint</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Image preview functionality
    document.getElementById('image').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file && file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function(event) {
                const preview = document.getElementById('imagePreview');
                preview.innerHTML = `<p>New Image Preview:</p>
                                   <img src="${event.target.result}"
                                        class="img-thumbnail preview-image"
                                        alt="Preview of new image">`;
            };
            reader.readAsDataURL(file);
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>