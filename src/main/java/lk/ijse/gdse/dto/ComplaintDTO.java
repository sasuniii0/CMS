package lk.ijse.gdse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ComplaintDTO {
    private String cid;
    private String title;
    private String image;
    private String description;
    private String status;
    private String user_id;
}
