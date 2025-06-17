<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 6/17/2025
  Time: 10:31 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard | Complaint Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --glass-color: rgba(255, 255, 255, 0.15);
            --glass-border: 1px solid rgba(255, 255, 255, 0.2);
            --glass-blur: blur(10px);
            --glass-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            background-attachment: fixed;
            min-height: 100vh;
            color: white;
        }

        .glass-card {
            background: var(--glass-color);
            border: var(--glass-border);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            box-shadow: var(--glass-shadow);
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        .sidebar {
            background: rgba(0, 0, 0, 0.3) !important;
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border-right: var(--glass-border);
        }

        .table-glass {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
        }

        .table-glass th, .table-glass td {
            background: transparent;
            color: white;
            border-color: rgba(255, 255, 255, 0.1);
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.8) !important;
            border-radius: 5px;
            margin: 2px 0;
        }

        .nav-link:hover, .nav-link.active {
            background: rgba(255, 255, 255, 0.2) !important;
            color: white !important;
        }

        .btn-glass {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }

        .btn-glass:hover {
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar Navigation -->
        <nav id="sidebar" class="col-md-3 col-lg-2 d-md-block sidebar collapse">
            <div class="position-sticky pt-3">
                <div class="text-center mb-4">
                    <h5 class="text-white">Admin Panel</h5>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">
                            <i class="bi bi-speedometer2 me-2"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/complaints">
                            <i class="bi bi-list-ul me-2"></i> All Complaints
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom border-white border-opacity-25">
                <h1 class="h2 text-white">Admin Dashboard</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-glass btn-sm">
                            <i class="bi bi-download me-1"></i> Export
                        </button>
                    </div>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="row mb-4 g-4">
                <div class="col-md-3">
                    <div class="glass-card p-3 h-100">
                        <div class="card-body text-center">
                            <h5 class="card-title text-white-50">Total Complaints</h5>
                            <p class="card-text display-4 fw-bold text-white">${totalComplaints}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="glass-card p-3 h-100">
                        <div class="card-body text-center">
                            <h5 class="card-title text-white-50">Pending</h5>
                            <p class="card-text display-4 fw-bold text-warning">${pendingComplaints}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="glass-card p-3 h-100">
                        <div class="card-body text-center">
                            <h5 class="card-title text-white-50">Resolved</h5>
                            <p class="card-text display-4 fw-bold text-success">${resolvedComplaints}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="glass-card p-3 h-100">
                        <div class="card-body text-center">
                            <h5 class="card-title text-white-50">Rejected</h5>
                            <p class="card-text display-4 fw-bold text-danger">${rejectedComplaints}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Complaints Table -->
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="h4 text-white mb-0">Recent Complaints</h2>
                    <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-glass btn-sm">
                        <i class="bi bi-arrow-right me-1"></i> View All
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-glass table-borderless table-hover">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Title</th>
                            <th scope="col">Submitted By</th>
                            <th scope="col">Date</th>
                            <th scope="col">Status</th>
                            <th scope="col">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="complaint" items="${recentComplaints}">
                            <tr>
                                <td>${complaint.id}</td>
                                <td>${complaint.title}</td>
                                <td>${complaint.submittedBy}</td>
                                <td>${complaint.submissionDate}</td>
                                <td>
                                        <span class="badge rounded-pill
                                            ${complaint.status == 'PENDING' ? 'bg-warning text-dark' :
                                              complaint.status == 'RESOLVED' ? 'bg-success' : 'bg-danger'}">
                                                ${complaint.status}
                                        </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/complaints/view?id=${complaint.id}"
                                       class="btn btn-glass btn-sm me-1">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/complaints/update?id=${complaint.id}"
                                       class="btn btn-glass btn-sm">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
