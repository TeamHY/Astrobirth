Astro.Collectible.VIRGO_EX = Isaac.GetItemIdByName("Virgo EX")

if EID then
    EID:addCollectible(Astro.Collectible.VIRGO_EX, "다음 게임 시작 시 {{Planetarium}}행성방으로 이동됩니다", "초 처녀자리")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.GoPlanetarium then
            local player = Isaac.GetPlayer()
            local collectibleRNG = player:GetCollectibleRNG(Astro.Collectible.VIRGO_EX)

            Isaac.ExecuteCommand("goto s.planetarium." .. collectibleRNG:RandomInt(7))
            Astro.Data.GoPlanetarium = false
        end
    end
)

-- 최적화 필요
Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.VIRGO_EX) then
                Astro.Data.GoPlanetarium = true
            end
        end
    end
)

-- Astrobirth:AddCallback(
--     ModCallbacks.MC_POST_GAME_END,
--     ---@param isGameOver boolean
--     function(_, isGameOver)
--         local player = Isaac.GetPlayer(0)

--         if player:HasCollectible(Astrobirth.Collectible.VIRGO_EX) then
--             Astrobirth.Data.GoPlanetarium = true
--         end
--     end
-- )
