local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.WARD = Isaac.GetItemIdByName("Ward")
Astro.Collectible.PINK_WARD = Isaac.GetItemIdByName("Pink Ward")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.WARD, "와드", "...", "스테이지 중심 5x5의 방을 보여줍니다.")
    Astro:AddEIDCollectible(Astro.Collectible.PINK_WARD, "핑크 와드", "...", "스테이지 중심 5x5의 방을 보여줍니다.#숨어 있는 적을 아군으로 만듭니다.")
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

            if player:HasCollectible(Astro.Collectible.WARD) or player:HasCollectible(Astro.Collectible.PINK_WARD) then
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
        if collectibleType == Astro.Collectible.WARD or collectibleType == Astro.Collectible.PINK_WARD then
            DisplayWardRoom()
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    ---@param entityNPC EntityNPC
    function(_, entityNPC)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
        
            if player:HasCollectible(Astro.Collectible.PINK_WARD) then
                if entityNPC.Type == EntityType.ENTITY_NEEDLE or entityNPC.Type == EntityType.ENTITY_WIZOOB or entityNPC.Type == EntityType.ENTITY_RED_GHOST or entityNPC.Type == EntityType.ENTITY_POLTY then
                    entityNPC:AddEntityFlags(EntityFlag.FLAG_CHARM)
                    entityNPC:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
                end
            end

            break
        end
    end
)

