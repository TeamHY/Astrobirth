local item = {}

---comment
---@param tear EntityTear
function item:OnFireTear(tear)
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(Redrawn.Collectible.ScorpioEX) then
        tear:SetColor(Color(0.2, 0.4, 1, 1, 0, 0, 0), - 1, 1, false, true)
        tear:Remove()
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 2, player.Position, Vector(0, 0), player)
    end
end

Redrawn:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, item.OnUpdate)

return item
