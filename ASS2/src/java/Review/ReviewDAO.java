/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

/**
 *
 * @author Longtri
 */
public class ReviewDAO {
    public double getAverageRatingByProductId(int productId) {
        double avgRating = 0.0;
        String sql = "SELECT COALESCE(AVG(rating), 0) AS avg_rating FROM reviews WHERE product_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                avgRating = rs.getDouble("avg_rating");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return avgRating;
    }
    
    public List<ReviewDTO> getReviewsByProductId(int productId) {
    List<ReviewDTO> reviews = new ArrayList<>();
    String sql = "SELECT * FROM reviews WHERE product_id = ? ORDER BY created_at DESC";

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, productId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            reviews.add(new ReviewDTO(
                    rs.getInt("review_id"),
                    rs.getInt("user_id"),
                    rs.getInt("product_id"),
                    rs.getInt("rating"),
                    rs.getString("comment"),
                    rs.getTimestamp("created_at").toLocalDateTime()
            ));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return reviews;
}
}
