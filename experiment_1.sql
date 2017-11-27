-- 创建用户民为user_name 密码为passwd的用户
create user S5120155133 identified by "passwd";

-- 设置权限
grant "DBA" to S5120155133;
grant "CONNECT" to S5120155133;
alter user  S5120155133 default role "DBA", "CONNECT";

-- 删除各表（顺序不能乱，建表倒序）
-- drop table reserve ;
-- drop table borrow_item;
-- drop table fine;
-- drop table reader;
-- drop table book_item;
-- drop table bibliography;
-- drop table book_class;

--建数据表
-- 图书类别表
create table book_class(
	class_no varchar(20) primary key,
	class_name varchar(20)
);

comment on table book_class is '图书分类表';
comment on column book_class.class_no is '图书类别编号';
comment on column book_class.class_name is '图书类别名称';

-- 书目表
create table bibliography(
	ISBN varchar(20) primary key,
	book_name varchar(50),
	book_author varchar(20),
	book_publish_unit varchar(50),
	book_price BINARY_DOUBLE,
	class_no varchar(20),
	foreign key(class_no) references book_class(class_no)
);
comment on table bibliography is '书目表';
comment on column bibliography.ISBN is 'ISBN';
comment on column bibliography.book_name is '书名';
comment on column bibliography.book_author is '作者';
comment on column bibliography.book_publish_unit is '出版社';
comment on column bibliography.book_price is '单价';
comment on column bibliography.class_no is '图书类别号';

-- 图书表
create table book_item(
	book_item_no varchar(10) primary key,
	ISBN varchar(20),
	is_lend char(2),
	memo varchar(255),
	foreign key(ISBN) references bibliography(ISBN)
);
comment on table book_item is '图书表';
comment on column book_item.book_item_no is '图书编号';
comment on column book_item.ISBN is 'ISBN';
comment on column book_item.is_lend is '是否借出';
comment on column book_item.memo is '备注';

-- 读者表
create table reader(
	lend_card_no varchar(20) primary key,
	name varchar(20),
	unit varchar(50),
	sex char(2),
	adress varchar(50),
	phone_no char(11),
	id_card char(18) unique
);
comment on table reader is '读者表';
comment on column reader.lend_card_no is '借阅证编号';
comment on column reader.name is '姓名';
comment on column reader.unit is '单位';
comment on column reader.sex is '性别';
comment on column reader.adress is '地址';
comment on column reader.phone_no is '联系电话';
comment on column reader.id_card is '身份证编号';

-- 罚款分类表
create table fine(
	fine_class_no varchar(20) primary key,
	fine_name varchar(20),
	penalty BINARY_DOUBLE
);
comment on table fine is '罚款分类表';
comment on column fine.fine_class_no is '罚款分类号';
comment on column fine.fine_name is '罚款名称';
comment on column fine.penalty is '罚金';

-- 借阅表
create table borrow_item(
	borrow_item_no number primary key,
	lend_card_no varchar(20),
	book_item_no varchar(10),
	lend_at date not null,
	return_at date,
	fine_class_no varchar(20) ,
	memo varchar(255),
	foreign key(lend_card_no) references reader(lend_card_no),
	foreign key(book_item_no) references book_item(book_item_no),
	foreign key(fine_class_no) references fine(fine_class_no)
);
comment on table borrow_item is '借阅表';
comment on column borrow_item.borrow_item_no is '借阅流水号';
comment on column borrow_item.lend_card_no is '借书证号';
comment on column borrow_item.book_item_no is '图书编号';
comment on column borrow_item.lend_at is '借书时间';
comment on column borrow_item.return_at is '归还时间';
comment on column borrow_item.fine_class_no is '罚款分类号';
comment on column borrow_item.memo is '备注';

-- 预约表
create table reserve(
	reserve_no varchar(20) primary key,
	lend_card_no varchar(20),
	ISBN varchar(20),
	reserve_at date,
	foreign key(lend_card_no) references reader(lend_card_no),
	foreign key(ISBN) references bibliography(ISBN)
);
comment on table reserve is '预约表';
comment on column reserve.reserve_no is '预约流水号';
comment on column reserve.lend_card_no is '借书证号';
comment on column reserve.ISBN is 'ISBN';
comment on column reserve.reserve_at is '预约时间';



--修改当前会话的系统时间 
select sysdate from dual;
alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';
select sysdate from dual;

-- sysdba登录后
-- update props$ set value$ = 'YYYY-MM-DD HH24:MI:SS' where name = 'NLS_DATE_FORMAT';

