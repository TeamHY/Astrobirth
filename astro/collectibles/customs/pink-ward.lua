local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.PINK_WARD = Isaac.GetItemIdByName("Pink Ward")

if EID then
    EID:addCollectible(Astro.Collectible.PINK_WARD, "레드방을 포함한 스테이지 중심 5x5의 방을 보여줍니다.", "핑크 와드")
end

local function DisplayPinkWardRoom()
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

        room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX | RoomDescriptor.DISPLAY_ICON
    end

    level:UpdateVisibility()
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.PINK_WARD) then
                DisplayPinkWardRoom()
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
        Game():GetItemPool():RemoveCollectible(Astro.Collectible.WARD)

        DisplayPinkWardRoom()
    end,
    Astro.Collectible.PINK_WARD
)
