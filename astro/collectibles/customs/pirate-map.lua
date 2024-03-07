local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.PIRATE_MAP = Isaac.GetItemIdByName("Pirate Map")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.PIRATE_MAP, "해적 지도", "...", "현재 스테이지에서 랜덤한 방 위치 2개를 보여주며, 행운 2당 1개의 방을 추가로 보여줍니다.#중첩 시마다 2개의 방을 추가로 보여줍니다.")
end

---@param count integer
---@param rng RNG
local function DisplayRandomRoom(count, rng)
    local level = Game():GetLevel()

    local rooms = {}

    for i = 0, 169 do
        local room = level:GetRoomByIdx(i)

        if room.Flags & RoomDescriptor.FLAG_RED_ROOM ~= RoomDescriptor.FLAG_RED_ROOM and room.DisplayFlags & RoomDescriptor.DISPLAY_BOX ~= RoomDescriptor.DISPLAY_BOX then
            table.insert(rooms, room)
        end
    end

    for _ = 1, count do
        if #rooms == 0 then
            break
        end

        local room = rooms[rng:RandomInt(#rooms) + 1]

        room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX | RoomDescriptor.DISPLAY_ICON
    end

    level:UpdateVisibility()
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.PIRATE_MAP) then
                local rng = player:GetCollectibleRNG(Astro.Collectible.PIRATE_MAP)

                DisplayRandomRoom(math.floor(2 * player:GetCollectibleNum(Astro.Collectible.PIRATE_MAP) + player.Luck / 2), rng)

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
        if Astro:IsFirstAdded(Astro.Collectible.PIRATE_MAP) then
            local rng = player:GetCollectibleRNG(Astro.Collectible.PIRATE_MAP)

            DisplayRandomRoom(math.floor(2 + player.Luck / 2), rng)
        end
    end,
    Astro.Collectible.PIRATE_MAP
)
