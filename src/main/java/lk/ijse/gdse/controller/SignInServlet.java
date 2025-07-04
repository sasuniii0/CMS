package lk.ijse.gdse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.gdse.bean.UserDTO;
import lk.ijse.gdse.model.UserModel;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;

@WebServlet("/signin")
public class SignInServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");

        String role = UserModel.getRole(email, ds);
        boolean user = UserModel.findUser(new UserDTO(email, password, role), role, ds);
        System.out.println("user found: " + user);

        if (!user) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        } else {
            System.out.println("User authenticated successfully");

            String userId = UserModel.getUserIdByEmail(email, ds);
            System.out.println("Fetched userId: " + userId);

            HttpSession session = req.getSession();
            session.setAttribute("email", email);
            session.setAttribute("role", role);
            session.setAttribute("user_id", userId);

            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        }
        System.out.println("email: " + email + " password: " + password + " role: " + role);
    }

}