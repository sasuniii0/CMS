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

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        String id = req.getParameter("cid");
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        try {
            String cid = String.valueOf(Integer.parseInt(id));
            String userId = (String) session.getAttribute("user_id");
            if (!ComplaintModel.canUserUpdate(cid, userId,ds)) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }
            boolean isDeleted = ComplaintModel.deleteComplaint(cid,ds);
            if (isDeleted) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }
}
