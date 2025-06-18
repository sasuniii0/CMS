package lk.ijse.gdse.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import lk.ijse.gdse.dto.ComplaintDTO;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

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
        /*resp.setContentType("application/json");

        try {
            String email = req.getParameter("email");
            String role = req.getParameter("role");

            Integer userId = (Integer) req.getSession().getAttribute("user_id");


            if (email == null || role == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().println(mapper.writeValueAsString(
                        Map.of("error", "Email and role parameters are required")));
                return;
            }

            ServletContext sc = req.getServletContext();
            BasicDataSource ds = (BasicDataSource) sc.getAttribute("ds");

            List<ComplaintDTO> complaints = ComplaintModel.fetchComplaintsByEmployee(userId, role, ds);
            req.setAttribute("complaints", complaints);

            req.getRequestDispatcher("/complaints.jsp").forward(req, resp);

            *//*resp.getWriter().println(mapper.writeValueAsString(
                    Map.of("success", true, "data", complaints)));

            resp.sendRedirect(req.getContextPath() + "/complaints.jsp");*//*

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().println("Error loading complaints: " + e.getMessage());
        }*/
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");

        try {
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            Part filePart = req.getPart("image");

            String file = filePart.getSubmittedFileName();
            String filename = UUID.randomUUID() + "_" + file;
            String path = "C:\\Users\\User\\OneDrive\\Documents\\JAVAEE\\CMS-JAVAEE\\web\\assets";

            java.io.File uploadDir = new java.io.File(path);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = path + java.io.File.separator + filename;
            filePart.write(filePath);

            Integer userId = (Integer) req.getSession().getAttribute("user_id");

            if (title == null || description == null || userId == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().println(mapper.writeValueAsString(
                        Map.of("success", false, "message", "Title, description and user session are required")));
                return;
            }

            ComplaintDTO complaint = new ComplaintDTO();
            complaint.setTitle(title);
            complaint.setDescription(description);
            complaint.setUser_id(userId.toString());
            complaint.setImage("assets/" + filename);

            ServletContext sc = req.getServletContext();
            BasicDataSource ds = (BasicDataSource) sc.getAttribute("ds");

            boolean isSubmitted = ComplaintModel.submitComplaint(complaint, ds);

            if (isSubmitted) {
                resp.sendRedirect(req.getContextPath() + "/complaint?role=" + req.getParameter("role"));
            } else {
                req.setAttribute("error", "Failed to submit complaint");
                req.getRequestDispatcher("/complaints.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Invalid request: " + e.getMessage());
            req.getRequestDispatcher("/complaints.jsp").forward(req, resp);
        }
    }
}
