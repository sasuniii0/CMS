<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if (session == null || session.getAttribute("user_id") == null) {
    response.sendRedirect("index.jsp");
    return;
  }

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
    .status-badge {
      padding: 5px 10px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 600;
    }
    .status-pending {
      background-color: rgba(253, 203, 110, 0.2);
      color: #fdcb6e;
    }
    .status-in-progress {
      background-color: rgba(129, 236, 236, 0.2);
      color: #81ecec;
    }
    .status-resolved {
      background-color: rgba(85, 239, 196, 0.2);
      color: #55efc4;
    }
    .status-rejected {
      background-color: rgba(255, 107, 107, 0.2);
      color: #ff6b6b;
    }
    .btn-light {
      background-color: #a29bfe;
      color: #fff;
      border: none;
    }
    .btn-light:hover {
      background-color: #6c5ce7;
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
    .complaint-image-thumb {
      width: 80px;
      height: 60px;
      object-fit: cover;
      border-radius: 4px;
      border: 1px solid rgba(255, 255, 255, 0.2);
    }
  </style>
</head>
<body>
<div class="container">
  <div class="row justify-content-center">
    <div class="col-lg-10">
      <% if (error != null) { %>
      <div class="alert alert-danger alert-dismissible fade show mb-4">
        <c:choose>
          <c:when test="${error == 'delete_failed'}">Failed to delete complaint. Please try again.</c:when>
          <c:when test="${error == 'unauthorized'}">You are not authorized to perform this action.</c:when>
          <c:otherwise>An error occurred: <%= error %></c:otherwise>
        </c:choose>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
      <% } %>

      <% if (success != null) { %>
      <div class="alert alert-success alert-dismissible fade show mb-4">
        Complaint updated successfully!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
      <% } %>

      <% if (deleted != null && deleted.equals("true")) { %>
      <div class="alert alert-success alert-dismissible fade show mb-4">
        Complaint deleted successfully!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
      <% } %>



      <div class="card shadow mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h4 class="mb-0"><i class="bi bi-list-ul"></i> My Complaints</h4>
          <div>
            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn btn-info me-2">
              <i class="bi bi-back"></i> Back to dashboard
            </a>
            <a href="${pageContext.request.contextPath}/viewMyComplaints" class="btn btn-secondary me-2">
              <i class="bi bi-arrow-clockwise"></i> Refresh
            </a>
            <a href="${pageContext.request.contextPath}/submit-complaint.jsp" class="btn btn-primary me-2">
              <i class="bi bi-plus-circle"></i> New Complaint
            </a>
          </div>
        </div>
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover mb-0">
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
              <c:forEach var="complaint" items="${complaints}">
                <tr>
                  <td>${complaint.title}</td>
                  <td>${complaint.description}</td>
                  <td>
                    <c:if test="${not empty complaint.image}">
                      <img src="${pageContext.request.contextPath}/${complaint.image}"
                           class="complaint-image-thumb"
                           alt="Complaint Image">
                    </c:if>
                    <c:if test="${empty complaint.image}">
                      <span class="text-muted">No image</span>
                    </c:if>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${complaint.status == 'PENDING'}">
                        <span class="status-badge status-pending">Pending</span>
                      </c:when>
                      <c:when test="${complaint.status == 'RESOLVED'}">
                        <span class="status-badge status-resolved">Resolved</span>
                      </c:when>
                      <c:otherwise>
                        <span class="status-badge">${complaint.status}</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>${complaint.remarks != null ? complaint.remarks : 'No remarks'}</td>
                  <td>
                    <div class="d-flex gap-2">

                      <button type="button"
                              class="btn btn-sm btn-primary"
                              data-bs-toggle="modal"
                              data-bs-target="#updateComplaintModal"
                              onclick="fillUpdateModal('${complaint.cid}', '${complaint.title}', `${complaint.description}`, '${complaint.status}', `${complaint.remarks}`)">
                        <i class="bi bi-pencil"></i> Edit
                      </button>



                      <form action="${pageContext.request.contextPath}/delete-complaint" method="post" style="display: inline;">
                        <input type="hidden" name="cid" value="${complaint.cid}">
                        <button type="submit" class="btn btn-danger me-md-2"
                                onclick="return confirm('Are you sure you want to delete this complaint?');">
                          <i class="bi bi-trash"></i> Delete Complaint
                        </button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<<div class="modal fade" id="updateComplaintModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content text-white" style="background: #333;">
      <form action="${pageContext.request.contextPath}/update-complaint" method="post" enctype="multipart/form-data">
        <div class="modal-header">
          <h5 class="modal-title">Update Complaint</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="cid" id="modalCid">

          <div class="mb-3">
            <label class="form-label">Title</label>
            <input type="text" name="title" id="modalTitle" class="form-control" required>
          </div>

          <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea name="description" id="modalDescription" class="form-control" rows="5" required></textarea>
          </div>

          <div class="mb-3">
            <label class="form-label">Status</label>
            <select name="status" id="modalStatus" class="form-select" required>
              <option value="PENDING">Pending</option>
              <option value="RESOLVED">Resolved</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label">Remarks</label>
            <textarea name="remarks" id="modalRemarks" class="form-control" rows="3"></textarea>
          </div>

          <div class="mb-3">
            <label class="form-label">Update Image (optional)</label>
            <input type="file" name="image" class="form-control" accept="image/*">
            <small class="text-muted">Leave blank to keep current image</small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Update</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function fillUpdateModal(cid, title, description, status, remarks) {
    console.log("CID passed to modal:", cid); // ✅ Check in browser console
    document.getElementById("modalCid").value = cid;
    document.getElementById("modalTitle").value = title;
    document.getElementById("modalDescription").value = description;
    document.getElementById("modalStatus").value = status;
    document.getElementById("modalRemarks").value = remarks;
  }


</script>
</body>
</html>