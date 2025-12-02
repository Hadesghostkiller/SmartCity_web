-- ================== THỦ ĐỨC – 10 ĐIỂM MỚI NHẤT 2025 ==================

-- 1. Đảm bảo tỉnh + quận (TP.HCM = 2)
INSERT OR IGNORE INTO tinh_thanh (id, ten_tinh) VALUES (2, 'TP. Hồ Chí Minh');

INSERT OR IGNORE INTO quan_huyen (id, tinh_id, ten_quan, loai) VALUES
(201,2,'TP. Thủ Đức','Thành phố');

-- 2. XÓA sạch địa điểm cũ của Thủ Đức
DELETE FROM dia_diem WHERE quan_huyen_id = 201;

-- 3. Thêm mới 10 điểm Thủ Đức – đúng công thức bạn yêu cầu
INSERT INTO dia_diem (quan_huyen_id, loai_dich_vu_id, ten_dia_diem, dia_chi, dien_thoai,       rate, so_danh_gia,   gia_trung_binh, gio_mo_cua) VALUES
-- 2 Hành chính
(201,5,'Công an TP. Thủ Đức','01 Võ Văn Ngân','028 3899 2211',4.2,  9873,'Miễn phí','24/7'),
(201,5,'UBND TP. Thủ Đức','02 Võ Văn Ngân','028 3899 2222',4.1,  5231,'Miễn phí','07:30-17:00'),

-- 2 Du lịch
(201,1,'Làng Đại học Quốc gia','Phường Linh Trung',null,4.4, 189721,'Miễn phí','05:00-22:00'),
(201,1,'Suối Tiên','120 Xa lộ Hà Nội',null,4.3, 267853,'150k','08:00-17:30'),

-- 2 Khách sạn
(201,2,'Sài Gòn Riverside Hotel Thủ Đức','18 Đường D1','028 3729 1111',4.4,  12847,'1.5-4tr','24h'),
(201,2,'Mường Thanh Grand Thủ Đức','QL13','028 3720 8888',4.3,  9873,'1.2-3.5tr','24h'),

-- 2 Nhà hàng
(201,3,'Lẩu dê 404 Thủ Đức','QL13','0909 123 456',4.4,  72381,'250-400k','11:00-23:00'),
(201,3,'Cơm tấm Cali Thủ Đức','Đại học Ngân Hàng','0918 765 432',4.3,  59827,'50-80k','06:00-21:00'),

-- 2 Vui chơi
(201,4,'Vincom Mega Mall Thảo Điền','161 Xa lộ Hà Nội','028 3620 2222',4.4, 156783,'200-1000k','10:00-22:00'),
(201,4,'Snow Town Sài Gòn','Khu du lịch Suối Tiên','028 3620 8888',4.3, 112947,'200k','09:00-21:00');

-- 4. Kiểm tra
SELECT 'THỦ ĐỨC ĐÃ CẬP NHẬT XONG – 10 ĐIỂM MỚI!' AS STATUS,
       COUNT(*) AS SO_DIEM 
FROM dia_diem 
WHERE quan_huyen_id = 201;