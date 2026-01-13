const role = localStorage.getItem("currentRole");
if (role != 1) {
    alert("Không phận sự miễn vào!");
    window.location.href = "chonThanhPho.html";
}

let pageUser = 1, pagePlace = 1;
let totalPageUser = 1, totalPagePlace = 1;

function showTab(tab) {
    document.getElementById('tab-users').style.display = (tab === 'users') ? 'block' : 'none';
    document.getElementById('tab-places').style.display = (tab === 'places') ? 'block' : 'none';
}
function openModal(id) { document.getElementById(id).style.display = 'block'; }
function closeModal(id) { document.getElementById(id).style.display = 'none'; }

// ================= QUẢN LÝ USER (ĐÃ KHÔI PHỤC) =================
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
                        <button onclick="deleteUser('${u.user}')" style="color:red; border:1px solid red; background:white;">🗑 Xóa</button>
                    </td>
                </tr>`;
            });
            document.getElementById('tblUsers').innerHTML = html;
            document.getElementById('pageInfoUser').innerText = `Trang ${pageUser} / ${totalPageUser}`;
        });
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

function changePageUser(step) {
    let nextPage = pageUser + step;
    if (nextPage >= 1 && nextPage <= totalPageUser) {
        pageUser = nextPage;
        loadUsers();
    }
}

// ================= QUẢN LÝ ĐỊA ĐIỂM =================

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
                let encodedDesc = encodeURIComponent(p.mota);
                let safeName = p.ten.replace(/'/g, "\\'");
                let safeAddr = p.diachi.replace(/'/g, "\\'");
                let safeMap = p.map ? p.map.replace(/'/g, "\\'") : "";

                // --- FIX LỖI ẢNH TABLE: Chỉ lấy ảnh đầu tiên ---
                let firstImg = 'default_place.jpg';
                if (p.anh && p.anh.trim() !== "") {
                    let imgs = p.anh.trim().split(/\s+/);
                    if (imgs.length > 0) firstImg = imgs[0];
                }

                html += `<tr>
                <td>${p.id}</td>
                <td>
                    <img src="../images/${firstImg}" style="width:50px; height:35px; object-fit:cover; float:left; margin-right:8px; border-radius:4px; border:1px solid #ccc;">
                    <b>${p.ten}</b>
                </td>
                <td>${p.ten_loai}</td>
                <td style="text-align:center;">
                    <button class="btn-action" onclick="openEditModal(${p.id}, '${safeName}', '${safeAddr}', ${p.id_loai}, '${encodedDesc}', '${p.anh}', '${safeMap}')">✏️</button>
                    <button class="btn-action" onclick="deletePlace(${p.id})" style="color:red;">🗑</button>
                </td>
            </tr>`;
            });
            document.getElementById('tblPlaces').innerHTML = html;
            document.getElementById('pageInfoPlace').innerText = `Trang ${pagePlace} / ${totalPagePlace}`;
        });
}

// --- HÀM XỬ LÝ FILE (CHỌN NHIỀU ẢNH) ---
// prefix: 'p' (Add) hoặc 'e' (Edit)
function handleFileSelect(prefix) {
    const fileInput = document.getElementById(prefix + '_fileInput');
    const nameInput = document.getElementById(prefix + '_anh');
    const previewDiv = document.getElementById(prefix + '_preview_container');

    if (fileInput.files && fileInput.files.length > 0) {
        let fileNames = [];
        previewDiv.innerHTML = ""; // Xóa preview cũ

        Array.from(fileInput.files).forEach(file => {
            fileNames.push(file.name); // Lấy tên file

            // Tạo ảnh xem trước từ Blob (ko cần server)
            let img = document.createElement("img");
            img.src = URL.createObjectURL(file);
            img.style.height = "60px";
            img.style.width = "auto";
            img.style.border = "1px solid #ddd";
            img.style.borderRadius = "4px";
            previewDiv.appendChild(img);
        });

        // Nối tên file bằng dấu cách và điền vào input
        nameInput.value = fileNames.join(" ");
    }
}

function clearImages(prefix) {
    document.getElementById(prefix + '_fileInput').value = "";
    document.getElementById(prefix + '_anh').value = "";
    document.getElementById(prefix + '_preview_container').innerHTML = "<span style='color:#999; font-size:12px; margin: auto;'>Đã xóa ảnh</span>";
}

// --- OPEN EDIT MODAL ---
function openEditModal(id, ten, diachi, idLoai, encodedDesc, anh, map) {
    document.getElementById('e_id').value = id;
    document.getElementById('e_ten').value = ten;
    document.getElementById('e_dc').value = diachi;
    document.getElementById('e_loai').value = idLoai;
    document.getElementById('e_mota').value = decodeURIComponent(encodedDesc);
    document.getElementById('e_anh').value = anh;
    document.getElementById('e_map').value = map;

    // Xem trước ảnh cũ (Load từ Server)
    const previewDiv = document.getElementById('e_preview_container');
    previewDiv.innerHTML = "";
    if(anh && anh.trim() !== "") {
        let imgs = anh.trim().split(/\s+/);
        imgs.forEach(imgName => {
            let img = document.createElement("img");
            img.src = "../images/" + imgName;
            img.style.height = "60px";
            img.style.border = "1px solid #ddd";
            img.style.borderRadius = "4px";
            img.onerror = function() { this.src = '../images/default_place.jpg'; };
            previewDiv.appendChild(img);
        });
    } else {
        previewDiv.innerHTML = "<span style='color:#999; font-size:12px; margin: auto;'>Chưa có ảnh</span>";
    }

    openModal('modalEditPlace');
}

function addPlace() {
    const idCity = document.getElementById('adminCitySelect').value;
    const ten = document.getElementById('p_ten').value;
    const dc = document.getElementById('p_dc').value;
    const idLoai = document.getElementById('p_loai').value;
    const mota = document.getElementById('p_mota').value;
    const anh = document.getElementById('p_anh').value;
    const map = document.getElementById('p_map').value;

    fetch('/SMcity/api/admin-diadiem', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=add&id_city=${idCity}&ten=${ten}&diachi=${dc}&id_loai=${idLoai}&mota=${mota}&anh=${anh}&map=${map}`
    }).then(res => res.json()).then(data => {
        alert(data.message);
        if(data.status==='success') { closeModal('modalAddPlace'); loadPlaces(); }
    });
}

function updatePlace() {
    const id = document.getElementById('e_id').value;
    const ten = document.getElementById('e_ten').value;
    const dc = document.getElementById('e_dc').value;
    const loai = document.getElementById('e_loai').value;
    const mota = document.getElementById('e_mota').value;
    const anh = document.getElementById('e_anh').value;
    const map = document.getElementById('e_map').value;

    fetch('/SMcity/api/admin-diadiem', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=update&id=${id}&ten=${ten}&diachi=${dc}&id_loai=${loai}&mota=${mota}&anh=${anh}&map=${map}`
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

// Mặc định load Users khi vào trang
loadUsers();