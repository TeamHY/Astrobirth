local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.D = Isaac.GetItemIdByName("D")

if EID then
    EID:addCollectible(
        Astro.Collectible.D,
        "-- d - 베가(Vega) : 획득 시 더블 액티브(534), 더블 장신구(458), 더블 포겟(454) 3개가 등장하며 하나를 획득하면 나머지 제거, 다음 게임 시작 시 안수즈 룬 1개 소환",
        "초 물고기자리"
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunVega then
            local player = Isaac.GetPlayer()

            Astro:SpawnCard(Card.RUNE_ANSUZ, player.Position)

            Astro.Data.RunVega = false
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG, player.Position + Vector(40 * -2, -40), Astro.Collectible.D)
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_BELLY_BUTTON, player.Position + Vector(40 * -2, -40), Astro.Collectible.D)
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY, player.Position + Vector(40 * -2, -40), Astro.Collectible.D)

        Astro.Data.RunVega = true
    end,
    Astro.Collectible.D
)
