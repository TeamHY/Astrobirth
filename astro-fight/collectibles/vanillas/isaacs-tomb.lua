if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesIsaacsTomb",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_ISAACS_TOMB then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#최초 획득 시 {{OldChest}}오래된상자 1개를 소환합니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_ISAACS_TOMB) then
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_OLDCHEST,
                ChestSubType.CHEST_CLOSED,
                currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                Vector.Zero,
                nil
            )
        end
    end,
    CollectibleType.COLLECTIBLE_ISAACS_TOMB
)
