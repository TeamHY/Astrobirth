Astro.Challenge = {
    CYGNUS = Isaac.GetChallengeIdByName("Cygnus [15m limited]"),
    LIBRA_EX = Isaac.GetChallengeIdByName("Libra EX [15m limited]"),
    CANCER_EX = Isaac.GetChallengeIdByName("Cancer EX [15m limited]"),
    SCORPIO_EX = Isaac.GetChallengeIdByName("Scorpio EX [15m limited]"),
}

local itemTable = {
    collectible = {
        -- CollectibleType.COLLECTIBLE_SAD_ONION,
        -- CollectibleType.COLLECTIBLE_SAD_ONION,
    },
    trinket = {
        -- TrinketType.TRINKET_SWALLOWED_PENNY,
        -- TrinketType.TRINKET_SWALLOWED_PENNY,
    },
    card = {
        -- Card.CARD_HOLY,
        -- Card.CARD_HOLY,
    },
    pill = {
        -- PillEffect.PILLEFFECT_BAD_GAS,
        -- PillEffect.PILLEFFECT_BAD_GAS,
    }
}

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if Astro.Data.Unlock == nil then
            Astro.Data.Unlock = {
                ChallengeCygnus = false,
                ChallengeLibraEX = false,
                ChallengeCancerEX = false,
                ChallengeScorpioEX = false,
            }
        end

        -- local itemPool = Game():GetItemPool()

        print("")
        print("Checking challenges...")

        if Astro.Data.Unlock.ChallengeCygnus ~= true then
            Astro.Data.Unlock.ChallengeCygnus = false

            -- itemPool:RemoveCollectible(AstroItems.Collectible.CYGNUS)
            print("Cygnus is not unlocked.")
        end

        if Astro.Data.Unlock.ChallengeLibraEX ~= true then
            Astro.Data.Unlock.ChallengeLibraEX = false

            -- itemPool:RemoveCollectible(AstroItems.Collectible.LIBRA_EX)
            print("Libra EX is not unlocked.")
        end

        if Astro.Data.Unlock.ChallengeCancerEX ~= true then
            Astro.Data.Unlock.ChallengeCancerEX = false

            -- itemPool:RemoveCollectible(AstroItems.Collectible.CANCER_EX)
            print("Cancer EX is not unlocked.")
        end

        if Astro.Data.Unlock.ChallengeScorpioEX ~= true then
            Astro.Data.Unlock.ChallengeScorpioEX = false

            -- itemPool:RemoveCollectible(AstroItems.Collectible.SCORPIO_EX)
            print("Scorpio EX is not unlocked.")
        end

        if Astro.Data.Unlock.ChallengeCygnus == true and Astro.Data.Unlock.ChallengeLibraEX == true and Astro.Data.Unlock.ChallengeCancerEX == true and Astro.Data.Unlock.ChallengeScorpioEX == true then
            print("All challenges are unlocked.")

            if not isContinued then
                local position = Isaac.GetPlayer().Position

                for _, value in ipairs(itemTable.collectible) do
                    Astro:SpawnCollectible(value, position)
                end

                for _, value in ipairs(itemTable.trinket) do
                    Astro:SpawnTrinket(value, position)
                end

                for _, value in ipairs(itemTable.card) do
                    Astro:SpawnCard(value, position)
                end

                for _, value in ipairs(itemTable.pill) do
                    Astro:SpawnPill(value, position)
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_PRE_PICKUP_COLLISION,
    ---@param entityPickup EntityPickup
    ---@param collider Entity
    ---@param low boolean
    function(_, entityPickup, collider, low)
        if entityPickup.Type == EntityType.ENTITY_PICKUP and entityPickup.Variant == PickupVariant.PICKUP_TROPHY then
            local challengeId = Isaac.GetChallenge()

            if challengeId == Astro.Challenge.CYGNUS then
                Astro.Data.Unlock.ChallengeCygnus = true
            elseif challengeId == Astro.Challenge.LIBRA_EX then
                Astro.Data.Unlock.ChallengeLibraEX = true
            elseif challengeId == Astro.Challenge.CANCER_EX then
                Astro.Data.Unlock.ChallengeCancerEX = true
            elseif challengeId == Astro.Challenge.SCORPIO_EX then
                Astro.Data.Unlock.ChallengeScorpioEX = true
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function()
        local challengeId = Isaac.GetChallenge()
        local timeCounter = Game().TimeCounter

        if challengeId == Astro.Challenge.CYGNUS and timeCounter >= 15 * Astro.MINUTE then
            for i = 1, Game():GetNumPlayers() do
                Isaac.GetPlayer(i - 1):Die()
            end
        elseif challengeId == Astro.Challenge.LIBRA_EX and timeCounter >= 15 * Astro.MINUTE then
            for i = 1, Game():GetNumPlayers() do
                Isaac.GetPlayer(i - 1):Die()
            end
        elseif challengeId == Astro.Challenge.CANCER_EX and timeCounter >= 15 * Astro.MINUTE then
            for i = 1, Game():GetNumPlayers() do
                Isaac.GetPlayer(i - 1):Die()
            end
        elseif challengeId == Astro.Challenge.SCORPIO_EX and timeCounter >= 15 * Astro.MINUTE then
            for i = 1, Game():GetNumPlayers() do
                Isaac.GetPlayer(i - 1):Die()
            end
        end
    end
)
