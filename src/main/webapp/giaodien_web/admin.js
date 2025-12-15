// Kiểm tra quyền
const role = localStorage.getItem("currentRole");
if (role != 1) {
    alert("Không phận sự miễn vào!");
    window.location.href = "chonThanhPho.html";
}

let pageUser = 1;
let pagePlace = 1;
let totalPageUser = 1;
let totalPagePlace = 1;

// --- HÀM CHUNG ---
function showTab(tab) {
    document.getElementById('tab-users').style.display = (tab === 'users') ? 'block' : 'none';
    document.getElementById('tab-places').style.display = (tab === 'places') ? 'block' : 'none';
}
function openModal(id) { document.getElementById(id).style.display = 'block'; }
function closeModal(id) { document.getElementById(id).style.display = 'none'; }

// ================= USER =================

function loadUsers() {
    const kw = document.getElementById('searchUser').value;
    fetch(`/SMcity/api/admin-user?page=${pageUser}&q=${kw}`)
        .then(res => res.json())
        .then(res => {
            let html = "";
            totalPageUser = res.total_pages;

            res.data.forEach(u => {
                html += `<tr>
                <td>${u.user}</td>
                <td>${u.ten}</td>
                <td style="text-align:center;">
                    <button onclick="deleteUser('${u.user}')" style="color:red;">🗑</button>
                </td>
            </tr>`;
            });
            document.getElementById('tblUsers').innerHTML = html;
            document.getElementById('pageInfoUser').innerText = `Trang ${pageUser} / ${totalPageUser}`;
        });
}

function deleteUser(username) {
    if (confirm("Xóa user: " + username + "?")) {
        fetch('/SMcity/api/admin-user', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: `action=delete&username=${username}`
        }).then(res => res.json()).then(data => {
            alert(data.message);
            loadUsers();
        });
    }
}

function addUser() {
    const u = document.getElementById('new_u').value;
    const p = document.getElementById('new_p').value;
    const n = document.getElementById('new_n').value;
    fetch('/SMcity/api/admin-user', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=add&username=${u}&password=${p}&hoten=${n}`
    }).then(res => res.json()).then(data => {
        alert(data.message);
        if(data.status==='success') { closeModal('modalAddUser'); loadUsers(); }
    });
}

function changePageUser(step) {
    let nextPage = pageUser + step;
    if (nextPage >= 1 && nextPage <= totalPageUser) {
        pageUser = nextPage;
        loadUsers();
    }
}


// ================= ĐỊA ĐIỂM =================

// Load list thành phố
fetch('/SMcity/api/danh-sach-thanh-pho').then(res=>res.json()).then(data => {
    let sel = document.getElementById('adminCitySelect');
    data.forEach(c => {
        let opt = document.createElement('option');
        opt.value = c.id; opt.text = c.ten;
        sel.add(opt);
    });
    loadPlaces();
});

function loadPlaces() {
    const idCity = document.getElementById('adminCitySelect').value;
    fetch(`/SMcity/api/admin-diadiem?page=${pagePlace}&id_city=${idCity}`)
        .then(res => res.json())
        .then(res => {
            let html = "";
            totalPagePlace = res.total_pages;

            res.data.forEach(p => {
                // Xử lý chuỗi an toàn
                let safeName = p.ten.replace(/'/g, "\\'");
                let safeAddr = p.diachi.replace(/'/g, "\\'");
                let safeDesc = "";
                if(p.mota) safeDesc = p.mota.replace(/'/g, "\\'").replace(/"/g, "&quot;");

                html += `<tr>
                <td>${p.id}</td>
                <td><b>${p.ten}</b><br><small>${p.diachi}</small></td>
                <td>${p.ten_loai}</td>
                <td style="text-align:center;">
                    <button class="btn-action" onclick="openEditModal(${p.id}, '${safeName}', '${safeAddr}', ${p.id_loai}, '${safeDesc}')">✏️</button>
                    <button class="btn-action" onclick="deletePlace(${p.id})" style="color:red;">🗑</button>
                </td>
            </tr>`;
            });
            document.getElementById('tblPlaces').innerHTML = html;
            document.getElementById('pageInfoPlace').innerText = `Trang ${pagePlace} / ${totalPagePlace}`;
        });
}

// Sửa lỗi ID null: Hàm này đảm bảo lấy đúng giá trị từ select box p_loai
function addPlace() {
    const idCity = document.getElementById('adminCitySelect').value;
    const ten = document.getElementById('p_ten').value;
    const dc = document.getElementById('p_dc').value;

    // Lấy ID loại hình (1,2,3,4,5)
    const idLoai = document.getElementById('p_loai').value;

    const mota = document.getElementById('p_mota').value;

    fetch('/SMcity/api/admin-diadiem', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        // Gửi tham số tên là "id_loai" để khớp với Servlet
        body: `action=add&id_city=${idCity}&ten=${ten}&diachi=${dc}&id_loai=${idLoai}&mota=${mota}`
    }).then(res => res.json()).then(data => {
        alert(data.message);
        if(data.status==='success') { closeModal('modalAddPlace'); loadPlaces(); }
    });
}

function openEditModal(id, ten, diachi, idLoai, mota) {
    document.getElementById('e_id').value = id;
    document.getElementById('e_ten').value = ten;
    document.getElementById('e_dc').value = diachi;
    document.getElementById('e_loai').value = idLoai;
    document.getElementById('e_mota').value = mota;
    openModal('modalEditPlace');
}

function updatePlace() {
    const id = document.getElementById('e_id').value;
    const ten = document.getElementById('e_ten').value;
    const dc = document.getElementById('e_dc').value;
    const loai = document.getElementById('e_loai').value;
    const mota = document.getElementById('e_mota').value;

    fetch('/SMcity/api/admin-diadiem', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=update&id=${id}&ten=${ten}&diachi=${dc}&id_loai=${loai}&mota=${mota}`
    }).then(res => res.json()).then(data => {
        alert(data.message);
        if(data.status==='success') { closeModal('modalEditPlace'); loadPlaces(); }
    });
}

function deletePlace(id) {
    if(confirm("Xóa địa điểm này?")) {
        fetch('/SMcity/api/admin-diadiem', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: `action=delete&id=${id}`
        }).then(res => res.json()).then(data => { alert(data.message); loadPlaces(); });
    }
}

function changePagePlace(step) {
    let nextPage = pagePlace + step;
    if (nextPage >= 1 && nextPage <= totalPagePlace) {
        pagePlace = nextPage;
        loadPlaces();
    }
}

// Chạy mặc định khi tải trang
loadUsers();