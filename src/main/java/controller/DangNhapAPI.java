package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tienich.KetNoiCSDL;
import util.SHA256;

@WebServlet("api/dang-nhap")
public class DangNhapAPI extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = SHA256.hash(request.getParameter("password")); // hash SHA-256

        String sql = "SELECT ho_ten, role FROM nguoidung WHERE username = ? AND password = ?";

        try (Connection conn = KetNoiCSDL.layKetNoi(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ĐĂNG NHẬP THÀNH CÔNG → TRẢ JSON ĐÚNG THEO JS CỦA BẠN
                String hoTen = rs.getString("ho_ten");
                int role = rs.getInt("role");

                out.print("{\"status\":\"success\",\"ten\":\"" + hoTen + "\",\"role\":" + role + "}");
            } else {
                // SAI TÀI KHOẢN HOẶC MẬT KHẨU
                out.print("{\"status\":\"error\",\"message\":\"Sai tài khoản hoặc mật khẩu!\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\",\"message\":\"Lỗi hệ thống!\"}");
        }
    }
}
