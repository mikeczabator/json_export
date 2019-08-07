# json_export
Formats a SQL result set in a JSON format.  Built and tested for MySQL and MemSQL.  This exports whole tables only.  If you want to select only certain rows, filter results, or use a LIMIT,  use a view.  

usage : `call json_export([table name]);` 

NOTE, it will be looking for the table in the client's currently seleted database.  Do a `use otherDB;` and execute from there.  

```
memsql> select * from employee;
+------+-------+------+
| id   | name  | dept |
+------+-------+------+
|    2 | tom   | me   |
| NULL | jimmy | sj   |
|    6 | NULL  | NULL |
|    3 | john  | dd   |
|    5 | bill  | bb   |
|    1 | mike  | se   |
|    4 | jess  | qq   |
+------+-------+------+
7 rows in set (0.00 sec)

memsql> call json_export("employee");
+------------------------------------+
| json                               |
+------------------------------------+
| {"dept":"me","id":2,"name":"tom"}  |
| {"dept":"sj","name":"jimmy"}       |
| {"id":6}                           |
| {"dept":"dd","id":3,"name":"john"} |
| {"dept":"bb","id":5,"name":"bill"} |
| {"dept":"se","id":1,"name":"mike"} |
| {"dept":"qq","id":4,"name":"jess"} |
+------------------------------------+
7 rows in set (0.01 sec)

Query OK, 0 rows affected (0.01 sec)
```


