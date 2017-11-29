-- exp S5120155133/sce19970228@orcl file=e:\temp.dmp tables=(reader)

-- imp S5120155133/sce19970228@orcl file=e:\temp.dmp



-- 回滚
-- 设置可回滚
alter table reader enable  row  movement;
flashback table reader to timestamp to_timestamp('2017/11/23 19:17:00','yyyy/mm/dd hh24:mi:ss');


create user S5120155133_USER identified by sce19970228;
grant "DBA","CONNECT","RESOURCE" to S5120155133_USER;
 alter user  S5120155133_USER default role "DBA", "CONNECT","RESOURCE";

-- 创建用户组
create role S5120155133_OPER1 identified by  null;
grant execute on p_lend_book to S5120155133_OPER1;
grant execute on p_return_book to S5120155133_OPER1;
grant execute on p_reserve_book to S5120155133_OPER1;
grant "RESOURCE" to S5120155133_OPER1;

-- 创建用户
create user S5120155133_USER2 identified by null;
alter user S5120155133_USER2 identified by "sce19970228";
grant "S5120155133_OPER1" to S5120155133_USER2;
grant create session,resource to S5120155133_USER2;
alter user  S5120155133_USER2 default role "S5120155133_OPER1";
-- 借书
select sysdate from dual;
alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';
select sysdate from dual;
call p_lend_book('20051001','2001231');


-- 视图
create or replace view VIEW_READER  
	as  
	select bc.class_name, bb.* from book_class bc,bibliography bb where bc.class_no = bb.class_no;