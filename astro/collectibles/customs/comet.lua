local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.COMET = Isaac.GetItemIdByName("Comet")

if EID then
    Astro:AddEIDCollectible(
        Astro.Collectible.COMET,
        "혜성",
        "...",
        "획득  {{Card78}}Cracked Key가 하나 드랍됩니다.#다음 게임 시작 시 {{Card78}}Cracked Key을 하나 소환합니다.#중첩이 가능합니다.#맵에 {{UltraSecretRoom}}특급 비밀방의 위치가 표시됩니다."
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
        if not isContinued and Astro.Data.CometCount ~= nil and Astro.Data.CometCount > 0 then
            local player = Isaac.GetPlayer()
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            for _ = 1, Astro.Data.CometCount do
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_TAROTCARD,
                    Card.CARD_CRACKED_KEY,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                    Vector.Zero,
                    nil
                )
            end

            Astro.Data.CometCount = 0
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

        Astro.Data.CometCount = player:GetCollectibleNum(Astro.Collectible.COMET)
    end,
    Astro.Collectible.COMET
)
