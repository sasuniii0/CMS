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

        String cid = req.getParameter("cid");
        System.out.println("Editing complaint: " + cid);

        if (cid == null || cid.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing complaint ID");
            return;
        }

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

        req.setAttribute("complaint", complaint);
        req.getRequestDispatcher("update-status.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect("index.jsp");
            return;
        }

        String cid = req.getParameter("cid");
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");

        if (cid == null || cid.trim().isEmpty() ||
                status == null || status.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        if (!List.of("pending", "resolved", "rejected").contains(status)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status value");
            return;
        }

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        try {
            boolean updated = ComplaintModel.updateStatusAndRemarks(cid, status, remarks, ds);

            if (updated) {
                session.setAttribute("success", "Complaint updated successfully");
                resp.sendRedirect("viewAllComplaints");
            } else {
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