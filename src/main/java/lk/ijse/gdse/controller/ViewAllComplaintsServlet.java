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

@MultipartConfig
@WebServlet("/viewAllComplaints")
public class ViewAllComplaintsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try{
            BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
            List<ComplaintDTO> allComplaints = ComplaintModel.getAllComplaints(ds);
            req.setAttribute("allComplaints", allComplaints);
            req.getRequestDispatcher("view-all-complaints.jsp").forward(req, resp);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
