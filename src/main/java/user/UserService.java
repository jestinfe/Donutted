package user;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import util.CryptoUtil;
import util.RangeDTO;

public class UserService {

    private final UserDAO userDAO = UserDAO.getInstance();

    private String safeDecrypt(String value) {
        try {
            return CryptoUtil.isValidBase64(value) ? CryptoUtil.decrypt(value) : value;
        } catch (Exception e) {
            return value;
        }
    }

    public UserDTO getUserById(int userId) {
    	 if (userId <= 0) {
    	        System.err.println("UserService: Invalid userId = " + userId);
    	        return null;
    	    }
        try {
            UserDTO dto = userDAO.selectById(userId);
            if (dto != null) {
                dto.setName(safeDecrypt(dto.getName()));
                dto.setEmail(safeDecrypt(dto.getEmail()));
                dto.setPhone(safeDecrypt(dto.getPhone()));
                dto.setAddress1(safeDecrypt(dto.getAddress1()));
                dto.setAddress2(safeDecrypt(dto.getAddress2()));
            }else {
                System.out.println("No user found for userId = " + userId);
            }
            
            return dto;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public UserDTO login(String username, String password) {
        try {
            String hashedPassword = CryptoUtil.hashSHA256(password);
            return userDAO.selectByUsernameAndPassword(username, hashedPassword);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateUser(UserDTO dto) {
        try {
            UserDTO original = userDAO.selectById(dto.getUserId());

            if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
                dto.setPassword(CryptoUtil.hashSHA256(dto.getPassword()));
            } else {
                dto.setPassword(original.getPassword());
            }

            dto.setName(dto.getName() != null && !dto.getName().trim().isEmpty()
                ? CryptoUtil.encrypt(dto.getName()) : original.getName());
            dto.setEmail(dto.getEmail() != null && !dto.getEmail().trim().isEmpty()
                ? CryptoUtil.encrypt(dto.getEmail()) : original.getEmail());
            dto.setPhone(dto.getPhone() != null && !dto.getPhone().trim().isEmpty()
                ? CryptoUtil.encrypt(dto.getPhone()) : original.getPhone());
            dto.setAddress1(dto.getAddress1() != null && !dto.getAddress1().trim().isEmpty()
                ? CryptoUtil.encrypt(dto.getAddress1()) : original.getAddress1());
            dto.setAddress2(dto.getAddress2() != null && !dto.getAddress2().trim().isEmpty()
                ? CryptoUtil.encrypt(dto.getAddress2()) : original.getAddress2());

            dto.setBirthdate(dto.getBirthdate() != null ? dto.getBirthdate() : original.getBirthdate());
            dto.setGender(dto.getGender() != null && !dto.getGender().trim().isEmpty()
                ? dto.getGender() : original.getGender());

            return userDAO.updateUser(dto) == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean withdrawUser(int userId) {
        try {
            // 1) 기존 사용자 조회
            UserDTO user = getUserById(userId); // 복호화 전 원본

            if (user == null) return false;

            // 2) 복호화 후 `_withdrawn_` + userId 붙이고 다시 암호화
            String email = user.getEmail() + "_withdrawn_" + userId;
            String newEmail = CryptoUtil.encrypt(email);
            String newUsername = user.getUsername() + "_withdrawn_" + userId;

            // 3) DAO에 전달
            return userDAO.withdrawUser(userId, newEmail, newUsername) == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public List<UserDTO> getAllUsers() {
        try {
            List<UserDTO> list = userDAO.selectAllUsers();
            for (UserDTO dto : list) {
                dto.setName(safeDecrypt(dto.getName()));
                dto.setEmail(safeDecrypt(dto.getEmail()));
                dto.setPhone(safeDecrypt(dto.getPhone()));
                dto.setAddress1(safeDecrypt(dto.getAddress1()));
                dto.setAddress2(safeDecrypt(dto.getAddress2()));
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<UserDTO> getUsersByRange(RangeDTO range, boolean activeOnly) {
        try {
            List<UserDTO> list = userDAO.selectUsers(range, activeOnly ? "U1" : null, false);
            for (UserDTO dto : list) {
                dto.setName(safeDecrypt(dto.getName()));
                dto.setEmail(safeDecrypt(dto.getEmail()));
                dto.setPhone(safeDecrypt(dto.getPhone()));
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<UserDTO> getUsersBySearch(RangeDTO range, boolean activeOnly) {
        try {
            List<UserDTO> allList = userDAO.selectUsers(new RangeDTO(1, Integer.MAX_VALUE), activeOnly ? "U1" : null, false);
            List<UserDTO> filtered = new ArrayList<>();
            String field = range.getField();
            String keyword = range.getKeyword();

            for (UserDTO dto : allList) {
                String name = safeDecrypt(dto.getName());
                String email = safeDecrypt(dto.getEmail());
                String phone = safeDecrypt(dto.getPhone());

                dto.setName(name);
                dto.setEmail(email);
                dto.setPhone(phone);

                boolean match = false;
                if ("name".equalsIgnoreCase(field) && name.contains(keyword)) match = true;
                else if ("email".equalsIgnoreCase(field) && email.contains(keyword)) match = true;
                else if ("phone".equalsIgnoreCase(field) && phone.contains(keyword)) match = true;
                else if ("username".equalsIgnoreCase(field) && dto.getUsername().contains(keyword)) match = true;

                if (match) filtered.add(dto);
            }

            // ✅ 정렬 추가
            if ("asc".equalsIgnoreCase(range.getSort())) {
                filtered.sort(Comparator.comparing(UserDTO::getCreatedAt));
            } else {
                filtered.sort(Comparator.comparing(UserDTO::getCreatedAt).reversed());
            }

            // ✅ 페이징 적용
            int fromIndex = Math.max(0, range.getStartNum() - 1);
            int toIndex = Math.min(filtered.size(), range.getEndNum());

            return fromIndex < filtered.size() ? filtered.subList(fromIndex, toIndex) : new ArrayList<>();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }



    public int getUserCount(boolean activeOnly) {
        try {
            return userDAO.countUsers(null, null, activeOnly ? "U1" : null);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getSearchUserCount(RangeDTO range, boolean activeOnly) {
        try {
            List<UserDTO> list = getUsersBySearch(new RangeDTO(1, Integer.MAX_VALUE), activeOnly);
            return list != null ? list.size() : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }


    public List<UserDTO> getActiveUsers() {
        try {
            List<UserDTO> list = userDAO.selectUsers(new RangeDTO(1, Integer.MAX_VALUE), "U1", false);
            for (UserDTO dto : list) {
                dto.setName(safeDecrypt(dto.getName()));
                dto.setEmail(safeDecrypt(dto.getEmail()));
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean isUsernameExists(String username) {
        try {
            return userDAO.isUsernameExists(username);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean insertUser(UserDTO dto) {
        try {
            dto.setPassword(CryptoUtil.hashSHA256(dto.getPassword()));
            dto.setName(CryptoUtil.encrypt(dto.getName()));
            dto.setEmail(CryptoUtil.encrypt(dto.getEmail()));
            dto.setPhone(CryptoUtil.encrypt(dto.getPhone()));
            dto.setAddress1(CryptoUtil.encrypt(dto.getAddress1()));
            dto.setAddress2(CryptoUtil.encrypt(dto.getAddress2()));
            return userDAO.insertUser(dto) == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isValidLogin(String username, String password) {
        try {
            return userDAO.isValidLogin(username, CryptoUtil.hashSHA256(password));
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        
    }
    
    public String findUsernameByNameAndPhone(String name, String phone) {
        try {
            return userDAO.findUsernameByNameAndPhone(
                CryptoUtil.encrypt(name), CryptoUtil.encrypt(phone));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean isValidUserForPasswordReset(String username, String email, String phone) {
        try {
            return userDAO.isValidUserForPasswordReset(
                username,
                CryptoUtil.encrypt(email),
                CryptoUtil.encrypt(phone)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean resetPassword(String username, String newPassword) {
        try {
            return userDAO.resetPassword(username, CryptoUtil.hashSHA256(newPassword));
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
