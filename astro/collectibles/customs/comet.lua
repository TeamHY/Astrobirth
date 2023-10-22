-- Comet(혜성) : 획득 시 레드 키 조각이 1개 떨어지며, 다음 게임 시작 시 레드 키 조각이 한개 떨어집니다 + 해당 아이템 소지 시 게임 끝날때까지 스테이지에 레드방 위치를 표시

local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.COMET = Isaac.GetItemIdByName("Comet")

if EID then
    EID:addCollectible(
        Astro.Collectible.COMET,
        "획득 시 {{Card78}}Cracked Key가 하나 드랍됩니다.#다음 게임 시작 시 {{Card78}}Cracked Key을 하나 소환합니다.#맵에 {{UltraSecretRoom}}특급 비밀방의 위치가 표시됩니다.",
        "혜성"
    )
end

-- https://steamcommunity.com/sharedfiles/filedetails/?id=2557887449
local function DisplayUltraSecretRoom()
    local level = Game():GetLevel()

    for i = 0, 169 do
        local room = level:GetRoomByIdx(i)

        if room.Data and room.Data.Type == RoomType.ROOM_ULTRASECRET then
            room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX | RoomDescriptor.DISPLAY_ICON
            level:UpdateVisibility()
            return
        end
    end
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunComet then
            local player = Isaac.GetPlayer()
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TAROTCARD,
                Card.CARD_CRACKED_KEY,
                currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                Vector.Zero,
                nil
            )

            Astro.Data.RunComet = false
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.COMET) then
                DisplayUltraSecretRoom()
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
        if Astro:IsFirstAdded(Astro.Collectible.COMET) then
            Astro:SpawnCard(Card.CARD_CRACKED_KEY, player.Position)
        end

        DisplayUltraSecretRoom()

        Astro.Data.RunComet = true
    end,
    Astro.Collectible.COMET
)
