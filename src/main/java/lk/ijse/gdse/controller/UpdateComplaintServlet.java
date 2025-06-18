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

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        String cid = req.getParameter("id");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");
        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            // Validate required fields
            if (cid == null || title == null || description == null || status == null) {
                req.setAttribute("error", "All required fields must be provided");
                ComplaintDTO exist = ComplaintModel.getComplaintById(cid, ds);
                req.setAttribute("complaint", exist);
                req.getRequestDispatcher("/update-complaint.jsp").forward(req, resp);
                return;
            }

            // Check permission
            if (!ComplaintModel.canUserUpdate(cid, userId.toString(), ds)) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }

            // Create DTO
            ComplaintDTO complaint = new ComplaintDTO();
            complaint.setCid(cid);
            complaint.setTitle(title.trim());
            complaint.setDescription(description.trim());
            complaint.setStatus(status.trim());
            complaint.setRemarks(remarks != null ? remarks.trim() : "");
            complaint.setUser_id(userId.toString());

            // Handle file upload if present
            Part filePart = req.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/assets");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                complaint.setImage("assets/" + fileName);
            }

            boolean isUpdated = ComplaintModel.updateComplaint(complaint, ds);
            if (isUpdated) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints");
            } else {
                req.setAttribute("error", "Failed to update complaint");
                ComplaintDTO exist = ComplaintModel.getComplaintById(cid, ds);
                req.setAttribute("complaint", exist);
                req.getRequestDispatcher("/update-complaint.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error updating complaint: " + e.getMessage());
            req.getRequestDispatcher("/update-complaint.jsp").forward(req, resp);
        }
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }
        String id = req.getParameter("cid");
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        try {
            String cid = String.valueOf(Integer.parseInt(id));
            String userId = (String) session.getAttribute("user_id");


            if (!ComplaintModel.canUserUpdate(cid, userId, (BasicDataSource) req.getServletContext().getAttribute("ds"))) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }
            ComplaintDTO exist = ComplaintModel.getComplaintById(cid, (BasicDataSource) req.getServletContext().getAttribute("ds"));
            if (exist == null) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }

            req.setAttribute("complaint", exist);
            req.getRequestDispatcher("/update-complaint.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
        catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }
}
