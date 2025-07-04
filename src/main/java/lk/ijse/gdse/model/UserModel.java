package lk.ijse.gdse.model;

import lk.ijse.gdse.bean.UserDTO;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

public class UserModel {
    public static boolean findUser(UserDTO userDTO, String role, BasicDataSource ds) {
        try{
            Connection connection = ds.getConnection();
            PreparedStatement pstm = connection.prepareStatement(
                    "SELECT * FROM users WHERE email = ? AND password = ? AND role = ?");
            pstm.setString(1, userDTO.getEmail());
            pstm.setString(2, userDTO.getPassword());
            pstm.setString(3, role);
            ResultSet rst = pstm.executeQuery();
            if (rst.next()) {
                return true;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return false;
    }

    public static boolean saveUser(UserDTO userDTO, BasicDataSource ds) {
        try{
            Connection connection = ds.getConnection();
            PreparedStatement pstm = connection.prepareStatement(
                    "INSERT INTO users (uid, username, email, password,role) VALUES (?,?,?,?,?)");
            pstm.setString(1, UUID.randomUUID().toString());
            pstm.setString(2, userDTO.getEmail());
            pstm.setString(3, userDTO.getUsername());
            pstm.setString(4, userDTO.getPassword());
            pstm.setString(5, userDTO.getRole());
            int i = pstm.executeUpdate();
            if (i > 0) {
                return true;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return false;
    }

    public static String getRole(String email, BasicDataSource ds) {
        try {
            Connection connection = ds.getConnection();
            PreparedStatement pstm = connection.prepareStatement(
                    "SELECT role FROM users WHERE email = ?");
            pstm.setString(1, email);
            ResultSet rst = pstm.executeQuery();
            if (rst.next()) {
                return rst.getString("role");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public static String  getUserIdByEmail(String email, BasicDataSource ds) {
        try (Connection con = ds.getConnection();
             PreparedStatement stm = con.prepareStatement("SELECT uid FROM users WHERE email = ?")) {
            stm.setString(1, email);

            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getString("uid");
            } else {
                throw new SQLException("User ID not found for email: " + email);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
