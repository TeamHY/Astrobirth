-- Comet(혜성) : 획득 시 레드 키 조각이 1개 떨어지며, 다음 게임 시작 시 레드 키 조각이 한개 떨어집니다 + 해당 아이템 소지 시 게임 끝날때까지 스테이지에 레드방 위치를 표시

local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.COMET = Isaac.GetItemIdByName("Comet")

if EID then
    EID:addCollectible(Astro.Collectible.COMET, "획득 시 {{Card78}}Cracked Key가 하나 드랍됩니다.#(미구현) {{ColorBlack}}맵에 {{UltraSecretRoom}}특급 비밀방의 위치가 표시됩니다.#다음 게임 시작 시 {{Card78}}Cracked Key을 하나 소환합니다.", "혜성")
end

-- TODO: 획득 시와 스테이지 입장 시로 변경
Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if player:HasCollectible(Astro.Collectible.COMET) then
            local level = Game():GetLevel()
            local idx = level:QueryRoomTypeIndex(RoomType.ROOM_ULTRASECRET, false, RNG())
            local room = level:GetRoomByIdx(idx)
    
            if room.Data.Type == RoomType.ROOM_ULTRASECRET then
                room.DisplayFlags = room.DisplayFlags | 1 << 2
                level:UpdateVisibility()
            end
        end
    end
)

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

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro.Data.RunComet = true
    end,
    Astro.Collectible.COMET
)
