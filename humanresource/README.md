# WbSchool_DB



# Работа с сотрудниками

### Регистрация нового сотрудника 
```sql
SELECT humanresource.employee_upd('{
    "shop_id": 1,
    "post_id": 1,
    "first_name": "Елена",
    "surname": "Рябко",
    "patronymic": "Михайловна",
    "phone": "79548956482",
    "email": "hrelena229@mail.ru"
}'::jsonb, _staff_id := 1);
```

Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Редактирование данных по существующему сотруднику (по client_id, shop_id)
```sql
SELECT humanresource.employee_upd('{
    "employee_id": 1,
    "shop_id": 1,
    "post_id": 1,
    "first_name": "Елена",
    "surname": "Рябко",
    "patronymic": "Михайловна",
    "phone": "79548956555",
    "email": "hrelena322@mail.ru"
}'::jsonb, _staff_id := 1);
```

Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Удаление сотрудника (по client_id, shop_id)
```sql
SELECT humanresource.employee_upd('{
    "employee_id": 1,
    "shop_id": 1,
    "deleted_at": "01.01.2025"
}'::jsonb, _staff_id := 1);
```

Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```


### Рассчитать бонус для конкретного сотрудника в текущем месяце (по employee_id)
```sql
select humanresource.count_employee_bonus(_employee_id := 3) 
```
Пример ответа при правильном выполнении:
```
5000
```

### Рассчитать премию для конкретного сотрудника в текущем месяце (по employee_id)
```sql
select humanresource.count_premium(_employee_id := 5) 
```
Пример ответа при правильном выполнении:
```
100
```
### Получить инфо о сотрудниках (по employee_id, shop_id или post_id)


### Пример: по конкрентому shop_id
```sql
select humanresource.employees_get_by_param(_employee_id := null, _shop_id := 1, _post_id := null)
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"email": "krek2@mail.ru", "phone": "79578956583", "post_id": 2, "shop_id": 1, "surname": "Крещенко", "first_name": "Евгений", "patronymic": "Игоревич", "employee_id": 4, "bonus_at_month": null, "premium_at_month": 100}, {"email": "m.antonov@mail.ru", "phone": "79427892845", "post_id": 3, "shop_id": 1, "surname": "Антонов", "first_name": "Максим", "patronymic": "Валерьевич", "employee_id": 5, "bonus_at_month": null, "premium_at_month": 0}, {"email": "a.vasilev@mail.ru", "phone": "79428822823", "post_id": 4, "shop_id": 1, "surname": "Васильев", "first_name": "Андрей", "patronymic": "Михайлович", "employee_id": 6, "bonus_at_month": null, "premium_at_month": 0}, {"email": "hrelena229@mail.ru", "phone": "79548956482", "post_id": 1, "shop_id": 1, "surname": "Рябко", "first_name": "Екатерина", "patronymic": "Михайловна", "employee_id": 12, "bonus_at_month": null, "premium_at_month": 0}]}
```


# Работа с клиентами

### Регистрация нового клиента 
```sql
SELECT humanresource.client_upd('{
    "card_type_id": 1,
    "first_name": "Михаил",
    "surname":  "Шпаков",
    "phone":   "79522384566"
}'::jsonb, _staff_id := 4);
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
    "error": "humanresource.client_upd", "detail": null, "message": "Клиент с таким номером уже существует"
    }
  ]
}
```

### Перевыпуск карты для клиента 
```sql
SELECT humanresource.client_upd('{
    "client_id": 27,
    "card_type_id": 1,
    "first_name": "Михаил",
    "surname":  "Шпаков",
    "phone":   "79522384566"
}'::jsonb, _staff_id := 4);
```
Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Обновление данных клиента 
```sql
SELECT humanresource.client_upd('{
    "client_id": 27,
    "card_id": 61,
    "card_type_id": 1,
    "first_name": "Михаил",
    "surname":  "Шпаков",
    "phone":   "79537954522"
}'::jsonb, _staff_id := 4);
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
    "error": "humanresource.client_upd", "detail": null, "message": "Клиент с таким номером уже учавствует в программе лояльности"
    }
  ]
}
```

### Получить инфо о клиентах (по client_id, номеру бонусной карты или номеру телефона)


### Пример: по номеру телефона
```sql
select humanresource.clients_get_by_param(_client_id := null, _card_id := null, _phone := '74943434')
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"dt": "2023-10-17T11:49:59.936688+00:00", "email": null, "phone": "79537954522", "card_id": 61, "surname": "Шпаков", "client_id": 27, "first_name": "Михаил", "employee_id": 4, "card_type_id": 1, "ransom_amount": 0.00}]}
```