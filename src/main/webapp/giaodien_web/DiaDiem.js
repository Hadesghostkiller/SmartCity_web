// Kiểm tra đăng nhập
const currentUser = localStorage.getItem("currentUser");
const currentFullName = localStorage.getItem("currentFullName");
if (!currentUser) {
    alert("Vui lòng đăng nhập!");
    window.location.href = "login.html";
} else {
    document.getElementById('userHello').innerText = "Xin chào " + (currentFullName ? currentFullName : currentUser);
}

// Lấy ID địa điểm từ URL
const params = new URLSearchParams(window.location.search);
const idDiaDiem = params.get('id');

if (!idDiaDiem) {
    alert("Không xác định được địa điểm!");
    window.location.href = "chonThanhPho.html";
}
//Ngu
// Gọi API lấy chi tiết
fetch('/SMcity/api/chi-tiet-dia-diem?id=' + idDiaDiem + '&user=' + currentUser)
    .then(res => res.json())
    .then(data => {
        if (data.status === "success") {
            document.getElementById('ddTen').innerText = data.ten;
            document.getElementById('ddSao').innerText = data.sao;
            document.getElementById('ddLoai').innerText = data.loai;
            document.getElementById('ddDiaChi').innerText = data.diachi;
            document.getElementById('ddMoTa').innerText = data.mota;
            initFavoriteButton(data.is_fav);
            // Cấu hình nút Quay lại về đúng thành phố ID cũ
            document.getElementById('btnBack').onclick = function() {
                window.location.href = "thanhpho.html?id=" + data.id_city;
            };
        } else {
            alert("Lỗi: " + data.message);
        }
    })
    .catch(err => console.log(err));

// ====================================================================================
// -----------------------------TÍNH NĂNG MỚI: GỢI Ý & BÌNH LUẬN----------------------
// ====================================================================================
//1. Hàm tải gợi ý địa điểm
function loadRecommendation() {
    fetch('/SMcity/api/lay-de-xuat?id=' + idDiaDiem)
        .then(res => res.json())
        .then(data => {
            let div = document.getElementById('recommendList');
            div.innerHTML = "";

            if(data.length === 0) {
                div.innerHTML = "<i>Chưa có gợi ý liên quan.</i>";
                return;
            }

            data.forEach(item => {
                // Tạo link bấm vào là chuyển sang địa điểm đó
                div.innerHTML += `
                <div style="margin-bottom: 5px;">
                    👉 <a href="DiaDiem.html?id=${item.id}" style="text-decoration: none; color: #007bff;">
                        <b>${item.ten}</b>
                    </a>
                </div>
            `;
            });
        });
}

// 2. Hàm tải danh sách bình luận
function loadComments() {
    fetch('/SMcity/api/lay-binh-luan?id=' + idDiaDiem)
        .then(res => res.json())
        .then(data => {
            let div = document.getElementById('commentList');
            div.innerHTML = "";

            if(data.length === 0) {
                div.innerHTML = "<p>Chưa có đánh giá nào. Hãy là người đầu tiên!</p>";
                return;
            }

            data.forEach(item => {
                div.innerHTML += `
                <div style="border-bottom: 1px solid #eee; padding: 10px 0;">
                    <b>${item.user}</b> <span style="color: orange;">(${item.rate} ⭐)</span>
                    <span style="font-size: 0.8em; color: gray; float: right;">${item.ngay}</span>
                    <p style="margin-top: 5px;">${item.comment}</p>
                </div>
            `;
            });
        });
}

// 3. Xử lý nút Gửi bình luận
document.getElementById('btnSendComment').addEventListener('click', function() {
    const rate = document.getElementById('cmtRate').value;
    const comment = document.getElementById('cmtText').value;

    if(comment.trim() === "") {
        alert("Bạn chưa viết nội dung đánh giá!");
        return;
    }

    fetch('/SMcity/api/gui-binh-luan', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `username=${currentUser}&id_dia_diem=${idDiaDiem}&rate=${rate}&comment=${comment}`
    })
        .then(res => res.json())
        .then(data => {
            if(data.status === "success") {
                alert(data.message);
                document.getElementById('cmtText').value = ""; // Xóa ô nhập
                loadComments(); // Tải lại danh sách comment ngay lập tức
            } else {
                alert("Lỗi: " + data.message);
            }
        });
});

// ==================================================================
// ------------------------LOGIC SỞ THÍCH---------------------------
// ==================================================================
function updateFavoriteUI(isFav) {
    const btn = document.getElementById('btnFavorite');
    if (isFav) {
        btn.innerHTML = '✅ Đã thêm vào Sở thích';
        btn.style.backgroundColor = '#d4edda';
        btn.style.color = '#155724';
    } else {
        btn.innerHTML = '🤍 Thêm vào Sở thích';
        btn.style.backgroundColor = '#f8d7da';
        btn.style.color = '#721c24';
    }
}

document.getElementById('btnFavorite').addEventListener('click', function() {
    fetch('/SMcity/api/xu-ly-so-thich', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `username=${currentUser}&id_dia_diem=${idDiaDiem}`
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === "success") {
                // Nếu action là 'added' -> true, 'removed' -> false
                const isAdded = (data.action === "added");
                updateFavoriteUI(isAdded);
            }
        });
});

// GỌI API CHI TIẾT (SỬA ĐOẠN NÀY)
// Thêm tham số &user=... vào URL
fetch('/SMcity/api/chi-tiet-dia-diem?id=' + idDiaDiem + '&user=' + currentUser)
    .then(res => res.json())
    .then(data => {
        if (data.status === "success") {
            document.getElementById('ddTen').innerText = data.ten;
            document.getElementById('ddSao').innerText = data.sao;
            document.getElementById('ddLoai').innerText = data.loai;
            document.getElementById('ddDiaChi').innerText = data.diachi;
            document.getElementById('ddMoTa').innerText = data.mota;

            // QUAN TRỌNG: Cập nhật nút theo trạng thái thật từ Database
            updateFavoriteUI(data.is_fav);

            document.getElementById('btnBack').onclick = function() {
                window.location.href = "thanhpho.html?id=" + data.id_city;
            };
        } else {
            alert("Lỗi: " + data.message);
        }
    })
    .catch(err => console.log(err));

// GỌI CÁC HÀM NÀY KHI VÀO TRANG
loadRecommendation();
loadComments();