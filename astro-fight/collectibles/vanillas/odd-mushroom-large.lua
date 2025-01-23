if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesOddMushroomLarge",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#↑ {{SpeedSmall}}이동속도 +0.1 or +0.2")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        local rng = Astro:CopyRNG(player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE))

        for _ = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE) do
            local random = rng:RandomInt(2)

            if random == 0 then
                player.MoveSpeed = player.MoveSpeed + 0.1
            elseif random == 1 then
                player.MoveSpeed = player.MoveSpeed + 0.2
            end
        end
    end,
    CacheFlag.CACHE_SPEED
)
