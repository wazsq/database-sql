-- exp S5120155133/sce19970228@orcl file=e:\temp.dmp tables=(reader)

-- imp S5120155133/sce19970228@orcl file=e:\temp.dmp

-- exp S5120155133/sce19970228@orcl file=e:\temp.dmp full=y


-- 回滚
-- 设置可回滚
alter table reader enable  row  movement;
flashback table reader to timestamp to_timestamp('2017/11/23 19:17:00','yyyy/mm/dd hh24:mi:ss');

grant "RESOURCE" to S5120155133;

-- 创建用户组
create role S5120155133_OPER identified by  null;
grant execute on p_lend_book,p_return_book,p_reserve_book to S5120155133_OPER;

-- 创建用户
create user S5120155133_USER2 identified by null;
alter user S5120155133_USER2 identified by "sce19970228";
grant "S5120155133_OPER" to S5120155133_USER2;
grant "CONNECT" to S5120155133_USER2;


-- 视图
create or replace view VIEW_READER  
	as  
	select bc.class_name, bb.* from book_class bc,bibliography bb where bc.class_no = bb.class_no;