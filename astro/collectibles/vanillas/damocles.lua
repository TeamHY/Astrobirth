local isc = require("astro.lib.isaacscript-common")

local collectibles = {
    CollectibleType.COLLECTIBLE_1UP,
    CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
    CollectibleType.COLLECTIBLE_DEAD_CAT, --81
    CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, --422
    CollectibleType.COLLECTIBLE_ANKH, --161
    CollectibleType.COLLECTIBLE_GNAWED_LEAF, --210
    CollectibleType.COLLECTIBLE_JUDAS_SHADOW, --311
    CollectibleType.COLLECTIBLE_INNER_CHILD, --688
    CollectibleType.COLLECTIBLE_ESAU_JR, --703
    CollectibleType.COLLECTIBLE_GENESIS, --622
    CollectibleType.COLLECTIBLE_HOLY_MANTLE, --313
    Astro.Collectible.ALTAIR,  --여기 알타일부터 아래 우라노스까지는 배열 안지워지고 그대로 나옴
    CollectibleType.COLLECTIBLE_PSY_FLY,
    CollectibleType.COLLECTIBLE_GENESIS,
    CollectibleType.COLLECTIBLE_LOST_CONTACT,
    CollectibleType.COLLECTIBLE_LIL_DUMPY,
    CollectibleType.COLLECTIBLE_CENSER,
    CollectibleType.COLLECTIBLE_BLANKET,
    CollectibleType.COLLECTIBLE_SWARM,
    CollectibleType.COLLECTIBLE_SOUL,
    Astro.Collectible.PISCES_EX,
    CollectibleType.COLLECTIBLE_STOP_WATCH,
    Astro.Collectible.LEO_EX,
    CollectibleType.COLLECTIBLE_URANUS
}

local trinkets = {
    TrinketType.TRINKET_BROKEN_ANKH,
    TrinketType.TRINKET_MISSING_POSTER,
    TrinketType.TRINKET_SIGIL_OF_BAPHOMET
}

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesDamocles",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_DAMOCLES then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#!!! 아래 아이템이 금지됩니다.#{{Collectible11}}, {{Collectible596}}, {{Collectible739}}, {{Collectible232}}, {{Collectible747}}, {{Collectible335}}, {{Collectible693}}, {{Collectible535}}, {{Collectible387}}, {{Collectible615}}, {{Collectible213}}, {{Collectible622}}, {{Collectible581}}, {{Collectible754}}, {{Collectible332}}, {{Collectible81}}, {{Collectible422}}, {{Collectible161}}, {{Collectible210}}, {{Collectible313}}, {{Collectible311}}, {{Collectible688}}, {{Collectible703}}, {{Collectible622}}, {{Trinket28}}, {{Trinket189}}, {{Trinket23}}")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ---@param collectibleID CollectibleType
    ---@param rngObj RNG
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags integer
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleID, rngObj, playerWhoUsedItem, useFlags, activeSlot, varData)
        local itemPool = Game():GetItemPool()

        for _, collectible in ipairs(collectibles) do
            Astro:RemoveAllCollectible(playerWhoUsedItem, collectible)
            itemPool:RemoveCollectible(collectible)
        end

        for _, trinket in ipairs(trinkets) do
            Astro:RemoveAllTrinket(playerWhoUsedItem, trinket)
            itemPool:RemoveTrinket(trinket)
        end

        return true
    end,
    CollectibleType.COLLECTIBLE_DAMOCLES
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_ITEM_PICKUP,
    ---@param player EntityPlayer
    ---@param pickingUpItem { itemType: ItemType, subType: CollectibleType | TrinketType }
    function(_, player, pickingUpItem)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
            if pickingUpItem.itemType ~= ItemType.ITEM_TRINKET then
                for _, collectible in ipairs(collectibles) do
                    if collectible == pickingUpItem.subType then
                        Astro:RemoveAllCollectible(player, collectible)
                        break
                    end
                end
            else
                for _, trinket in ipairs(trinkets) do
                    if trinket == pickingUpItem.subType then
                        Astro:RemoveAllTrinket(player, trinket)
                        break
                    end
                end
            end
        end
    end
)
