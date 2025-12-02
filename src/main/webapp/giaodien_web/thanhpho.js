// Lấy tham số ID trên URL (Ví dụ: .../thanhpho.html?id=1 -> lấy được số 1)
const urlParams = new URLSearchParams(window.location.search);
const currentId = urlParams.get('id');
const currentFullName = localStorage.getItem("currentFullName");
const currentUser = localStorage.getItem("currentUser");

if(document.getElementById('userHello') && currentFullName) {
    document.getElementById('userHello').innerText = "Xin chào " + currentFullName;
}

window.onload = function() {
    if (!currentId) {
        alert("Chưa chọn thành phố!");
        window.location.href = "chonThanhPho.html";
        return;
    }

    // 1. Tải danh sách cho hộp Select (Tái sử dụng)
    fetch('/SMcity/api/danh-sach-thanh-pho')
        .then(res => res.json())
        .then(data => {
            let selectBox = document.getElementById('citySelect');
            data.forEach(city => {
                let option = document.createElement("option");
                option.value = city.id;
                option.text = city.ten;
                // Nếu option trùng với thành phố đang xem thì chọn sẵn luôn
                if (city.id == currentId) option.selected = true;
                selectBox.add(option);
            });
        });

    // 2. Tải thông tin chi tiết thành phố hiện tại
    fetch('/SMcity/api/chi-tiet-thanh-pho?id=' + currentId)
        .then(res => res.json())
        .then(data => {
            if (data.status === "success") {
                document.getElementById('tenTP').innerText = data.ten;
                document.getElementById('moTaTP').innerText = data.mota;
                document.getElementById('soSao').innerText = data.sao;
            } else {
                alert("Lỗi tải dữ liệu: " + data.message);
            }
        })
        .catch(err => console.log(err));
};

//-------------------------- Xử lý nút chuyển thành phố------------------
document.getElementById('btnSwitch').addEventListener('click', function() {
    let selectBox = document.getElementById('citySelect');
    let newId = selectBox.value;
    if (newId) {
        // Load lại trang này với ID mới
        window.location.href = "thanhpho.html?id=" + newId;
    }
});

//----------------------------------- Xử lý nút Gửi đánh giá------------------------------
document.getElementById('btnRate').addEventListener('click', function() {
    // 1. Lấy thông tin
    const currentUser = localStorage.getItem("currentUser"); // Lấy user đã đăng nhập
    const currentCityId = new URLSearchParams(window.location.search).get('id');
    const star = document.getElementById('myRate').value;

    if (!currentUser) {
        alert("Vui lòng đăng nhập lại để đánh giá!");
        window.location.href = "login.html";
        return;
    }

    // 2. Gửi về Server
    fetch('/SMcity/api/them-danh-gia', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'username=' + currentUser + '&id_city=' + currentCityId + '&rate=' + star
    })
        .then(res => res.json())
        .then(data => {
            if(data.status == "success") {
                alert(data.message);
                location.reload(); // Tải lại trang để cập nhật điểm trung bình mới
            } else {
                alert("Thông báo: " + data.message); // Sẽ hiện "Bạn đã đánh giá rồi" nếu trùng
            }
        })
        .catch(err => console.log(err));
});

// ====================== PHẦN XỬ LÝ DANH SÁCH ĐỊA ĐIỂM ===========================
let globalType = 0;
let globalPage = 1;
let globalTotalPages = 1;

function loadDiaDiem() {
    const cityId = new URLSearchParams(window.location.search).get('id');
    const container = document.getElementById('listDiaDiem');
    const currentUser = localStorage.getItem("currentUser"); // Lấy user hiện tại

    container.innerHTML = "<p>Đang tải...</p>";

    // SỬA URL: Thêm &user=${currentUser}
    fetch(`/SMcity/api/lay-dia-diem?id_city=${cityId}&type=${globalType}&page=${globalPage}&user=${currentUser}`)
        .then(res => res.json())
        .then(result => {
            container.innerHTML = "";

            if (result.data.length === 0) {
                container.innerHTML = "<p>Chưa có địa điểm nào thuộc mục này.</p>";
                return;
            }

            result.data.forEach(item => {
                let div = document.createElement("div");

                // KIỂM TRA ĐỂ HIỆN DẤU TICK
                // Nếu item.is_fav là true thì hiện ✅, ngược lại thì rỗng
                let favMark = item.is_fav ? '<span style="float:right; font-size:1.2em;">✅</span>' : '';

                div.innerHTML = `
                ${favMark} 
                <a href="DiaDiem.html?id=${item.id}" style="text-decoration: none; color: blue; font-size: 1.2em; cursor: pointer;">
                    <b>${item.ten}</b>
                </a> 
                - [${item.loai}]<br>
                <span>Địa chỉ: ${item.diachi}</span>
                <hr> 
            `;
                container.appendChild(div);
            });

            // Cập nhật thông tin phân trang
            globalTotalPages = result.total_pages;
            document.getElementById('pageInfo').innerText = `Trang ${globalPage} / ${globalTotalPages}`;

            document.getElementById('btnPrev').disabled = (globalPage <= 1);
            document.getElementById('btnNext').disabled = (globalPage >= globalTotalPages);
        })
        .catch(err => console.log(err));
}

// Hàm đổi loại hình
function changeType(typeId) {
    globalType = typeId;
    globalPage = 1;
    loadDiaDiem();
}

// Hàm chuyển trang
function changePage(step) {
    let newPage = globalPage + step;
    if (newPage >= 1 && newPage <= globalTotalPages) {
        globalPage = newPage;
        loadDiaDiem();
    }
}
// Gọi hàm khi vào trang
loadDiaDiem();