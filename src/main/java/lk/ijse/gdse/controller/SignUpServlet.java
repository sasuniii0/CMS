package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.ijse.gdse.bean.UserDTO;
import lk.ijse.gdse.model.UserModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/signup")
public class SignUpServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");

        String email = req.getParameter("email");
        String fullName = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        if (email == null || fullName == null || password == null || role == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing signup fields");
            return;
        }

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        boolean isSaved = UserModel.saveUser(new UserDTO(UUID.randomUUID().toString(), email, fullName, password, role), ds);

        if (isSaved) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to register user");
        }

        System.out.println("email: " + email + " fullName: " + fullName + " password: " + password + " role: " + role);
    }
}
