-- ==============================
-- BẮT ĐẦU – CHẠY ĐƯỢC TRÊN SQLITE (DBeaver)
-- ==============================

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS Danhgia_diadiem;
DROP TABLE IF EXISTS Danhgia_city;
DROP TABLE IF EXISTS DiaDiem;
DROP TABLE IF EXISTS ThanhPho;
DROP TABLE IF EXISTS NguoiDung;
DROP TABLE IF EXISTS LoaiHinh;

PRAGMA foreign_keys = ON;

-- 1. LoaiHinh
CREATE TABLE LoaiHinh (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ten_loai_hinh TEXT NOT NULL UNIQUE
);

-- 2. NguoiDung
CREATE TABLE NguoiDung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password TEXT,
    ho_ten TEXT,
    role INTEGER DEFAULT 0
);

-- 3. ThanhPho
CREATE TABLE ThanhPho (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ten_thanh_pho TEXT NOT NULL,
    mo_ta TEXT
);

-- 4. DiaDiem
CREATE TABLE DiaDiem (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ten_dia_diem TEXT NOT NULL,
    dia_chi TEXT,
    id_city INTEGER NOT NULL,
    id_loai_hinh INTEGER NOT NULL,
    loai_hinh TEXT,
    mo_ta TEXT,
    FOREIGN KEY (id_city) REFERENCES ThanhPho(id) ON DELETE CASCADE,
    FOREIGN KEY (id_loai_hinh) REFERENCES LoaiHinh(id) ON DELETE CASCADE
);

-- 5. Danhgia_city
CREATE TABLE Danhgia_city (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_nguoidung INTEGER NOT NULL,
    id_city INTEGER NOT NULL,
    rate_city INTEGER DEFAULT 5 CHECK (rate_city BETWEEN 1 AND 5),
    FOREIGN KEY (id_nguoidung) REFERENCES NguoiDung(id) ON DELETE CASCADE,
    FOREIGN KEY (id_city) REFERENCES ThanhPho(id) ON DELETE CASCADE
);

-- 6. Danhgia_diadiem
CREATE TABLE Danhgia_diadiem (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_nguoidung INTEGER NOT NULL,
    id_dia_diem INTEGER NOT NULL,
    rate_point INTEGER NOT NULL CHECK (rate_point BETWEEN 1 AND 5),
    comment TEXT,
    ngay_danh_gia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_nguoidung) REFERENCES NguoiDung(id) ON DELETE CASCADE,
    FOREIGN KEY (id_dia_diem) REFERENCES DiaDiem(id) ON DELETE CASCADE
);

-- Index
CREATE INDEX IF NOT EXISTS idx_dgc_city ON Danhgia_city(id_city);
CREATE INDEX IF NOT EXISTS idx_dgd_dd   ON Danhgia_diadiem(id_dia_diem);

-- ==============================
-- INSERT DỮ LIỆU (theo đúng thứ tự)
-- ==============================

-- 1. LoaiHinh
-- Lord vai cac
INSERT INTO LoaiHinh (id, ten_loai_hinh) VALUES 
(1, 'Nhà hàng'),(2, 'Khách sạn'),(3, 'Vui chơi'),(4, 'Du lịch'),(5, 'Mua sắm');

-- 2. NguoiDung
INSERT INTO NguoiDung (id, username, password, ho_ten, role) VALUES 
(1,'admin','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Daniel Tam',1),
(2,'abc','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Nguyen Van A',0),
(3,'toilaai','91a73fd806ab2c005c13b4dc19130a884e909dea3f72d46e30266fe1a1f588d8','Tôixin Chào',0),
(4,'ban','d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35','Bạn Tên Gì',0),
(5,'banabc','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','Bạn Tên Gái',0),
(6,'user1','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Nguyen Van A',0),
(7,'user2','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Tran Thi B',0),
(8,'user3','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Le Van C',0),
(9,'user4','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Pham Thi D',0),
(10,'user5','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Hoang Van E',0),
(11,'user6','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Vu Thi F',0),
(12,'user7','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Dang Van G',0),
(13,'user8','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Bui Thi H',0),
(14,'user9','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Do Van I',0),
(15,'user10','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Ngo Thi K',0);

-- 3. ThanhPho
INSERT INTO ThanhPho (id, ten_thanh_pho, mo_ta) VALUES 
(1,'Đà Lạt','Thành phố ngàn hoa, khí hậu mát mẻ, vẻ đẹp yên bình'),
(2,'Vũng Tàu','Thành phố biển sôi động'),
(3,'Hà Nội','Thủ đô nghìn năm văn hiến'),
(4,'Nha Trang','Thành phố biển xinh đẹp'),
(5,'Cần Thơ','Sông nước rộn ràng mùa nước nổi');

-- 4. DiaDiem (60 dòng – mình chỉ để 5 dòng mẫu, bạn copy hết 60 dòng gốc của bạn vào đây)
INSERT INTO DiaDiem (id, ten_dia_diem, dia_chi, id_city, id_loai_hinh, loai_hinh, mo_ta) VALUES
(1, 'Quảng trường Lâm Viên', 'Đường Trần Quốc Toản, Phường 10, TP. Đà Lạt', 1, 4, 'Du lịch', 'Quảng trường Lâm Viên không chỉ là trái tim...'),
(2, 'Chợ Đêm Đà Lạt', 'Đường Nguyễn Thị Minh Khai, Phường 1, TP. Đà Lạt', 1, 5, 'Mua sắm', 'Chợ Đêm Đà Lạt, hay còn gọi là chợ Âm Phủ...'),
-- ... (dán tiếp 58 dòng còn lại của bạn)
(60, 'Nem Nướng Thanh Vân', '17 Đại lộ Hòa Bình, Tân An, Ninh Kiều, Cần Thơ', 5, 1, 'Nhà hàng', 'Nem Nướng Thanh Vân là quán ăn lâu đời...');

-- 5. Danhgia_city
INSERT INTO Danhgia_city (id_nguoidung, id_city, rate_city) VALUES
(2,3,4),(4,3,5),(3,2,2),(6,1,5),(6,2,4),(7,1,4),(7,3,5),(8,2,5),(8,3,4),
(9,1,3),(9,2,5),(10,3,5),(10,1,4),(11,2,4),(12,1,5),(13,3,3),(14,2,5),(15,1,4),
(8,1,5),(9,1,5),(10,1,4),(11,1,5),(12,2,4),(13,2,3),(14,2,5),(15,3,5),
(7,3,4),(6,4,5),(7,4,5),(8,4,4),(10,4,5),(13,4,5),(9,5,5),(11,5,4),
(12,5,5),(14,5,4),(15,5,5),(2,1,5),(2,5,5),(1,4,5);


-- HOÀN TẤT!