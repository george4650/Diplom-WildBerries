# WbSchool_DB



# Поставки



### Регистрация нового поставщика 
```sql
select  supply.supplier_upd('{
"name": "ООО Зооgoods.ru",
"phone": "749515485",
"email": "zoo232@mail.ru"
}'::jsonb,  _staff_id := 2);
```

Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Редактирование данных по существующему поставщику (по supplier_id)
```sql
select  supply.supplier_upd('{
"supplier_id": 3,
"name": "ООО Зооgoods.ru",
"phone": "749515485",
"email": "zoo555@mail.ru"
}'::jsonb,  _staff_id := 2);
```

Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Удаление поставщика (по supplier_id)
```sql
select humanresource.employee_upd('{
    "supplier_id": 3,
    "deleted_at": "01.01.2025"
}'::jsonb, _staff_id := 1);
```

Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```


### Получить инфо о поставщиках
```sql
select supply.suppliers_get_by_param(_supplier_id := null)
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"name": "ООО Medium&Maxi", "email": "zoo227@mail.ru", "phone": "749515486", "deleted_at": null, "supplier_id": 2}, {"name": "ОАО Farmina", "email": "zo23@mail.ru", "phone": "749512486", "deleted_at": null, "supplier_id": 3}, {"name": "ООО Зооgoods.ru", "email": "zoo232@mail.ru", "phone": "749515485", "deleted_at": null, "supplier_id": 1}]}
```

### Получить инфо о поставщике по id

```sql
select supply.suppliers_get_by_param(_supplier_id := 1)
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"name": "ООО Зооgoods.ru", "email": "zoo232@mail.ru", "phone": "749515485", "deleted_at": null, "supplier_id": 1}]}
```


### Сделать заказ
```sql
select  supply.make_order('[{
  "shop_id": 1,
  "supplier_id": 2,
  "supply_info": [{
  "nm_id": 9,
  "purchase_price": 1000,
  "quantity": 2}]
},
{
  "shop_id": 1,
  "supplier_id": 2,
   "supply_info": [{
  "nm_id": 10,
  "purchase_price": 1000,
  "quantity": 2}]
}]'::jsonb, _staff_id := 2);
```

Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```
### Принять заказ
```sql
select supply.take_order(_supply_id := 1, _staff_id := 2);
```
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

Примеры ошибок
```jsonb 
{
  "errors": [
    {
     "error": "supply.take_order", "detail": null, 
     "message": "Данная поставка уже принята"
    }
  ]
}
```

### Получить инфо о поставках (по supply_id, shop_id, supplier_id, начальной дате заказа, конечной дате заказа)
```sql
select supply.supplies_get_by_param(
  _supply_id := null,
  _shop_id := 1,
  _supplier_id := null,
  _start_date := null,
  _end_date := '01.01.2024'
)
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"shop_id": 1, "order_dt": "2023-10-15T17:28:51.008615+00:00", "supply_dt": "2023-10-16T17:43:04.806816+00:00", "supply_id": 6, "supplier_id": 2, "supply_info": [{"nm_id": 5, "quantity": 3, "purchase_price": 15000}], "staff_id_tooked": 2, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:50.826543+00:00", "supply_dt": "2023-10-16T17:44:35.617652+00:00", "supply_id": 5, "supplier_id": 3, "supply_info": [{"nm_id": 5, "quantity": 2, "purchase_price": 35000}], "staff_id_tooked": 2, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-16T20:35:56.754831+00:00", "supply_dt": null, "supply_id": 13, "supplier_id": 1, "supply_info": [{"nm_id": 2, "quantity": 6, "purchase_price": 5000}], "staff_id_tooked": null, "staff_id_ordered": 15}, {"shop_id": 1, "order_dt": "2023-10-16T20:54:16.879129+00:00", "supply_dt": null, "supply_id": 14, "supplier_id": 2, "supply_info": [{"nm_id": 9, "quantity": 2, "purchase_price": 1000}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-16T20:54:16.879129+00:00", "supply_dt": null, "supply_id": 15, "supplier_id": 2, "supply_info": [{"nm_id": 10, "quantity": 2, "purchase_price": 1000}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-16T20:54:17.908957+00:00", "supply_dt": null, "supply_id": 16, "supplier_id": 2, "supply_info": [{"nm_id": 9, "quantity": 2, "purchase_price": 1000}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-16T20:54:17.908957+00:00", "supply_dt": null, "supply_id": 17, "supplier_id": 2, "supply_info": [{"nm_id": 10, "quantity": 2, "purchase_price": 1000}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-17T12:25:08.335969+00:00", "supply_dt": null, "supply_id": 18, "supplier_id": 2, "supply_info": [{"nm_id": 9, "quantity": 2, "purchase_price": 1000}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-17T12:25:08.335969+00:00", "supply_dt": null, "supply_id": 19, "supplier_id": 2, "supply_info": [{"nm_id": 10, "quantity": 2, "purchase_price": 1000}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:50.212052+00:00", "supply_dt": "2023-10-15T23:45:31.199181+00:00", "supply_id": 1, "supplier_id": 1, "supply_info": [{"nm_id": 1, "quantity": 4, "purchase_price": 3000}], "staff_id_tooked": 2, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:50.674809+00:00", "supply_dt": null, "supply_id": 4, "supplier_id": 2, "supply_info": [{"nm_id": 3, "quantity": 5, "purchase_price": 4500}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:50.531926+00:00", "supply_dt": null, "supply_id": 3, "supplier_id": 1, "supply_info": [{"nm_id": 3, "quantity": 2, "purchase_price": 4000}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:50.384146+00:00", "supply_dt": "2023-10-15T23:22:43.796413+00:00", "supply_id": 2, "supplier_id": 1, "supply_info": [{"nm_id": 2, "quantity": 6, "purchase_price": 5000}], "staff_id_tooked": 2, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:51.741236+00:00", "supply_dt": null, "supply_id": 11, "supplier_id": 2, "supply_info": [{"nm_id": 9, "quantity": 2, "purchase_price": 1000}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:51.292295+00:00", "supply_dt": null, "supply_id": 8, "supplier_id": 1, "supply_info": [{"nm_id": 7, "quantity": 7, "purchase_price": 1200}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:51.442435+00:00", "supply_dt": null, "supply_id": 9, "supplier_id": 2, "supply_info": [{"nm_id": 8, "quantity": 4, "purchase_price": 2500}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:51.148871+00:00", "supply_dt": null, "supply_id": 7, "supplier_id": 3, "supply_info": [{"nm_id": 6, "quantity": 2, "purchase_price": 12500}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:51.588478+00:00", "supply_dt": null, "supply_id": 10, "supplier_id": 3, "supply_info": [{"nm_id": 9, "quantity": 3, "purchase_price": 1500}], "staff_id_tooked": null, "staff_id_ordered": 2}, {"shop_id": 1, "order_dt": "2023-10-15T17:28:51.741236+00:00", "supply_dt": null, "supply_id": 12, "supplier_id": 2, "supply_info": [{"nm_id": 10, "quantity": 2, "purchase_price": 1000}], "staff_id_tooked": null, "staff_id_ordered": 2}]}
```