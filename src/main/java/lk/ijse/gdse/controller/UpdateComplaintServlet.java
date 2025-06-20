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
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/update-complaint")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 1024 * 1024 * 5,    // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class UpdateComplaintServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String cid = req.getParameter("cid");
        if (cid == null || cid.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=missing_cid");
            return;
        }

        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");
        String userId = (String) session.getAttribute("user_id");
        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        System.out.println(cid+" " +userId);
        try {
            // Validate required fields
            if (cid == null || title == null || description == null || status == null ||
                    title.trim().isEmpty() || description.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=missing_fields");
                return;
            }

            System.out.println(cid + " " + userId);

            boolean canUpdate = ComplaintModel.canUserUpdate(cid, userId, ds);
            System.out.println("Can user " + userId + " update complaint " + cid + "? " + canUpdate);

            // Check if user can update this complaint
            if (!ComplaintModel.canUserUpdate(cid, userId, ds)) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=unauthorized");
                return;
            }

            // Create DTO with updated info
            ComplaintDTO dto = new ComplaintDTO();
            dto.setCid(cid);
            dto.setTitle(title.trim());
            dto.setDescription(description.trim());
            dto.setStatus(status.trim());
            dto.setRemarks(remarks != null ? remarks.trim() : "");
            dto.setUser_id(userId);

            // Handle file upload if present
            Part filePart = req.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                // Delete old image if exists
                ComplaintDTO existing = ComplaintModel.getComplaintById(cid, ds);
                if (existing != null && existing.getImage() != null) {
                    deleteOldImage(req, existing.getImage());
                }

                // Save new image
                String fileName = UUID.randomUUID() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/assets");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String filePath = uploadPath + File.separator + fileName;
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, new File(filePath).toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                dto.setImage("assets/" + fileName);
            } else {
                // Keep existing image
                ComplaintDTO existing = ComplaintModel.getComplaintById(cid, ds);
                if (!existing.getUser_id().equals(userId)) {
                    resp.sendRedirect("viewMyComplaints.jsp?error=unauthorized");
                    return;
                }
            }

            // Update complaint
            boolean updated = ComplaintModel.updateComplaint(dto, ds);
            if (updated) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?success=true");
            } else {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=server_error");
        }
    }

    private void deleteOldImage(HttpServletRequest req, String imagePath) {
        if (imagePath != null && !imagePath.isEmpty()) {
            String fullPath = getServletContext().getRealPath("/") + imagePath;
            File oldFile = new File(fullPath);
            if (oldFile.exists()) {
                oldFile.delete();
            }
        }
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String id = req.getParameter("cid");

        HttpSession session = req.getSession(false);
        if (session== null || session.getAttribute("user_id")== null){
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }

        if (id == null){
            resp.sendRedirect(req.getContextPath()+ "/dashboard.jsp");
            return;
        }
        System.out.println(id+"....................");
        BasicDataSource ds = (BasicDataSource) getServletContext().getAttribute("ds");
        try{
            String  userId = (String) session.getAttribute("user_id");

            if (!ComplaintModel.canUserUpdate(id,userId,ds)){
                resp.sendRedirect(req.getContextPath() + "/view.jsp");
                return;
            }
            ComplaintDTO complaintDTO = ComplaintModel.getComplaintById(id,ds);
            if (complaintDTO == null){
                resp.sendRedirect(req.getContextPath() + "/view.jsp");
                return;
            }

            String path = req.getContextPath() + "/edit-complaint.jsp";
            req.getRequestDispatcher(path).forward(req, resp);
        }catch (NumberFormatException e){
            resp.sendRedirect(req.getContextPath() + "/view.jsp");
        } catch (Exception e){
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/view.jsp");
        }
        /*String cid = req.getParameter("cid");
        if (cid == null || cid.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/viewMyComplaints");
            return;
        }

        try {
            BasicDataSource ds = (BasicDataSource) getServletContext().getAttribute("ds");
            ComplaintDTO complaint = ComplaintModel.getComplaintById(cid, ds);

            if (complaint != null) {
                req.setAttribute("complaint", complaint);
                req.getRequestDispatcher("/edit-complaint.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=not_found");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/viewMyComplaints?error=server_error");
        }*/
    }

}