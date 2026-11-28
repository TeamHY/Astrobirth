if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesRedKey",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_RED_KEY then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#최초 획득 시 {{Card78}}Cracked Key를 1개 소환합니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_RED_KEY) then
            Astro:SpawnCard(Card.CARD_CRACKED_KEY, player.Position)
        end
    end,
    CollectibleType.COLLECTIBLE_RED_KEY
)
