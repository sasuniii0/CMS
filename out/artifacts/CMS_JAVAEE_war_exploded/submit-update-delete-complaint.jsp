<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="https://jakarta.ee/specifications/tags/core" %>
<%@ page import="lk.ijse.gdse.dto.ComplaintDTO" %>
<%@ page import="java.util.List" %>

<%
    List<ComplaintDTO> complaints = (List<ComplaintDTO>) request.getAttribute("complaints");
    request.setAttribute("complaints", complaints);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Complaints</title>
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

        .card, .modal-content {
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

        .table {
            color: white;
        }

        .table thead {
            background: rgba(255, 255, 255, 0.1);
        }

        .form-control,
        .form-select {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }
        .modal-header{
            background: #A29BFEFF;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .modal-content input,
        .modal-content textarea,
        .modal-content select {
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
        }

        .btn-close-white {
            filter: brightness(0) invert(1);
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
            background-color: rgba(255, 234, 167, 0.3); /* light yellow */
            color: #ffeaa7;
        }
        .status-resolved {
            background-color: rgba(85, 239, 196, 0.3); /* light green */
            color: #55efc4;
        }
        .status-rejected {
            background-color: rgba(250, 177, 160, 0.3); /* light red */
            color: #fab1a0;
        }


        .modal-body img {
            max-width: 100%;
            border-radius: 10px;
        }

        .action-btn {
            margin-right: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card shadow">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h4 class="mb-0">My Complaints</h4>
            <button class="btn btn-light btn-sm" data-bs-toggle="modal" data-bs-target="#addComplaintModal">
                <i class="bi bi-plus-lg"></i> Add Complaint
            </button>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
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
                                         width="50"
                                         data-bs-toggle="modal"
                                         data-bs-target="#imageModal"
                                         data-image="data:image/jpeg;base64,${complaint.image}" />
                                </c:if>
                            </td>
                            <td title="${complaint.description}">${complaint.description}</td>
                            <td>
                                <span class="status-badge
                                    ${complaint.status == 'PENDING' ? 'status-pending' :
                                      complaint.status == 'RESOLVED' ? 'status-resolved' : 'status-rejected'}">
                                        ${complaint.status}
                                </span>
                            </td>
                            <td>${complaint.remarks}</td>
                            <td>
                                <button class="btn btn-sm btn-outline-primary edit-btn"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editComplaintModal"
                                        data-id="${complaint.cid}"
                                        data-userid="${complaint.user_id}"
                                        data-title="${complaint.title}"
                                        data-description="${complaint.description}"
                                        data-status="${complaint.status}"
                                        data-remarks="${complaint.remarks}">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-danger delete-btn"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal"
                                        data-id="${complaint.cid}">
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
<div class="modal fade" id="addComplaintModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/complaint?action=save" method="post" enctype="multipart/form-data">
                <div class="modal-header text-white">
                    <h5 class="modal-title fw-bold text-uppercase">
                        📝 Submit a New Complaint
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="userId" value="${sessionScope.userId}">
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" name="title" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Image (optional)</label>
                        <input type="file" name="image" class="form-control" accept="image/*">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-light" type="submit">Submit</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Complaint Modal -->
<div class="modal fade" id="editComplaintModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/complaint?action=update" method="post" enctype="multipart/form-data">
                <div class="modal-header  text-dark">
                    <h5 class="modal-title fw-bold text-uppercase">
                        ✏️ Edit Complaint
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="editId" name="id">
                    <input type="hidden" id="editUserId" name="userId">
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" id="editTitle" name="title" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea id="editDescription" name="description" class="form-control" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select id="editStatus" name="status" class="form-select">
                            <option value="PENDING">Pending</option>
                            <option value="RESOLVED">Resolved</option>
                            <option value="REJECTED">Rejected</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Remarks</label>
                        <textarea id="editRemarks" name="remarks" class="form-control" rows="2"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Update Image</label>
                        <input type="file" name="image" class="form-control" accept="image/*">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-primary" type="submit">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/complaint?action=delete" method="post">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title fw-bold text-uppercase">
                        ❗ Confirm Delete
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="deleteId" name="id">
                    <p>Are you sure you want to delete this complaint?</p>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-danger" type="submit">Delete</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Image Preview Modal -->
<div class="modal fade" id="imageModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-body text-center">
                <img id="modalImage" src="" class="img-fluid rounded" alt="Complaint Image">
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.querySelectorAll('.edit-btn').forEach(button => {
        button.addEventListener('click', () => {
            document.getElementById('editId').value = button.getAttribute('data-id');
            document.getElementById('editUserId').value = button.getAttribute('data-userid');
            document.getElementById('editTitle').value = button.getAttribute('data-title');
            document.getElementById('editDescription').value = button.getAttribute('data-description');
            document.getElementById('editStatus').value = button.getAttribute('data-status');
            document.getElementById('editRemarks').value = button.getAttribute('data-remarks');
        });
    });

    document.querySelectorAll('.delete-btn').forEach(button => {
        button.addEventListener('click', () => {
            document.getElementById('deleteId').value = button.getAttribute('data-id');
        });
    });

    const imageModal = document.getElementById('imageModal');
    if (imageModal) {
        imageModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const imgSrc = button.getAttribute('data-image');
            const modalImg = document.getElementById('modalImage');
            modalImg.src = imgSrc;
        });
    }
</script>
</body>
</html>
