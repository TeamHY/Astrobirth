Astro.Collectible.BACHELORS_DEGREE = Isaac.GetItemIdByName("Bachelor's Degree")

if EID then
    EID:addCollectible(Astro.Collectible.BACHELORS_DEGREE, "{{Pill1}}Gulp!와 스탯 관련 알약만 등장합니다.", "학사학위")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued then
            Astro.Data.StatusPillWhitelist = {
                -- PillEffect.PILLEFFECT_HEALTH_DOWN,
                -- PillEffect.PILLEFFECT_HEALTH_UP,
                PillEffect.PILLEFFECT_RANGE_DOWN,
                PillEffect.PILLEFFECT_RANGE_UP,
                PillEffect.PILLEFFECT_SPEED_DOWN,
                PillEffect.PILLEFFECT_SPEED_UP,
                PillEffect.PILLEFFECT_TEARS_DOWN,
                PillEffect.PILLEFFECT_TEARS_UP,
                PillEffect.PILLEFFECT_LUCK_DOWN,
                PillEffect.PILLEFFECT_LUCK_UP,
                PillEffect.PILLEFFECT_GULP,
                PillEffect.PILLEFFECT_SHOT_SPEED_DOWN,
                PillEffect.PILLEFFECT_SHOT_SPEED_UP,
            }
        end
    end
)

---@param pillEffect PillEffect
---@return boolean
local function CheckWhitelist(pillEffect)
    for _, value in ipairs(Astro.Data.StatusPillWhitelist) do
        if value == pillEffect then
            return true
        end
    end

    return false
end

Astro:AddCallback(
    ModCallbacks.MC_GET_PILL_EFFECT,
    ---@param selectedPillEffect PillEffect
    ---@param pillColor PillColor
    function(_, selectedPillEffect, pillColor)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.BACHELORS_DEGREE) and not CheckWhitelist(selectedPillEffect) then
                local rng = player:GetCollectibleRNG(Astro.Collectible.BACHELORS_DEGREE)
                local index = rng:RandomInt(#Astro.Data.StatusPillWhitelist) + 1
                local newPillEffect = Astro.Data.StatusPillWhitelist[index]

                -- table.remove(Astro.Data.StatusPillWhitelist, index)

                return newPillEffect
            end
        end

        if CheckWhitelist(selectedPillEffect) then
            for index, value in ipairs(Astro.Data.StatusPillWhitelist) do
                if value == selectedPillEffect then
                    table.remove(Astro.Data.StatusPillWhitelist, index)
                    
                    return selectedPillEffect
                end
            end
        end
    end
)
