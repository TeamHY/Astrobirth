Redrawn.Collectible.VIRGO_EX = Isaac.GetItemIdByName("Virgo EX")

if EID then
    EID:addCollectible(Redrawn.Collectible.VIRGO_EX, "다음 게임 시작 시 {{Planetarium}}행성방으로 이동됩니다", "초 처녀자리")
end

Redrawn:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Redrawn.Data.GoPlanetarium then
            local player = Isaac.GetPlayer()
            local collectibleRNG = player:GetCollectibleRNG(Redrawn.Collectible.VIRGO_EX)

            Isaac.ExecuteCommand("goto s.planetarium." .. collectibleRNG:RandomInt(7))
            Redrawn.Data.GoPlanetarium = false
        end
    end
)

Redrawn:AddCallback(
    ModCallbacks.MC_POST_GAME_END,
    ---@param isGameOver boolean
    function(_, isGameOver)
        local player = Isaac.GetPlayer(0)

        if player:HasCollectible(Redrawn.Collectible.VIRGO_EX) then
            Redrawn.Data.GoPlanetarium = true
        end
    end
)
