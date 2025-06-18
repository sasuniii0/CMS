package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.gdse.dto.ComplaintDTO;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;

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
        String id = req.getParameter("cid");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String status = req.getParameter("status");
        String image = req.getParameter("image");
        String remarks = req.getParameter("remarks");
        String user_id = (String) session.getAttribute("user_id");

        if (id == null || title == null || description == null || status == null || image == null || remarks == null) {
           req.setAttribute("errpr", "All fields are required.");
            req.getRequestDispatcher("update-complaint.jsp").forward(req, resp);
            return;
        }
        try{
            String cid = String.valueOf(Integer.parseInt(id));
            String  userId = (String) session.getAttribute("user_id");

            if (!ComplaintModel.canUserUpdate(cid,userId,ds)){
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }
            ComplaintDTO complaintDTO = new ComplaintDTO(cid, title, description, status, image, remarks, userId);
            complaintDTO.setCid(cid);
            complaintDTO.setTitle(title.trim());
            complaintDTO.setDescription(description.trim());
            complaintDTO.setStatus(status.trim());
            complaintDTO.setImage(image.trim());
            complaintDTO.setRemarks(remarks.trim());
            complaintDTO.setUser_id(userId);

            boolean isUpdated = ComplaintModel.updateComplaint(complaintDTO, (BasicDataSource) req.getServletContext().getAttribute("ds"));
            if (isUpdated) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } else {
                req.setAttribute("error", "Failed to update complaint");
                ComplaintDTO exist = ComplaintModel.getComplaintById(cid,ds);
                req.setAttribute("complaint", exist);
                req.getRequestDispatcher("/submit-update-delete-complaint.jsp").forward(req, resp);
            }
        }catch (Exception e){
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (Throwable e) {
            e.printStackTrace();
            req.setAttribute("error", "Invalid request: " + e.getMessage());
            req.getRequestDispatcher("/submit-update-delete-complaint.jsp").forward(req, resp);
        }
    }
}
