
--  查询“红楼梦”目前可借的各图书编号，及所属版本信息。（是否借出为‘否‘的图书）
select * from bibliography,book_item 
	where 
		bibliography.book_name = '红楼梦' and
		bibliography.ISBN = book_item.ISBN and
		book_item.is_lend = '否';

-- 查找高等教育出版社的所有书目及单价，结果按单价降序排序
select * from bibliography where book_publish_unit = '高等教育出版社' order by book_price desc;

-- 、统计“红楼梦”各版的藏书数量（ISBN不同则版本不同）。
select count(ISBN),* from bibliography where  book_name = '红楼梦' group by ISBN;
