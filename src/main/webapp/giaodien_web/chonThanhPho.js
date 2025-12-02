// 1. Hàm tự động chạy khi trang web tải xong
window.onload = function() {
    fetch('/SMcity/api/danh-sach-thanh-pho')
        .then(response => response.json())
        .then(data => {
            let selectBox = document.getElementById('citySelect');
            selectBox.innerHTML = ""; // Xóa dòng 'Đang tải...'

            // Duyệt qua danh sách và tạo thẻ <option>
            data.forEach(city => {
                let option = document.createElement("option");
                option.value = city.id; // Giá trị ngầm (ID)
                option.text = city.ten; // Giá trị hiển thị (Tên)
                selectBox.add(option);
            });
        })
        .catch(err => {
            console.log(err);
            alert("Không tải được danh sách thành phố!");
        });
};

// 2. Xử lý nút "Đi đến"
document.getElementById('btnGo').addEventListener('click', function() {
    let selectBox = document.getElementById('citySelect');
    let idThanhPho = selectBox.value; // Lấy ID (value) chứ không lấy tên nữa

    if(idThanhPho) {
        // Chuyển hướng sang trang chi tiết kèm theo ID
        window.location.href = "thanhpho.html?id=" + idThanhPho;
    } else {
        alert("Vui lòng chọn một thành phố!");
    }
});