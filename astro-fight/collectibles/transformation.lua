Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if pickup.Variant == PickupVariant.PICKUP_PILL then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasPlayerForm(PlayerForm.PLAYERFORM_MOM) then
                    Game():GetItemPool():IdentifyPill(pickup.SubType)
                    break
                end
            end
        end
    end
)
