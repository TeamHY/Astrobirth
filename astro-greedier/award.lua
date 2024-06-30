local function RunAward(wave)
    if Astro.Data["lastGreedAwardWave"] == wave then
        return
    end

    Astro.Data["lastGreedAwardWave"] = wave

    if not Astro.Data["greedierPenalty"] then
        if wave == 3 then
            Isaac.ExecuteCommand("spawn 5.20.3")
            Isaac.ExecuteCommand("spawn 5.20.3")
        elseif wave == 6 then
            Isaac.ExecuteCommand("spawn 5.20.3")
            Isaac.ExecuteCommand("spawn 5.20.3")
        elseif wave == 9 then
            Isaac.ExecuteCommand("spawn 5.20.3")
            Isaac.ExecuteCommand("spawn 5.20.3")
        elseif wave == 10 then
            Isaac.ExecuteCommand("spawn 5.20.3")
            Isaac.ExecuteCommand("spawn 5.20.3")
        elseif wave == 11 then
            Isaac.ExecuteCommand("spawn 5.20.3")
            Isaac.ExecuteCommand("spawn 5.20.3")
        elseif wave == 12 then
            Isaac.ExecuteCommand("spawn 5.20.3")
            Isaac.ExecuteCommand("spawn 5.20.3")
        end
    end
end

Astro:AddCallback(
    AstroItems.Callbacks.POST_NEW_GREED_WAVE,
    ---@param wave integer
    function(_, wave)
        RunAward(wave - 1)

        if wave == 4 or wave == 7 or wave == 10 or wave == 11 or wave == 12 then
            Astro.Data["greedierPenalty"] = false
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued then
            Astro.Data["greedierPenalty"] = false
        end
    end
)

Astro:AddCallback(
    AstroItems.Callbacks.POST_NEW_STAGE,
    ---@param stage LevelStage
    function(_, stage)
        Astro.Data["greedierPenalty"] = false
    end
)

Astro:AddCallback(
    AstroItems.Callbacks.PLAYER_TAKE_PENALTY,
    ---@param player EntityPlayer
    function(_, player)
        Astro.Data["greedierPenalty"] = true
    end
)

Astro:AddCallback(
	ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
	---@param rng RNG
	---@param spawnPosition Vector
	function(_, rng, spawnPosition)
        RunAward(Game():GetLevel().GreedModeWave)
    end
)
