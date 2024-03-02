Astro.Collectible.MORPHINE = Isaac.GetItemIdByName("Morphine")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.MORPHINE, "모르핀", "...", "적에게 준 피해의 1/10 만큼 보스가 아닌 모든 적들에게 피해를 입힙니다. Death's Head를 제외한 무적 상태의 적에게도 피해를 입힙니다.")
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

        if player ~= nil and player:HasCollectible(Astro.Collectible.MORPHINE) and entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_FIREPLACE then
            if
                source.Type == EntityType.ENTITY_TEAR or
                damageFlags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER or
                source.Type == EntityType.ENTITY_KNIFE
            then
                local entities = Isaac.GetRoomEntities()

                for i = 1, #entities do
                    if entities[i]:IsInvincible() and (not entities[i]:IsBoss()) and entities[i].Type ~= EntityType.ENTITY_DEATHS_HEAD then
                        entities[i].HitPoints = entities[i].HitPoints - amount / 10
                        entities[i]:SetColor(Color(1, 1, 1, 1, 255, 0, 0), 1, 10, false, false)

                        if entities[i].HitPoints <= 0 then
                            entities[i]:Kill()
                        end
                    end
                end
            end
        end
    end
)
