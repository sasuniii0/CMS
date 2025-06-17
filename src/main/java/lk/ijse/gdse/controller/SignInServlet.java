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

@WebServlet("/signin")
public class SignInServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        String role = UserModel.getRole(email,ds);
        boolean user = UserModel.findUser(new UserDTO(email, password,role),role, ds);
        System.out.println("user found: " + user);

        if (role == null || email == null || password == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        if (role.equals("admin")) {
            resp.sendRedirect(req.getContextPath() + "/admin.jsp");
        } else if (role.equals("employee")) {
            resp.sendRedirect(req.getContextPath() + "/employee.jsp");
        } else {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
        }

        System.out.println("email: " + email + " password: " + password);
    }
}