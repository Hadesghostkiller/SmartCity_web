const currentUser = localStorage.getItem("currentUser");
if (!currentUser) window.location.href = "login.html";

document.getElementById('lblUser').innerText = currentUser;

// 1. TẢI DỮ LIỆU KHI VÀO TRANG
function loadProfile() {
    fetch('/SMcity/api/lay-profile?username=' + currentUser)
        .then(res => res.json())
        .then(data => {
            // Điền họ tên
            document.getElementById('inpName').value = data.hoten;

            // Điền danh sách sở thích
            const container = document.getElementById('favList');
            container.innerHTML = "";

            if (data.favs.length === 0) {
                container.innerHTML = "<i>Bạn chưa có địa điểm yêu thích nào.</i>";
            } else {
                data.favs.forEach(item => {
                    let div = document.createElement("div");
                    div.style.padding = "5px 0";
                    div.style.borderBottom = "1px dashed #eee";
                    div.innerHTML = `
                    <button onclick="removeFav(${item.id})">❌ Xóa</button> 
                    <a href="DiaDiem.html?id=${item.id}" style="text-decoration: none; color: blue; font-weight: bold; margin-left: 10px;">
                        ${item.ten}
                    </a>
                `;
                    container.appendChild(div);
                });
            }
        });
}

// 2. XỬ LÝ LƯU TÊN
document.getElementById('btnSaveName').addEventListener('click', function() {
    const newName = document.getElementById('inpName').value;
    fetch('/SMcity/api/cap-nhat-thong-tin', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `username=${currentUser}&hoten=${newName}`
    })
        .then(res => res.json())
        .then(data => {
            alert(data.message);
            if(data.status === 'success') {
                localStorage.setItem("currentFullName", data.ten_moi); // Cập nhật luôn bộ nhớ
                loadProfile(); // Tải lại để thấy tên chuẩn hóa
            }
        });
});

// 3. XỬ LÝ ĐỔI PASS
document.getElementById('btnChangePass').addEventListener('click', function() {
    const oldP = document.getElementById('oldPass').value;
    const newP = document.getElementById('newPass').value;

    if(!oldP || !newP) { alert("Vui lòng nhập đủ mật khẩu!"); return; }

    fetch('/SMcity/api/doi-mat-khau', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `username=${currentUser}&pass_cu=${oldP}&pass_moi=${newP}`
    })
        .then(res => res.json())
        .then(data => {
            alert(data.message);
            if(data.status === 'success') {
                document.getElementById('oldPass').value = "";
                document.getElementById('newPass').value = "";
            }
        });
});

// 4. XỬ LÝ XÓA SỞ THÍCH (Dùng lại API XuLySoThich có sẵn)
function removeFav(idDiaDiem) {
    if (confirm("Bạn có chắc chắn muốn xóa địa điểm này khỏi Sở thích không?")) {
        fetch('/SMcity/api/xu-ly-so-thich', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: `username=${currentUser}&id_dia_diem=${idDiaDiem}`
        })
            .then(res => res.json())
            .then(data => {
                if(data.status === "success") {
                    loadProfile(); // Tải lại danh sách sau khi xóa
                } else {
                    alert("Lỗi: " + data.message);
                }
            });
    }
}

// Chạy khi mở trang
loadProfile();