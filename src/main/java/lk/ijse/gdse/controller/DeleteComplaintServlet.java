package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;

@MultipartConfig
@WebServlet("/delete-complaint")
public class DeleteComplaintServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String cid = req.getParameter("cid");
        if (cid == null || cid.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/viewMyComplaints");
            return;
        }

        String userId = String.valueOf(session.getAttribute("user_id"));
        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        try {
            // Ensure user has rights to delete the complaint
            if (!ComplaintModel.canUserUpdate(cid, userId, ds)) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints");
                return;
            }

            boolean deleted = ComplaintModel.deleteComplaint(cid, ds);
            if (deleted) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?deleted=true");
            } else {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=delete_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=server_error");
        }
    }
}
