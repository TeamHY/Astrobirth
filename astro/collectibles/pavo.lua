Astro.Collectible.PAVO = Isaac.GetItemIdByName("Pavo")

if EID then
    EID:addCollectible(Astro.Collectible.PAVO, "모든 몬스터들이 체력 25% 감소됩니다.", "공작자리")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local entities = Isaac.GetRoomEntities()

        local isRun = false
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.PAVO) and not isRun then
                for i = 1, #entities do
                    if entities[i]:IsVulnerableEnemy() and entities[i].Type ~= EntityType.ENTITY_FIREPLACE then
                        entities[i]:TakeDamage(entities[i].HitPoints * 0.25, 0, EntityRef(player), 1)
                    end
                end

                isRun = true
            end
        end
    end
)
