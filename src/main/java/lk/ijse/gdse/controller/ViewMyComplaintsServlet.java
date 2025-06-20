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
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig
@WebServlet("/viewMyComplaints")
public class ViewMyComplaintsServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(ViewMyComplaintsServlet.class.getName());
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect("index.jsp");
            return;
        }

        String userId = session.getAttribute("user_id").toString();
        String role = (String) session.getAttribute("role");
        logger.info("Fetching complaints for user ID: " + userId + ", role: " + role);


        BasicDataSource ds = (BasicDataSource) getServletContext().getAttribute("ds");

        try {
            List<ComplaintDTO> complaints = ComplaintModel.fetchComplaintsByEmployee(userId, role, ds);
            logger.info("Found " + complaints.size() + " complaints");

            req.setAttribute("complaints", complaints);
            req.getRequestDispatcher("view.jsp").forward(req, resp);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error fetching complaints", e);
            req.setAttribute("error", "Error loading complaints: " + e.getMessage());
            req.getRequestDispatcher("view.jsp").forward(req, resp);
        }
    }
}
