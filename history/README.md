# WbSchool_DB



###  Удалить партции таблицы которым уже больше 3-ёх месяцев
```sql
select history.delete_partitions(_table_name := 'storagechanges');
```

Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```