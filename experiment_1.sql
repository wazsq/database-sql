-- 创建用户民为user_name 密码为passwd的用户
create user user_name identified by "passwd";

-- 设置权限
grant "DBA" to user_name;
grant "CONNECT" to user_name;
alter user  user_name default role "DBA", "CONNECT";

--建表

-- 图书类别表
create table book_class(
	class_no number primary key,
	class_name varchar(20) not null
);

comment on table book_class is "图书分类表";
comment on column book_class.class_no is "图书类别编号";
comment on column book_class.class_name is "图书类别名称";

-- 书目表
create table bibliography(
	ISBN varchar(20) primary key,
	book_name varchar(50) primary key,
	book_author varchar(20),
	book_publish_unit varchar(50),
	book_price BINARY_DOUBLE not null,
	class_no number,
	foreign key(class_no) references book_class(class_no)
);
comment on table bibliography is "书目表";
comment on column bibliography.ISBN is "ISBN";
comment on column bibliography.book_name is "书名";
comment on column bibliography.book_author is "作者";
comment on column bibliography.book_publish_unit is "出版社";
comment on column bibliography.book_price is "单价";
comment on column bibliography.class_no is "图书类别号";

-- 图书表
create table book_item(
	book_item_no varchar(10) primary key,
	ISBN varchar(20),
	is_lend char(2),
	memo varchar(255),
	foreign key(ISBN) references bibliography(ISBN)
);
comment on table book_item is "图书表";
comment on column book_item.book_item_no is "图书编号";
comment on column book_item.ISBN is "ISBN";
comment on column book_item.is_lend is "是否借出";
comment on column book_item.memo is "备注";

-- 读者表
create table readere(
	lend_card_no varchar(20) primary key,
	name varchar(20) not null,
	unit varchar(20) not null,
	sex char(2) not null,
	adress varchar(50) not null,
	phone_no char(11) not null,
	idcard_no char(18) not null,
);
comment on table readere is "读者表";
comment on column readere.lend_card_no is "借阅证编号";
comment on column readere.name is "姓名";
comment on column readere.unit is "单位";
comment on column readere.sex is "性别";
comment on column readere.adress is "地址";
comment on column readere.phone_no is "联系电话";
comment on column readere.phone_no is "idcard_no身份证编号";

-- 借阅表
create table borrow_item(
	borrow_item_no varchar(10) primary key,
	lend_card_no varchar(20)，
	book_item_no varchar(10),
	lend_at date not null,
	return_at date not null,
	fine_class_no varchar(20) ,
	memo varchar(255)
);
