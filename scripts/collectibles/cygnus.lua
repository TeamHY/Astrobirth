local cygnus = {}

---comment
---@param player EntityPlayer
function cygnus:OnPostPeffectUpdate(player)
    if Game():GetFrameCount() % 450 == 0 then
        if player:HasCollectible(Redrawn.Collectible.Cygnus) then
            player:UseActiveItem(160, false, true, false, false)
            player:UseActiveItem(160, false, true, false, false)
        end
    end
end

Redrawn:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, cygnus.OnPostPeffectUpdate)
