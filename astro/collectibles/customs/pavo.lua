Astro.Collectible.PAVO = Isaac.GetItemIdByName("Pavo")

if EID then
    EID:addCollectible(Astro.Collectible.PAVO, "Mega Satan 1 페이즈을 제외한 모든 몬스터들의 체력이 15% 감소됩니다.#Mega Satan 1 페이즈의 체력이 10% 감소됩니다.", "공작자리")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    ---@param entity Entity
    function(_, entity)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.PAVO) then
                if entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_FIREPLACE then
                    if entity.Type == EntityType.ENTITY_MEGA_SATAN then
                        entity.HitPoints = entity.HitPoints - entity.MaxHitPoints * 0.1
                    else
                        entity.HitPoints = entity.HitPoints - entity.MaxHitPoints * 0.15
                    end
                end

                break
            end
        end
    end
)
