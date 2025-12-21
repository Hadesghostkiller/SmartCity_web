package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256 {

    /**
     * Hàm băm mật khẩu thành SHA-256 (64 ký tự hex) Dùng để so sánh với cột
     * password trong bảng nguoidung
     */
    public static String hash(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(input.getBytes());

            // Chuyển byte[] thành chuỗi hex
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi thuật toán SHA-256", e);
        }
    }

    // TEST NHANH (có thể chạy main để kiểm tra)
    public static void main(String[] args) {
        System.out.println("admin123 → " + hash("admin123"));
        // Kết quả phải ra: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9

        System.out.println("123 → " + hash("123"));
        // Kết quả phải ra: a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3
    }
}
