-- ================== VŨNG TÀU – 10 ĐIỂM MỚI NHẤT 2025 ==================

-- 1. Đảm bảo tỉnh + quận
INSERT OR IGNORE INTO tinh_thanh (id, ten_tinh) VALUES (80, 'Bà Rịa - Vũng Tàu');

INSERT OR IGNORE INTO quan_huyen (id, tinh_id, ten_quan, loai) VALUES
(801,80,'TP. Vũng Tàu','Thành phố'),
(802,80,'TP. Bà Rịa','Thành phố'),
(803,80,'Huyện Long Điền','Huyện'),
(804,80,'Huyện Xuyên Mộc','Huyện'),
(805,80,'Huyện Côn Đảo','Huyện');

-- 2. XÓA sạch địa điểm cũ của Vũng Tàu
DELETE FROM dia_diem WHERE quan_huyen_id BETWEEN 801 AND 810;

-- 3. Thêm mới 10 điểm (đã có cột dien_thoai)
INSERT INTO dia_diem (quan_huyen_id, loai_dich_vu_id, ten_dia_diem, dia_chi, dien_thoai,       rate, so_danh_gia,   gia_trung_binh, gio_mo_cua) VALUES
(801,5,'Công an TP. Vũng Tàu','237 Lê Hồng Phong','0284 385 2211',4.2,  9127,'Miễn phí','24/7'),
(801,5,'UBND TP. Vũng Tàu','01 Nguyễn Tất Thành','0284 385 2222',4.1,  4873,'Miễn phí','07:30-17:00'),
(801,1,'Bãi Sau (Thùy Vân','Đường Thùy Vân',null,4.5, 198427,'Miễn phí','Toàn thời gian'),
(801,1,'Tượng Chúa Kitô Vua','Núi Nhỏ',null,4.5, 267853,'50k','07:30-17:00'),
(801,2,'Imperial Hotel Vũng Tàu','159 Thùy Vân','0254 362 8888',4.5,  15693,'2.5-7tr','24h'),
(801,2,'Pullman Vung Tau','15 Thi Sách','0254 355 1777',4.4,  12481,'3-8tr','24h'),
(801,3,'Gành Hào Restaurant','03 Trần Phú','0284 355 0909',4.4,  78921,'300-800k','10:00-22:00'),
(801,3,'Hải sản Biển Xanh','Bãi Sau','0908 234 567',4.3,  56387,'200-500k','11:00-23:00'),
(801,4,'Cáp treo Núi Lớn – Hồ Mây','Núi Lớn',null,4.4, 134567,'250k','08:00-17:30'),
(805,4,'Khu du lịch Côn Đảo','Côn Đảo','0254 383 0123',4.5,  89213,'300-700k','07:00-17:00');

-- 4. Kiểm tra
SELECT 'VŨNG TÀU THÀNH CÔNG – 10 ĐIỂM!' AS STATUS, COUNT(*) AS SO_DIEM 
FROM dia_diem 
WHERE quan_huyen_id BETWEEN 801 AND 810;