Astro.Collectible.CANCER_EX = Isaac.GetItemIdByName("Cancer EX")

if EID then
    EID:addCollectible(Astro.Collectible.CANCER_EX, "적에게 준 피해의 1/10 만큼 모든 적들에게 피해를 입힙니다.#중첩이 가능합니다.", "초 게자리")
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

        if player ~= nil and player:HasCollectible(Astro.Collectible.CANCER_EX) and entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_FIREPLACE then
            if
                source.Type == EntityType.ENTITY_TEAR or
                damageFlags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER or
                source.Type == EntityType.ENTITY_KNIFE
            then
                local entities = Isaac.GetRoomEntities()

                for i = 1, #entities do
                    if entities[i]:IsVulnerableEnemy() and entities[i].Type ~= EntityType.ENTITY_FIREPLACE and not (entities[i].Type == EntityType.ENTITY_MAMA_GURDY and entities[i].Variant > 0) then
                        entities[i]:TakeDamage(amount / 10 * player:GetCollectibleNum(Astro.Collectible.CANCER_EX), 0, EntityRef(player), 1)
                    end
                end
            end
        end
    end
)
