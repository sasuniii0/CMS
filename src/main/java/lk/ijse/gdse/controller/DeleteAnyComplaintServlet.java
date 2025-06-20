package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/delete-any-complaint")
public class DeleteAnyComplaintServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect("index.jsp");
            return;
        }

        String cid = req.getParameter("cid");
        System.out.println("[GET] Received CID: " + cid); // Debug log
        if (cid == null || cid.trim().isEmpty()) {
            resp.sendRedirect("viewAllComplaints?error=missing_id");
            return;
        }

        req.setAttribute("cid", cid);
        req.getRequestDispatcher("delete-complaint.jsp").forward(req, resp);
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
        System.out.println("[POST] Attempting to delete CID: " + cid); // Debug log

        if (cid == null || cid.trim().isEmpty()) {
            session.setAttribute("error", "No complaint ID provided");
            resp.sendRedirect("viewAllComplaints");
            return;
        }

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        try {
            int rowsDeleted = ComplaintModel.deleteComplaintByCid(cid, ds);

            if (rowsDeleted > 0) {
                session.setAttribute("success", "Complaint " + cid + " deleted successfully");
            } else {
                session.setAttribute("error", "No complaint found with ID: " + cid);
            }
        } catch (SQLException e) {
            session.setAttribute("error", "Delete failed: " + e.getMessage());
            e.printStackTrace();
        }

        resp.sendRedirect("viewAllComplaints");
    }

}