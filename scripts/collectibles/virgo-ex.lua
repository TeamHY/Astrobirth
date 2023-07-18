Astrobirth.Collectible.VIRGO_EX = Isaac.GetItemIdByName("Virgo EX")

if EID then
    EID:addCollectible(Astrobirth.Collectible.VIRGO_EX, "다음 게임 시작 시 {{Planetarium}}행성방으로 이동됩니다", "초 처녀자리")
end

Astrobirth:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astrobirth.Data.GoPlanetarium then
            local player = Isaac.GetPlayer()
            local collectibleRNG = player:GetCollectibleRNG(Astrobirth.Collectible.VIRGO_EX)

            Isaac.ExecuteCommand("goto s.planetarium." .. collectibleRNG:RandomInt(7))
            Astrobirth.Data.GoPlanetarium = false
        end
    end
)

Astrobirth:AddCallback(
    ModCallbacks.MC_POST_GAME_END,
    ---@param isGameOver boolean
    function(_, isGameOver)
        local player = Isaac.GetPlayer(0)

        if player:HasCollectible(Astrobirth.Collectible.VIRGO_EX) then
            Astrobirth.Data.GoPlanetarium = true
        end
    end
)
