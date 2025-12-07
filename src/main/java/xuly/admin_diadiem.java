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

@WebServlet("/api/admin-diadiem")
public class admin_diadiem extends HttpServlet {
    // GET: Lấy danh sách địa điểm (Có lọc theo thành phố)
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String idCity = req.getParameter("id_city"); // Lọc theo thành phố
        int page = 1;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception e) {}
        int limit = 10;
        int offset = (page - 1) * limit;

        Connection conn = KetNoiCSDL.layKetNoi();
        StringBuilder jsonBody = new StringBuilder("[");
        int totalPages = 0;

        if (conn != null) {
            try {
                // Đếm tổng
                String sqlCount = "SELECT COUNT(*) FROM DiaDiem WHERE id_city = ?";
                PreparedStatement stmtCount = conn.prepareStatement(sqlCount);
                stmtCount.setString(1, idCity);
                ResultSet rsCount = stmtCount.executeQuery();
                if(rsCount.next()) totalPages = (int) Math.ceil((double) rsCount.getInt(1) / limit);

                // Lấy data
                String sql = "SELECT id, ten_dia_diem, loai_hinh FROM DiaDiem WHERE id_city = ? LIMIT ? OFFSET ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, idCity);
                stmt.setInt(2, limit);
                stmt.setInt(3, offset);
                ResultSet rs = stmt.executeQuery();

                boolean isFirst = true;
                while(rs.next()) {
                    if(!isFirst) jsonBody.append(",");
                    jsonBody.append("{")
                            .append("\"id\":").append(rs.getInt("id")).append(",")
                            .append("\"ten\":\"").append(rs.getString("ten_dia_diem")).append("\",")
                            .append("\"loai\":\"").append(rs.getString("loai_hinh")).append("\"")
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

    // POST: Thêm hoặc Xóa địa điểm
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        String action = req.getParameter("action");
        Connection conn = KetNoiCSDL.layKetNoi();

        try {
            if ("delete".equals(action)) {
                String id = req.getParameter("id");
                String sql = "DELETE FROM DiaDiem WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, id);
                stmt.executeUpdate();
                out.print("{\"status\":\"success\", \"message\":\"Đã xóa địa điểm!\"}");
            }
            else if ("add".equals(action)) {
                // Thêm địa điểm (Tạm thời fix cứng id_loai_hinh = 4 (Du lịch) cho nhanh, hoặc bạn làm thêm dropdown chọn loại)
                String ten = req.getParameter("ten");
                String diachi = req.getParameter("diachi");
                String mota = req.getParameter("mota");
                String idCity = req.getParameter("id_city");
                String loai = req.getParameter("loai"); // Chữ

                String sql = "INSERT INTO DiaDiem(ten_dia_diem, dia_chi, mo_ta, id_city, loai_hinh, id_loai_hinh) VALUES(?, ?, ?, ?, ?, 4)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, ten);
                stmt.setString(2, diachi);
                stmt.setString(3, mota);
                stmt.setString(4, idCity);
                stmt.setString(5, loai);
                stmt.executeUpdate();
                out.print("{\"status\":\"success\", \"message\":\"Thêm địa điểm thành công!\"}");
            }
            conn.close();
        } catch (Exception e) {
            out.print("{\"status\":\"error\", \"message\":\"Lỗi SQL\"}");
        }
        out.flush();
    }
}