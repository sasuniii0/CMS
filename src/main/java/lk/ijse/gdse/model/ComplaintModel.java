package lk.ijse.gdse.model;

import lk.ijse.gdse.dto.ComplaintDTO;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ComplaintModel {
    public static List<ComplaintDTO> fetchComplaintsByEmployee(String email, String role, BasicDataSource ds)
            throws SQLException {

        List<ComplaintDTO> complaints = new ArrayList<>();
        String sql;

        if ("admin".equalsIgnoreCase(role)) {
            sql = "SELECT * FROM complaints";
        } else {
            sql = "SELECT * FROM complaints WHERE user_id = ?";
        }

        try (Connection connection = ds.getConnection();
             PreparedStatement pstm = connection.prepareStatement(sql)) {

            if (!"admin".equalsIgnoreCase(role)) {
                pstm.setString(1, email);
            }

            try (ResultSet rst = pstm.executeQuery()) {
                while (rst.next()) {
                    ComplaintDTO complaint = new ComplaintDTO();
                    complaint.setCid(rst.getString("cid"));
                    complaint.setTitle(rst.getString("title"));
                    complaint.setImage(rst.getString("image"));
                    complaint.setDescription(rst.getString("description"));
                    complaint.setStatus(rst.getString("status"));
                    complaint.setRemarks(rst.getString("remarks"));
                    complaint.setUser_id(rst.getString("user_id"));
                    complaints.add(complaint);
                }
            }
        }
        return complaints;
    }

    public static boolean submitComplaint(ComplaintDTO complaint, BasicDataSource ds) {
        try{
            Connection connection = ds.getConnection();
            PreparedStatement pstm = connection.prepareStatement("INSERT INTO complaints (cid, title, image, description, status, remarks, user_id, created_date) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

            String id = UUID.randomUUID().toString(); // Generate a unique ID
            pstm.setString(1, id);
            pstm.setString(2, complaint.getTitle());
            pstm.setString(3, complaint.getImage());
            pstm.setString(4, complaint.getDescription());
            pstm.setString(5, complaint.getStatus());
            pstm.setString(6, complaint.getRemarks());
            pstm.setString(7, complaint.getUser_id());
            return pstm.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
