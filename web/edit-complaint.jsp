<%@ page import="lk.ijse.gdse.dto.ComplaintDTO" %>
<%@ page import="org.apache.commons.dbcp2.BasicDataSource" %>
<%@ page import="lk.ijse.gdse.model.ComplaintModel" %>

<%
    String cid = request.getParameter("cid");
    BasicDataSource ds = (BasicDataSource) application.getAttribute("ds");
    ComplaintDTO complaint = null;
    try {
        complaint = ComplaintModel.getComplaintById(cid, ds);
        if (complaint == null) {
            response.sendRedirect(request.getContextPath() + "/viewMyComplaints?error=not_found");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<form action="<%= request.getContextPath() %>/update-complaint" method="post" enctype="multipart/form-data">
    <input type="hidden" name="cid" value="<%= complaint.getCid() %>" />

    <label>Title</label><br/>
    <input type="text" name="title" value="<%= complaint.getTitle() %>" required /><br/>

    <label>Description</label><br/>
    <textarea name="description" required><%= complaint.getDescription() %></textarea><br/>

    <label>Status</label><br/>
    <input type="text" name="status" value="<%= complaint.getStatus() %>" /><br/>

    <label>Remarks</label><br/>
    <textarea name="remarks"><%= complaint.getRemarks() %></textarea><br/>

    <label>Image</label><br/>
    <% if (complaint.getImage() != null && !complaint.getImage().isEmpty()) { %>
    <img src="<%= request.getContextPath() + "/" + complaint.getImage() %>" style="max-width:150px;" alt="Current Image" /><br/>
    <% } %>
    <input type="file" name="image" accept="image/*" /><br/>

    <button type="submit">Update Complaint</button>
</form>
