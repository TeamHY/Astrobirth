if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesYumHeart",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_YUM_HEART then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#희생방을 보여줍니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_YUM_HEART) then
                Astro:DisplayRoom(RoomType.ROOM_SACRIFICE)
                break
            end
        end
    end
)


Astro:AddCallback(
    Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro:DisplayRoom(RoomType.ROOM_SACRIFICE)
    end,
    CollectibleType.COLLECTIBLE_YUM_HEART
)
