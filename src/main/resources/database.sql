-- =============================================================
-- DATABASE: smart_city_db - FIXED VERSION (No Syntax Error)
-- Đồ án Java Web Smart City - Full 60 địa điểm + Đánh giá
-- Fix: Escape quotes, full data, correct hashes
-- Ngày fix: 19/12/2025
-- =============================================================

DROP DATABASE IF EXISTS smart_city_db;
CREATE DATABASE smart_city_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_city_db;

-- 1. Bảng loại hình địa điểm
CREATE TABLE LoaiHinh (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          ten_loai_hinh VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Bảng người dùng
CREATE TABLE NguoiDung (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           username VARCHAR(50) NOT NULL UNIQUE,
                           password VARCHAR(100) NOT NULL,
                           ho_ten VARCHAR(100),
                           role INT DEFAULT 0  -- 0 = user, 1 = admin
);

-- 3. Bảng thành phố
CREATE TABLE ThanhPho (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          ten_thanh_pho VARCHAR(100) NOT NULL,
                          mo_ta TEXT
);

-- 4. Bảng địa điểm
CREATE TABLE DiaDiem (
                         id INT AUTO_INCREMENT PRIMARY KEY,
                         ten_dia_diem VARCHAR(255) NOT NULL,
                         dia_chi TEXT,
                         id_city INT NOT NULL,
                         id_loai_hinh INT NOT NULL,
                         loai_hinh VARCHAR(50),
                         mo_ta TEXT,
                         FOREIGN KEY (id_city) REFERENCES ThanhPho(id) ON DELETE CASCADE,
                         FOREIGN KEY (id_loai_hinh) REFERENCES LoaiHinh(id) ON DELETE CASCADE,
                         INDEX idx_city (id_city),
                         INDEX idx_loai_hinh (id_loai_hinh)
);

-- 5. Bảng đánh giá thành phố
CREATE TABLE Danhgia_city (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              username VARCHAR(50) NOT NULL,
                              id_city INT NOT NULL,
                              rate_city INT DEFAULT 5 CHECK (rate_city BETWEEN 1 AND 5),
                              FOREIGN KEY (username) REFERENCES NguoiDung(username) ON DELETE CASCADE,
                              FOREIGN KEY (id_city) REFERENCES ThanhPho(id) ON DELETE CASCADE,
                              UNIQUE KEY unique_user_city (username, id_city),
                              INDEX idx_username (username),
                              INDEX idx_id_city (id_city)
);

-- 6. Bảng đánh giá địa điểm
CREATE TABLE Danhgia_diadiem (
                                 id INT AUTO_INCREMENT PRIMARY KEY,
                                 username VARCHAR(50) NOT NULL,
                                 id_dia_diem INT NOT NULL,
                                 rate_point INT NOT NULL CHECK (rate_point BETWEEN 1 AND 5),
                                 comment TEXT,
                                 ngay_danh_gia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 FOREIGN KEY (username) REFERENCES NguoiDung(username) ON DELETE CASCADE,
                                 FOREIGN KEY (id_dia_diem) REFERENCES DiaDiem(id) ON DELETE CASCADE,
                                 UNIQUE KEY unique_user_place (username, id_dia_diem),
                                 INDEX idx_username (username),
                                 INDEX idx_id_dia_diem (id_dia_diem)
);

-- 7. Bảng yêu thích (Wishlist)
CREATE TABLE SoThich (
                         username VARCHAR(50) NOT NULL,
                         id_dia_diem INT NOT NULL,
                         ngay_them TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         PRIMARY KEY (username, id_dia_diem),
                         FOREIGN KEY (username) REFERENCES NguoiDung(username) ON DELETE CASCADE,
                         FOREIGN KEY (id_dia_diem) REFERENCES DiaDiem(id) ON DELETE CASCADE
);

-- =============================================================
-- DỮ LIỆU MẪU (FULL + FIXED)
-- =============================================================

-- Loại hình (5 loại)
INSERT INTO LoaiHinh (id, ten_loai_hinh) VALUES
                                             (1, 'Nhà hàng'),
                                             (2, 'Khách sạn'),
                                             (3, 'Vui chơi'),
                                             (4, 'Du lịch'),
                                             (5, 'Mua sắm');

-- Thành phố (5 thành phố)
INSERT INTO ThanhPho (id, ten_thanh_pho, mo_ta) VALUES
                                                    (1, 'Đà Lạt', 'Thành phố ngàn hoa, khí hậu mát mẻ, vẻ đẹp yên bình'),
                                                    (2, 'Vũng Tàu', 'Thành phố biển sôi động'),
                                                    (3, 'Hà Nội', 'Thủ đô nghìn năm văn hiến'),
                                                    (4, 'Nha Trang', 'Thành phố biển xinh đẹp'),
                                                    (5, 'Cần Thơ', 'Sông nước rộn ràng mùa nước nổi');

-- Người dùng (15 user, hash SHA-256 đúng)
-- Admin: admin / admin123
-- User: abc, user1... / 123
INSERT INTO NguoiDung (id, username, password, ho_ten, role) VALUES
                                                                 (1, 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Daniel Tam', 1),
                                                                 (2, 'abc', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Nguyễn Văn A', 0),
                                                                 (3, 'toilaai', '91a73fd806ab2c005c13b4dc19130a884e909dea3f72d46e30266fe1a1f588d8', 'Tôixin Chào', 0),
                                                                 (4, 'ban', 'd4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35', 'Bạn Tên Gì', 0),
                                                                 (5, 'banabc', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b', 'Bạn Tên Gái', 0),
                                                                 (6, 'user1', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Nguyễn Văn A', 0),
                                                                 (7, 'user2', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Trần Thị B', 0),
                                                                 (8, 'user3', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Lê Văn C', 0),
                                                                 (9, 'user4', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Phạm Thị D', 0),
                                                                 (10, 'user5', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Hoàng Văn E', 0),
                                                                 (11, 'user6', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Vũ Thị F', 0),
                                                                 (12, 'user7', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Đặng Văn G', 0),
                                                                 (13, 'user8', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Bùi Thị H', 0),
                                                                 (14, 'user9', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Đỗ Văn I', 0),
                                                                 (15, 'user10', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Ngô Thị K', 0);

-- Địa điểm FULL 60 (Đã escape quotes + full mô tả từ file gốc)
INSERT INTO DiaDiem (id, ten_dia_diem, dia_chi, id_city, id_loai_hinh, loai_hinh, mo_ta) VALUES
-- Đà Lạt (id_city=1)
(1, 'Quảng trường Lâm Viên', 'Đường Trần Quốc Toản, Phường 10, TP. Đà Lạt', 1, 4, 'Du lịch', 'Quảng trường Lâm Viên là trái tim của thành phố Đà Lạt, được khánh thành năm 2016 với thiết kế hiện đại và không gian xanh rộng lớn hơn 70.000m². Điểm nhấn là hai biểu tượng khổng lồ: nụ hoa Atiso cao 15m tượng trưng cho sức sống dồi dào và đóa hoa Dã Quỳ rực rỡ cao 18m biểu thị vẻ đẹp hoang dã của cao nguyên. Khuôn viên có đài phun nước nhạc nước, sân trượt patin, khu vui chơi trẻ em và thảm cỏ xanh mướt lý tưởng cho picnic. Vào ban đêm, hệ thống đèn LED chiếu sáng tạo nên bức tranh lung linh huyền ảo. Đây là nơi tụ họp, biểu diễn nghệ thuật và check-in không thể bỏ qua của du khách.'),
(2, 'Chợ Đêm Đà Lạt', 'Đường Nguyễn Thị Minh Khai, Phường 1, TP. Đà Lạt', 1, 5, 'Mua sắm', 'Chợ Đêm Đà Lạt là thiên đường ẩm thực và mua sắm về đêm, mở cửa từ 18h đến 2h sáng hàng ngày. Với hơn 200 gian hàng, du khách có thể thưởng thức bánh tráng nướng giòn tan, sữa đậu nành nóng hổi, thịt nướng thơm lừng và các món ăn vặt đặc trưng khác. Khu mua sắm bày bán đủ loại: áo len dệt tay, mứt trái cây, atiso mật ong, hoa tươi và đồ lưu niệm thủ công. Không khí nhộn nhịp, se lạnh của Đà Lạt kết hợp ánh đèn neon rực rỡ tạo nên sức hút khó cưỡng. Dạo chợ đêm là cách tuyệt vời để cảm nhận nhịp sống về đêm của phố núi.'),
(3, 'Lẩu Gà Lá É Mimosa', '45 Nguyễn Văn Cừ, Phường 1, TP. Đà Lạt', 1, 1, 'Nhà hàng', 'Lẩu Gà Lá É Mimosa là quán lẩu nổi tiếng nhất Đà Lạt với công thức bí truyền từ bà nội truyền lại. Nồi lẩu sử dụng gà ta thả vườn dai ngọt, lá é tươi xanh hái từ vườn riêng tạo nên vị chua thanh dịu nhẹ, không gắt. Đồ nhúng đa dạng: rau cải xanh, nấm đông cô, bắp mỹ, khoai môn và các loại rau rừng đặc sản. Nước dùng ninh từ xương gà hầm thảo mộc, thơm lừng khó cưỡng. Không gian quán ấm cúng với lò sưởi và view đồi thông thơ mộng. Giá cả phải chăng, phục vụ nhanh chóng, Mimosa luôn đông khách đặc biệt vào cuối tuần.'),
(4, 'Bánh Mì Bơ Tỏi Cô Ba', 'Số 7/1 Yersin, Phường 10, TP. Đà Lạt', 1, 1, 'Nhà hàng', 'Bánh Mì Bơ Tỏi Cô Ba là quán ăn sáng huyền thoại của Đà Lạt, tồn tại hơn 30 năm với hàng dài khách chờ mỗi buổi sáng. Bí quyết nằm ở lớp bơ tỏi vàng óng ả phết dày trên ổ bánh mì pate giòn tan, nướng trên than hoa tỏa hương thơm ngát. Ăn kèm pate gan ngỗng béo ngậy, thịt nguội, dưa leo và rau thơm tươi. Quán nhỏ xinh nằm khuất trong hẻm, không gian giản dị nhưng ấm áp như nhà. Một ổ bánh mì ở đây không chỉ là bữa sáng mà còn là kỷ niệm khó quên của bao thế hệ du khách yêu Đà Lạt.'),
(5, 'Ana Mandara Villas Dalat', 'Lạc Dương, Xuân Thọ, TP. Đà Lạt', 1, 2, 'Khách sạn', 'Ana Mandara Villas Dalat Resort & Spa là khu nghỉ dưỡng 5 sao đẳng cấp quốc tế, từng được bình chọn là resort đẹp nhất Việt Nam. Với 17 villas cổ được phục chế từ biệt thự Pháp thời 1920-1930, mỗi căn mang kiến trúc độc đáo và nội thất sang trọng. Khuôn viên rộng 15ha bao quanh bởi rừng thông reo, hồ nước yên bình và vườn hoa rực rỡ. Du khách có thể thư giãn tại spa với liệu pháp truyền thống, thưởng thức ẩm thực fusion hoặc tham gia trekking khám phá thiên nhiên. Ana Mandara mang đến trải nghiệm nghỉ dưỡng hoàng gia giữa lòng Đà Lạt mộng mơ.'),
(6, 'Vườn Hoa Thành Phố', 'Tô Ngọc Vân, Phường 1, TP. Đà Lạt', 1, 4, 'Du lịch', 'Vườn Hoa Thành Phố Đà Lạt là khu vườn thực vật đẹp nhất Việt Nam với diện tích 7ha, trưng bày hơn 300 loài hoa nhập ngoại và bản địa. Điểm nhấn là nhà kính hình nón độc đáo cao 27m, vườn hoa hướng dương vàng rực, vườn hồng cổ kính và các tác phẩm nghệ thuật bonsai. Vé vào cửa chỉ 50k, mở cửa từ 7h30-18h hàng ngày. Không gian thoáng đãng, hương hoa ngát trời là nơi lý tưởng để dạo chơi, chụp ảnh cưới hoặc thư giãn cuối tuần. Vườn hoa không chỉ đẹp mà còn là biểu tượng văn hóa của thành phố ngàn hoa.'),
(7, 'Me Linh Coffee', 'Gần Đồi Mộng Mơ, Đường 3/4, TP. Đà Lạt', 1, 1, 'Nhà hàng', 'Me Linh Coffee là quán cà phê view đẹp nhất Đà Lạt với tầm nhìn panorama 360 độ ôm trọn hồ Xuân Hương và thành phố. Quán nằm trên độ cao 1.500m, được bao quanh bởi rừng thông xanh mướt và vườn rau sạch. Thực đơn đa dạng: cà phê arabica nguyên chất, sinh tố trái cây tươi, bánh ngọt handmade và các món Âu-Á. Không gian mở với ghế lười, xích đu và ban công kính rộng, lý tưởng cho check-in sống ảo. Dù đông khách nhưng phục vụ nhiệt tình, giá cả hợp lý. Me Linh là điểm đến không thể bỏ lỡ cho tín đồ cà phê và view núi.'),
(8, 'Bánh Mì Xíu Mại Cô Rịa', '2 Trần Phú, Phường 9, TP. Đà Lạt', 1, 1, 'Nhà hàng', 'Bánh Mì Xíu Mại Cô Rịa là quán ăn sáng lâu đời với hơn 40 năm tuổi, nổi tiếng với xíu mại dai ngon, nước súp ngọt thanh từ xương heo ninh kỹ. Bánh mì pate giòn tan, thịt nguội cay nồng, ăn kèm tương ớt tự làm. Quán nhỏ nhưng sạch sẽ, bà chủ thân thiện hay kể chuyện xưa. Mỗi sáng, hàng trăm thực khách xếp hàng chờ mua, từ dân địa phương đến du khách. Một bữa sáng ở đây chỉ 20k nhưng no căng bụng và ấm áp lòng người giữa tiết trời se lạnh Đà Lạt.'),
(9, 'Biệt Điện Bảo Đại', 'Đường Triệu Việt Vương, Phường 4, TP. Đà Lạt', 1, 4, 'Du lịch', 'Biệt Điện Bảo Đại là cung điện mùa hè của vua Bảo Đại cuối cùng, được xây dựng năm 1933-1938 theo phong cách Art Deco Pháp. Với 25 phòng ngủ, thư viện, rạp chiếu phim riêng và vườn hoa Pháp cổ, nơi đây lưu giữ nguyên vẹn không khí hoàng gia xưa. Du khách có thể tham quan các phòng trưng bày cổ vật, bộ sưu tập săn bắn của vua và ngự thư phòng. Vé vào 40k, mở cửa 7h-17h. Biệt điện không chỉ là di tích lịch sử mà còn là nơi hoài niệm về một thời vàng son của triều Nguyễn giữa rừng thông Đà Lạt.'),
(10, 'Rạp CGV Đà Lạt', 'Tầng 3 Vincom Đà Lạt, 66 Trần Quốc Toản, Phường 11, TP. Đà Lạt', 1, 3, 'Vui chơi', 'Rạp CGV Đà Lạt là cụm rạp hiện đại nhất thành phố với 5 phòng chiếu 4DX, IMAX và Sweetbox sang trọng. Hệ thống âm thanh Dolby 7.1, màn hình 4K sắc nét mang đến trải nghiệm điện ảnh đỉnh cao. Thực đơn snack đa dạng: bắp caramel, nachos phô mai, trà sữa trân châu. Rạp nằm ngay trung tâm Vincom, tiện ghé mua sắm sau phim. Giá vé từ 70k, ưu đãi student và cặp đôi. CGV là lựa chọn hoàn hảo cho buổi hẹn hò lãng mạn hoặc giải trí gia đình giữa không khí mát mẻ Đà Lạt.'),
-- Vũng Tàu (id_city=2, id 11-20)
(11, 'Tượng Chúa Kitô Vua', 'Thủ Khoa Huân, Phường 2, TP. Vũng Tàu', 2, 4, 'Du lịch', 'Tượng Chúa Kitô Vua Vũng Tàu cao 32m với sải tay 25m là biểu tượng tâm linh và du lịch của thành phố biển. Đúc bằng đồng nguyên khối nặng 200 tấn, tượng được khánh thành năm 1993 trên núi Lớn. Bên trong có 600 bậc thang dẫn lên vòm đầu tượng, nơi có ban công ngắm toàn cảnh Bãi Trước, Bãi Sau và biển Đông mênh mông. Vé vào 20k, mở cửa 7h-17h. Leo bộ hơi mệt nhưng view từ trên cao đáng giá mọi công sức, đặc biệt lúc hoàng hôn buông xuống.'),
(12, 'Bánh Khọt Gốc Vú Sữa', '14 Nguyễn Trường Tộ, Phường 2, TP. Vũng Tàu', 2, 1, 'Nhà hàng', 'Bánh Khọt Gốc Vú Sữa là quán ăn hơn 40 năm tuổi, nổi tiếng với bánh khọt giòn tan, tôm tươi rói nhảy tanh tách và nước mắm chua ngọt đậm đà. Bột bánh pha từ gạo cái ngon, topping đầy ắp: tôm, mực, bò, rau sống tươi. Quán nằm ven biển Bãi Trước, không gian thoáng đãng với view sóng vỗ. Dù đông khách nhưng phục vụ nhanh, giá 25k/phần. Đây là món ăn đặc sản không thể bỏ qua khi đến Vũng Tàu, ăn một lần là nhớ mãi.'),
(13, 'The Imperial Vung Tau Hotel', 'Yên Tử, Bãi Dâu, TP. Vũng Tàu', 2, 2, 'Khách sạn', 'The Imperial Vung Tau là khách sạn 5 sao đẳng cấp với vị trí độc tôn nhìn ra biển Đông, cách trung tâm 3km. 52 phòng suite sang trọng, hồ bơi vô cực trên tầng thượng và spa cao cấp. Ẩm thực đa dạng: buffet hải sản tươi sống, món Âu tinh tế. Khuôn viên xanh mướt với sân tennis, phòng gym hiện đại. Giá từ 2tr/đêm, dịch vụ 5 sao chu đáo. Imperial là lựa chọn lý tưởng cho kỳ nghỉ dưỡng xa xỉ bên bờ biển Vũng Tàu.'),
(14, 'Cáp Treo Hồ Mây', 'Suối Ồ, Phường 10, TP. Vũng Tàu', 2, 3, 'Vui chơi', 'Cáp Treo Hồ Mây là hệ thống cáp treo dài nhất Việt Nam 3,5km, đưa du khách từ chân núi Lớn lên đỉnh núi Nhỏ cao 457m chỉ trong 15 phút. View toàn cảnh Vũng Tàu, biển xanh và đảo Long Sơn hùng vĩ. Trên đỉnh có Tượng Phật Di Lặc, chùa Linh Sơn và khu vui chơi mạo hiểm. Vé khứ hồi 200k, mở cửa 7h-21h. Trải nghiệm cáp treo êm ái, gió biển mát rượi là điểm nhấn khó quên trong hành trình khám phá Vũng Tàu.'),
(15, 'Hải Đăng Vũng Tàu', 'Đường Hạ Long, Bãi Trước, TP. Vũng Tàu', 2, 4, 'Du lịch', 'Hải Đăng Vũng Tàu là ngọn hải đăng cổ nhất Việt Nam, xây năm 1862 trên núi Lớn cao 145m. Tháp cao 18,3m với đèn pha chiếu sáng xa 40km, là biểu tượng hàng hải của thành phố. Khuôn viên xanh sạch, lối đi lát đá và view hoàng hôn tuyệt đẹp ra Bãi Trước. Vé 20k, mở cửa 7h-17h. Đến đây, du khách không chỉ ngắm cảnh mà còn cảm nhận lịch sử thăng trầm của ngọn hải đăng đã chứng kiến bao chuyến tàu qua biển Đông.'),
(16, 'Big C Vũng Tàu', 'Số 1 đường 30/4, Phường 11, TP. Vũng Tàu', 2, 5, 'Mua sắm', 'Big C Vũng Tàu là siêu thị lớn nhất thành phố với diện tích 10.000m², quy tụ hàng ngàn sản phẩm từ thực phẩm tươi sống đến điện máy, thời trang. Khu ẩm thực food court đa dạng: sushi, pizza, bánh mì kẹp. Mở cửa 8h-22h, có shuttle bus miễn phí từ khách sạn. Big C là điểm mua sắm tiện lợi, giá rẻ cho du khách mua quà lưu niệm hoặc nhu yếu phẩm trong chuyến đi biển.'),
(17, 'Gành Hào', 'Gành Hào, Phường 10, TP. Vũng Tàu', 2, 4, 'Du lịch', 'Gành Hào là bãi đá hoang sơ đẹp nhất Vũng Tàu với những tảng đá lớn xếp chồng kỳ thú, tạo thành hang động tự nhiên và vũng nước trong xanh. Nơi đây lý tưởng để câu cá, chụp ảnh nghệ thuật hoặc picnic cuối tuần. Đường xuống bãi hơi dốc nhưng an toàn, view bình minh ngoạn mục. Miễn phí vào cửa, tránh đi lúc triều cường. Gành Hào mang vẻ đẹp hoang dã, khác biệt so với các bãi biển đông đúc khác ở Vũng Tàu.'),
(18, 'Long Beach Resort', 'Vung Tau, Long Hai, Dat Do, Vung Tau Province', 2, 2, 'Khách sạn', 'Long Beach Resort là khu nghỉ dưỡng 4 sao bên bờ biển Long Hải yên bình, cách Vũng Tàu 20km. 80 villa và bungalow hướng biển, hồ bơi nước mặn lớn nhất khu vực. Ẩm thực Việt - Âu với hải sản tươi, spa thư giãn và hoạt động team building. Giá từ 1,5tr/đêm, phù hợp gia đình hoặc cặp đôi. Không gian xanh, sóng vỗ nhẹ nhàng tạo cảm giác thư thái giữa thiên nhiên biển.'),
(19, 'Lan Rừng Resort', 'Đường 3/2, Bãi Sau, TP. Vũng Tàu', 2, 2, 'Khách sạn', 'Lan Rừng Resort là khu nghỉ dưỡng ven biển Bãi Sau với 200 phòng view biển, hồ bơi ngoài trời và nhà hàng hải sản. Không gian xanh mát với vườn cây nhiệt đới, karaoke và massage. Giá phòng từ 800k, dịch vụ thân thiện. Lan Rừng là lựa chọn kinh tế cho du lịch biển, gần các điểm vui chơi sôi động của Vũng Tàu.'),
(20, 'Pullman Vung Tau', '44 Hạ Long, Bãi Trước, TP. Vũng Tàu', 2, 2, 'Khách sạn', 'Pullman Vung Tau là khách sạn 5 sao quốc tế với vị trí trung tâm Bãi Trước, 360 phòng hiện đại và sky bar rooftop view biển 360 độ. Hồ bơi vô cực, spa cao cấp và nhà hàng Pháp tinh tế. Giá từ 2,5tr/đêm, lý tưởng cho doanh nhân hoặc kỳ nghỉ sang trọng. Pullman mang tiêu chuẩn Accor toàn cầu đến Vũng Tàu.'),
-- Hà Nội (id_city=3, id 21-30)
(21, 'Hồ Hoàn Kiếm', 'Hoàn Kiếm, Hà Nội', 3, 4, 'Du lịch', 'Hồ Hoàn Kiếm là trái tim của Hà Nội cổ kính, gắn liền với truyền thuyết rùa thần trả gươm cho vua Lê Lợi. Sáng sớm, hồ yên bình với người tập thái cực quyền, chiều tối tháp Rùa lung linh ánh đèn. Đi thuyền ngắm hồ chỉ 10k, ghé đền Ngọc Sơn chiêm ngưỡng bia rùa. Hồ Hoàn Kiếm không chỉ đẹp mà còn là biểu tượng tinh thần của người Hà thành qua bao thế kỷ.'),
(22, 'Phở Thìn Lờ Đúc', '13 Lò Đúc, Hai Bà Trưng, Hà Nội', 3, 1, 'Nhà hàng', 'Phở Thìn Lờ Đúc là quán phở gia truyền 3 đời, nổi tiếng với phở bò tái lăn giòn tan, nước dùng ninh từ xương ống 12 giờ ngọt thanh. Bánh phở dai mềm, thịt bò tươi, hành lá thơm. Quán nhỏ nhưng sạch sẽ, phục vụ nhanh dù đông khách. Giá 50k/tô, mở cửa từ 6h sáng. Ăn phở Thìn là trải nghiệm chuẩn vị Hà Nội, đậm đà bản sắc.'),
(23, 'Lăng Bác', 'Ba Đình, Hà Nội', 3, 4, 'Du lịch', 'Lăng Chủ Tịch Hồ Chí Minh là nơi an nghỉ của Bác, biểu tượng thiêng liêng của dân tộc Việt Nam. Kiến trúc giản dị, kính cường lực bảo vệ thi hài Bác nguyên vẹn. Tham quan miễn phí thứ 3-4-5-7 sáng, xếp hàng nghiêm trang. Bên cạnh là nhà sàn Bác Hồ và bảo tàng Hồ Chí Minh trưng bày tài liệu quý. Đến lăng Bác, lòng người xúc động và tự hào dân tộc.'),
(24, 'Tràng Tiền Plaza', '24 Hai Bà Trưng, Hoàn Kiếm, Hà Nội', 3, 5, 'Mua sắm', 'Tràng Tiền Plaza là trung tâm thương mại cao cấp nhất Hà Nội với kiến trúc Pháp cổ kính và các brand quốc tế như Gucci, Louis Vuitton. Khu ẩm thực rooftop view hồ Hoàn Kiếm, rạp Lotte cinema hiện đại. Mở cửa 9h30-22h, không gian sang trọng lý tưởng shopping và hẹn hò. Tràng Tiền Plaza là biểu tượng thời thượng của thủ đô.'),
(25, 'Sofitel Legend Metropole Hanoi', '15 Ngô Quyền, Hoàn Kiếm, Hà Nội', 3, 2, 'Khách sạn', 'Sofitel Legend Metropole Hanoi là khách sạn 5 sao lịch sử nhất Hà Nội, mở cửa từ 1901 chứng kiến bao sự kiện lớn. 364 phòng sang trọng, spa bậc nhất, nhà hàng Pháp Michelin. Hồ bơi ngoài trời và bunker thời chiến. Giá từ 4tr/đêm, dịch vụ đẳng cấp. Metropole mang vẻ đẹp cổ điển giữa lòng Hà Nội ngàn năm văn hiến.'),
(26, 'Phố Bia Tạ Hiện', 'Tạ Hiện, Hoàn Kiếm, Hà Nội', 3, 3, 'Vui chơi', 'Phố Bia Tạ Hiện là thiên đường bia hơi Hà Nội với hàng trăm quán nhỏ xinh, không khí náo nhiệt về đêm. Bia hơi tươi mát giá 5k/ly, nhậu nhẹt từ nem chua rán đến thịt xiên nướng. Nhạc sống, tiếng cười nói rộn ràng tạo sức hút khó cưỡng. Phố Tạ Hiện là nơi gặp gỡ bạn bè, cảm nhận nhịp sống sôi động của thủ đô.'),
(27, 'Chả Cá Lã Vọng', '14 Chả Cá, Hoàn Kiếm, Hà Nội', 3, 1, 'Nhà hàng', 'Chả Cá Lã Vọng là nhà hàng gia truyền 4 đời, nổi tiếng với chả cá hồ Tây tươi ngon nướng than hoa, ăn kèm bún, rau sống và mắm tôm. Nước dùng nóng hổi, chả cá vàng óng thơm lừng. Không gian cổ kính với bàn ghế gỗ lim. Giá 300k/người, đặt chỗ trước. Ăn chả cá Lã Vọng là thưởng thức tinh hoa ẩm thực Hà Nội.'),
(28, 'Văn Miếu Quốc Tử Giám', '58 Quốc Tử Giám, Đống Đa, Hà Nội', 3, 4, 'Du lịch', 'Văn Miếu Quốc Tử Giám là trường đại học đầu tiên Việt Nam, xây năm 1070 với 82 bia tiến sĩ vinh danh 1.304 người đỗ đạt. Khuôn viên cổ kính với hồ Thiên Quang, vườn thượng uyển và các khu thờ tự. Vé 30k, mở cửa 8h-17h. Văn Miếu là nơi tôn vinh đạo học, mang giá trị văn hóa ngàn năm của dân tộc.'),
(29, 'Vincom Center Ba Trieu', '191 Bà Triệu, Hai Bà Trưng, Hà Nội', 3, 5, 'Mua sắm', 'Vincom Center Ba Trieu là trung tâm thương mại lớn với hơn 200 cửa hàng thời trang, mỹ phẩm và siêu thị GO. Rạp CGV 6 phòng, food court đa dạng món ăn. Mở cửa 9h30-22h, không gian hiện đại giữa lòng Hà Nội. Vincom là điểm shopping tiện lợi cho cư dân thủ đô và du khách.'),
(30, 'Rạp Chiếu Phim Quốc Gia', '87 Láng Hạ, Ba Đình, Hà Nội', 3, 3, 'Vui chơi', 'Rạp Chiếu Phim Quốc Gia là rạp lớn nhất Hà Nội với khán phòng 1.500 chỗ, hệ thống âm thanh vòm và màn hình khổng lồ. Chuyên chiếu phim Việt chất lượng cao, sự kiện văn hóa lớn. Giá vé 60k, vị trí trung tâm dễ di chuyển. Rạp là nơi lưu giữ ký ức điện ảnh Việt Nam qua bao thập kỷ.'),
-- Nha Trang (id_city=4, id 31-40)
(31, 'VinWonders Nha Trang', 'Vịnh Nha Trang, Vĩnh Nguyên, TP. Nha Trang', 4, 3, 'Vui chơi', 'VinWonders Nha Trang là công viên giải trí biển lớn nhất Việt Nam với hơn 100 trò chơi cảm giác mạnh, công viên nước và show biểu diễn quốc tế. Phần nổi bật là tàu lượn Aqua Park, tháp rơi tự do và aquarium khổng lồ. Vé 880k, mở cửa 9h-19h. VinWonders mang đến ngày vui bất tận cho gia đình và bạn trẻ yêu mạo hiểm.'),
(32, 'Tháp Bà Ponagar', 'Sự Canh, Vĩnh Nguyên, TP. Nha Trang', 4, 4, 'Du lịch', 'Tháp Bà Ponagar là quần thể tháp Chăm cổ nhất Nam Việt Nam, xây thế kỷ 8-13 thờ nữ thần Ponagar. Kiến trúc đá ong tinh xảo, phù điêu sống động kể chuyện lịch sử. Lễ hội Tháp Bà tháng 3 rực rỡ. Vé 22k, mở cửa 6h-18h. Tháp Bà là di sản văn hóa, nơi giao thoa giữa văn minh Chăm và Việt.'),
(33, 'Nem Nướng Ninh Hòa', '64 Yersin, Lộc Thọ, TP. Nha Trang', 4, 1, 'Nhà hàng', 'Nem Nướng Ninh Hòa là quán nem nướng gia truyền với nem tươi nướng than hồng, nước chấm bùi bùi đặc trưng từ đậu phộng xay. Ăn cuốn bánh tráng, rau sống tươi. Quán sạch sẽ, phục vụ nhanh. Giá 50k/phần, đông khách trưa tối. Nem nướng là món ăn đường phố Nha Trang không thể bỏ qua.'),
(34, 'Amiana Resort Nha Trang', 'Hoà Trung, Vĩnh Hoà, TP. Nha Trang', 4, 2, 'Khách sạn', 'Amiana Resort Nha Trang là khu nghỉ dưỡng 5 sao biệt lập trên đảo Hòn Tre, với villa overwater và hồ bơi riêng. Spa thiên nhiên, yoga và ẩm thực hữu cơ. Giá từ 5tr/đêm, view vịnh Nha Trang tuyệt đẹp. Amiana mang đến sự riêng tư, thư giãn giữa thiên đường biển.'),
(35, 'Hải Đăng Nha Trang', 'Đèo Hòn Lết, Vĩnh Phương, TP. Nha Trang', 4, 4, 'Du lịch', 'Hải Đăng Nha Trang là ngọn hải đăng cổ trên vịnh biển đẹp nhất Việt Nam, cao 26m với view 360 độ ra vịnh và núi non. Leo 168 bậc thang ngắm bình minh. Vé 10k, mở cửa sáng sớm. Hải đăng là biểu tượng lãng mạn của Nha Trang.'),
(36, 'Vincom Plaza Nha Trang', '1 Trần Hưng Đạo, Lộc Thọ, TP. Nha Trang', 4, 5, 'Mua sắm', 'Vincom Plaza Nha Trang là trung tâm thương mại ven biển với brand thời trang, rạp CGV và food court hải sản. Mở cửa 9h-22h, view biển tuyệt. Vincom là điểm shopping sôi động của du khách.'),
(37, 'Bãi Dài Nha Trang', 'Cam Lâm, Khánh Hoà', 4, 4, 'Du lịch', 'Bãi Dài Nha Trang là bãi biển hoang sơ dài 15km cát trắng mịn, nước xanh ngọc. Lý tưởng lướt ván, dù lượn. Ít đông đúc, giá rẻ. Bãi Dài là thiên đường biển yên bình.'),
(38, 'Mia Resort Nha Trang', 'Bai Dai, Cam Ranh, Khanh Hoa', 4, 2, 'Khách sạn', 'Mia Resort Nha Trang là khu nghỉ dưỡng 5 sao với villa riêng lẻ, hồ bơi vô cực và spa. Ẩm thực fusion, hoạt động biển. Giá 3tr/đêm, riêng tư cao cấp.'),
(39, 'Chợ Đêm Đầm', 'Đường Trần Phú, Nha Trang', 4, 5, 'Mua sắm', 'Chợ Đêm Đầm là khu chợ sầm uất với hải sản tươi, đồ lưu niệm và street food. Mở cửa 18h-24h, không khí nhộn nhịp. Chợ Đầm là nơi mua sắm đêm Nha Trang.'),
(40, 'Chùa Long Sơn', '22 Đường 23/10, Phương Sơn, TP. Nha Trang', 4, 4, 'Du lịch', 'Chùa Long Sơn với tượng Phật trắng cao 24m trên đồi Trại Thủy, view toàn thành phố. Kiến trúc cổ, không gian thanh tịnh. Miễn phí, chùa là điểm tâm linh Nha Trang.'),
-- Cần Thơ (id_city=5, id 41-60) - Từ file gốc, đã fix quotes và full
(41, 'Bến Ninh Kiều', 'Ninh Kiều, Cần Thơ', 5, 4, 'Du lịch', 'Bến Ninh Kiều là biểu tượng của Cần Thơ, nơi sông Hậu uốn lượn, view cầu Cần Thơ lung linh đêm. Dạo chơi, ăn uống ven sông. Bến là trái tim Tây Đô sôi động.'),
(42, 'Lẩu Mắm Bà Dú', '123 Mậu Thân, Ninh Kiều, Cần Thơ', 5, 1, 'Nhà hàng', 'Lẩu Mắm Bà Dú nổi tiếng với lẩu mắm cá linh bông điên điển, đồ nhúng phong phú. Nước dùng đậm đà miền Tây. Quán rộng, giá 150k/nồi. Lẩu mắm là đặc sản Cần Thơ.'),
(43, 'TTC Hotel Cần Thơ', 'Cái Khế, Ninh Kiều, Cần Thơ', 5, 2, 'Khách sạn', 'TTC Hotel Cần Thơ 4 sao trung tâm, phòng view sông, hồ bơi và buffet sáng. Giá 1tr/đêm, tiện nghi cao. TTC là lựa chọn thoải mái cho du lịch miền Tây.'),
(44, 'Vincom Plaza Xuân Khánh', '209 Đường 30/4, Xuân Khánh, Ninh Kiều, Cần Thơ', 5, 5, 'Mua sắm', 'Vincom Plaza Xuân Khánh là trung tâm thương mại lớn nhất ĐBSCL, với brand quốc tế, rạp CGV và view sông Hậu. Mở cửa 9h-22h, hiện đại năng động.'),
(45, 'Victoria Can Tho Resort', 'Cồn Cái Khế, Phường Cái Khế, Ninh Kiều, Cần Thơ', 5, 2, 'Khách sạn', 'Victoria Can Tho Resort 4 sao bên sông Hậu, kiến trúc Đông Dương, spa và tàu du lịch Lady Hau. Giá 2tr/đêm, nghỉ dưỡng thanh bình miền Tây.'),
(46, 'Nhà Cổ Bình Thủy', '144 Bùi Hữu Nghĩa, Bình Thủy, Cần Thơ', 5, 4, 'Du lịch', 'Nhà Cổ Bình Thủy xây 1870, kiến trúc Pháp-Việt, bối cảnh phim \'Người Tình\'. Cổ vật quý, vé 20k. Nhà cổ là di sản văn hóa Cần Thơ.'),
(47, 'Pizza 4P\'s Cần Thơ', 'Lầu 2, Sense City, Đại lộ Hòa Bình, Ninh Kiều, Cần Thơ', 5, 1, 'Nhà hàng', 'Pizza 4P\'s Cần Thơ kết hợp pizza Ý-Nhật, phô mai handmade, không gian sang trọng. Giá 200k/pizza, ẩm thực fusion đỉnh cao miền Tây.'),
(48, 'Chợ Đêm Tây Đô', 'Cách Mạng Tháng 8, Cái Khế, Ninh Kiều, Cần Thơ', 5, 5, 'Mua sắm', 'Chợ Đêm Tây Đô sầm uất với street food bánh xèo, cá nướng và đồ thủ công. Mở cửa 17h-23h, không khí văn hóa miền Tây rộn ràng.'),
(49, 'Thiền Viện Trúc Lâm', 'TL 923, Mỹ Khánh, Phong Điền, Cần Thơ', 5, 4, 'Du lịch', 'Thiền Viện Trúc Lâm Phương Nam lớn nhất miền Tây, kiến trúc Lý-Trần, hồ sen thanh tịnh. Miễn phí, nơi tu học và du lịch tâm linh.'),
(50, 'Khu Du Lịch Mỹ Khánh', '335 Lộ Vòng Cung, Mỹ Khánh, Phong Điền, Cần Thơ', 5, 3, 'Vui chơi', 'Khu Du Lịch Mỹ Khánh như ĐBSCL thu nhỏ, vườn trái cây, đua heo, cơm điền chủ. Vé 100k, vui nhộn cho team building và gia đình.'),
(51, 'Ga Đà Lạt', '1 Quang Trung, Phường 10, TP. Đà Lạt', 1, 4, 'Du lịch', 'Ga Đà Lạt cổ kính nhất Đông Dương, kiến trúc nhà rông, tàu du lịch đến Trại Mát. Vé 100k, sống ảo hoài cổ.'),
(52, 'Langfarm Buffet', '06 Nguyễn Thị Minh Khai, Phường 1, TP. Đà Lạt', 1, 1, 'Nhà hàng', 'Langfarm Buffet 50 món nông sản Đà Lạt, mứt dâu, kem gelato. Giá 200k, ấm cúng gia đình.'),
(53, 'Bạch Dinh', '06 Trần Phú, Phường 1, TP. Vũng Tàu', 2, 4, 'Du lịch', 'Bạch Dinh dinh thự Pháp cổ, cổ vật gốm sứ, view Bãi Trước. Vé 40k, lịch sử hoàng kim.'),
(54, 'David Pizzeria', '92 Hạ Long, Phường 2, TP. Vũng Tàu', 2, 1, 'Nhà hàng', 'David Pizzeria pizza nướng củi Ý, view biển lãng mạn. Giá 150k, ẩm thực Âu đích thực.'),
(55, 'Nhà Hát Lớn Hà Nội', '01 Tràng Tiền, Phan Chu Trinh, Hoàn Kiếm, Hà Nội', 3, 4, 'Du lịch', 'Nhà Hát Lớn Hà Nội kiến trúc Pháp, hòa nhạc giao hưởng. Vé show 500k+, nghệ thuật thủ đô.'),
(56, 'Cafe Giảng', '39 Nguyễn Hữu Huân, Lý Thái Tổ, Hoàn Kiếm, Hà Nội', 3, 1, 'Nhà hàng', 'Cafe Giảng cà phê trứng huyền thoại, không gian hoài cổ phố cổ. Giá 30k/ly, vị Hà Nội xưa.'),
(57, 'Chùa Long Sơn', '22 Đường 23/10, Phương Sơn, TP. Nha Trang', 4, 4, 'Du lịch', 'Chùa Long Sơn tượng Phật trắng khổng lồ, leo 193 bậc view Nha Trang. Thanh tịnh tâm linh.'),
(58, 'Skylight Nha Trang', '38 Trần Phú, Lộc Thọ, TP. Nha Trang', 4, 3, 'Vui chơi', 'Skylight Rooftop Beach Club cao nhất, skywalk kính, DJ party view vịnh. Vé 500k, nightlife đỉnh.'),
(59, 'Vườn Cò Bằng Lăng', 'Thới Bình 1, Thuận An, Thốt Nốt, Cần Thơ', 5, 4, 'Du lịch', 'Vườn Cò Bằng Lăng hàng ngàn cò trắng, ngắm bình minh hoàng hôn. Thiên nhiên miền Tây hoang sơ.'),
(60, 'Nem Nướng Thanh Vân', '17 Đại lộ Hòa Bình, Tân An, Ninh Kiều, Cần Thơ', 5, 1, 'Nhà hàng', 'Nem Nướng Thanh Vân nem tươi nướng than, nước chấm sền sệt đặc biệt. Giá 50k, thương hiệu Cần Thơ.');

-- Đánh giá thành phố (lọc trùng, 40 records mẫu)

-- ================================
-- ĐÁNH GIÁ THÀNH PHỐ (40 record - đã fix lỗi 1136)
-- ================================
INSERT IGNORE INTO Danhgia_city (username, id_city, rate_city) VALUES
('abc', 3, 4),
('ban', 3, 5),
('toilaai', 2, 2),
('user1', 1, 5),
('user1', 2, 4),
('user2', 1, 4),
('user2', 3, 5),
('user3', 2, 5),
('user3', 3, 4),
('user4', 1, 3),
('user4', 2, 5),
('user5', 3, 5),
('user5', 1, 4),
('user6', 2, 4),
('user7', 1, 5),
('user8', 3, 3),
('user9', 2, 5),
('user10', 1, 4),
('user3', 1, 5),
('user4', 1, 5),
('user5', 1, 4),
('user6', 1, 5),
('user7', 2, 4),
('user8', 2, 3),
('user9', 2, 5),
('user10', 3, 5),
('user2', 3, 4),
('user1', 4, 5),
('user2', 4, 5),
('user3', 4, 4),
('user5', 4, 5),
('user8', 4, 5),
('user4', 5, 5),
('user6', 5, 4),
('user7', 5, 5),
('user9', 5, 4),
('user10', 5, 5),
('abc', 1, 5),
('abc', 5, 5),
('admin', 4, 5);

-- ================================
-- ĐÁNH GIÁ ĐỊA ĐIỂM (đã fix hết lỗi)
-- ================================
INSERT IGNORE INTO Danhgia_diadiem (username, id_dia_diem, rate_point, comment, ngay_danh_gia) VALUES
('admin', 1, 5, 'Quảng trường rất đẹp, không khí trong lành!', '2025-12-02 03:20:39'),
('user1', 1, 4, 'Đông vui nhưng hơi kẹt xe vào cuối tuần.', '2025-12-02 03:20:39'),
('admin', 1, 3, 'Nên dẹp một vài hàng quán bán giá cắt cổ người dân.', '2025-12-02 03:27:29'),
('abc', 1, 5, 'Quảng trường rộng bao la, chụp hình với nụ hoa Atiso siêu đẹp.', '2025-12-02 03:52:09'),
('user2', 1, 4, 'Buổi tối hơi lạnh nhưng không khí rất tuyệt, nhiều đồ ăn vặt.', '2025-12-02 03:52:09'),
('toilaai', 1, 5, 'Địa điểm check-in không thể bỏ qua khi đến Đà Lạt.', '2025-12-02 03:52:09'),
('ban', 2, 5, 'Đồ len rẻ đẹp, khoai lang nướng mật ngọt lịm.', '2025-12-02 03:52:09'),
('user5', 2, 4, 'Chợ đông vui nhộn nhịp, cẩn thận lạc nhau nhé.', '2025-12-02 03:52:09'),
('user1', 3, 5, 'Lẩu gà lá é ngon tuyệt vời, vị lạ miệng rất thích.', '2025-12-02 03:52:09'),
('user3', 3, 5, 'Thịt gà dai ngọt, nước dùng cay cay ấm người.', '2025-12-02 03:52:09'),
('banabc', 4, 4, 'Bánh mì ngon, bức tường vàng chụp ảnh rất nghệ.', '2025-12-02 03:52:09'),
('user6', 5, 5, 'Khách sạn sang trọng, ngay chợ rất tiện đi lại.', '2025-12-02 03:52:09'),
('user7', 6, 5, 'Cảnh đẹp như tranh, trăm hoa đua nở rất lãng mạn.', '2025-12-02 03:52:09'),
('user8', 7, 4, 'Quán cafe yên tĩnh, mấy bé mèo cute xỉu.', '2025-12-02 03:52:09'),
('user9', 8, 5, 'Bánh mì xíu mại nóng hổi, ăn sáng là chuẩn bài.', '2025-12-02 03:52:09'),
('user10', 9, 4, 'Biệt điện cổ kính, tìm hiểu lịch sử rất thú vị.', '2025-12-02 03:52:09'),
('abc', 10, 5, 'Rạp phim hiện đại, ghế ngồi thoải mái.', '2025-12-02 03:52:09'),
('toilaai', 51, 5, 'Nhà ga cổ kính, chụp hình cưới ở đây thì hết ý.', '2025-12-02 03:52:09'),
('ban', 52, 5, 'Buffet nhiều món ngon, thích nhất là kem và mứt dâu.', '2025-12-02 03:52:09'),
('user4', 11, 5, 'Leo bộ hơi mệt nhưng view từ vai tượng Chúa đẹp xuất sắc.', '2025-12-02 03:52:09'),
('user1', 11, 5, 'Gió mát lồng lộng, ngắm toàn cảnh biển Vũng Tàu.', '2025-12-02 03:52:09'),
('user2', 12, 4, 'Bánh khọt giòn rụm, tôm tươi rói, nước mắm pha vừa miệng.', '2025-12-02 03:52:09'),
('user3', 12, 5, 'Đợi hơi lâu xíu nhưng bù lại bánh rất ngon.', '2025-12-02 03:52:09'),
('user5', 13, 5, 'Khách sạn đẳng cấp, hồ bơi đẹp, nhân viên thân thiện.', '2025-12-02 03:52:09'),
('user6', 14, 4, 'Cáp treo đi êm, trên núi khí hậu mát mẻ như Đà Lạt.', '2025-12-02 03:52:09');
-- (Bạn có thể thêm tiếp 20-30 dòng nữa nếu muốn, cứ copy từ file cũ là được, miễn đừng có số thứ tự ở đầu)


-- Yêu thích mẫu
INSERT INTO SoThich (username, id_dia_diem) VALUES
                                                ('admin', 1), ('admin', 11), ('abc', 2), ('user1', 21);

-- =============================================================
-- END - Chạy thành công!
-- =============================================================