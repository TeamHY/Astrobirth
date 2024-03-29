if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesBloodOath",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_BLOOD_OATH then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#↑ {{DamageSmall}}공격력 +1.8#↓ 현재 체력 한 칸당 {{DamageSmall}}공격력 -0.18")

            return descObj
        end
    )
end

local prevHearts = 0

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_OATH) and Game():GetFrameCount() % 30 == 0 then
            local hearts = player:GetHearts() + player:GetSoulHearts()

            if hearts ~= prevHearts then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end

            prevHearts = hearts
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_OATH) then
                player.Damage = player.Damage + (1.8 ^ player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BLOOD_OATH)) - (player:GetHearts() + player:GetSoulHearts()) * 0.09
            end
        end
    end
)
