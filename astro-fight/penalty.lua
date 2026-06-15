---

local MAX_PENALTY_COUNT = 3

local SPEED_DECREMENT = -0.1
local TEARS_DECREMENT = -0.1
local DAMAGE_DECREMENT = -0.1
local RANGE_DECREMENT = -1
local LUCK_DECREMENT = -1

---

local PENALTY_COUNT_KEY = "holyShieldPenaltyCount"
local SHIELD_TRACKER_KEY = "holyShieldPenaltyTracker"

local function HasHolyCardShield(player)
    return NullItemID and
        NullItemID.ID_HOLY_CARD and
        player:GetEffects():HasNullEffect(NullItemID.ID_HOLY_CARD)
end

local function GetHolyShieldCount(player)
    return player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
end

local function GetHolyShieldState(player)
    return {
        count = GetHolyShieldCount(player),
        hasHolyCard = HasHolyCardShield(player) == true
    }
end

local function SyncHolyShieldTracker(player)
    local data = Astro:GetPersistentPlayerData(player)

    data[SHIELD_TRACKER_KEY] = GetHolyShieldState(player)
end

local function ApplyPenalty(player, amount)
    local data = Astro:GetPersistentPlayerData(player)
    local currentCount = data[PENALTY_COUNT_KEY] or 0
    local nextCount = math.min(currentCount + amount, MAX_PENALTY_COUNT)

    if nextCount == currentCount then
        return
    end

    data[PENALTY_COUNT_KEY] = nextCount

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end

local function ResetPenalty(player)
    local data = Astro:GetPersistentPlayerData(player)

    if data == nil then
        return
    end

    if (data[PENALTY_COUNT_KEY] or 0) == 0 then
        SyncHolyShieldTracker(player)
        return
    end

    data[PENALTY_COUNT_KEY] = nil

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()

    SyncHolyShieldTracker(player)
end

local function GetBrokenShieldCount(previousState, currentState)
    local previousCount = previousState.count or 0
    local currentCount = currentState.count or 0
    local brokenCount = math.max(previousCount - currentCount, 0)

    if previousState.hasHolyCard and not currentState.hasHolyCard then
        brokenCount = math.max(brokenCount, 1)
    end

    return brokenCount
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            ResetPenalty(Isaac.GetPlayer(i - 1))
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        local data = Astro:GetPersistentPlayerData(player)
        local previousState = data[SHIELD_TRACKER_KEY]
        local currentState = GetHolyShieldState(player)

        if previousState == nil then
            data[SHIELD_TRACKER_KEY] = currentState
            return
        end

        local brokenCount = GetBrokenShieldCount(previousState, currentState)

        if brokenCount > 0 then
            local currentRoomDesc = Game():GetLevel():GetCurrentRoomDesc()
            if currentRoomDesc.Data.Name == "Beast Room" then
                player:Kill()
            end

            ApplyPenalty(player, brokenCount)
        end

        data[SHIELD_TRACKER_KEY] = currentState
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        local data = Astro:GetPersistentPlayerData(player)
        local penaltyCount = data[PENALTY_COUNT_KEY] or 0

        if penaltyCount <= 0 then
            return
        end

        if cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + SPEED_DECREMENT * penaltyCount
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = Astro:AddTears(player.MaxFireDelay, TEARS_DECREMENT * penaltyCount)
        elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + DAMAGE_DECREMENT * penaltyCount
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + RANGE_DECREMENT * penaltyCount
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + LUCK_DECREMENT * penaltyCount
        end
    end
)
--[[
Astro:AddCallback(
    ModCallbacks.MC_INPUT_ACTION,
    ---@param entity Entity
    ---@param inputHook InputHook
    ---@param buttonAction ButtonAction
    function(_, entity, inputHook, buttonAction)
        local room = Game():GetRoom()
        local bossID = roomGetBossID()
        
        if bossID == 55 or bossID == 70 or bossID == 71 or bossID == 100 then
            if inputHook == 0 or inputHook == 1 then
                if buttonAction == ButtonAction.ACTION_MENUBACK or buttonAction == ButtonAction.ACTION_PAUSE or buttonAction == ButtonAction.ACTION_CONSOLE then
                    return false
                end
            end
        end
    end
)]]
