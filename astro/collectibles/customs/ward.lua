local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.WARD = Isaac.GetItemIdByName("Ward")

if EID then
    EID:addCollectible(Astro.Collectible.WARD, "스테이지 중심 5x5의 방을 보여줍니다.", "와드")
end

local function DisplayWardRoom()
    local level = Game():GetLevel()

    local roomIndexs = {
        56, 57, 58, 59, 60,
        69, 70, 71, 72, 73,
        82, 83, 84, 85, 86,
        95, 96, 97, 98, 99,
        108, 109, 110, 111, 112
    }

    for _, value in ipairs(roomIndexs) do
        local room = level:GetRoomByIdx(value)

        if room.Flags & RoomDescriptor.FLAG_RED_ROOM ~= RoomDescriptor.FLAG_RED_ROOM and room.DisplayFlags & RoomDescriptor.DISPLAY_BOX ~= RoomDescriptor.DISPLAY_BOX then
            room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX | RoomDescriptor.DISPLAY_ICON
        end
    end

    level:UpdateVisibility()
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.WARD) then
                DisplayWardRoom()
                break
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(Astro.Collectible.WARD) then
            DisplayWardRoom()
        end
    end,
    Astro.Collectible.WARD
)
