local virgoEX = {}

---comment
---@param isContinued boolean
function virgoEX:OnPostGameStarted(isContinued)
    if not isContinued and Redrawn.Data.Storage.GoPlanetarium then
        local player = Isaac.GetPlayer()
        local collectibleRNG = player:GetCollectibleRNG(Redrawn.Collectible.VirgoEX)

        Isaac.ExecuteCommand("goto s.planetarium." .. collectibleRNG:RandomInt(7))
        Redrawn.Data.Storage.GoPlanetarium = false
    end
end

Redrawn:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, virgoEX.OnPostGameStarted)

---comment
---@param isGameOver boolean
function virgoEX:OnPostGameEnd(isGameOver)
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(Redrawn.Collectible.VirgoEX) then
        Redrawn.Data.Storage.GoPlanetarium = true
    end
end

Redrawn:AddCallback(ModCallbacks.MC_POST_GAME_END, virgoEX.OnPostGameEnd)
