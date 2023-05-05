
set statistics io on;

select * from Vista;

select * from indexado;
--select * from indexado with (noexpand);
--CREATE UNIQUE CLUSTERED INDEX IX_Vista ON indexado (responsible_name);

select * from dinamico;

select * from flyway_schema_history;
