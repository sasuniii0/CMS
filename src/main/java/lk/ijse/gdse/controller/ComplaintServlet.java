package lk.ijse.gdse.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.ijse.gdse.dto.ComplaintDTO;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/complaint")
public class ComplaintServlet extends HttpServlet {
    private static final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");

        try {
            String email = req.getParameter("email");
            String role = req.getParameter("role");

            if (email == null || role == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().println(mapper.writeValueAsString(
                        Map.of("error", "Email and role parameters are required")));
                return;
            }

            ServletContext sc = req.getServletContext();
            BasicDataSource ds = (BasicDataSource) sc.getAttribute("ds");

            List<ComplaintDTO> complaints = ComplaintModel.fetchComplaintsByEmployee(email, role, ds);

            resp.getWriter().println(mapper.writeValueAsString(
                    Map.of("success", true, "data", complaints)));

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().println(mapper.writeValueAsString(
                    Map.of("error", "Failed to fetch complaints: " + e.getMessage())));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");

        try {
            ComplaintDTO complaint = mapper.readValue(req.getReader(), ComplaintDTO.class);

            if (complaint.getTitle() == null || complaint.getDescription() == null || complaint.getUser_id() == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().println(mapper.writeValueAsString(
                        Map.of("success", false, "message", "Title, description and user ID are required")));
                return;
            }

            ServletContext sc = req.getServletContext();
            BasicDataSource ds = (BasicDataSource) sc.getAttribute("ds");

            boolean isSubmitted = ComplaintModel.submitComplaint(complaint, ds);

            if (isSubmitted) {
                resp.getWriter().println(mapper.writeValueAsString(
                        Map.of("success", true, "message", "Complaint submitted successfully")));
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().println(mapper.writeValueAsString(
                        Map.of("success", false, "message", "Failed to submit complaint")));
            }

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().println(mapper.writeValueAsString(
                    Map.of("success", false, "message", "Invalid request: " + e.getMessage())));
        }
    }
}
