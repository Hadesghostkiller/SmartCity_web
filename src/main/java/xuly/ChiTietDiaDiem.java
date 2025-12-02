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
import java.text.DecimalFormat;

@WebServlet("/api/chi-tiet-dia-diem")
public class ChiTietDiaDiem extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String id = req.getParameter("id");
        String username = req.getParameter("user"); // Nhận username
        Connection conn = KetNoiCSDL.layKetNoi();
        String jsonResult = "{}";

        if (conn != null && id != null) {
            try {
                // 1. Lấy thông tin địa điểm
                String sql = "SELECT * FROM DiaDiem WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, id);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String ten = rs.getString("ten_dia_diem");
                    String diaChi = rs.getString("dia_chi");
                    String moTa = rs.getString("mo_ta");
                    String loaiHinh = rs.getString("loai_hinh");
                    int idCity = rs.getInt("id_city");

                    if(moTa != null) moTa = moTa.replace("\"", "\\\"").replace("\n", " ");

                    // 2. Tính điểm trung bình
                    String sqlRate = "SELECT AVG(rate_point) as diem_tb FROM Danhgia_diadiem WHERE id_dia_diem = ?";
                    PreparedStatement stmtRate = conn.prepareStatement(sqlRate);
                    stmtRate.setString(1, id);
                    ResultSet rsRate = stmtRate.executeQuery();

                    double diemTB = 0;
                    if (rsRate.next()) diemTB = rsRate.getDouble("diem_tb");
                    DecimalFormat df = new DecimalFormat("#.0");
                    String sao = df.format(diemTB);

                    // 3. KIỂM TRA ĐÃ THÍCH CHƯA
                    boolean isFav = false;
                    if (username != null && !username.isEmpty() && !username.equals("null")) {
                        String sqlFav = "SELECT COUNT(*) FROM SoThich WHERE username = ? AND id_dia_diem = ?";
                        PreparedStatement stmtFav = conn.prepareStatement(sqlFav);
                        stmtFav.setString(1, username);
                        stmtFav.setString(2, id);
                        ResultSet rsFav = stmtFav.executeQuery();
                        if (rsFav.next() && rsFav.getInt(1) > 0) {
                            isFav = true;
                        }
                    }

                    jsonResult = "{" +
                            "\"status\": \"success\"," +
                            "\"ten\": \"" + ten + "\"," +
                            "\"diachi\": \"" + diaChi + "\"," +
                            "\"mota\": \"" + moTa + "\"," +
                            "\"loai\": \"" + loaiHinh + "\"," +
                            "\"id_city\": " + idCity + "," +
                            "\"sao\": \"" + sao + "\"," +
                            "\"is_fav\": " + isFav + // Trả về true/false
                            "}";
                } else {
                    jsonResult = "{\"status\": \"fail\", \"message\": \"Không tìm thấy địa điểm\"}";
                }
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        out.print(jsonResult);
        out.flush();
    }
}