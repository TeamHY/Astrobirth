Redrawn.Collectible.SCORPIO_EX = Isaac.GetItemIdByName("Scorpio EX")

if EID then
    EID:addCollectible(Redrawn.Collectible.SCORPIO_EX, "눈물 대신 {{Poison}}독 파리가 생성됩니다", "초 전갈자리")
end

Redrawn:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Isaac.GetPlayer(0)

        if player:HasCollectible(Redrawn.Collectible.SCORPIO_EX) then
            tear:Remove()
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 2, player.Position, Vector(0, 0), player)
        end
    end
)
