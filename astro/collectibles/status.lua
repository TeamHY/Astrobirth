if EID then
    EID:addDescriptionModifier(
        "Astro",
        function(descObj)
            return true
        end,
        function(descObj)
            if descObj.ObjSubType == CollectibleType.COLLECTIBLE_LITTLE_HORN or descObj.ObjSubType == CollectibleType.COLLECTIBLE_EUTHANASIA or descObj.ObjSubType == CollectibleType.COLLECTIBLE_LOST_CONTACT then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.75")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_GHOST_PEPPER or descObj.ObjSubType == CollectibleType.COLLECTIBLE_BIRDS_EYE then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.8#↓ {{LuckSmall}}행운 -5")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_C_SECTION then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.8")
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
                player.Damage = player.Damage * 0.8
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) then
                player.Damage = player.Damage * 0.8
            end
            
            if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
                player.Damage = player.Damage * 0.8
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
        end
    end
)
