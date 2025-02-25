if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesStatus",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
                return true
            end
        end,
        function(descObj)
            if descObj.ObjSubType == CollectibleType.COLLECTIBLE_LITTLE_HORN then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.75")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_EUTHANASIA then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.75")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_LOST_CONTACT then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.75")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_GHOST_PEPPER then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.9#↓ {{LuckSmall}}행운 -5")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_BIRDS_EYE then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.9#↓ {{LuckSmall}}행운 -5")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_C_SECTION then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.95")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_IT_HURTS then
                EID:appendToDescription(descObj, "#↑ {{DamageSmall}}공격력 배율 x1.3")
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
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE then
                EID:appendToDescription(descObj, "#↑ {{ShotspeedSmall}}탄속 +0.5")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_TRISAGION then
                EID:appendToDescription(descObj, "#↓ {{ShotspeedSmall}}탄속 x0.5")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_TECH_X then
                EID:appendToDescription(descObj, "#↓ {{ShotspeedSmall}}탄속 x0.5")
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
                player.Damage = player.Damage * 0.9
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) then
                player.Damage = player.Damage * 0.9
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
                player.Damage = player.Damage * 0.95
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_IT_HURTS) then
                player.Damage = player.Damage * (1.3 ^ player:GetCollectibleNum(CollectibleType.COLLECTIBLE_IT_HURTS))
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
        elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
                player.ShotSpeed = player.ShotSpeed + 0.5
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_TRISAGION) then
                player.ShotSpeed = player.ShotSpeed * 0.5
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
                player.ShotSpeed = player.ShotSpeed * 0.5
            end
        end
    end
)
