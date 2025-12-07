// Kiểm tra quyền
const role = localStorage.getItem("currentRole");
if (role != 1) {
    alert("Không phận sự miễn vào!");
    window.location.href = "chonThanhPho.html";
}

// Biến toàn cục
let pageUser = 1;
let pagePlace = 1;
let totalPageUser = 1;
let totalPagePlace = 1;

// Biến lưu dòng đang chọn
let selectedUser = null;
let selectedPlaceId = null;

// --- HÀM CHUNG ---
function showTab(tab) {
    document.getElementById('tab-users').style.display = (tab === 'users') ? 'block' : 'none';
    document.getElementById('tab-places').style.display = (tab === 'places') ? 'block' : 'none';
}
function openModal(id) { document.getElementById(id).style.display = 'block'; }
function closeModal(id) { document.getElementById(id).style.display = 'none'; }

// ================= USER =================

// 1. Tải danh sách
function loadUsers() {
    const kw = document.getElementById('searchUser').value;
    fetch(`/SMcity/api/admin-user?page=${pageUser}&q=${kw}`)
        .then(res => res.json())
        .then(res => {
            let html = "";
            totalPageUser = res.total_pages; // Lưu tổng số trang để check nút Next

            res.data.forEach(u => {
                // Thêm sự kiện onclick để chọn dòng
                html += `<tr onclick="selectRowUser(this, '${u.user}')">
                <td>${u.user}</td>
                <td>${u.ten}</td>
            </tr>`;
            });
            document.getElementById('tblUsers').innerHTML = html;
            document.getElementById('pageInfoUser').innerText = `Trang ${pageUser} / ${totalPageUser}`;

            // Reset lựa chọn
            selectedUser = null;
            document.getElementById('lblSelectedUser').innerText = "(Chưa chọn dòng nào)";
        });
}

// 2. Chọn dòng (Tô màu)
function selectRowUser(row, username) {
    // Xóa màu cũ
    let rows = document.getElementById('tblUsers').getElementsByTagName('tr');
    for(let i=0; i<rows.length; i++) rows[i].classList.remove('selected-row');

    // Tô màu mới
    row.classList.add('selected-row');
    selectedUser = username;
    document.getElementById('lblSelectedUser').innerText = "Đang chọn: " + username;
}

// 3. Xử lý nút [-] Xóa
function confirmDeleteUser() {
    if (!selectedUser) {
        alert("Vui lòng chọn một dòng để xóa!");
        return;
    }
    if (confirm("Bạn chắc chắn muốn xóa user: " + selectedUser + " không?")) {
        fetch('/SMcity/api/admin-user', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: `action=delete&username=${selectedUser}`
        }).then(res => res.json()).then(data => {
            alert(data.message);
            loadUsers(); // Tải lại bảng
        });
    }
}

// 4. Xử lý nút [+] Thêm
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

// 5. Chuyển trang User (Sửa lỗi cũ)
function changePageUser(step) {
    let nextPage = pageUser + step;
    if (nextPage >= 1 && nextPage <= totalPageUser) {
        pageUser = nextPage;
        loadUsers();
    }
}


// ================= ĐỊA ĐIỂM =================

// Load list thành phố vào dropdown
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
                html += `<tr onclick="selectRowPlace(this, ${p.id}, '${p.ten}')">
                <td>${p.id}</td>
                <td>${p.ten}</td>
                <td>${p.loai}</td>
            </tr>`;
            });
            document.getElementById('tblPlaces').innerHTML = html;
            document.getElementById('pageInfoPlace').innerText = `Trang ${pagePlace} / ${totalPagePlace}`;

            selectedPlaceId = null;
            document.getElementById('lblSelectedPlace').innerText = "(Chưa chọn dòng nào)";
        });
}

function selectRowPlace(row, id, name) {
    let rows = document.getElementById('tblPlaces').getElementsByTagName('tr');
    for(let i=0; i<rows.length; i++) rows[i].classList.remove('selected-row');

    row.classList.add('selected-row');
    selectedPlaceId = id;
    document.getElementById('lblSelectedPlace').innerText = "Đang chọn: " + name;
}

function confirmDeletePlace() {
    if (!selectedPlaceId) {
        alert("Vui lòng chọn địa điểm để xóa!");
        return;
    }
    if (confirm("Xóa địa điểm này sẽ mất hết đánh giá. Tiếp tục?")) {
        fetch('/SMcity/api/admin-diadiem', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: `action=delete&id=${selectedPlaceId}`
        }).then(res => res.json()).then(data => { alert(data.message); loadPlaces(); });
    }
}

function addPlace() {
    const idCity = document.getElementById('adminCitySelect').value;
    const ten = document.getElementById('p_ten').value;
    const dc = document.getElementById('p_dc').value;
    const loai = document.getElementById('p_loai').value;
    const mota = document.getElementById('p_mota').value;

    fetch('/SMcity/api/admin-diadiem', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=add&id_city=${idCity}&ten=${ten}&diachi=${dc}&loai=${loai}&mota=${mota}`
    }).then(res => res.json()).then(data => {
        alert(data.message);
        if(data.status==='success') { closeModal('modalAddPlace'); loadPlaces(); }
    });
}

function changePagePlace(step) {
    let nextPage = pagePlace + step;
    if (nextPage >= 1 && nextPage <= totalPagePlace) {
        pagePlace = nextPage;
        loadPlaces();
    }
}

// Chạy mặc định
loadUsers();