Необходимо написать запрос выбирающий для каждого налогоплательщика наиболее прибыльный день в месяце. 
Уникальный налогоплательщик определяется полем content.userInn , 
сумма для транзакции определена только для транзакций типа "subtype": "receipt" (остальные типы можно не учитывать), 
сумма транзакции определена в поле  "totalSum" в json-объекте транзакции ККТ. Дата и время берутся из поля content.dateTime.
