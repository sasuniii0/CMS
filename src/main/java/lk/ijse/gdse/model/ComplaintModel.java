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
    public static boolean submitComplaint(ComplaintDTO complaint, BasicDataSource ds) {
        try{
            Connection connection = ds.getConnection();
            PreparedStatement pstm = connection.prepareStatement("INSERT INTO complaints (cid, title, image, description, status, remarks, user_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)");

            String id = UUID.randomUUID().toString();
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

    public static List<ComplaintDTO> fetchComplaintsByEmployee(String userId, String role, BasicDataSource ds) throws SQLException {
        System.out.println("Executing query for user: " + userId + ", role: " + role);

        String sql = "SELECT * FROM complaints WHERE user_id = ?";
        if ("admin".equals(role)) {
            sql = "SELECT * FROM complaints";
        }

        try (Connection connection = ds.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {

            if (!"admin".equals(role)) {
                pstmt.setString(1, userId);
            }

            ResultSet rs = pstmt.executeQuery();
            List<ComplaintDTO> complaints = new ArrayList<>();

            while (rs.next()) {
                ComplaintDTO complaint = new ComplaintDTO();
                complaint.setCid(rs.getString("cid"));
                complaint.setTitle(rs.getString("title"));
                complaint.setUser_id(userId);
                complaints.add(complaint);
            }

            System.out.println("Found " + complaints.size() + " complaints");
            return complaints;
        }
    }

    public static boolean updateComplaint(ComplaintDTO complaint, BasicDataSource ds) {
        try (Connection connection = ds.getConnection();
             PreparedStatement pstm = connection.prepareStatement(
                     "UPDATE complaints SET title = ?, description = ?, status = ?, remarks = ? " +
                             (complaint.getImage() != null ? ", image = ? " : "") +
                             "WHERE cid = ?")) {

            int paramIndex = 1;
            pstm.setString(paramIndex++, complaint.getTitle());
            pstm.setString(paramIndex++, complaint.getDescription());
            pstm.setString(paramIndex++, complaint.getStatus());
            pstm.setString(paramIndex++, complaint.getRemarks());

            if (complaint.getImage() != null) {
                pstm.setString(paramIndex++, complaint.getImage());
            }

            pstm.setString(paramIndex, complaint.getCid());

            return pstm.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean deleteComplaint(String cid,BasicDataSource ds) {
        try (Connection connection = ds.getConnection();
             PreparedStatement pstm = connection.prepareStatement("DELETE FROM complaints WHERE cid = ?")) {

            pstm.setString(1, cid);
            return pstm.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting complaint: " + e.getMessage(), e);
        }

    }

    public static List<ComplaintDTO> getAllComplaints(BasicDataSource ds) {
        List<ComplaintDTO> complaints = new ArrayList<>();

        try{
            Connection connection = ds.getConnection();
            PreparedStatement pstm = connection.prepareStatement("SELECT * FROM complaints");
            ResultSet rst = pstm.executeQuery();
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
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all complaints: " + e.getMessage(), e);
        }
        return complaints;
    }

    public static boolean canUserUpdate(String cid, String userId,BasicDataSource ds) {
        try{
            Connection connection = ds.getConnection();
            PreparedStatement pstm = connection.prepareStatement("SELECT COUNT(*) FROM complaints WHERE id = ? AND user_id = ? AND status != 'RESOLVED'");
            pstm.setString(1, cid);
            pstm.setString(2, userId);
            ResultSet rst = pstm.executeQuery();
            if (rst.next()) {
                return rst.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking user update permission: " + e.getMessage(), e);
        }
        return false;
    }

    public static ComplaintDTO getComplaintById(String cid, BasicDataSource ds) {
        try{
            Connection connection = ds.getConnection();
            PreparedStatement pstm = connection.prepareStatement("SELECT * FROM complaints WHERE cid = ?");
            pstm.setString(1, cid);
            ResultSet rst = pstm.executeQuery();
            if (rst.next()) {
                ComplaintDTO complaint = new ComplaintDTO();
                complaint.setCid(rst.getString("cid"));
                complaint.setTitle(rst.getString("title"));
                complaint.setImage(rst.getString("image"));
                complaint.setDescription(rst.getString("description"));
                complaint.setStatus(rst.getString("status"));
                complaint.setRemarks(rst.getString("remarks"));
                complaint.setUser_id(rst.getString("user_id"));
                return complaint;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching complaint by ID: " + e.getMessage(), e);
        }
        return null;
    }

    public static void updateStatusAndRemarks(String cid, String status, String remarks,BasicDataSource ds) {
        try{
            Connection connection = ds.getConnection();
            PreparedStatement pstm = connection.prepareStatement(
                    "UPDATE complaints SET status = ?, remarks = ? WHERE cid = ?");
            pstm.setString(1, status);
            pstm.setString(2, remarks);
            pstm.setString(3, cid);
            int i = pstm.executeUpdate();
            if (i == 0) {
                throw new RuntimeException("Failed to update complaint status and remarks");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error updating complaint status and remark: " + e.getMessage(), e);
        }
    }
}
