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

@WebServlet("/api/chi-tiet-thanh-pho")
public class ChiTietThanhPho extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String idCity = req.getParameter("id"); // Lấy ID từ URL

        Connection conn = KetNoiCSDL.layKetNoi();
        String jsonResult = "{}";

        if (conn != null && idCity != null) {
            try {
                // Query 1: Lấy thông tin cơ bản
                String sqlInfo = "SELECT ten_thanh_pho, mo_ta FROM ThanhPho WHERE id = ?";
                PreparedStatement stmtInfo = conn.prepareStatement(sqlInfo);
                stmtInfo.setString(1, idCity);
                ResultSet rsInfo = stmtInfo.executeQuery();

                if (rsInfo.next()) {
                    String ten = rsInfo.getString("ten_thanh_pho");
                    String moTa = rsInfo.getString("mo_ta");
                    if(moTa == null) moTa = "Chưa có mô tả.";

                    // Query 2: Tính trung bình cộng số sao
                    String sqlRate = "SELECT AVG(rate_city) as diem_tb FROM Danhgia_city WHERE id_city = ?";
                    PreparedStatement stmtRate = conn.prepareStatement(sqlRate);
                    stmtRate.setString(1, idCity);
                    ResultSet rsRate = stmtRate.executeQuery();

                    double diemTB = 0;
                    if (rsRate.next()) {
                        diemTB = rsRate.getDouble("diem_tb");
                    }

                    // Làm tròn 1 chữ số thập phân (Ví dụ 4.6666 -> 4.7)
                    DecimalFormat df = new DecimalFormat("#.0");
                    String diemDep = df.format(diemTB);

                    // Tạo JSON
                    // Lưu ý: diemDep là chuỗi, nên để trong ngoặc kép
                    jsonResult = "{\"status\": \"success\", \"ten\": \"" + ten + "\", \"mota\": \"" + moTa + "\", \"sao\": \"" + diemDep + "\"}";
                } else {
                    jsonResult = "{\"status\": \"fail\", \"message\": \"Không tìm thấy thành phố\"}";
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