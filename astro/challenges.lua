Astro.Challenge = {
    CYGNUS = Isaac.GetChallengeIdByName("Cygnus"),
    LIBRA_EX = Isaac.GetChallengeIdByName("Libra EX"),
    CANCER_EX = Isaac.GetChallengeIdByName("Cancer EX"),
    SCORPIO_EX = Isaac.GetChallengeIdByName("Scorpio EX"),
}

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued then
            if Astro.Data.Unlock == nil then
                Astro.Data.Unlock = {
                    ChallengeCygnus = false,
                    ChallengeLibraEX = false,
                    ChallengeCancerEX = false,
                    ChallengeScorpioEX = false,
                }
            end

            local itemPool = Game():GetItemPool()
    
            if Astro.Data.Unlock.ChallengeCygnus ~= true then
                Astro.Data.Unlock.ChallengeCygnus = false

                itemPool:RemoveCollectible(Astro.Collectible.CYGNUS)
            end

            if Astro.Data.Unlock.ChallengeLibraEX ~= true then
                Astro.Data.Unlock.ChallengeLibraEX = false

                itemPool:RemoveCollectible(Astro.Collectible.LIBRA_EX)
            end

            if Astro.Data.Unlock.ChallengeCancerEX ~= true then
                Astro.Data.Unlock.ChallengeCancerEX = false

                itemPool:RemoveCollectible(Astro.Collectible.CANCER_EX)
            end

            if Astro.Data.Unlock.ChallengeScorpioEX ~= true then
                Astro.Data.Unlock.ChallengeScorpioEX = false

                itemPool:RemoveCollectible(Astro.Collectible.SCORPIO_EX)
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function()
        if Isaac.GetChallenge then
            if Game().TimeCounter >= 18 * 30 * 60 then
                for i = 1, Game():GetNumPlayers() do
                    Isaac.GetPlayer(i - 1):Die()
                end
            end
        end
    end
)
