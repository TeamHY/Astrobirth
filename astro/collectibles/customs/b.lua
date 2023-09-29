local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.B = Isaac.GetItemIdByName("B")

if EID then
    EID:addCollectible(
        Astro.Collectible.B,
        "b - 알타일(Altair) : 획득 시 로스트 장신구와 라자루스 룬 소환, 다음 게임 시작 시 1스테이지 한정 스폰방(센터) 로스트가 되는 하얀불(33.4.0) 소환",
        "초 물고기자리"
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
        if Astro:IsFirstAdded(Astro.Collectible.B) then
            Astro:SpawnTrinket(TrinketType.TRINKET_MISSING_POSTER, player.Position)
            Astro:SpawnCard(Card.CARD_SOUL_LAZARUS, player.Position)
        end

        Astro.Data.RunAltair = true
    end,
    Astro.Collectible.B
)
