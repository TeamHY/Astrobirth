local scorpioEX = {}

---comment
---@param tear EntityTear
function scorpioEX:OnFireTear(tear)
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(Redrawn.Collectible.SCORPIO_EX) then
        tear:Remove()
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 2, player.Position, Vector(0, 0), player)
    end
end

Redrawn:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, scorpioEX.OnFireTear)

return scorpioEX
