// --- KHỞI TẠO BIẾN ---
const urlParams = new URLSearchParams(window.location.search);
const currentId = urlParams.get('id');
const currentFullName = localStorage.getItem("currentFullName");
const currentUser = localStorage.getItem("currentUser");

// --- 1. XỬ LÝ HEADER ---
if(currentUser && currentFullName) {
    document.getElementById('userHello').innerText = "Xin chào, " + currentFullName;
    // Link vào profile
    document.getElementById('linkProfile').innerText = currentFullName;
}

function logout() {
    if(confirm("Đăng xuất khỏi hệ thống?")) {
        localStorage.removeItem("currentUser");
        localStorage.removeItem("currentFullName");
        localStorage.removeItem("currentRole");
        window.location.href = "login.html";
    }
}

// --- 2. XỬ LÝ CHÍNH KHI TẢI TRANG ---
window.onload = function() {
    if (!currentId) {
        alert("Chưa chọn thành phố!");
        window.location.href = "chonThanhPho.html";
        return;
    }

    // A. Tải danh sách thành phố vào Select box
    fetch('/SMcity/api/danh-sach-thanh-pho')
        .then(res => res.json())
        .then(data => {
            let selectBox = document.getElementById('citySelect');
            data.forEach(city => {
                let option = document.createElement("option");
                option.value = city.id;
                option.text = city.ten;
                if (city.id == currentId) option.selected = true;
                selectBox.add(option);
            });
        });

    // B. Tải chi tiết thành phố (Banner, Tên, Mô tả, Sao)
    fetch('/SMcity/api/chi-tiet-thanh-pho?id=' + currentId)
        .then(res => res.json())
        .then(data => {
            if (data.status === "success") {
                // Điền thông tin
                document.getElementById('tenTP').innerText = data.ten;
                document.getElementById('moTaTP').innerText = data.mota;
                document.getElementById('soSao').innerText = data.sao;

                // Cập nhật Banner (Lấy ảnh từ folder images/)
                // Lưu ý: data.banner chính là tên file ảnh (vd: dalat.jpg)
                const bannerUrl = `url('../images/${data.banner}')`;
                document.getElementById('bannerBg').style.backgroundImage = bannerUrl;
            } else {
                alert("Lỗi tải dữ liệu: " + data.message);
            }
        })
        .catch(err => console.log(err));

    // C. Tải danh sách địa điểm
    loadDiaDiem();
};

// --- 3. XỬ LÝ CHUYỂN THÀNH PHỐ ---
document.getElementById('btnSwitch').addEventListener('click', function() {
    let newId = document.getElementById('citySelect').value;
    if (newId) window.location.href = "thanhpho.html?id=" + newId;
});

// --- 4. XỬ LÝ ĐÁNH GIÁ (SLIDER) ---
// Hàm hiển thị số sao khi kéo thanh trượt
function updateSliderValue(val) {
    document.getElementById('sliderValue').innerText = val;
}

// Hàm gửi đánh giá
// Hàm gửi đánh giá (UPDATE CHO SAO)
function submitRating() {
    if (!currentUser) {
        alert("Vui lòng đăng nhập lại!");
        window.location.href = "login.html";
        return;
    }

    // 1. Lấy giá trị từ Radio Button (Sao)
    // Tìm thẻ input nào có name="rate" mà đang được check
    const checkedStar = document.querySelector('input[name="rate"]:checked');

    if (!checkedStar) {
        alert("Bạn chưa chọn số sao!");
        return;
    }

    const starValue = checkedStar.value;

    // 2. Gửi về Server
    fetch('/SMcity/api/them-danh-gia', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'username=' + currentUser + '&id_city=' + currentId + '&rate=' + starValue
    })
        .then(res => res.json())
        .then(data => {
            if(data.status == "success") {
                alert(data.message);
                location.reload(); // Tải lại trang để cập nhật điểm trung bình
            } else {
                alert("Thông báo: " + data.message);
            }
        });
}

// --- 5. XỬ LÝ TAB & DANH SÁCH ĐỊA ĐIỂM (Giữ nguyên logic cũ) ---
let globalType = 0;
let globalPage = 1;
let globalTotalPages = 1;

function changeType(typeId, btnElement) {
    globalType = typeId;
    globalPage = 1;

    // Update CSS active cho nút
    let buttons = document.querySelectorAll('.tab-btn');
    buttons.forEach(btn => btn.classList.remove('active'));
    btnElement.classList.add('active');

    loadDiaDiem();
}

function changePage(step) {
    let newPage = globalPage + step;
    if (newPage >= 1 && newPage <= globalTotalPages) {
        globalPage = newPage;
        loadDiaDiem();
    }
}

function loadDiaDiem() {
    const container = document.getElementById('listDiaDiem');
    container.innerHTML = "<p>Đang tải...</p>";

    fetch(`/SMcity/api/lay-dia-diem?id_city=${currentId}&type=${globalType}&page=${globalPage}&user=${currentUser}`)
        .then(res => res.json())
        .then(result => {
            container.innerHTML = "";
            if (result.data.length === 0) {
                container.innerHTML = "<p>Không tìm thấy địa điểm nào.</p>";
                return;
            }

            result.data.forEach(item => {
                let favMark = item.is_fav ? '<span style="float:right;">❤️ Đã thích</span>' : '';

                // Style cơ bản cho từng item
                let div = document.createElement("div");
                div.style.borderBottom = "1px solid #eee";
                div.style.padding = "15px 0";

                div.innerHTML = `
                    ${favMark}
                    <a href="DiaDiem.html?id=${item.id}" style="text-decoration: none; color: #007bff; font-size: 18px; font-weight: bold;">
                        ${item.ten}
                    </a> 
                    <span style="color: #666; font-size: 14px;"> - [${item.loai}]</span><br>
                    <span style="color: #555;">📍 ${item.diachi}</span>
                `;
                container.appendChild(div);
            });

            globalTotalPages = result.total_pages;
            document.getElementById('pageInfo').innerText = `Trang ${globalPage} / ${globalTotalPages}`;
            document.getElementById('btnPrev').disabled = (globalPage <= 1);
            document.getElementById('btnNext').disabled = (globalPage >= globalTotalPages);
        });
}