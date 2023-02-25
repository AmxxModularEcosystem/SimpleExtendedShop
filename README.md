# Extended Shop

Простой магазин предметов с использованием ItemsController и ModularWallet.

## Требования

- [VipModular](https://github.com/ArKaNeMaN/amxx-VipModular-pub) (Нужен только ItemsController)
- [ModularWallet](https://github.com/ArKaNeMaN/amxx-ModularWallet)

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
]
```

[Подробнее о структуре предметов](https://github.com/ArKaNeMaN/amxx-VipModular-pub/blob/master/readme/items.md)
