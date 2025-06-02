package user;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class UserDTO {
	private int userId;
    private String username;
    private String password;
    private String email;
    private String name;
    private Date birthdate;
    private String gender;
    private String phone;
    private String zipcode;
    private String address1;
    private String address2;
    private String userStatus;
    private Date createdAt;

}
