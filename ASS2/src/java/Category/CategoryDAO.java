package Category;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class CategoryDAO {

    // Lấy tất cả danh mục
    public List<CategoryDTO> getAllCategories() {
        List<CategoryDTO> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name FROM Categories";

        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(new CategoryDTO(
                        rs.getInt("category_id"),
                        rs.getString("category_name")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    // Lấy danh mục theo phân trang
    public List<CategoryDTO> getCategoriesByPage(int page, int categoriesPerPage) {
        List<CategoryDTO> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name FROM Categories ORDER BY category_id " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int start = (page - 1) * categoriesPerPage;
            ps.setInt(1, start);
            ps.setInt(2, categoriesPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                categories.add(new CategoryDTO(
                        rs.getInt("category_id"),
                        rs.getString("category_name")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    // Lấy tổng số danh mục
    public int getTotalCategories() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM Categories";

        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    // Lấy danh mục theo ID
    public CategoryDTO getCategoryById(int categoryId) {
        String sql = "SELECT category_id, category_name FROM Categories WHERE category_id = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new CategoryDTO(
                        rs.getInt("category_id"),
                        rs.getString("category_name")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
