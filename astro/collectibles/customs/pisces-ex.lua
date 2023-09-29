local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.PISCES_EX = Isaac.GetItemIdByName("Pisces EX")

if EID then
    EID:addCollectible(
        Astro.Collectible.PISCES_EX,
        "게임 시간 2분마다 {{Card57}}The Magician?가 발동됩니다.#다음 게임 시작 시 {{Card57}}The Magician?을 하나 소환합니다.",
        "초 물고기자리"
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if Game():GetFrameCount() % 3600 == 0 then
            if player:HasCollectible(Astro.Collectible.PISCES_EX) then
                player:UseCard(Card.CARD_REVERSE_MAGICIAN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunPiscesEX then
            local player = Isaac.GetPlayer()
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TAROTCARD,
                Card.CARD_REVERSE_MAGICIAN,
                currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                Vector.Zero,
                nil
            )

            Astro.Data.RunPiscesEX = false
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro.Data.RunPiscesEX = true
    end,
    Astro.Collectible.PISCES_EX
)
