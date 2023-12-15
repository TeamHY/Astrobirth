if EID then
    EID:addDescriptionModifier(
        "AstroTrinketsStatus",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
                return true
            end
        end,
        function(descObj)
            if descObj.ObjSubType == TrinketType.TRINKET_CAINS_EYE then
                EID:appendToDescription(descObj, "#↓ {{LuckSmall}}행운 -3")
            end

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if cacheFlag == CacheFlag.CACHE_LUCK then
            if player:HasTrinket(TrinketType.TRINKET_CAINS_EYE) then
                player.Luck = player.Luck - 3
            end
        end
    end
)
