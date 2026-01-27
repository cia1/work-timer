# API
- `GET` Список задач  
    Ответ:
    _id_, _title_, _createdAt_, _startedAt_, _seconds_, _isRun_.
- `POST task` Добавление задачи  
    Тело запроса:  
    _title_ название  
- `PUT {id}` Переименование задачи
- `PUT {id}/toggle` Запуск таймера задачи
- `DELETE {id}` Удаление задачи