Astro.Collectible.MORPHINE = Isaac.GetItemIdByName("Morphine")

if EID then
    EID:addCollectible(Astro.Collectible.MORPHINE, "무적 상태 적에게 x0.25 피해를 줄 수 있게 됩니다.", "모르핀")
end

-- 완전 무적 몬스터에게만 동작합니다. 특정 상황에 무적인 몬스터일 경우 별도 처리해야하므로 목록이 필요합니다.
-- https://github.com/TeamHY/Redrawn_Hard/issues/26 에서 추적합니다. 누락된 몬스터가 있을 경우 댓글로 추가해주세요.

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = Astro:GetPlayerFromEntity(source.Entity)

        if player ~= nil and player:HasCollectible(Astro.Collectible.MORPHINE) then
            if source.Type == EntityType.ENTITY_TEAR or damageFlags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER or source.Type == EntityType.ENTITY_KNIFE then
                if entity:IsInvincible() and entity.Type ~= EntityType.ENTITY_DEATHS_HEAD then
                    entity.HitPoints = entity.HitPoints - amount * 0.25
                    entity:SetColor(Color(1, 1, 1, 1, 255, 0, 0), 1, 10, false, false)

                    if entity.HitPoints <= 0 then
                        entity:Kill()
                    end
                end
            end
        end
    end
)
