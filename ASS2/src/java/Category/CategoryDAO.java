package Category;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class CategoryDAO {

    public List<CategoryDTO> getAllCategories() throws Exception {
        List<CategoryDTO> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name FROM Categories";

        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CategoryDTO category = new CategoryDTO();
                category.setCategoryId(rs.getInt("category_id"));  // Đổi thành đúng tên cột
                category.setCategoryName(rs.getString("category_name")); // Đổi thành đúng tên cột
                categories.add(category);
            }
        }
        return categories;
    }
}
