const urlParams = new URLSearchParams(window.location.search);
const currentId = urlParams.get('id');
const currentFullName = localStorage.getItem("currentFullName");
const currentUser = localStorage.getItem("currentUser");

if(currentUser && currentFullName) {
    document.getElementById('userHello').innerText = "Xin chào, " + currentFullName;
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

window.onload = function() {
    if (!currentId) {
        alert("Chưa chọn thành phố!");
        window.location.href = "chonThanhPho.html";
        return;
    }

    // A. Load Select Box
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

    // B. Load Chi Tiết & MAP
    fetch('/SMcity/api/chi-tiet-thanh-pho?id=' + currentId)
        .then(res => res.json())
        .then(data => {
            if (data.status === "success") {
                document.getElementById('tenTP').innerText = data.ten;
                document.getElementById('moTaTP').innerText = data.mota;
                document.getElementById('soSao').innerText = data.sao;
                document.getElementById('bannerBg').style.backgroundImage = `url('../images/${data.banner}')`;

                if(data.map_link && data.map_link !== "") {
                    document.getElementById('cityMapBox').style.display = "block";
                    document.getElementById('cityMapFrame').src = data.map_link;
                }
            } else {
                alert("Lỗi tải dữ liệu: " + data.message);
            }
        });

    // C. Load Các Section (Carousel)
    createSection('section-hot', 'list-hot', 0, 'hot', '🔥', 'Khám phá địa điểm HOT ngay nào');
    createSection('section-1', 'list-type-1', 1, 'new', '🍜', 'Ăn uống ngon - bổ - rẻ');
    createSection('section-2', 'list-type-2', 2, 'new', '🏨', 'Nơi dừng chân nghỉ ngơi');
    createSection('section-3', 'list-type-3', 3, 'new', '🎡', 'Thỏa thích quậy tưng bừng');
    createSection('section-4', 'list-type-4', 4, 'new', '📸', 'Chiêm ngưỡng cảnh đẹp');
    createSection('section-5', 'list-type-5', 5, 'new', '🛍️', 'Cửa hàng mua sắm');
};

// Hàm tạo HTML Section + Carousel
function createSection(wrapperId, listId, typeId, sortMode, icon, title) {
    const wrapper = document.getElementById(wrapperId);
    if (!wrapper) return;

    wrapper.innerHTML = `
        <div class="section-header">
            <div style="display:flex; align-items:center;">
                <span class="section-icon">${icon}</span>
                <h3 class="section-title-text">${title}</h3>
            </div>
            <button class="btn-expand-view" onclick="toggleView('${listId}', this)">
                Xem tất cả <i class="fas fa-chevron-down"></i>
            </button>
        </div>
        <div class="carousel-wrapper">
            <div class="scroll-btn left" onclick="scrollCarousel('${listId}', -300)">❮</div>
            <div class="carousel-container" id="${listId}">
                <p>Đang tải...</p>
            </div>
            <div class="scroll-btn right" onclick="scrollCarousel('${listId}', 300)">❯</div>
        </div>
    `;

    fetch(`/SMcity/api/lay-dia-diem?id_city=${currentId}&type=${typeId}&sort=${sortMode}&user=${currentUser}`)
        .then(res => res.json())
        .then(result => {
            const container = document.getElementById(listId);
            container.innerHTML = "";
            if (result.data.length === 0) {
                container.innerHTML = "<p style='color:#999; margin-left:10px;'>Chưa có địa điểm.</p>";
                return;
            }
            result.data.forEach(item => {
                let shortAddr = item.diachi.split(',').slice(0, 2).join(', ');
                let heartHtml = item.is_fav ? `<div class="card-heart"><i class="fas fa-heart"></i></div>` : '';

                // --- XỬ LÝ HIỂN THỊ ĐÁNH GIÁ ---
                let ratingHtml = '';
                if (item.luot_dg === 0) {
                    ratingHtml = `<span style="font-size: 13px; color: #999; font-style: italic;">Chưa có đánh giá</span>`;
                } else {
                    ratingHtml = `
                        <span class="rating-star-icon">★</span>
                        <span style="font-weight:bold;">${item.sao}</span>
                        <span style="margin-left:5px; color:#999;">(${item.luot_dg})</span>
                    `;
                }

                let html = `
                <a href="DiaDiem.html?id=${item.id}" class="place-card">
                    <div class="card-img-container">
                        <img src="../images/${item.anh}" class="card-img" onerror="this.src='../images/default_place.jpg'">
                        ${heartHtml}
                    </div>
                    <div class="card-body">
                        <h4 class="card-title" title="${item.ten}">${item.ten}</h4>
                        <div class="card-rating">
                            ${ratingHtml}
                        </div>
                        <div class="card-address"><i class="fas fa-map-marker-alt"></i> ${shortAddr}</div>
                    </div>
                </a>`;
                container.innerHTML += html;
            });
        });
}

function scrollCarousel(id, amount) {
    document.getElementById(id).scrollBy({ left: amount, behavior: 'smooth' });
}

function toggleView(id, btn) {
    const container = document.getElementById(id);
    const wrapper = container.parentElement;
    container.classList.toggle('expanded');
    if (container.classList.contains('expanded')) {
        btn.innerHTML = `Thu gọn <i class="fas fa-chevron-up"></i>`;
        wrapper.querySelector('.scroll-btn.left').style.display = 'none';
        wrapper.querySelector('.scroll-btn.right').style.display = 'none';
    } else {
        btn.innerHTML = `Xem tất cả <i class="fas fa-chevron-down"></i>`;
        wrapper.querySelector('.scroll-btn.left').style.display = 'flex';
        wrapper.querySelector('.scroll-btn.right').style.display = 'flex';
    }
}

document.getElementById('btnSwitch').addEventListener('click', function() {
    let newId = document.getElementById('citySelect').value;
    if (newId) window.location.href = "thanhpho.html?id=" + newId;
});

function submitRating() {
    if (!currentUser) {
        alert("Vui lòng đăng nhập lại!"); window.location.href = "login.html"; return;
    }
    const checkedStar = document.querySelector('input[name="rate"]:checked');
    if (!checkedStar) { alert("Bạn chưa chọn số sao!"); return; }

    fetch('/SMcity/api/them-danh-gia', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'username=' + currentUser + '&id_city=' + currentId + '&rate=' + checkedStar.value
    }).then(res => res.json()).then(data => {
        if(data.status == "success") { alert(data.message); location.reload(); }
        else { alert("Thông báo: " + data.message); }
    });
}