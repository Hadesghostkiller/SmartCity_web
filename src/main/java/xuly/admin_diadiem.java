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

    // GET: Lấy danh sách đầy đủ để hiển thị và sửa
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String idCity = req.getParameter("id_city");

        // Mặc định page = 1 nếu không truyền hoặc lỗi
        int page = 1;
        try {
            if(req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
        } catch (Exception e) { page = 1; }

        int limit = 10;
        int offset = (page - 1) * limit;

        Connection conn = KetNoiCSDL.layKetNoi();
        StringBuilder jsonBody = new StringBuilder("[");
        int totalPages = 0;

        if (conn != null) {
            try {
                // 1. Đếm tổng số lượng để phân trang
                String sqlCount = "SELECT COUNT(*) FROM DiaDiem WHERE id_city = ?";
                PreparedStatement stmtCount = conn.prepareStatement(sqlCount);
                stmtCount.setString(1, idCity);
                ResultSet rsCount = stmtCount.executeQuery();
                if(rsCount.next()) {
                    totalPages = (int) Math.ceil((double) rsCount.getInt(1) / limit);
                }

                // 2. Lấy dữ liệu chi tiết + Tên loại hình
                String sql = "SELECT d.*, l.ten_loai_hinh FROM DiaDiem d " +
                        "JOIN LoaiHinh l ON d.id_loai_hinh = l.id " +
                        "WHERE d.id_city = ? ORDER BY d.id DESC LIMIT ? OFFSET ?";

                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, idCity);
                stmt.setInt(2, limit);
                stmt.setInt(3, offset);
                ResultSet rs = stmt.executeQuery();

                boolean isFirst = true;
                while(rs.next()) {
                    if(!isFirst) jsonBody.append(",");

                    // Xử lý các ký tự đặc biệt (dấu ngoặc kép, xuống dòng) để tránh lỗi JSON
                    String ten = rs.getString("ten_dia_diem");
                    if(ten != null) ten = ten.replace("\"", "\\\"").replace("\n", " ");

                    String diaChi = rs.getString("dia_chi");
                    if(diaChi != null) diaChi = diaChi.replace("\"", "\\\"").replace("\n", " ");

                    String moTa = rs.getString("mo_ta");
                    if(moTa != null) moTa = moTa.replace("\"", "\\\"").replace("\n", " ");

                    jsonBody.append("{")
                            .append("\"id\":").append(rs.getInt("id")).append(",")
                            .append("\"ten\":\"").append(ten).append("\",")
                            .append("\"diachi\":\"").append(diaChi).append("\",")
                            .append("\"mota\":\"").append(moTa).append("\",")
                            .append("\"id_loai\":").append(rs.getInt("id_loai_hinh")).append(",")
                            .append("\"ten_loai\":\"").append(rs.getString("ten_loai_hinh")).append("\"")
                            .append("}");
                    isFirst = false;
                }
                conn.close();
            } catch (Exception e) { e.printStackTrace(); }
        }
        jsonBody.append("]");

        // Trả về JSON
        out.print("{\"status\":\"success\", \"total_pages\":" + totalPages + ", \"data\":" + jsonBody.toString() + "}");
        out.flush();
    }

    // POST: Thêm, Xóa, Sửa
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
                // Lấy dữ liệu từ Client
                String ten = req.getParameter("ten");
                String diachi = req.getParameter("diachi");
                String mota = req.getParameter("mota");
                String idCity = req.getParameter("id_city");
                String idLoai = req.getParameter("id_loai"); // Quan trọng: ID loại hình

                String sql = "INSERT INTO DiaDiem(ten_dia_diem, dia_chi, mo_ta, id_city, id_loai_hinh) VALUES(?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, ten);
                stmt.setString(2, diachi);
                stmt.setString(3, mota);
                stmt.setString(4, idCity);
                stmt.setString(5, idLoai); // Truyền đúng id_loai_hinh

                stmt.executeUpdate();
                out.print("{\"status\":\"success\", \"message\":\"Thêm địa điểm thành công!\"}");
            }
            else if ("update".equals(action)) {
                // Lấy dữ liệu cập nhật
                String id = req.getParameter("id");
                String ten = req.getParameter("ten");
                String diachi = req.getParameter("diachi");
                String mota = req.getParameter("mota");
                String idLoai = req.getParameter("id_loai");

                String sql = "UPDATE DiaDiem SET ten_dia_diem=?, dia_chi=?, mo_ta=?, id_loai_hinh=? WHERE id=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, ten);
                stmt.setString(2, diachi);
                stmt.setString(3, mota);
                stmt.setString(4, idLoai);
                stmt.setString(5, id);

                stmt.executeUpdate();
                out.print("{\"status\":\"success\", \"message\":\"Cập nhật thành công!\"}");
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // Trả về lỗi chi tiết cho Client để dễ debug
            out.print("{\"status\":\"error\", \"message\":\"Lỗi SQL: " + e.getMessage() + "\"}");
        }
        out.flush();
    }
}