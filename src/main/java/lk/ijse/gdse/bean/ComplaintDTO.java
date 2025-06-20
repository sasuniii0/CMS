package lk.ijse.gdse.bean;

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
    private String remarks;
    private String user_id;
}
