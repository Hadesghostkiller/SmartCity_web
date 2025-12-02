-- ================== NHA TRANG – 10 ĐIỂM MỚI NHẤT 2025 (ĐÃ SỬA LỖI) ==================

-- 1. Đảm bảo tỉnh + quận
INSERT OR IGNORE INTO tinh_thanh (id, ten_tinh) VALUES (81, 'Khánh Hòa');

INSERT OR IGNORE INTO quan_huyen (id, tinh_id, ten_quan, loai) VALUES
(811,81,'TP. Nha Trang','Thành phố'),
(812,81,'TP. Cam Ranh','Thành phố'),
(813,81,'Huyện Cam Lâm','Huyện'),
(814,81,'Huyện Vạn Ninh','Huyện'),
(815,81,'Huyện Diên Khánh','Huyện');

-- 2. XÓA sạch địa điểm cũ của Nha Trang
DELETE FROM dia_diem 
WHERE quan_huyen_id BETWEEN 811 AND 820;

-- 3. Thêm mới 10 điểm (ĐÃ SỬA DẤU PHẨY)
INSERT INTO dia_diem (quan_huyen_id, loai_dich_vu_id, ten_dia_diem, dia_chi, dien_thoai,       rate, so_danh_gia,   gia_trung_binh, gio_mo_cua) VALUES
-- 2 Hành chính
(811,5,'Công an TP. Nha Trang','01 Trần Phú','0258 382 2211',4.2,  9873,'Miễn phí','24/7'),
(811,5,'UBND TP. Nha Trang','60 Trần Phú','0258 382 2222',4.1,  4567,'Miễn phí','07:30-17:00'),

-- 2 Du lịch
(811,1,'Bãi biển Nha Trang','Trần Phú',null,4.5, 289471,'Miễn phí','Toàn thời gian'),
(811,1,'Vinpearl Land Nha Trang','Đảo Hòn Tre','0258 359 0111',4.5, 367853,'700-900k','08:00-21:00'),

-- 2 Khách sạn
(811,2,'Vinpearl Resort & Spa Nha Trang Bay','Hòn Tre','0258 359 8888',4.5,  18921,'4-12tr','24h'),
(811,2,'Sheraton Nha Trang Hotel','26 Trần Phú','0258 388 0000',4.4,  14287,'3.5-9tr','24h'),

-- 2 Nhà hàng
(811,3,'Nhà hàng Hải Sản Louis','66 Trần Phú','0258 382 9999',4.4,  82371,'300-800k','10:00-22:00'),
(811,3,'Nhà hàng Ngon Nha Trang','02 Nguyễn Thị Minh Khai','0909 123 456',4.3,  65421,'150-400k','11:00-23:00'),

-- 2 Vui chơi
(811,4,'Tháp Bà Ponagar','02 Tháng 4','0258 382 2222',4.4, 178563,'50k','06:00-18:00'),
(811,4,'Hòn Chồng','Vĩnh Phước','0258 383 1234',4.3, 112947,'30k','06:00-18:00');

-- 4. Kiểm tra
SELECT 'NHA TRANG ĐÃ CẬP NHẬT XONG – 10 ĐIỂM MỚI!' AS STATUS,
       COUNT(*) AS SO_DIEM 
FROM dia_diem 
WHERE quan_huyen_id BETWEEN 811 AND 820;