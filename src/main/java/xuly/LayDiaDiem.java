package xuly;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tienich.KetNoiCSDL;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/api/lay-dia-diem")
public class LayDiaDiem extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String idCity = req.getParameter("id_city");
        String typeId = req.getParameter("type");
        String username = req.getParameter("user"); // NHẬN THÊM USERNAME
        int page = 1;
        int limit = 10; // Giới hạn 10 địa điểm/trang

        try {
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
        } catch (NumberFormatException e) { page = 1; }

        int offset = (page - 1) * limit; // Tính vị trí bắt đầu lấy (VD: trang 2 thì bỏ qua 10 cái đầu)

        Connection conn = KetNoiCSDL.layKetNoi();
        StringBuilder jsonBody = new StringBuilder();
        int totalPages = 0;

        if (conn != null) {
            try {
                // 1. Đếm tổng số lượng (để tính số trang)
                String sqlCount = "SELECT COUNT(*) FROM DiaDiem WHERE id_city = ?";
                if (typeId != null && !typeId.equals("0")) {
                    sqlCount += " AND id_loai_hinh = ?";
                }

                PreparedStatement stmtCount = conn.prepareStatement(sqlCount);
                stmtCount.setString(1, idCity);
                if (typeId != null && !typeId.equals("0")) {
                    stmtCount.setString(2, typeId);
                }

                ResultSet rsCount = stmtCount.executeQuery();
                int totalRecords = 0;
                if (rsCount.next()) totalRecords = rsCount.getInt(1);

                // Tính tổng số trang (Ví dụ 25 dòng -> 3 trang)
                totalPages = (int) Math.ceil((double) totalRecords / limit);

                // 2. Lấy dữ liệu phân trang

                String sqlData = "SELECT d.*, IF(s.username IS NOT NULL, 'true', 'false') as da_thich " +
                        "FROM DiaDiem d " +
                        "LEFT JOIN SoThich s ON d.id = s.id_dia_diem AND s.username = ? " +
                        "WHERE d.id_city = ?";

                if (typeId != null && !typeId.equals("0")) {
                    sqlData += " AND d.id_loai_hinh = ?";
                }
                sqlData += " LIMIT ? OFFSET ?";

                PreparedStatement stmtData = conn.prepareStatement(sqlData);
                int paramIndex = 1;
                stmtData.setString(paramIndex++, username); // Tham số 1: username
                stmtData.setString(paramIndex++, idCity);   // Tham số 2: id_city

                if (typeId != null && !typeId.equals("0")) {
                    stmtData.setString(paramIndex++, typeId);
                }
                stmtData.setInt(paramIndex++, limit);
                stmtData.setInt(paramIndex, offset);

                ResultSet rs = stmtData.executeQuery();
                boolean isFirst = true;

                while (rs.next()) {
                    if (!isFirst) jsonBody.append(",");

                    // Lấy trạng thái thích
                    boolean isFav = Boolean.parseBoolean(rs.getString("da_thich"));

                    jsonBody.append("{")
                            .append("\"id\":").append(rs.getInt("id")).append(",")
                            .append("\"ten\":\"").append(rs.getString("ten_dia_diem")).append("\",")
                            .append("\"diachi\":\"").append(rs.getString("dia_chi")).append("\",")
                            .append("\"loai\":\"").append(rs.getString("loai_hinh")).append("\",")
                            .append("\"is_fav\":").append(isFav) // Thêm trường này vào JSON
                            .append("}");
                    isFirst = false;
                }
                conn.close();
            } catch (Exception e) { e.printStackTrace(); }
        }

        // Trả về JSON gồm: dữ liệu danh sách + tổng số trang
        String finalJson = "{\"status\": \"success\", \"total_pages\": " + totalPages + ", \"current_page\": " + page + ", \"data\": [" + jsonBody.toString() + "]}";
        out.print(finalJson);
        out.flush();
    }
}