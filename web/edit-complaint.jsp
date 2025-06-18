<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.ijse.gdse.dto.ComplaintDTO" %>
<%@ page import="java.util.List" %>

<%
    // Prevent direct access to view.jsp without going through servlet
    if (request.getAttribute("complaints") == null) {
        response.sendRedirect(request.getContextPath() + "/viewMyComplaints");
        return;
    }

    // Get user ID from session for additional security
    if (session == null || session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Complaints</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            padding-top: 50px;
            background: linear-gradient(135deg, #667eea, #764ba2) fixed;
            min-height: 100vh;
            color: #fff;
            font-family: 'Segoe UI', sans-serif;
            backdrop-filter: blur(2px);
        }

        .card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
            color: white;
        }

        .card-header {
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .table {
            color: white;
        }

        .table thead {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(8px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .modal-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: white;
        }

        .btn-close-white {
            filter: brightness(0) invert(1);
        }

        .form-control,
        .form-select {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }

        .form-control::placeholder,
        .form-select option {
            color: rgba(255, 255, 255, 0.6);
        }

        .modal-body img {
            border-radius: 10px;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            backdrop-filter: blur(4px);
        }

        .status-pending {
            background-color: rgba(255, 243, 205, 0.3);
            color: #f1c40f;
        }

        .status-resolved {
            background-color: rgba(212, 237, 218, 0.3);
            color: #2ecc71;
        }

        .status-rejected {
            background-color: rgba(248, 215, 218, 0.3);
            color: #e74c3c;
        }

    </style>
</head>
<body >
<div class="container">
    <div class="card shadow">
        <div class="card-header text-white d-flex justify-content-between align-items-center">
            <h4 class="mb-0">Edit Complaints</h4>

            <div>
                <a href="dashboard.jsp" class="btn btn-secondary me-md-2">
                    <i class="bi bi-arrow-left"></i> Back to Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/viewMyComplaints" class="btn btn-info me-md-2">
                    <i class="bi bi-arrow-clockwise"></i> Refresh
                </a>
            </div>

        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>Title</th>
                        <th>Image</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Remarks</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<ComplaintDTO> complaints = (List<ComplaintDTO>) request.getAttribute("complaints");
                        if (complaints == null || complaints.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="6" class="text-center">
                            No complaints found.
                            <a href="${pageContext.request.contextPath}/viewMyComplaints" class="btn btn-sm btn-link">Try again</a>
                        </td>
                    </tr>
                    <%
                    } else {
                        for (ComplaintDTO complaint : complaints) {
                    %>
                    <tr>
                        <td><%= complaint.getTitle() %></td>
                        <td>
                            <% if (complaint.getImage() != null && !complaint.getImage().isEmpty()) { %>
                            <img src="data:image/jpeg;base64,<%= complaint.getImage() %>"
                                 width="50"
                                 data-bs-toggle="modal"
                                 data-bs-target="#imageModal"
                                 data-image="data:image/jpeg;base64,<%= complaint.getImage() %>" />
                            <% } %>
                        </td>
                        <td title="<%= complaint.getDescription() != null ? complaint.getDescription() : "" %>">
                            <%= complaint.getDescription() != null ?
                                    (complaint.getDescription().length() > 50 ?
                                            complaint.getDescription().substring(0, 50) + "..." :
                                            complaint.getDescription())
                                    : "" %>
                        </td>
                        <td>
                  <span class="status-badge
    <%= complaint.getStatus() == null ? "status-pending" :
       complaint.getStatus().equals("PENDING") ? "status-pending" :
       complaint.getStatus().equals("RESOLVED") ? "status-resolved" : "status-rejected" %>">
    <%= complaint.getStatus() == null ? "PENDING" : complaint.getStatus() %>
</span>
                        </td>
                        <td><%= complaint.getRemarks() != null ? complaint.getRemarks() : "" %></td>
                        <td >
                            <button class="btn btn-sm btn-outline-primary edit-btn"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editComplaintModal"
                                    data-id="<%= complaint.getCid() %>"
                                    data-userid="<%= complaint.getUser_id() %>"
                                    data-title="<%= complaint.getTitle() %>"
                                    data-description="<%= complaint.getDescription() %>"
                                    data-status="<%= complaint.getStatus() %>"
                                    data-remarks="<%= complaint.getRemarks() != null ? complaint.getRemarks() : "" %>">
                                <i class="bi bi-pencil"></i> Edit
                            </button>
                            <button class="btn btn-sm btn-outline-danger delete-btn"
                                    data-bs-toggle="modal"
                                    data-bs-target="#deleteModal"
                                    data-id="<%= complaint.getCid() %>">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Edit Complaint Modal -->
<div class="modal fade" id="editComplaintModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/update-complaint" method="post" enctype="multipart/form-data">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold">Edit Complaint</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="id" id="editId">
                    <input type="hidden" name="userId" id="editUserId">

                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" name="title" id="editTitle" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" id="editDescription" class="form-control" rows="4" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select name="status" id="editStatus" class="form-select" required>
                            <option value="PENDING">Pending</option>
                            <option value="RESOLVED">Resolved</option>
                            <option value="REJECTED">Rejected</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Remarks</label>
                        <textarea name="remarks" id="editRemarks" class="form-control" rows="3"></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Update Image (optional)</label>
                        <input type="file" name="image" class="form-control" accept="image/*">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Complaint</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Complaint Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/delete-complaint" method="post">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="cid" id="deleteId">
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


<div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-body text-center">
                <img id="modalImage" src="" class="img-fluid" alt="Complaint Image">
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.querySelectorAll('.edit-btn').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('editId').value = this.getAttribute('data-id');
            document.getElementById('editUserId').value = this.getAttribute('data-userid');
            document.getElementById('editTitle').value = this.getAttribute('data-title');
            document.getElementById('editDescription').value = this.getAttribute('data-description');
            document.getElementById('editStatus').value = this.getAttribute('data-status');
            document.getElementById('editRemarks').value = this.getAttribute('data-remarks');
        });
    });

    document.querySelectorAll('.delete-btn').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('deleteId').value = this.getAttribute('data-id');
        });
    });

    const imageModal = document.getElementById('imageModal');
    if (imageModal) {
        imageModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const imageSrc = button.getAttribute('data-image');
            const modalImage = document.getElementById('modalImage');
            modalImage.src = imageSrc;
        });
    }
</script>
</body>
</html>