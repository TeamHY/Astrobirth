Astro.Callbacks = {
    POST_NEW_STAGE = "ASTRO_POST_NEW_STAGE",
    POST_NEW_GREED_WAVE = "ASTRO_POST_NEW_GREED_WAVE",
    PLAYER_TAKE_PENALTY = "ASTRO_PLAYER_TAKE_PENALTY"
}

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued then
            Astro.Data["lastStage"] = LevelStage.STAGE_NULL
            Astro.Data["lastGreedWave"] = 0
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        local stage = Game():GetLevel():GetStage()

        if Astro.Data["lastStage"] ~= stage then
            Astro.Data["lastStage"] = stage
            Astro.Data["lastGreedWave"] = 0

            Isaac.RunCallback(Astro.Callbacks.POST_NEW_STAGE, stage)
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        local wave = Game():GetLevel().GreedModeWave

        if Astro.Data["lastGreedWave"] ~= wave then
            Isaac.RunCallback(Astro.Callbacks.POST_NEW_GREED_WAVE, wave)
        end

        Astro.Data["lastGreedWave"] = wave
    end
)

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = entity:ToPlayer()

        if player ~= nil then
            if damageFlags & (DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS) == 0 then
                Isaac.RunCallback(Astro.Callbacks.PLAYER_TAKE_PENALTY, player)
            end
        end
    end
)
