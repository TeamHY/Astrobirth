local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.ALTAIR = Isaac.GetItemIdByName("Altair")

if EID then
    EID:addCollectible(
        Astro.Collectible.ALTAIR,
        "획득 시 {{Trinket23}}Missing Poster와 {{Card89}}Soul of Lazarus를 소환합니다.#다음 게임 시작 시 하얀불을 소환합니다.",
        "알타일"
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunAltair then
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            Isaac.Spawn(EntityType.ENTITY_FIREPLACE, 4, 0, currentRoom:GetCenterPos(), Vector.Zero, nil)

            Astro.Data.RunAltair = false
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(Astro.Collectible.ALTAIR) then
            Astro:SpawnTrinket(TrinketType.TRINKET_MISSING_POSTER, player.Position)
            Astro:SpawnCard(Card.CARD_SOUL_LAZARUS, player.Position)
        end

        Astro.Data.RunAltair = true
    end,
    Astro.Collectible.ALTAIR
)
