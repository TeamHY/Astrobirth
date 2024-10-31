if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesTheWiz",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_THE_WIZ then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#방 입장 시 {{Card2}}I - The Magician이 발동됩니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
        
            if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
                player:UseCard(Card.CARD_MAGICIAN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOCOSTUME)
            end
        end
    end
)

-- Astro:AddCallback(
--     Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
--     ---@param player EntityPlayer
--     ---@param collectibleType CollectibleType
--     function(_, player, collectibleType)
--         player:UseCard(Card.CARD_MAGICIAN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOCOSTUME)
--     end,
--     CollectibleType.COLLECTIBLE_THE_WIZ
-- )
