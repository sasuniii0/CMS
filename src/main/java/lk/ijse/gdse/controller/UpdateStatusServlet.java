package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.gdse.dto.ComplaintDTO;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.util.List;

@WebServlet("/updateStatus")
public class UpdateStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Get and validate CID
        String cid = req.getParameter("cid");
        System.out.println("Editing complaint: " + cid); // Debug log

        if (cid == null || cid.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing complaint ID");
            return;
        }

        // 2. Fetch complaint
        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        ComplaintDTO complaint;
        try {
            complaint = ComplaintModel.getComplaintById(cid, ds);
            if (complaint == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
            return;
        }

        // 3. Forward to edit page
        req.setAttribute("complaint", complaint);
        req.getRequestDispatcher("update-status.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Verify admin session
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect("index.jsp");
            return;
        }

        // 2. Get and validate all parameters
        String cid = req.getParameter("cid");
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");

        if (cid == null || cid.trim().isEmpty() ||
                status == null || status.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        // 3. Validate status value
        if (!List.of("pending", "resolved", "rejected").contains(status)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status value");
            return;
        }

        // 4. Process the update
        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        try {
            boolean updated = ComplaintModel.updateStatusAndRemarks(cid, status, remarks, ds);

            if (updated) {
                // Success - redirect with success message
                session.setAttribute("success", "Complaint updated successfully");
                resp.sendRedirect("viewAllComplaints");
            } else {
                // No rows affected - complaint not found
                session.setAttribute("error", "Complaint not found");
                resp.sendRedirect("viewAllComplaints");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Server error during update");
            resp.sendRedirect("viewAllComplaints");
        }
    }
}