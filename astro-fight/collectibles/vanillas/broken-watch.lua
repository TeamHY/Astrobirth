if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesBrokenWatch",
        function(descObj)
            if
                descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and
                    descObj.ObjSubType == CollectibleType.COLLECTIBLE_BROKEN_WATCH
             then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#↑ {{SpeedSmall}}이동속도 +0.3")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BROKEN_WATCH) and cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + 0.3
        end
    end,
    CacheFlag.CACHE_SPEED
)
