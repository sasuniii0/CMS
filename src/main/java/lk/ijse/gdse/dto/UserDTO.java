package lk.ijse.gdse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserDTO {
    private String id;
    private String username;
    private String email;
    private String password;
    private String role;

    public UserDTO(String email, String password) {
        this.email = email;
        this.password = password;
    }
    public UserDTO(String email, String password, String role) {
        this.email = email;
        this.password = password;
        this.role = role;
    }
}
