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
        List<ComplaintDTO> complaints = new ArrayList<>();
        String sql = "SELECT title, image,description, status,remarks FROM complaints WHERE user_id = ? ORDER BY cid DESC";

        try (Connection connection = ds.getConnection();
             PreparedStatement pstm = connection.prepareStatement(sql)) {

            pstm.setString(1, userId);

            try (ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    ComplaintDTO dto = new ComplaintDTO();
                    dto.setTitle(rs.getString("title"));
                    dto.setDescription(rs.getString("description"));
                    dto.setStatus(rs.getString("status"));
                    dto.setImage(rs.getString("image"));
                    dto.setRemarks(rs.getString("remarks"));
                    complaints.add(dto);
                }
            }
        }
        return complaints;
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

    public static List<ComplaintDTO> getAllComplaints(BasicDataSource ds) throws SQLException {
        if (ds == null) {
            throw new IllegalArgumentException("DataSource cannot be null");
        }

        List<ComplaintDTO> complaints = new ArrayList<>();
        String sql = "SELECT cid, title, description, image, status, remarks, user_id FROM complaints";

        try (Connection connection = ds.getConnection();
             PreparedStatement pstm = connection.prepareStatement(sql);
             ResultSet rst = pstm.executeQuery()) {

            while (rst.next()) {
                ComplaintDTO complaint = new ComplaintDTO();
                complaint.setCid(rst.getString("cid"));
                complaint.setTitle(rst.getString("title"));
                complaint.setDescription(rst.getString("description"));
                complaint.setImage(rst.getString("image"));
                complaint.setStatus(rst.getString("status"));
                complaint.setRemarks(rst.getString("remarks"));
                complaint.setUser_id(rst.getString("user_id"));
                complaints.add(complaint);
            }
        }
        return complaints;
    }

    public static boolean canUserUpdate(String cid, String userId, BasicDataSource ds) {
        Connection connection = null;
        PreparedStatement pstm = null;
        ResultSet rst = null;

        try {
            connection = ds.getConnection();
            pstm = connection.prepareStatement(
                    "SELECT COUNT(*) FROM complaints WHERE cid = ? AND user_id = ? AND status != 'RESOLVED'"
            );
            pstm.setString(1, cid);
            pstm.setString(2, userId);

            rst = pstm.executeQuery();
            return rst.next() && rst.getInt(1) > 0;

        } catch (SQLException e) {
            // Log the error properly
            System.err.println("Error checking user update permission for complaint " + cid +
                    ", user " + userId + ": " + e.getMessage());
            return false;
        } finally {
            // Close resources in reverse order
            try { if (rst != null) rst.close(); } catch (SQLException e) { /* ignore */ }
            try { if (pstm != null) pstm.close(); } catch (SQLException e) { /* ignore */ }
            try { if (connection != null) connection.close(); } catch (SQLException e) { /* ignore */ }
        }
    }

    public static ComplaintDTO getComplaintById(String cid, BasicDataSource ds) {
        if (cid == null || cid.trim().isEmpty()) {
            throw new IllegalArgumentException("Complaint ID cannot be null or empty");
        }

        try (Connection connection = ds.getConnection();
             PreparedStatement pstm = connection.prepareStatement(
                     "SELECT cid, title, description, image, status, remarks, user_id " +
                             "FROM complaints WHERE cid = ?")) {

            try {
                pstm.setInt(1, Integer.parseInt(cid));
            } catch (NumberFormatException e) {
                pstm.setString(1, cid);
            }

            try (ResultSet rst = pstm.executeQuery()) {
                if (rst.next()) {
                    ComplaintDTO complaint = new ComplaintDTO();
                    complaint.setCid(rst.getString("cid"));
                    complaint.setTitle(rst.getString("title"));
                    complaint.setDescription(rst.getString("description"));
                    complaint.setImage(rst.getString("image"));
                    complaint.setStatus(rst.getString("status"));
                    complaint.setRemarks(rst.getString("remarks"));
                    complaint.setUser_id(rst.getString("user_id"));
                    return complaint;
                }
                return null; // Explicit return null if not found
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching complaint with ID " + cid + ": " +
                    e.getMessage(), e);
        }
    }

    public static boolean updateStatusAndRemarks(String cid, String status, String remarks, BasicDataSource ds) {
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
        return false;
    }


    public static int deleteComplaintByCid(String cid, BasicDataSource ds) throws SQLException {
        try (Connection conn = ds.getConnection();
             PreparedStatement pstm = conn.prepareStatement(
                     "DELETE FROM complaints WHERE cid = ?")) {

            pstm.setString(1, cid);
            return pstm.executeUpdate();
        }
    }
}
