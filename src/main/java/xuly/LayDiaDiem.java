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
        String username = req.getParameter("user");

        int page = 1;
        try {
            if(req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page"));
        } catch (Exception e) { page = 1; }

        int limit = 10;
        int offset = (page - 1) * limit;

        Connection conn = KetNoiCSDL.layKetNoi();
        StringBuilder jsonBody = new StringBuilder("[");
        int totalPages = 0;

        if (conn != null) {
            try {
                // 1. Đếm tổng số trang
                String sqlCount = "SELECT COUNT(*) FROM DiaDiem WHERE id_city = ?";
                if (typeId != null && !typeId.equals("0")) {
                    sqlCount += " AND id_loai_hinh = ?"; // Sửa thành id_loai_hinh
                }
                PreparedStatement stmtCount = conn.prepareStatement(sqlCount);
                stmtCount.setString(1, idCity);
                if (typeId != null && !typeId.equals("0")) {
                    stmtCount.setString(2, typeId);
                }
                ResultSet rsCount = stmtCount.executeQuery();
                if (rsCount.next()) {
                    int total = rsCount.getInt(1);
                    totalPages = (int) Math.ceil((double) total / limit);
                }

                // 2. Lấy dữ liệu (SỬA ĐOẠN NÀY: JOIN VỚI BẢNG LOAIHINH)
                String sqlData = "SELECT d.*, l.ten_loai_hinh, IF(s.username IS NOT NULL, 'true', 'false') as da_thich " +
                        "FROM DiaDiem d " +
                        "LEFT JOIN LoaiHinh l ON d.id_loai_hinh = l.id " + // JOIN để lấy tên loại
                        "LEFT JOIN SoThich s ON d.id = s.id_dia_diem AND s.username = ? " +
                        "WHERE d.id_city = ?";

                if (typeId != null && !typeId.equals("0")) {
                    sqlData += " AND d.id_loai_hinh = ?";
                }
                sqlData += " LIMIT ? OFFSET ?";

                PreparedStatement stmtData = conn.prepareStatement(sqlData);
                int paramIndex = 1;
                stmtData.setString(paramIndex++, username);
                stmtData.setString(paramIndex++, idCity);

                if (typeId != null && !typeId.equals("0")) {
                    stmtData.setString(paramIndex++, typeId);
                }
                stmtData.setInt(paramIndex++, limit);
                stmtData.setInt(paramIndex, offset);

                ResultSet rs = stmtData.executeQuery();
                boolean isFirst = true;

                while (rs.next()) {
                    if (!isFirst) jsonBody.append(",");

                    boolean isFav = Boolean.parseBoolean(rs.getString("da_thich"));

                    // Lấy tên loại hình từ bảng LoaiHinh (l.ten_loai_hinh)
                    String tenLoai = rs.getString("ten_loai_hinh");
                    if(tenLoai == null) tenLoai = "Khác"; // Dự phòng nếu null

                    jsonBody.append("{")
                            .append("\"id\":").append(rs.getInt("id")).append(",")
                            .append("\"ten\":\"").append(rs.getString("ten_dia_diem")).append("\",")
                            .append("\"diachi\":\"").append(rs.getString("dia_chi")).append("\",")
                            .append("\"loai\":\"").append(tenLoai).append("\",") // Gán tên loại chuẩn vào JSON
                            .append("\"is_fav\":").append(isFav)
                            .append("}");
                    isFirst = false;
                }
                conn.close();
            } catch (Exception e) { e.printStackTrace(); }
        }
        jsonBody.append("]");
        out.print("{\"status\":\"success\", \"total_pages\":" + totalPages + ", \"data\":" + jsonBody.toString() + "}");
        out.flush();
    }
}