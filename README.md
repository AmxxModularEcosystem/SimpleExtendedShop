# Extended Shop

Простой магазин предметов с использованием ItemsController и ModularWallet.

## Требования

- [VipModular](https://github.com/ArKaNeMaN/amxx-VipModular-pub) >=`5.0.0-beta.8` (Нужен только ItemsController и расширения с типами предметов)
- [ModularWallet](https://github.com/ArKaNeMaN/amxx-ModularWallet) >=`1.0.0-beta.2`

## Настройка

Файл конфигурации: `amxmodx/configs/plugins/SimpleExtendedShop.json`

```jsonc
[
    {
        "Title": "Название пункта", // Отображаемое название валюты
        "Currency": "CurrencyName", // Название валюты из ModularWallet
        "Price": 1500, // Цена пункта в указанной валюте
        "Items": [ // Массив предметов из ItemsController
            {
                "Type": "HealthNade"
            }
        ]
    }
    // {...}
]
```

| Параметр      | Тип               | Описание
| :---          | :---              | :---
| `Title`       | Строка            | Отображаемое название пункта магазина
| `Currency`    | Валюта            | Название существующей валюты из ModularWallet
| `Price`       | Д.Число           | Цена пункта в указанной валюте
| `Items`       | Массив предметов  | Предметы из ItemsController, которые будут выданы при успешной покупке

- [Подробнее о структуре предметов ItemsController](https://github.com/ArKaNeMaN/amxx-VipModular-pub/blob/master/readme/items.md)
- Списки доступных типов предметов [тут](https://github.com/ArKaNeMaN/amxx-VipModular-pub/blob/master/readme/default-extensions.md#%D1%82%D0%B8%D0%BF%D1%8B-%D0%BF%D1%80%D0%B5%D0%B4%D0%BC%D0%B5%D1%82%D0%BE%D0%B2) и [тут](https://github.com/ArKaNeMaN/amxx-VipModular-pub/blob/master/readme/thirdparty-extensions.md#%D1%82%D0%B8%D0%BF%D1%8B-%D0%BF%D1%80%D0%B5%D0%B4%D0%BC%D0%B5%D1%82%D0%BE%D0%B2).
- Ссылки как в VipModular на данный момент не поддерживаются.
