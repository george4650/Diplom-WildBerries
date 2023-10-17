# WbSchool_DB



# Продажи

### В таблице sales поле sale_info храниться в формате json
```jsonb
[
 {
  "nm_id": 1, 
  "quantity": 99, 
  "product_price": 9000
 }
]
```

### Продать товары
```sql
select  sales.sale_ins('[
  {
    "nm_id": 1,
    "product_price": 9000,
    "quantity": 2
  }
]'::json,  _shop_id := 1, _staff_id := 3, _card_id := 1);
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
      {
        "error": "sales.sale_ins", "detail": null, 
        "message": "товара нет в данном магазине"
      }
    }
  ]
}
```
```jsonb 
{
  "errors": [
    {
      "error": "sales.sale_ins", "detail": null, 
      "message": "товара нет в наличии в данном магазине"
    }
  ]
}
```


### Получить инфо о продажах (по sale_id, card_id, employee_id,  start_date, end_date)

### Пример: по конкрентной карте и максимальной дате
```sql
 select sales.sales_get_by_param(_sale_id := null, _card_id := 7, _staff_id :=null, _start_date := null, _end_date :='01.01.2025')
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"dt": "2023-10-16T18:20:56.427535+00:00", "card_id": 7, "sale_id": 199, "shop_id": 1, "discount": 50.00, "sale_info": [{"nm_id": 5, "quantity": 2, "product_price": 500}], "employee_id": 3, "total_price": 1000.00}]}
```