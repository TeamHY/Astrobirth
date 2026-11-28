if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesRuneBag",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_RUNE_BAG then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#최초 획득 시 {{Rune}}랜덤 룬 1개를 소환합니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_RUNE_BAG) then
            local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_RUNE_BAG)
            local rune = Game():GetItemPool():GetCard(rng:Next(), false, true, true)

            Astro:SpawnCard(rune, player.Position)
        end
    end,
    CollectibleType.COLLECTIBLE_RUNE_BAG
)
