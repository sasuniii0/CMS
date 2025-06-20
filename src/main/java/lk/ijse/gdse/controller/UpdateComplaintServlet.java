package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.ijse.gdse.bean.ComplaintDTO;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/update-complaint")
@MultipartConfig
public class UpdateComplaintServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String complaintId = req.getParameter("cid");
            if (complaintId == null || !complaintId.matches("\\d+")) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=invalid_id");
                return;
            }
            BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

            ComplaintDTO complaint = ComplaintModel.getComplaintById(complaintId,ds);
            if (complaint == null) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=not_found");
                return;
            }

            req.setAttribute("complaint", complaint);
            req.getRequestDispatcher("/edit-complaint.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=server_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
                return;
            }

            String complaintId = req.getParameter("cid");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String status = req.getParameter("status");
            Part imagePart = req.getPart("image");

            if (complaintId == null || !complaintId.matches("\\d+") ||
                    title == null || title.trim().isEmpty() ||
                    description == null || description.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/edit-complaint.jsp?id=" + complaintId + "&error=invalid_input");
                return;
            }

            String userId = (String) session.getAttribute("user_id");
            /*ComplaintDTO existing = ComplaintModel.getComplaintById(complaintId,ds);
            if (existing == null || !existing.getUser_id().equals(userId) ||
                    !"PENDING".equals(existing.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=invalid_operation");
                return;
            }*/

            String imagePath = req.getParameter("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                if (imagePath != null) {
                    deleteImage(req.getServletContext().getRealPath("") + imagePath);
                }
                imagePath = saveUploadedImage(imagePart, req.getServletContext().getRealPath("/assets"));
            }

            ComplaintDTO updatedComplaint = new ComplaintDTO(
                    complaintId,
                    title.trim(),
                    description.trim(),
                    imagePath,
                    status != null ? status : "PENDING",
                    req.getParameter("remarks"),
                    userId
            );

            boolean success = ComplaintModel.updateComplaint(updatedComplaint,ds);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?success=updated");
                resp.sendRedirect(req.getContextPath() + "/edit-complaint.jsp?id=" + complaintId + "&success=updated");
            } else {
                resp.sendRedirect(req.getContextPath() + "/edit-complaint.jsp?id=" + complaintId + "&error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String complaintId = req.getParameter("cid");
            resp.sendRedirect(req.getContextPath() + "/edit-complaint.jsp?id=" + complaintId + "&error=server_error");
        }
    }

    private void deleteImage(String imagePath) {
        try {
            Path path = Paths.get(imagePath);
            Files.deleteIfExists(path);
        } catch (IOException e) {
            System.err.println("Failed to delete image: " + e.getMessage());
        }
    }

    private String saveUploadedImage(Part imagePart, String uploadPath) throws IOException {
        String fileName = UUID.randomUUID() + "_" + imagePart.getSubmittedFileName();
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String filePath = uploadPath + File.separator + fileName;
        try (InputStream input = imagePart.getInputStream()) {
            Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
        }
        return "/uploads/" + fileName;
    }
}