-- ================== ĐÀ LẠT – 10 ĐIỂM MỚI NHẤT 2025 ==================

-- 1. Đảm bảo tỉnh + quận
INSERT OR IGNORE INTO tinh_thanh (id, ten_tinh) VALUES (82, 'Lâm Đồng');

INSERT OR IGNORE INTO quan_huyen (id, tinh_id, ten_quan, loai) VALUES
(821,82,'TP. Đà Lạt','Thành phố'),
(822,82,'TP. Bảo Lộc','Thành phố'),
(823,82,'Huyện Lạc Dương','Huyện'),
(824,82,'Huyện Đam Rông','Huyện'),
(825,82,'Huyện Lâm Hà','Huyện');

-- 2. XÓA sạch địa điểm cũ của Đà Lạt
DELETE FROM dia_diem 
WHERE quan_huyen_id BETWEEN 821 AND 830;

-- 3. Thêm mới 10 điểm – đúng công thức
INSERT INTO dia_diem (quan_huyen_id, loai_dich_vu_id, ten_dia_diem, dia_chi, dien_thoai,       rate, so_danh_gia,   gia_trung_binh, gio_mo_cua) VALUES
-- 2 Hành chính
(821,5,'Công an TP. Đà Lạt','17 Trần Phú','0263 382 2211',4.2,  8427,'Miễn phí','24/7'),
(821,5,'UBND TP. Đà Lạt','03 Trần Phú','0263 382 2222',4.1,  4873,'Miễn phí','07:30-17:00'),

-- 2 Du lịch
(821,1,'Hồ Xuân Hương','Trung tâm Đà Lạt',null,4.5, 234567,'Miễn phí','Toàn thời gian'),
(821,1,'Thung lũng Tình Yêu','07 Mai Anh Đào','0263 382 2244',4.5, 178923,'120k','07:30-17:00'),

-- 2 Khách sạn
(821,2,'Dalat Palace Heritage','02 Trần Phú','0263 382 5444',4.5,  15683,'5-15tr','24h'),
(821,2,'Ana Mandara Villas Resort','Lê Lai','0263 355 5777',4.4,  12847,'3-10tr','24h'),

-- 2 Nhà hàng
(821,3,'Nhà hàng Le Chalet','01 Trần Phú','0263 382 9900',4.4,  72381,'300-700k','10:00-22:00'),
(821,3,'Nhà hàng Lẩu Bò Ba Toa','01 Ba Toa','0909 876 543',4.3,  59827,'200-500k','11:00-23:00'),

-- 2 Vui chơi
(821,4,'Ga Đà Lạt','01 Quang Trung','0263 383 4409',4.4, 134567,'30k','07:30-17:00'),
(821,4,'Đồi chè Cầu Đất','Cầu Đất','0263 383 1234',4.3, 112947,'50k','06:00-18:00');

-- 4. Kiểm tra
SELECT 'ĐÀ LẠT ĐÃ CẬP NHẬT XONG – 10 ĐIỂM MỚI!' AS STATUS,
       COUNT(*) AS SO_DIEM 
FROM dia_diem 
WHERE quan_huyen_id BETWEEN 821 AND 830;