-- 增加约束
alter table reader add constraint check_reader_sex check (sex in ('男','女'));
alter table reader add constraint check_reader_phone check (regexp_like(phone_no,'1[34578][0-9]{9}'));
alter table reader 
	add constraint check_reader_id_card 
	check (regexp_like(id_card,'[0-9]{17}[x,X,0-9]'));

alter table book_item add constraint check_book_item_is_lend check(is_lend in ('是','否'));

-- 插入数据
insert into book_class(class_no,class_name) values('100','文学');
insert into book_class(class_no,class_name) values('200','科技');
insert into book_class(class_no,class_name) values('300','哲学');

insert into bibliography(ISBN, book_name, book_author, book_publish_unit, book_price, class_no)
	values('7040195836', '数据库系统概论','王珊','高等教育出版社',39.00,'200');
insert into bibliography(ISBN, book_name, book_author, book_publish_unit, book_price, class_no)
	values('9787508040110', '红楼梦','曹雪芹','人民出版社',20.00,'100');
insert into bibliography(ISBN, book_name, book_author, book_publish_unit, book_price, class_no)
	values('9787506336239', '红楼梦','曹雪芹','作家出版社',34.30,'100');
insert into bibliography(ISBN, book_name, book_author, book_publish_unit, book_price, class_no)
	values('9787010073750', '心学之路','张立文','人民出版社',33.80,'300');

insert into book_item(book_item_no,ISBN,is_lend,memo) values('2001231','7040195836','否','');
insert into book_item(book_item_no,ISBN,is_lend,memo) values('2001232','7040195836','是','');
insert into book_item(book_item_no,ISBN,is_lend,memo) values('1005050','9787506336239','否','');
insert into book_item(book_item_no,ISBN,is_lend,memo) values('1005063','9787508040110','是','');
insert into book_item(book_item_no,ISBN,is_lend,memo) values('3007071','9787010073750','是','');

insert into reader(lend_card_no, name, unit, sex, adress, phone_no, id_card) values('20051001','王菲','四川绵阳西科大计算机学院','女','','18281111111','53030219990711094X');
insert into reader(lend_card_no, name, unit, sex, adress, phone_no, id_card) values('20062001','张江','四川绵阳中心医院','男','','18281111111','53030219990711095X');
insert into reader(lend_card_no, name, unit, sex, adress, phone_no, id_card) values('20061234','郭敬明','四川江油305','男','','18281111111','53030219990711093X');
insert into reader(lend_card_no, name, unit, sex, adress, phone_no, id_card) values('20071235','李晓明','四川成都工商银行','男','','18281111111','53030219990712095X');
insert into reader(lend_card_no, name, unit, sex, adress, phone_no, id_card) values('20081237','赵鑫','四川广元广元中学','女','','18281111111','53030219990701095X');

insert into fine(fine_class_no, fine_name, penalty) values('1','延期',10);
insert into fine(fine_class_no, fine_name, penalty) values('2','损坏',20);
insert into fine(fine_class_no, fine_name, penalty) values('3','丢失',50);


insert into borrow_item(borrow_item_no, lend_card_no, book_item_no, lend_at, return_at, fine_class_no, memo) 
	values(1,'20081237','3007071',to_date('2010/09/19','yyyy/mm/dd'),to_date('2010/09/20','yyyy/mm/dd'),'','');
insert into borrow_item(borrow_item_no, lend_card_no, book_item_no, lend_at, return_at, fine_class_no, memo) 
	values(2,'20071235','1005063',to_date('2010/10/20','yyyy/mm/dd'),to_date('2011/02/20','yyyy/mm/dd'),'1','');
insert into borrow_item(borrow_item_no, lend_card_no, book_item_no, lend_at, return_at, fine_class_no, memo) 
	values(3,'20071235','2001232',to_date('2011/09/01','yyyy/mm/dd'),to_date('','yyyy/mm/dd'),'','');
insert into borrow_item(borrow_item_no, lend_card_no, book_item_no, lend_at, return_at, fine_class_no, memo) 
	values(4,'20061234','1005063',to_date('2011/9/20','yyyy/mm/dd'),to_date('','yyyy/mm/dd'),'','');
insert into borrow_item(borrow_item_no, lend_card_no, book_item_no, lend_at, return_at, fine_class_no, memo) 
	values(5,'20051001','3007071',to_date('2011/9/10','yyyy/mm/dd'),to_date('','yyyy/mm/dd'),'','');

insert into reserve(reserve_no,lend_card_no, ISBN,reserve_at)
	values('1','20081237','9787508040110',to_date('2011/09/11','yyyy/mm/dd'));
