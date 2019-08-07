delimiter //
create or replace procedure json_export(in_table_name varchar(64))
 as
declare 
columns_query query(col_name varchar(64), col_data_type varchar(64)) =  select column_name,data_type from information_schema.columns where table_schema = database() and table_name = in_table_name;
columns_array array(record(col_name varchar(64), col_data_type varchar(64)));
col_name varchar(64);
col_data_type varchar(64);
query_string text;
array_length int;
array_counter int = 0;
BEGIN 

query_string = 'ECHO SELECT CONCAT_WS(\'\', \'{\', TRIM(TRAILING \',\' FROM CONCAT_WS(\'\',';

columns_array = collect(columns_query);
array_length = length(columns_array);
if array_length = 0 then
	RAISE user_exception(concat("ERROR : TABLE ",in_table_name," NOT FOUND IN CURRENT DATABASE: ",database()));
end if;	
for r in columns_array loop
	array_counter += 1;
    col_name = r.col_name;
	col_data_type = r.col_data_type;
    if col_data_type in ("int", "smallint", "decimal", "bigint", "double", "float", "tinyint", "enum") then 
		-- Don't quote numeric datatypes
		query_string = concat( query_string,'(select concat(\'\"\', \"', col_name,'\", \'\":\', `',col_name, if(array_counter < array_length, '`,\',\' )) ,', '`,\'\'  ))'));
   else
		-- DO quote string datatypes
		query_string = concat( query_string,'(select concat(\'\"\', \"', col_name,'\", \'\":\"\',`',col_name, if(array_counter < array_length, '`,\'\",\' )) ,', '`,\'\"\'  ))'));
	end if;
    
end loop;

query_string = concat(query_string,  ' )), \'}\' ) :> json as json FROM ', in_table_name);
execute immediate query_string;

end;
//
delimiter ;
