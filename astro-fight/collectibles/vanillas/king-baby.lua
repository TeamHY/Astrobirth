if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesKingBaby",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_MARBLES then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(
                descObj,
                "#획득 시 {{Card92}}Soul of Lilith가 소환되며, {{Trinket127}}Baby Bender와 {{Trinket141}}Forgotten Lullaby를 흡수 획득합니다."
            )

            return descObj
        end
    )
end

Astro:AddCallback(
    Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_KING_BABY) then
            Astro:SpawnCard(Card.CARD_SOUL_LILITH, player.Position)
            Astro:SmeltTrinket(player, TrinketType.TRINKET_BABY_BENDER)
            Astro:SmeltTrinket(player, TrinketType.TRINKET_FORGOTTEN_LULLABY)
        end
    end,
    CollectibleType.COLLECTIBLE_KING_BABY
)
