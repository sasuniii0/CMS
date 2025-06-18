package lk.ijse.gdse.controller;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

@MultipartConfig
@WebServlet("/delete-complaint")
public class DeleteComplaintServlet extends HttpServlet {
}
