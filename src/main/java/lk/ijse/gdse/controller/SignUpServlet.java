package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.ijse.gdse.dto.UserDTO;
import lk.ijse.gdse.model.UserModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/signup")
public class SignUpServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = UUID.randomUUID().toString();
        String email = req.getParameter("email");
        String fullName = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        boolean isSaved= UserModel.saveUser(new UserDTO(id, email, fullName, password, role), ds);
        if (isSaved) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
        }


        System.out.println("email: " + email + " fullName: " + fullName + " password: " + password + " role: " + role);
    }
}
