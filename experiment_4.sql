-- exp S5120155133/sce19970228@orcl file=e:\temp.dmp tables=(reader)

-- imp S5120155133/sce19970228@orcl file=e:\temp.dmp

-- exp S5120155133/sce19970228@orcl file=e:\temp.dmp full=y


-- 回滚
-- 设置可回滚
alter table reader enable  row  movement;
flashback table reader to timestamp to_timestamp('2017/11/23 19:17:00','yyyy/mm/dd hh24:mi:ss');