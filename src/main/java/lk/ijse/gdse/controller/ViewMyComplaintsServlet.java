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

import java.awt.desktop.PrintFilesEvent;
import java.io.IOException;
import java.util.List;

@MultipartConfig
@WebServlet("/viewMyComplaints")
public class ViewMyComplaintsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Get session and validate user
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect("index.jsp"); // Redirect to login if not authenticated
            return;
        }

        // 2. Get user info from session
        String userId = session.getAttribute("user_id").toString();
        String role = (String) session.getAttribute("role");

        // 3. Get database connection pool
        BasicDataSource ds = (BasicDataSource) getServletContext().getAttribute("ds");

        try {
            // 4. Fetch complaints from model
            List<ComplaintDTO> complaints = ComplaintModel.fetchComplaintsByEmployee(userId, role, ds);

            // 5. Set the complaints list in request attribute
            req.setAttribute("complaints", complaints); // Must match what JSP expects

            // 6. Forward to your JSP file
            req.getRequestDispatcher("view.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("error.jsp"); // Redirect to error page
        }
    }
}
