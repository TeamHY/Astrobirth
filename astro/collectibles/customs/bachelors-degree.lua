Astro.Collectible.BACHELORS_DEGREE = Isaac.GetItemIdByName("Bachelor's Degree")

if EID then
    EID:addCollectible(Astro.Collectible.BACHELORS_DEGREE, "{{Pill1}}Gulp!와 스탯 관련 알약만 등장합니다.#알약의 효과를 보여줍니다.", "학사학위")
end

local whitelist = {
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

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued then
            Astro.Data.Pills = {}
        end
    end
)

---@param pillEffect PillEffect
---@return boolean
local function CheckWhitelist(pillEffect)
    for _, value in ipairs(whitelist) do
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
        if not Astro.Data.Pills then
            return selectedPillEffect
        end

        if Astro.Data.Pills[pillColor] then
            return Astro.Data.Pills[pillColor]
        end

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.BACHELORS_DEGREE) then
                if CheckWhitelist(selectedPillEffect) then
                    Astro.Data.Pills[pillColor] = selectedPillEffect
                else
                    local rng = player:GetCollectibleRNG(Astro.Collectible.BACHELORS_DEGREE)
                    local index = rng:RandomInt(#whitelist) + 1
                    local newPillEffect = whitelist[index]
    
                    Astro.Data.Pills[pillColor] = newPillEffect
                end

                return Astro.Data.Pills[pillColor]
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if pickup.Variant == PickupVariant.PICKUP_PILL then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasCollectible(Astro.Collectible.BACHELORS_DEGREE) then
                    Game():GetItemPool():IdentifyPill(pickup.SubType)
                    break
                end
            end
        end
    end
)
