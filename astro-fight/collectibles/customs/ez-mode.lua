if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesEzMode",
        function(descObj)
            if
                descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and
                descObj.ObjSubType == Astro.Collectible.EZ_MODE
            then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#1 스테이지일 경우 맵에 {{CurseRoom}}저주방 위치가 표시됩니다.")

            return descObj
        end
    )
end

local function DisplayCurseRoom()
    local level = Game():GetLevel()

    if level:GetAbsoluteStage() ~= LevelStage.STAGE1_1 then
        return
    end

    for i = 0, 169 do
        local room = level:GetRoomByIdx(i)

        if room.Data then
            if room.Data.Type == RoomType.ROOM_CURSE then
                room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX | RoomDescriptor.DISPLAY_ICON
            end
        end
    end

    level:UpdateVisibility()
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        if Astro:HasCollectible(Astro.Collectible.EZ_MODE) then
            DisplayCurseRoom()
        end
    end
)

Astro:AddCallback(
    Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        DisplayCurseRoom()
    end,
    Astro.Collectible.EZ_MODE
)
