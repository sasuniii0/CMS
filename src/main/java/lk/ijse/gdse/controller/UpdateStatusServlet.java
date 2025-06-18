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

@MultipartConfig
@WebServlet("/updateStatus")
public class UpdateStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String cid = req.getParameter("cid");
        if (cid == null || cid.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        String id;
        try{
            id = String.valueOf(Integer.parseInt(cid));
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        ComplaintDTO complaintDTO = ComplaintModel.getComplaintById(id,ds);
        if (complaintDTO == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        req.setAttribute("complaint", complaintDTO);
        req.getRequestDispatcher("updateStatus.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String cid = req.getParameter("cid");
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        if ("pending".equals(status)){
            status = "pending";
        } else if ("resolved".equals(status)){
            status = "resolved";
        } else if ("rejected".equals(status)){
            status = "rejected";
        }

        ComplaintModel.updateStatusAndRemarks(cid,status, remarks,ds);
        req.setAttribute("success", "Status updated successfully");
        resp.sendRedirect(req.getContextPath() + "/viewAllComplaints");
    }
}
