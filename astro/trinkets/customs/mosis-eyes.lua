local isc = require("astro.lib.isaacscript-common")

Astro.Trinket.MOSIS_EYES = Isaac.GetTrinketIdByName("Mosi's Eyes")

if EID then
    EID:addTrinket(Astro.Trinket.MOSIS_EYES, "↓ {{LuckSmall}}행운 -3#캐릭터가 있는 방에서 2칸 이내에 있는 스테이지 구조를 맵에 표시합니다.", "모시의 눈")

    -- Astro:AddGoldenTrinketDescription(Astro.Trinket.MOSIS_EYES, "", 1)
end


local function DisplayNeighborRoom()
    local level = Game():GetLevel()

    local roomIndexs = {
        -28, -27, -26, -25, -24,
        -15, -14, -13, -12, -11,
        -2, -1, 0, 1, 2,
        11, 12, 13, 14, 15,
        24, 25, 26, 27, 28
    }

    local currentRoomIndex = level:GetCurrentRoomIndex()

    for _, value in ipairs(roomIndexs) do
        -- TODO: 올바른 인덱스인지 검사
        local room = level:GetRoomByIdx(currentRoomIndex + value)

        -- TODO: 비밀방, 일급 비밀방 제외 처리
        if room.Data.Type ~= RoomType.ROOM_ULTRASECRET and room.DisplayFlags & RoomDescriptor.DISPLAY_BOX ~= RoomDescriptor.DISPLAY_BOX then
            room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX
        end
    end

    level:UpdateVisibility()
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if not player:HasTrinket(Astro.Trinket.MOSIS_EYES) then
                break
            end

            DisplayNeighborRoom()
        end
    end
)

Astro:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasTrinket(Astro.Trinket.MOSIS_EYES) then
            player.Luck = player.Luck - 3
        end
    end,
    CacheFlag.CACHE_LUCK
)
