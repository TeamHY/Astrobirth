Astro:AddCallback(
    Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_LUNA) then
            Astro:SpawnTrinket(TrinketType.TRINKET_FRAGMENTED_CARD, player.Position)
        end
    end,
    CollectibleType.COLLECTIBLE_LUNA
)
