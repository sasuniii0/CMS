package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.ijse.gdse.dto.ComplaintDTO;
import lk.ijse.gdse.model.ComplaintModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.util.List;

@WebServlet("/viewAllComplaints")
public class ViewAllComplaintsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // 1. Get DataSource from servlet context
            BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

            // 2. Fetch complaints from model
            List<ComplaintDTO> allComplaints = ComplaintModel.getAllComplaints(ds);

            // 3. Log for debugging
            System.out.println("Number of complaints fetched: " + allComplaints.size());

            // 4. Set attribute for JSP
            req.setAttribute("complaintsList", allComplaints);

            // 5. Forward to JSP
            req.getRequestDispatcher("view-all-complaints.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading complaints: " + e.getMessage());
        }
    }
}