-- 建立存储过程完成图书管理系统中的借书功能，并调用该存储过程实现借书功能。
create or replace procedure p_lend_book
	(p_borrow_item_no in varchar, p_lend_card_no in varchar,p_book_item_no in varchar)
	as
		v_isLend book_item.is_lend%type;
	begin
		select is_lend into v_isLend from book_item where book_item_no = p_book_item_no;
		if v_isLend='否' then
			insert into borrow_item(borrow_item_no,book_item_no,lend_card_no,lend_at)
				values(p_borrow_item_no,p_book_item_no,p_lend_card_no,to_char(sysdate,'yyyy/mm/dd'));
			update book_item set is_lend= '是' where book_item_no = p_book_item_no;
		else
			dbms_output.put_line('该书已经被借出');
		end if;
	end;


-- begin
-- 	p_lend_book('7','20051001','2001231');
-- 	commit;
-- end;


-- 建立存储过程完成图书管理系统中的预约功能。
create or replace procedure p_reserve_book
	(p_reserve_no in varchar, p_lend_card_no in varchar, p_isbn in varchar)
	as
		v_isLend int;
	begin
		select count(*) into v_isLend from book_item where ISBN = p_isbn and is_lend = '否';
		-- 预约
		if v_isLend = 0 then 
			insert into reserve(reserve_no,lend_card_no, ISBN,reserve_at) 
				values(p_reserve_no,p_lend_card_no,p_isbn,to_date(to_char(sysdate,'yyyy/mm/dd'),'yyyy/mm/dd'));
			commit;
		else
			dbms_output.put_line('该书目有可借图书，请查找');
		end if;
	end;

-- 还书
create or replace procedure p_return_book
	(p_lend_card_no in varchar,p_book_item_no in varchar, p_fine_class_no in varchar)
	as
	begin
		update borrow_item set fine_class_no = p_fine_class_no, return_at = to_date(to_char(sysdate,'yyyy/mm/dd'),'yyyy/mm/dd')
			where 
				lend_card_no = p_lend_card_no and 
				book_item_no = p_book_item_no;
		update book_item set is_lend = '否' where book_item_no = p_book_item_no;
	end;


-- 通过序列和触发器实现借阅表中借阅流水号字段的自动递增。
create sequence borrow_item_sequence
	increment by 1
	start with 1
	minvalue 1
	maxvalue 99999
	nocycle;

create or replace trigger inser_borrow_item_before
	before insert on borrow_item
	for each row
	begin
		select borrow_item_sequence.nextval into :new.borrow_item_no from sys.dual;
	end;

drop procedure p_lend_book;

create or replace procedure p_lend_book
	(p_lend_card_no in varchar,p_book_item_no in varchar)
	as
		v_isLend book_item.is_lend%type;
	begin
		select is_lend into v_isLend from book_item where book_item_no = p_book_item_no;
		if v_isLend='否' then
			insert into borrow_item(book_item_no,lend_card_no,lend_at)
				values(p_book_item_no,p_lend_card_no,to_char(sysdate,'yyyy/mm/dd'));		
		else
			dbms_output.put_line('该书已经被借出');
		end if;
	end;

create or replace trigger update_book_item
	after insert on borrow_item
	for each row
	begin
		update book_item set is_lend= '是' where book_item_no = :new.book_item_no;
	end;


