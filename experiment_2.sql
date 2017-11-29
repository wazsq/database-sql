
--  查询“红楼梦”目前可借的各图书编号，及所属版本信息。（是否借出为‘否‘的图书）
select * from bibliography,book_item 
	where 
		bibliography.book_name = '红楼梦' and
		bibliography.ISBN = book_item.ISBN and
		book_item.is_lend = '否';

-- 查找高等教育出版社的所有书目及单价，结果按单价降序排序
select * from bibliography where book_publish_unit = '高等教育出版社' order by book_price desc;

-- 、统计“红楼梦”各版的藏书数量（ISBN不同则版本不同）。
select count(ISBN),ISBN from bibliography where  book_name = '红楼梦' group by ISBN;

-- 查询学号“20061234”号借书证借阅未还的图书的信息
select book_item.book_item_no,bibliography.* from borrow_item,book_item ,bibliography
	where
		borrow_item.lend_card_no = '20061234' and
		book_item.book_item_no = borrow_item.book_item_no and
		book_item.is_lend = '否'and
		book_item.ISBN = bibliography.ISBN;

-- 查询各个出版社的图书最高单价、平均单价。
select book_publish_unit,max(book_price) max_price, avg(book_price) avg_price from bibliography group by book_publish_unit;

-- 要查询借阅了两本和两本以上图书的读者的个人信息
select * from reader 
	where lend_card_no in (
		select borrow_item.lend_card_no from borrow_item
			group by borrow_item.lend_card_no
    		having count(*) >= 2
		);

-- 查询“王菲”的单位、所借图书的书名和借阅日期。
select reader.name,reader.unit, bibliography.book_name, borrow_item.lend_at from reader, borrow_item,book_item, bibliography
	where 
		reader.name = '王菲' and
		borrow_item.lend_card_no = reader.lend_card_no and
		book_item.book_item_no = borrow_item.book_item_no and
		bibliography.ISBN = book_item.ISBN;

-- 查询每类图书的册数和平均单价。
select class_no,count(*), avg(book_price) from bibliography
	group by class_no;

-- 统计从未借书的读者人数
select count(*) from reader 
	where	
		lend_card_no not in (
			select distinct lend_card_no from borrow_item
			);

-- 统计参与借书的人数。
select count(distinct lend_card_no)  from borrow_item;

-- 找出所有借书未还的读者的信息及所借图书编号及名称。
select bibliography.book_name,reader.*,book_item.book_item_no from book_item,borrow_item,reader,bibliography
	where 
		book_item.is_lend = '否' and
		bibliography.ISBN = book_item.ISBN and
		book_item.book_item_no = borrow_item.book_item_no and
		reader.lend_card_no = borrow_item.lend_card_no;

-- 检索书名是以“Internet”开头的所有图书的书名和作者。
select book_name,book_author from  bibliography
	where book_name like 'Internet%';

-- 查询各图书的罚款总数。
select count(borrow_item.fine_class_no) from borrow_item,book_item
	where book_item.book_item_no = borrow_item.book_item_no
	order by book_item.book_item_no;

-- 查询借阅及罚款分类信息，如果有罚款则显示借阅信息及罚款名称、罚金，如果没有罚款则罚款名称、罚金显示空（左外连接）
select borrow_item.*,fine.fine_class_no, fine.fine_name, fine.penalty  from borrow_item
	left outer join fine
	on borrow_item.fine_class_no = borrow_item.fine_class_no;

-- 查询借阅了所有“文学”类书目的读者的姓名、单位。
select name,unit from reader
	where not exists
	(
		select * from bibliography where bibliography.class_no in
		(
			select class_no from book_class where class_name = '文学'
		)
		and not exists
		(
			select * from borrow_item where borrow_item.lend_card_no = reader.lend_card_no
				and bibliography.ISBN = 
				(
					select book_item.ISBN from book_item 
						where book_item.book_item_no = borrow_item.book_item_no
				)
		)
	);


-- 扩展
-- 在书目关系中新增“出版年份”，并在该属性下添加数据。（使用SQL完成）
alter table bibliography add (publish_year date);
update bibliography set publish_year = to_date('2005','yyyy') where ISBN='7040195836'; 