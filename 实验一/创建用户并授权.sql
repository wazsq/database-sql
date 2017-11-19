
--创建用户名为user_naem的用户
CREATE USER user_naem IDENTIFIED BY "passwd";
--分配表空间（users）
DEFAULT TABLESPACE "USERS";
--分配临时空间
TEMPORARY TABLESPACE "TEMP";

--设置user_naem的权限
GRANT "DBA" TO user_naem ; --管理员权限
GRANT "CONNECT" TO user_naem ; --创建绘画权限
ALTER USER user_naem DEFAULT ROLE "DBA","CONNECT";