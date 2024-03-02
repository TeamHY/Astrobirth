local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.CORVUS = Isaac.GetItemIdByName("Corvus")

if EID then
    -- 20초 -> 10초 -> 6.66초
    Astro:AddEIDCollectible(Astro.Collectible.CORVUS, "까마귀자리", "...", "게임 시간 10초마다 {{Card86}}Soul of Eve가 발동됩니다.#중첩 시 발동 간격이 줄어듭니다.#다음 게임 시작 시 {{Card86}}Soul of Eve을 하나 소환합니다.#중첩이 가능합니다.")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if player:HasCollectible(Astro.Collectible.CORVUS) then
            if Game():GetFrameCount() % math.floor(300 / player:GetCollectibleNum(Astro.Collectible.CORVUS)) == 0 then
                player:UseCard(Card.CARD_SOUL_EVE, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.CorvusCount ~= nil and Astro.Data.CorvusCount > 0 then
            local player = Isaac.GetPlayer()
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            for _ = 1, Astro.Data.CorvusCount do
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_TAROTCARD,
                    Card.CARD_SOUL_EVE,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                    Vector.Zero,
                    nil
                )
            end

            Astro.Data.CorvusCount = 0
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro.Data.CorvusCount = player:GetCollectibleNum(Astro.Collectible.CORVUS)
    end,
    Astro.Collectible.CORVUS
)
