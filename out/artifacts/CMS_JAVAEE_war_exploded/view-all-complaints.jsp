<%@ page import="java.sql.*, javax.sql.DataSource" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    List<Map<String, String>> complaints = new ArrayList<>();

    try {
        DataSource ds = (DataSource) application.getAttribute("ds");
        con = ds.getConnection();
        stmt = con.prepareStatement("SELECT id, title, description, status, created_at FROM complaints ORDER BY created_at DESC");
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> complaint = new HashMap<>();
            complaint.put("id", rs.getString("id"));
            complaint.put("title", rs.getString("title"));
            complaint.put("description", rs.getString("description"));
            complaint.put("status", rs.getString("status"));
            complaint.put("created_at", rs.getString("created_at"));
            complaints.add(complaint);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>All Complaints</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #2c2c54, #1e1e2f) fixed;
            color: #fff;
        }

        .modal-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }

        th, td {
            color: white;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
    </style>
</head>
<body>

<!-- Modal Triggered on Page Load -->
<div class="modal fade show" id="complaintModal" tabindex="-1" style="display: block;" aria-labelledby="modalLabel" aria-modal="true" role="dialog">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">All Complaints</h5>
                <a href="dashboard.jsp" class="btn-close btn-close-white"></a>
            </div>
            <div class="modal-body">
                <% if (complaints.isEmpty()) { %>
                <p class="text-center">No complaints found.</p>
                <% } else { %>
                <table class="table table-hover table-bordered">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Created At</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Map<String, String> complaint : complaints) { %>
                    <tr>
                        <td><%= complaint.get("id") %></td>
                        <td><%= complaint.get("title") %></td>
                        <td><%= complaint.get("description") %></td>
                        <td><%= complaint.get("status") %></td>
                        <td><%= complaint.get("created_at") %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>
            <div class="modal-footer">
                <a href="dashboard.jsp" class="btn btn-secondary">Close</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
