package Users;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class UserDAO {

    // Lấy danh sách tất cả người dùng
    public List<UserDTO> getAllUsers() throws SQLException {
        List<UserDTO> users = new ArrayList<>();
        String sql = "SELECT user_id, name, email, phone, address, role, created_at FROM Users";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                UserDTO user = new UserDTO();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                
                users.add(user);
            }
        }
        return users;
    }

    // Lấy thông tin người dùng theo ID
    public UserDTO getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                UserDTO user = new UserDTO();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public List<UserDTO> searchUsers(String keyword) {
            List<UserDTO> userList = new ArrayList<>();
            String sql = "SELECT * FROM Users WHERE role = 'user' AND "
                   + "(name LIKE ? OR email LIKE ? OR phone LIKE ? OR address LIKE ?)";

            try (Connection conn = DBUtils.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, "%" + keyword.toLowerCase() + "%");
                stmt.setString(2, "%" + keyword.toLowerCase() + "%");
                stmt.setString(3, "%" + keyword + "%");
                stmt.setString(4, "%" + keyword.toLowerCase() + "%");

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    UserDTO user = new UserDTO();
                    user.setUserId(rs.getInt("user_id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));

                    userList.add(user);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return userList;
        }
        
          public List<UserDTO> getUsersByPage(int page, int limit) {
        List<UserDTO> userList = new ArrayList<>();
        int offset = (page - 1) * limit;
        
        String sql = "SELECT * FROM Users WHERE role = 'user' ORDER BY user_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, offset);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                UserDTO user = new UserDTO();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }
         
          public int getTotalUsers() {
   int count = 0;
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
          
          }

    // Thêm người dùng mới
   public static boolean insertUser(UserDTO user) {
    String sql = "INSERT INTO Users (name, email, phone, address, role, created_at, password) VALUES (z?, ?, ?, ?, ?, ?, ?)";
    try (Connection conn = DBUtils.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

        stmt.setString(1, user.getName());
        stmt.setString(2, user.getEmail());
        stmt.setString(3, user.getPhone());
        stmt.setString(4, user.getAddress());
        stmt.setString(5, user.getRole());
        stmt.setTimestamp(6, user.getCreatedAt());
        stmt.setString(7, user.getPassword()); // Lưu mật khẩu

        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {    
                user.setUserId(rs.getInt(1)); // Lấy ID vừa tạo
            }
            return true;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
   public static boolean isEmailExists(String email) {
    String sql = "SELECT 1 FROM Users WHERE email = ?";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        return rs.next(); // Nếu có dữ liệu, email đã tồn tại
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}


    // Cập nhật thông tin người dùng
    public boolean updateUser(UserDTO user) {
        String sql = "UPDATE Users SET name=?, email=?, phone=?, address=?, role=?, created_at=? WHERE user_id=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getRole());
            stmt.setTimestamp(6, user.getCreatedAt());
            stmt.setInt(7, user.getUserId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa người dùng
    public boolean deleteUser(int userId) {
    String sql = "DELETE FROM Users WHERE user_id = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        return stmt.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
    
    public UserDTO checkLogin(String email, String password) throws SQLException {
        UserDTO user = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM [Users] WHERE email = ? AND password = ?";
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(sql);
                ptm.setString(1, email);
                ptm.setString(2, password);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    int userId = rs.getInt("user_id");            
                    String phone = rs.getString("phone");            
                    String name = rs.getString("name");            
                    String address = rs.getString("address");            
                    String role = rs.getString("role");            
                    Timestamp createdAt = rs.getTimestamp("created_at");            
                    user = new UserDTO( userId,name,  email,  phone,  address,  role,  createdAt, password);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return user;
    }
}
