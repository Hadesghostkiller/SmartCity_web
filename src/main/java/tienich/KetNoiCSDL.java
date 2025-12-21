/**
 * This Java class provides a method to establish a connection to a MySQL database.
 */
package tienich;

import java.sql.Connection;
import java.sql.DriverManager;

public class KetNoiCSDL {

    // Cấu hình Database
    // Sửa lại đoạn sau dấu gạch chéo cuối cùng thành tên DB thật: smartcityapp
    private static final String DB_URL = "jdbc:mysql://localhost:3306/smart_city_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = "vy2401";

    public static Connection layKetNoi() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            System.out.println("Kết nối database thành công!");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }

    public static void main(String[] args) {
        layKetNoi();  // Gọi hàm kết nối
    }
}
