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

@WebServlet("/api/lay-de-xuat")
public class LayDeXuat extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String currentId = req.getParameter("id"); // ID địa điểm đang xem
        Connection conn = KetNoiCSDL.layKetNoi();
        StringBuilder jsonBody = new StringBuilder();

        if (conn != null) {
            try {
                String sql = "SELECT * FROM DiaDiem " +
                        "WHERE id_city = (SELECT id_city FROM DiaDiem WHERE id = ?) " +
                        "AND id_loai_hinh = (SELECT id_loai_hinh FROM DiaDiem WHERE id = ?) " +
                        "AND id != ? " +
                        "LIMIT 3"; // Chỉ lấy 3 gợi ý

                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, currentId);
                stmt.setString(2, currentId);
                stmt.setString(3, currentId);

                ResultSet rs = stmt.executeQuery();
                boolean isFirst = true;

                while (rs.next()) {
                    if (!isFirst) jsonBody.append(",");
                    jsonBody.append("{")
                            .append("\"id\":").append(rs.getInt("id")).append(",")
                            .append("\"ten\":\"").append(rs.getString("ten_dia_diem")).append("\"")
                            .append("}");
                    isFirst = false;
                }
                conn.close();
            } catch (Exception e) { e.printStackTrace(); }
        }
        out.print("[" + jsonBody.toString() + "]");
        out.flush();
    }
}