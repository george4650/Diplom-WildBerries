# WbSchool_DB



# Работа со словарём

### Получить все типы продуктов
```sql
select dictionary.good_type_get_by_param(_good_type_id := null);
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"name": "Кот", "good_type_id": 1}, {"name": "Кошка", "good_type_id": 2}, {"name": "Рыба", "good_type_id": 3}, {"name": "Попугай", "good_type_id": 4}, {"name": "Собака", "good_type_id": 5}, {"name": "Черепаха", "good_type_id": 6}, {"name": "Утконос", "good_type_id": 7}, {"name": "Ёж", "good_type_id": 8}, {"name": "Корм для собак", "good_type_id": 9}, {"name": "Корм для птиц", "good_type_id": 10}, {"name": "Клетка для птиц", "good_type_id": 11}, {"name": "Поводок", "good_type_id": 12}, {"name": "Ошейник", "good_type_id": 13}, {"name": "Брелок", "good_type_id": 14}]}
```

### Получить тип продукта по id
```sql
select dictionary.good_type_get_by_param(_good_type_id := 1);
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"name": "Кот", "good_type_id": 1}]}
```

### Добавить тип продукта
```sql
select dictionary.good_type_ins('Корм для собак');
```

Пример ответа при правильном выполнении:
```jsonb
{"data" : null}
```

### Получить инфо о всех должностях в магазине
```sql
select dictionary.post_get_by_param_id(_post_id := null)
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"name": "HR", "salary": 35000.00, "post_id": 1}, {"name": "Товаровед", "salary": 45000.00, "post_id": 2}, {"name": "Продавец-кассир", "salary": 35200.00, "post_id": 3}, {"name": "Старший продавец-кассир", "salary": 42300.00, "post_id": 4}]}
```

### Получить инфо о должности по id
```sql
select dictionary.post_get_by_param_id(_post_id := 1)
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"name": "HR", "salary": 35000.00, "post_id": 1}]}
```

### Получить инфо по бонусным картам
```sql
select dictionary.type_card_get_by_param_id(_type_card_id := null)
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"name": "Стандартный", "discount": 1, "card_type_id": 1, "ransom_amount": 0}, {"name": "Бронзовый", "discount": 2, "card_type_id": 2, "ransom_amount": 10000}, {"name": "Серебряный", "discount": 3, "card_type_id": 3, "ransom_amount": 15000}, {"name": "Золотой", "discount": 4, "card_type_id": 4, "ransom_amount": 20000}, {"name": "Платиновый", "discount": 5, "card_type_id": 5, "ransom_amount": 30000}]}
```

### Получить инфо о типе бонусной карты по id
```sql
select dictionary.type_card_get_by_param_id(_type_card_id := 5)
```
Пример ответа при правильном выполнении:
```jsonb
{"data": [{"name": "Платиновый", "discount": 5, "card_type_id": 5, "ransom_amount": 30000}]}
```