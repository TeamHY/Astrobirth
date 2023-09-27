if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesAquarius",
        function(descObj)
            if
                descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and
                    descObj.ObjSubType == CollectibleType.COLLECTIBLE_AQUARIUS
             then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#공격 당한 몬스터에서 눈물이 뿜어져 나옵니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = Astro:GetPlayerFromEntity(source.Entity)

        if
            player ~= nil and not player:HasCollectible(Astro.Collectible.AQUARIUS_EX) and
                player:HasCollectible(CollectibleType.COLLECTIBLE_AQUARIUS) and
                entity:IsVulnerableEnemy()
         then
            if
                source.Type == EntityType.ENTITY_TEAR or
                    damageFlags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER or
                    source.Type == EntityType.ENTITY_KNIFE
             then
                entity:GetData().Aquarius = {
                    Source = player,
                    Delay = 14
                }
            end
        end
    end
)

-- 눈물 뿜는 효과는 astro/collectibles/customs/aquarius-ex.lua에서 처리 됨.
