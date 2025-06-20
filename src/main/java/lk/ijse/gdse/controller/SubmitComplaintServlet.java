package lk.ijse.gdse.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.ijse.gdse.dto.ComplaintDTO;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@MultipartConfig
@WebServlet("/complaint")
public class SubmitComplaintServlet extends HttpServlet {
    private static final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }
        String role = req.getParameter("role");
        req.setAttribute("role", role);
        req.getRequestDispatcher("/submit-complaint.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        try {
            String cid = req.getParameter("uid");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            Part filePart = req.getPart("image");
            String userId = (String) session.getAttribute("user_id"); // Must be String

            System.out.println(cid + " " + title + " " + description + " " + userId);
            if (title == null || title.trim().isEmpty() ||
                    description == null || description.trim().isEmpty()) {
                req.setAttribute("error", "Title and description are required");
                req.getRequestDispatcher("/submit-complaint.jsp").forward(req, resp);
                return;
            }

            ComplaintDTO complaint = new ComplaintDTO();
            complaint.setCid(cid);
            complaint.setTitle(title.trim());
            complaint.setDescription(description.trim());
            complaint.setUser_id(userId);
            complaint.setStatus("PENDING"); // Default status

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/assets");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                complaint.setImage("assets/" + fileName);
            }

            BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
            boolean isSubmitted = ComplaintModel.submitComplaint(complaint, ds);

            if (isSubmitted) {
                resp.sendRedirect(req.getContextPath() + "/viewMyComplaints");
            } else {
                req.setAttribute("error", "Failed to submit complaint");
                req.getRequestDispatcher("/submit-complaint.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error submitting complaint: " + e.getMessage());
            req.getRequestDispatcher("/submit-complaint.jsp").forward(req, resp);
        }
    }
}
