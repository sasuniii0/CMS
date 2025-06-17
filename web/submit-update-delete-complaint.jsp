<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<body>
<div class="container">
    <div class="card shadow">
        <div class="card-header text-white d-flex justify-content-between align-items-center">
            <h4 class="mb-0">My Complaints</h4>
            <button class="btn btn-light btn-sm" data-bs-toggle="modal" data-bs-target="#addComplaintModal">
                <i class="bi bi-plus-lg"></i> Add New Complaint
            </button>
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
                    <c:forEach var="complaint" items="${complaints}">
                        <tr>
                            <td>${complaint.title}</td>
                            <td>
                                <c:if test="${not empty complaint.image}">
                                    <img src="data:image/jpeg;base64,${complaint.image}"
                                         class="complaint-image"
                                         alt="Complaint Image"
                                         data-bs-toggle="modal"
                                         data-bs-target="#imageModal"
                                         data-image="data:image/jpeg;base64,${complaint.image}">
                                </c:if>
                            </td>
                            <td class="description-cell" title="${complaint.description}">
                                    ${complaint.description}
                            </td>
                            <td>
                                    <span class="status-badge
                                        ${complaint.status == 'PENDING' ? 'status-pending' :
                                          complaint.status == 'RESOLVED' ? 'status-resolved' : 'status-rejected'}">
                                            ${complaint.status}
                                    </span>
                            </td>
                            <td>${complaint.remarks}</td>
                            <td>
                                <button class="btn btn-sm btn-outline-primary action-btn edit-btn"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editComplaintModal"
                                        data-id="${complaint.id}"
                                        data-userid="${complaint.userId}"
                                        data-title="${complaint.title}"
                                        data-description="${complaint.description}"
                                        data-status="${complaint.status}"
                                        data-remarks="${complaint.remarks}">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-danger action-btn delete-btn"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal"
                                        data-id="${complaint.id}">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add Complaint Modal -->
<div class="modal fade" id="addComplaintModal" tabindex="-1" aria-labelledby="addComplaintModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="addComplaintForm" action="ComplaintServlet?action=save" method="post" enctype="multipart/form-data">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="addComplaintModalLabel">Add New Complaint</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="userId" value="${sessionScope.userId}">
                    <div class="mb-3">
                        <label for="title" class="form-label">Title</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="image" class="form-label">Image (Optional)</label>
                        <input class="form-control" type="file" id="image" name="image" accept="image/*">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Complaint</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Complaint Modal -->
<div class="modal fade" id="editComplaintModal" tabindex="-1" aria-labelledby="editComplaintModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="editComplaintForm" action="ComplaintServlet?action=update" method="post" enctype="multipart/form-data">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editComplaintModalLabel">Edit Complaint</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="editId" name="id">
                    <input type="hidden" id="editUserId" name="userId">
                    <div class="mb-3">
                        <label for="editTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="editTitle" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="editDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="editDescription" name="description" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-select" id="status" name="status">
                            <option value="PENDING" style="color: black">Pending</option>
                            <option value="RESOLVED" style="color: black">Resolved</option>
                            <option value="REJECTED" style="color: black">Rejected</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="editRemarks" class="form-label">Remarks</label>
                        <textarea class="form-control" id="editRemarks" name="remarks" rows="2"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="editImage" class="form-label">Change Image (Optional)</label>
                        <input class="form-control" type="file" id="editImage" name="image" accept="image/*">
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

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="deleteForm" action="ComplaintServlet?action=delete" method="post">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="deleteId" name="id">
                    <p>Are you sure you want to delete this complaint? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete Complaint</button>
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