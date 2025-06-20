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

@WebServlet("/delete-complaint")
public class DeleteComplaintServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String cid = req.getParameter("cid");
        String userId = (String) session.getAttribute("user_id");

        if (cid == null || cid.trim().isEmpty()) {
            System.out.println(" CID is missing");
            resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=invalid_id");
            return;
        }

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        try {
            if (!ComplaintModel.canUserUpdate(cid, userId, ds)) {
                System.out.println("🚫 Unauthorized delete attempt by user: " + userId);
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=unauthorized");
                return;
            }

            int deleted = ComplaintModel.deleteComplaint(cid, ds);
            if (deleted > 0) {
                System.out.println("✅ Complaint deleted successfully: " + cid);
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?deleted=true");
            } else {
                System.out.println("⚠️ Delete failed for complaint: " + cid);
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=delete_failed");
            }
        } catch (Exception e) {
            System.out.println("🔥 Exception while deleting complaint: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=server_error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/viewMyComplaints");
    }
}
