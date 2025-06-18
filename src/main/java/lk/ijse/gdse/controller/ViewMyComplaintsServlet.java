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

@MultipartConfig
@WebServlet("/viewMyComplaints")
public class ViewMyComplaintsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect("index.jsp");
            return;
        }

        String id = req.getParameter("id");
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        try{
            String  complaintId = String.valueOf(Integer.parseInt(id));
            String  userId = (String) session.getAttribute("user_id");
            String userRole = (String) session.getAttribute("role");

            ComplaintDTO complaintDTO = (ComplaintDTO) ComplaintModel.fetchComplaintsByEmployee(complaintId,userRole,userId,ds);
            if (complaintDTO == null) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
            req.setAttribute("complaint", complaintDTO);
            req.getRequestDispatcher("viewMyComplaints.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }
}
