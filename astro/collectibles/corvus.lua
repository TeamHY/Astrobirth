local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.CORVUS = Isaac.GetItemIdByName("Corvus")

if EID then
    EID:addCollectible(Astro.Collectible.CORVUS, "게임 시간 20초마다 {{Card86}}Soul of Eve가 발동됩니다.#다음 게임 시작 시 {{Card86}}Soul of Eve을 하나 소환합니다.", "까마귀자리")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if Game():GetFrameCount() % 600 == 0 then
            if player:HasCollectible(Astro.Collectible.CORVUS) then
                player:UseCard(Card.CARD_SOUL_EVE)
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunCorvus then
            local player = Isaac.GetPlayer()
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TAROTCARD,
                Card.CARD_SOUL_EVE,
                currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                Vector.Zero,
                nil
            )

            Astro.Data.RunCorvus = false
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro.Data.RunCorvus = true
    end,
    Astro.Collectible.CORVUS
)

