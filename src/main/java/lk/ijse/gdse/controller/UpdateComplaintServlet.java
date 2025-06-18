package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.ijse.gdse.dto.ComplaintDTO;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.*;
import java.nio.file.Files;
import java.util.Base64;
import java.util.UUID;

@WebServlet("/update-complaint")
@MultipartConfig
public class UpdateComplaintServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String cid = req.getParameter("id"); // Corrected: this matches hidden input name in form
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");
        String userId = String.valueOf(session.getAttribute("user_id"));

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        try {
            if (cid == null || title == null || description == null || status == null) {
                req.setAttribute("error", "All fields are required.");
                forwardToEdit(req, resp, cid, ds);
                return;
            }

            if (!ComplaintModel.canUserUpdate(cid, userId, ds)) {
                resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                return;
            }

            ComplaintDTO dto = new ComplaintDTO();
            dto.setCid(cid);
            dto.setTitle(title.trim());
            dto.setDescription(description.trim());
            dto.setStatus(status.trim());
            dto.setRemarks(remarks != null ? remarks.trim() : "");
            dto.setUser_id(userId);

            // Image upload handling
            Part imagePart = req.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                // Convert to Base64
                try (InputStream inputStream = imagePart.getInputStream()) {
                    byte[] imageBytes = inputStream.readAllBytes();
                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                    dto.setImage(base64Image);
                }
            } else {
                // Retain existing image if no new image provided
                ComplaintDTO existing = ComplaintModel.getComplaintById(cid, ds);
                dto.setImage(existing != null ? existing.getImage() : null);
            }

            boolean result = ComplaintModel.updateComplaint(dto, ds);
            if (result) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints");
            } else {
                req.setAttribute("error", "Failed to update complaint.");
                req.setAttribute("complaint", dto);
                req.getRequestDispatcher("/edit-complaint.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            forwardToEdit(req, resp, cid, ds);
        }
    }

    private void forwardToEdit(HttpServletRequest req, HttpServletResponse resp, String cid, BasicDataSource ds)
            throws ServletException, IOException {
        try {
            ComplaintDTO fallback = ComplaintModel.getComplaintById(cid, ds);
            req.setAttribute("complaint", fallback);
            req.getRequestDispatcher("/edit-complaint.jsp").forward(req, resp);
        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String cid = req.getParameter("cid");
        String userId = String.valueOf(session.getAttribute("user_id"));
        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        try {
            if (!ComplaintModel.canUserUpdate(cid, userId, ds)) {
                resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                return;
            }

            ComplaintDTO complaint = ComplaintModel.getComplaintById(cid, ds);
            if (complaint == null) {
                resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                return;
            }

            req.setAttribute("complaint", complaint);
            req.getRequestDispatcher("/edit-complaint.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        }
    }
}
