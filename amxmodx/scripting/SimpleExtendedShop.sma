#include <amxmodx>
#include <json>
#include <VipM/ItemsController>
#include <ModularWallet>

#pragma semicolon 1
#pragma compress 1

public stock const PluginName[] = "Simple Extended Shop";
public stock const PluginVersion[] = "1.0.0";
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginURL[] = "t.me/arkanaplugins";
public stock const PluginDescription[] = "Simple shop using ModularWallet and ItemsController from VipModular";

enum _:E_ShopItem {
    ShopItem_Title[64],
    Array:ShopItem_Items,
    T_Currency:ShopItem_Currency,
    Float:ShopItem_Price,
}

new Array:g_aShopItems = Invalid_Array; // E_ShopItem[]

public plugin_precache() {
    register_plugin(PluginName, PluginVersion, PluginAuthor);

    VipM_IC_Init();
    MWallet_Init();

    if (!LoadShopFromFile(fmt("%s/plugins/SimpleExtendedShop.json", GetConfigsPath()))) {
        set_fail_state("Error during read config...");
        return;
    }

    register_clcmd("shop", "@Cmd_Shop");
    register_clcmd("say /shop", "@Cmd_ShopMenu");
    register_clcmd("say_team /shop", "@Cmd_ShopMenu");
}

@Cmd_Shop(const UserId) {
    if (read_argc() < 2) {
        return @Cmd_ShopMenu(UserId);
    }

    new iItemIndex = read_argv_int(1);
    if (iItemIndex < 0 || iItemIndex >= ArraySize(g_aShopItems)) {
        client_print(UserId, print_console, "Invalid shop item index (%d).", iItemIndex);
        return PLUGIN_HANDLED;
    }

    new ShopItem[E_ShopItem];
    ArrayGetArray(g_aShopItems, iItemIndex, ShopItem);

    if (MWallet_Currency_IsEnough(ShopItem[ShopItem_Currency], UserId, ShopItem[ShopItem_Price])) {
        if (VipM_IC_GiveItems(UserId, ShopItem[ShopItem_Items])) {
            MWallet_Currency_Credit(ShopItem[ShopItem_Currency], UserId, ShopItem[ShopItem_Price]);
        }
    } else {
        client_print(UserId, print_center, "Недостаточно средств");
    }

    return PLUGIN_HANDLED;
}

@Cmd_ShopMenu(const UserId) {
    new iMenu = menu_create("Магазин", "@MenuHandler_Command");

    for (new i = 0, ii = ArraySize(g_aShopItems); i < ii; i++) {
        new ShopItem[E_ShopItem];
        ArrayGetArray(g_aShopItems, i, ShopItem);

        menu_additem(
            iMenu,
            fmt("%-32 %s", ShopItem[ShopItem_Title], MWallet_Currency_Fmt(ShopItem[ShopItem_Currency], ShopItem[ShopItem_Price])),
            fmt("shop %d", i)
        );
    }

    menu_display(UserId, iMenu);

    return PLUGIN_HANDLED;
}

@MenuHandler_Command(const UserId, const MenuId, const ItemId) {
    if (ItemId == MENU_EXIT) {
        menu_destroy(MenuId);
        return;
    }

    static sCmd[128];
    menu_item_getinfo(MenuId, ItemId, _, sCmd, charsmax(sCmd));

    if (sCmd[0]) {
        client_cmd(UserId, sCmd);
    }

    menu_destroy(MenuId);
}

LoadShopFromFile(const sFilePath[]) {
    new JSON:jShop = json_parse(sFilePath, true, true);

    if (!json_is_array(jShop) || json_array_get_count(jShop) < 1) {
        log_amx("[ERROR] File: %s", sFilePath);
        log_amx("[ERROR] Root value must be non-empty array.");
        json_free(jShop);
        return false;
    }

    g_aShopItems = ArrayCreate(E_ShopItem, json_array_get_count(jShop));

    for (new i = 0, ii = json_array_get_count(jShop); i < ii; i++) {
        new JSON:jShopItem = json_array_get_value(jShop, i);
        if (!json_is_object(jShopItem)) {
            log_amx("[ERROR] File: %s -> Item #%d", sFilePath, i);
            log_amx("[ERROR] Array items must be an object.");
            json_free(jShopItem);
            continue;
        }

        new ShopItem[E_ShopItem];

        json_object_get_string(jShopItem, "Title", ShopItem[ShopItem_Title], charsmax(ShopItem[ShopItem_Title]));

        ShopItem[ShopItem_Currency] = MWallet_JsonObjectGetCurrency(jShopItem, "Currency");
        if (ShopItem[ShopItem_Currency] == Invalid_Currency) {
            log_amx("[ERROR] File: %s -> Item #%d", sFilePath, i);
            log_amx("[ERROR] Specified currency not found.");
            json_free(jShopItem);
            continue;
        }

        ShopItem[ShopItem_Price] = json_object_get_real(jShopItem, "Price");
        if (ShopItem[ShopItem_Price] <= 0.0) {
            log_amx("[WARNING] File: %s -> Item #%d", sFilePath, i);
            log_amx("[WARNING] Price is zero or negative.");
        }

        ShopItem[ShopItem_Items] = VipM_IC_JsonGetItems(json_object_get_value(jShopItem, "Items"));
        if (ShopItem[ShopItem_Items] == Invalid_Array) {
            log_amx("[WARNING] File: %s -> Item #%d", sFilePath, i);
            log_amx("[WARNING] Items array is empty.");
        }

        ArrayPushArray(g_aShopItems, ShopItem);
        json_free(jShopItem);
    }
    json_free(jShop);
    
    if (ArraySize(g_aShopItems) < 1) {
        log_amx("[ERROR] File: %s", sFilePath);
        log_amx("[ERROR] Shop items array is empty.");
        return false;
    }

    return true;
}

GetConfigsPath() {
    static __amxx_configsdir[PLATFORM_MAX_PATH];
    if (!__amxx_configsdir[0]) {
        get_localinfo("amxx_configsdir", __amxx_configsdir, charsmax(__amxx_configsdir));
    }
    return __amxx_configsdir;
}
