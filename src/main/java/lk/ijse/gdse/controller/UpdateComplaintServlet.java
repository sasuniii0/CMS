package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.ijse.gdse.dto.ComplaintDTO;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@MultipartConfig
@WebServlet("/update-complaint")
public class UpdateComplaintServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String cid = req.getParameter("cid");  // fix: not "id" → should be "cid" to match the form
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");
        String userId = String.valueOf(session.getAttribute("user_id"));

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        try {
            // Validate
            if (cid == null || title == null || description == null || status == null) {
                req.setAttribute("error", "All required fields must be provided.");
                ComplaintDTO exist = ComplaintModel.getComplaintById(cid, ds);
                req.setAttribute("complaint", exist);
                req.getRequestDispatcher("/edit-complaint.jsp").forward(req, resp);
                return;
            }

            // Permission check
            if (!ComplaintModel.canUserUpdate(cid, userId, ds)) {
                resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                return;
            }

            // Prepare DTO
            ComplaintDTO complaint = new ComplaintDTO();
            complaint.setCid(cid);
            complaint.setTitle(title.trim());
            complaint.setDescription(description.trim());
            complaint.setStatus(status.trim());
            complaint.setRemarks(remarks != null ? remarks.trim() : "");
            complaint.setUser_id(userId);

            // Optional: File upload
            Part filePart = req.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/assets");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                complaint.setImage("assets/" + fileName);
            } else {
                // Preserve existing image if new one not uploaded
                ComplaintDTO existing = ComplaintModel.getComplaintById(cid, ds);
                if (existing != null) {
                    complaint.setImage(existing.getImage());
                }
            }

            // Update
            boolean updated = ComplaintModel.updateComplaint(complaint, ds);
            if (updated) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints");
            } else {
                req.setAttribute("error", "Failed to update complaint.");
                req.setAttribute("complaint", complaint);
                req.getRequestDispatcher("/edit-complaint.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Unexpected error: " + e.getMessage());
            ComplaintDTO fallback = ComplaintModel.getComplaintById(cid, ds);
            req.setAttribute("complaint", fallback);
            req.getRequestDispatcher("/edit-complaint.jsp").forward(req, resp);
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
        if (cid == null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
            return;
        }

        try {
            String userId = String.valueOf(session.getAttribute("user_id"));
            BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

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
