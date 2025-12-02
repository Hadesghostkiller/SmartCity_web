create table LoaiHinh
(
    id            int auto_increment
        primary key,
    ten_loai_hinh varchar(50) not null
);

create table NguoiDung
(
    id       int auto_increment
        primary key,
    username varchar(50)   not null,
    password varchar(100)  null,
    ho_ten   varchar(100)  null,
    role     int default 0 null,
    constraint unique_username
        unique (username),
    constraint username
        unique (username)
);

create table ThanhPho
(
    id            int auto_increment
        primary key,
    ten_thanh_pho varchar(100) not null,
    mo_ta         text         null
);

create table Danhgia_city
(
    id        int auto_increment
        primary key,
    username  varchar(50)   not null,
    id_city   int           not null,
    rate_city int default 5 null,
    constraint Danhgia_city_ibfk_1
        foreign key (username) references NguoiDung (username)
            on delete cascade,
    constraint Danhgia_city_ibfk_2
        foreign key (id_city) references ThanhPho (id)
            on delete cascade
);

create index id_city
    on Danhgia_city (id_city);

create index username
    on Danhgia_city (username);

create table DiaDiem
(
    id           int auto_increment
        primary key,
    ten_dia_diem varchar(255) not null,
    dia_chi      text         null,
    id_city      int          not null,
    id_loai_hinh int          not null,
    loai_hinh    varchar(50)  null,
    mo_ta        text         null,
    constraint DiaDiem_ibfk_1
        foreign key (id_city) references ThanhPho (id)
            on delete cascade,
    constraint DiaDiem_ibfk_2
        foreign key (id_loai_hinh) references LoaiHinh (id)
            on delete cascade
);

create table Danhgia_diadiem
(
    id            int auto_increment
        primary key,
    username      varchar(50)                         not null,
    id_dia_diem   int                                 not null,
    rate_point    int                                 not null,
    comment       text                                null,
    ngay_danh_gia timestamp default CURRENT_TIMESTAMP null,
    constraint Danhgia_diadiem_ibfk_1
        foreign key (username) references NguoiDung (username)
            on delete cascade,
    constraint Danhgia_diadiem_ibfk_2
        foreign key (id_dia_diem) references DiaDiem (id)
            on delete cascade
);

create index id_dia_diem
    on Danhgia_diadiem (id_dia_diem);

create index username
    on Danhgia_diadiem (username);

create index id_city
    on DiaDiem (id_city);

create index id_loai_hinh
    on DiaDiem (id_loai_hinh);

