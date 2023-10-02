local startItem = {
    Collectible = {
        -- CollectibleType.COLLECTIBLE_SAD_ONION,
        -- CollectibleType.COLLECTIBLE_SAD_ONION
    },
    Trinket = {
        -- TrinketType.TRINKET_SWALLOWED_PENNY,
        -- TrinketType.TRINKET_SWALLOWED_PENNY
    },
    Card = {
        Card.CARD_HOLY
    },
    Pill = {
        -- PillEffect.PILLEFFECT_BAD_GAS,
        -- PillEffect.PILLEFFECT_BAD_GAS
    }
}

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            local player = Isaac.GetPlayer()
            local playerType = player:GetPlayerType()
            local position = player.Position

            for _, value in ipairs(startItem.Collectible) do
                Astro:SpawnCollectible(value, position)
            end

            for _, value in ipairs(startItem.Trinket) do
                Astro:SpawnTrinket(value, position)
            end

            for _, value in ipairs(startItem.Card) do
                Astro:SpawnCard(value, position)
            end

            for _, value in ipairs(startItem.Pill) do
                Astro:SpawnPill(value, position)
            end

            if playerType == PlayerType.PLAYER_ISAAC then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_D6)
            elseif playerType == PlayerType.PLAYER_EVE then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_RAZOR_BLADE)
            end
        end
    end
)
