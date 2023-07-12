local capricornEX = {}

--- 작동하지 않음
---@param player EntityPlayer
function capricornEX:OnPostPeffectUpdate(player)
    local effects = player:GetEffects()

    if player:HasCollectible(Redrawn.Collectible.CAPRICORN_EX) then
        if not effects:HasTrinketEffect(TrinketType.TRINKET_NUMBER_MAGNET) then
            effects:AddTrinketEffect(TrinketType.TRINKET_NUMBER_MAGNET, false)
        end
    else
        effects:RemoveTrinketEffect(TrinketType.TRINKET_NUMBER_MAGNET)
    end
end

Redrawn:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, capricornEX.OnPostPeffectUpdate)

return capricornEX
