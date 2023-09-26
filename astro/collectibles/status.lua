if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesStatus",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
                return true
            end
        end,
        function(descObj)
            if
                descObj.ObjSubType == CollectibleType.COLLECTIBLE_LITTLE_HORN or
                    descObj.ObjSubType == CollectibleType.COLLECTIBLE_EUTHANASIA or
                    descObj.ObjSubType == CollectibleType.COLLECTIBLE_LOST_CONTACT
             then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.75")
            elseif
                descObj.ObjSubType == CollectibleType.COLLECTIBLE_GHOST_PEPPER or
                    descObj.ObjSubType == CollectibleType.COLLECTIBLE_BIRDS_EYE
             then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.5#↓ {{LuckSmall}}행운 -5")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_C_SECTION then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.75")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_PARASITOID then
                EID:appendToDescription(descObj, "#↓ {{LuckSmall}}행운 -2")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_TOUGH_LOVE then
                EID:appendToDescription(descObj, "#↓ {{LuckSmall}}행운 -3")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_APPLE then
                EID:appendToDescription(descObj, "#↓ {{LuckSmall}}행운 -4")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_ATHAME then
                EID:appendToDescription(descObj, "#↓ {{LuckSmall}}행운 -3")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_LODESTONE then
                EID:appendToDescription(descObj, "#↓ {{LuckSmall}}행운 -2")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_HOLY_LIGHT then
                EID:appendToDescription(descObj, "#↓ {{LuckSmall}}행운 -1")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_MERCURIUS then
                EID:appendToDescription(descObj, "#↓ 최대 이동 속도가 1.6으로 제한이 됩니다")
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
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_HORN) then
                player.Damage = player.Damage * 0.75
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_EUTHANASIA) then
                player.Damage = player.Damage * 0.75
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_LOST_CONTACT) then
                player.Damage = player.Damage * 0.75
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) then
                player.Damage = player.Damage * 0.5
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) then
                player.Damage = player.Damage * 0.5
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
                player.Damage = player.Damage * 0.75
            end
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) then
                player.Luck = player.Luck - 5
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) then
                player.Luck = player.Luck - 5
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_PARASITOID) then
                player.Luck = player.Luck - 2
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_TOUGH_LOVE) then
                player.Luck = player.Luck - 3
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_APPLE) then
                player.Luck = player.Luck - 4
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_ATHAME) then
                player.Luck = player.Luck - 3
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_LODESTONE) then
                player.Luck = player.Luck - 2
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_LIGHT) then
                player.Luck = player.Luck - 1
            end
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MERCURIUS) then
                if player.MoveSpeed > 1.6 then
                    player.MoveSpeed = 1.6
                end
            end
        end
    end
)
