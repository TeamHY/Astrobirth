local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.AMAZING_CHAOS_SCROLL = Isaac.GetItemIdByName("Amazing Chaos Scroll")

if EID then
    Astro:AddEIDCollectible(
        Astro.Collectible.AMAZING_CHAOS_SCROLL,
        "놀라운 혼돈의 주문서",
        "...",
        "{{UnknownHeart}} 최대 체력, 소울하트, 블랙하트 중 하나 +1" ..
        "#{{ArrowUp}} {{SpeedSmall}}이동속도 배율 x1.1~1.5" ..
        "#{{ArrowUp}} {{TearsSmall}}공격 딜레이 ÷1.1~1.5" ..
        "#{{ArrowUp}} {{DamageSmall}}공격력 배율 x1.1~1.5" ..
        "#{{ArrowUp}} {{RangeSmall}}사거리 배율 x1.1~1.5" ..
        "#{{ArrowUp}} {{ShotspeedSmall}}탄속 배율 x1.1~1.5" ..
        "#{{ArrowUp}} {{LuckSmall}}행운 배율 x1.1~1.5"
        "#{{ArrowUp}} {{LuckSmall}}행운 배율 x1.1~1.5" ..
        "#!!! 해당 아이템의 체력은 즉시 들어오지 않으며, 거래 후 체력이 없을경우 사망합니다"
    )
end

local milkshake = {}

local PINK_TEAR_COLOR = Color(1, 0, 1, 1, 0.196, 0, 0)
local STAT_COUNTER_DURATION = 150
local STAT_COUNTER_MOVEMENT_DURATION = 10
local STAT_COUNTER_FADING_DURATION = 40
local StatsFont = Font()                   -- init font object
StatsFont:Load("font/luaminioutlined.fnt") -- load a font into the font object

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued then
            Astro.Data.MilkshakeMultiplierFramePerPlayer = {}
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        Astro.Data.MilkshakeMultiplierFramePerPlayer = {}
    end
)

--- Checks if a player is the main player, i.e. the one who started the run.
--- Useful because it's the only one whose stats are rendered.
---@param player EntityPlayer
---@return boolean
local function IsFirstPlayer(player)
    local mainTwin = player:GetMainTwin()
    local playerIndex = isc:getPlayerIndex(mainTwin)

    local firstPlayer = Isaac.GetPlayer()
    local firstPlayerIndex = isc:getPlayerIndex(firstPlayer)

    return playerIndex == firstPlayerIndex
end

---Checks if a player's stats are in the found HUD.
---@param player EntityPlayer
---@return boolean
local function IsPlayerShowingStatsUI(player)
    --Child players never show stats
    if isc:isChildPlayer(player) then return false end

    --The first player always shows their stats
    if IsFirstPlayer(player) then return true end

    --If the first player is jacob and esau, the player 2 stats don't show
    local firstPlayer = Isaac.GetPlayer()
    if firstPlayer:GetPlayerType() == PlayerType.PLAYER_JACOB then return false end

    local initialControllerIndex = firstPlayer.ControllerIndex
    local mainSecondPlayer = nil
    for i = 0, Game():GetNumPlayers() - 1, 1 do
        local otherPlayer = Game():GetPlayer(i)
        local otherControllerIndex = otherPlayer.ControllerIndex

        if initialControllerIndex ~= otherControllerIndex then
            mainSecondPlayer = otherPlayer
            break
        end
    end

    if not mainSecondPlayer then return false end

    local playerIndex = isc:getPlayerIndex(player)
    local secondPlayerIndex = isc:getPlayerIndex(mainSecondPlayer)

    return playerIndex == secondPlayerIndex
end

---Checks if there is more than one real player in the run
---@return boolean
local function IsMultiplayer()
    local players = isc:getPlayers()

    local firstPlayer = Isaac.GetPlayer()
    local initialControllerIndex = firstPlayer.ControllerIndex

    return isc:some(players, function(player)
        if not player then
            return false
        end

        return initialControllerIndex ~= player.ControllerIndex
    end)
end

---Checks if any player is the given player type
---@param character PlayerType
---@return boolean
local function AnyPlayerIsCharacter(character)
    local players = isc:getPlayers()

    return isc:some(players, function(player)
        if not player then
            return false
        end

        return player:GetPlayerType() == character
    end)
end

---@param rng RNG
---@param itemNum integer
local function GetStatMultiplier(rng, itemNum)
    local baseMultiplier = isc:getRandomFloat(1.1, 1.5, rng)
    local totalMultiplier = 1

    for _ = 1, itemNum, 1 do
        totalMultiplier = totalMultiplier * baseMultiplier
    end

    return totalMultiplier
end


---@param player EntityPlayer
---@param cacheFlag CacheFlag
function milkshake:onCache(player, cacheFlag)
    if not player:HasCollectible(Astro.Collectible.AMAZING_CHAOS_SCROLL) then return end

    local rng = isc:copyRNG(player:GetCollectibleRNG(Astro.Collectible.AMAZING_CHAOS_SCROLL))
    local itemNum = player:GetCollectibleNum(Astro.Collectible.AMAZING_CHAOS_SCROLL)

    local MilkShakeSpeed = GetStatMultiplier(rng, itemNum)
    local MilkShakeTears = GetStatMultiplier(rng, itemNum)
    local MilkShakeDamage = GetStatMultiplier(rng, itemNum)
    local MilkShakeRange = GetStatMultiplier(rng, itemNum)
    local MilkShakeShotSpeed = GetStatMultiplier(rng, itemNum)
    local MilkShakeLuck = GetStatMultiplier(rng, itemNum)

    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = ((player.MaxFireDelay + 1) / MilkShakeTears) - 1
    end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * MilkShakeDamage
    end

    if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed * MilkShakeSpeed
    end

    if cacheFlag == CacheFlag.CACHE_LUCK and player.Luck > 0 then
        player.Luck = player.Luck * MilkShakeLuck
    end

    if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange * MilkShakeRange
    end

    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed * MilkShakeShotSpeed
    end

    if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
        player.TearColor = PINK_TEAR_COLOR
    end
end

Astro:AddPriorityCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    CallbackPriority.LATE + 2000, --Very low priority so the multiplier works with mods
    milkshake.onCache
)


---@param player EntityPlayer
---@param firstTime boolean
function milkshake:OnMilkshakeAdded(player, _, firstTime)
    if IsPlayerShowingStatsUI(player) then
        local playerIndex = isc:getPlayerIndex(player)

        if not Astro.Data.MilkshakeMultiplierFramePerPlayer then
            Astro.Data.MilkshakeMultiplierFramePerPlayer = {}
        end

        local multiplierCounterFramesPerPlayer = Astro.Data.MilkshakeMultiplierFramePerPlayer
        multiplierCounterFramesPerPlayer[playerIndex] = Game():GetFrameCount()
    end

    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B and not firstTime then return end

    local rng = isc:copyRNG(player:GetCollectibleRNG(Astro.Collectible.AMAZING_CHAOS_SCROLL))
    local itemNum = player:GetCollectibleNum(Astro.Collectible.AMAZING_CHAOS_SCROLL)

    for _ = 1, itemNum, 1 do
        rng:Next()
    end

    local chosenHeart = rng:RandomInt(3)

    if chosenHeart == 0 then
        player:AddMaxHearts(2)
        player:AddHearts(2)
    elseif chosenHeart == 1 then
        player:AddSoulHearts(2)
    elseif chosenHeart == 2 then
        player:AddBlackHearts(2)
    end
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    milkshake.OnMilkshakeAdded,
    Astro.Collectible.AMAZING_CHAOS_SCROLL
)


---@param mult number
---@param pos Vector
local function RenderStat(mult, pos, alpha)
    local value = string.format("x%.2f", mult)
    pos = pos + (Options.HUDOffset * Vector(20, 12))
    pos = pos + Game().ScreenShakeOffset

    StatsFont:DrawString(
        value,
        pos.X,
        pos.Y,
        KColor(255 / 255, 153 / 255, 255 / 255, alpha),
        0,
        true
    )
end


local function IsDisplayingMultiplayerStats()
    return IsMultiplayer() and not isc:isJacobOrEsau(Isaac.GetPlayer())
end

---@param player EntityPlayer
---@param startingFrame integer
---@return boolean
local function RenderMultiplier(player, startingFrame)
    local currentFrame = Game():GetFrameCount()
    local duration = currentFrame - startingFrame

    if duration >= STAT_COUNTER_DURATION then return true end

    if not Options.FoundHUD then return false end

    if not player:HasCollectible(Astro.Collectible.AMAZING_CHAOS_SCROLL) then return true end

    local rng = isc:copyRNG(player:GetCollectibleRNG(Astro.Collectible.AMAZING_CHAOS_SCROLL))
    local itemNum = player:GetCollectibleNum(Astro.Collectible.AMAZING_CHAOS_SCROLL)

    local statMultipliers = {
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum)
    }

    local baseXPos = 75
    local baseYPos = 87
    local alpha = 0.5

    if IsDisplayingMultiplayerStats() then
        if IsFirstPlayer(player) then
            baseYPos = baseYPos - 4
        else
            baseYPos = baseYPos + 4
        end
    end

    if Game().Challenge == Challenge.CHALLENGE_NULL
        and Game().Difficulty == Difficulty.DIFFICULTY_NORMAL then
        -- and TSIL.Run.CanRunUnlockAchievements() then
        --If there are no symbols (Hard mode, greed, achievements disabled, etc..) move the ui up
        baseYPos = baseYPos - 15.5
    end

    if AnyPlayerIsCharacter(PlayerType.PLAYER_BETHANY) then
        --If the player is playing bethany, account for the soul charge
        baseYPos = baseYPos + 10
    end

    if AnyPlayerIsCharacter(PlayerType.PLAYER_BETHANY_B) then
        --If the player is playing T.bethany, account for the red health charge
        baseYPos = baseYPos + 10
    end

    if AnyPlayerIsCharacter(PlayerType.PLAYER_BLUEBABY_B) and IsMultiplayer() then
        --If there is a t.blue baby and playing coop poop is separate from bombs
        baseYPos = baseYPos + 10
    end

    if isc:isJacobOrEsau(Isaac.GetPlayer()) then
        --If the main player is jacob and esau lower it a bit
        baseYPos = baseYPos + 16
    end

    if duration <= STAT_COUNTER_MOVEMENT_DURATION then
        local percent = duration / STAT_COUNTER_MOVEMENT_DURATION
        local movementPercent = isc:easeOutSine(percent)

        local XOffset = isc:lerp(20, 0, movementPercent)
        baseXPos = baseXPos - XOffset

        alpha = isc:lerp(0, 0.5, percent)
    end

    if STAT_COUNTER_DURATION - duration <= STAT_COUNTER_FADING_DURATION then
        local percent = (STAT_COUNTER_DURATION - duration) / STAT_COUNTER_FADING_DURATION

        alpha = isc:lerp(0, 0.5, percent)
    end

    for index, mult in ipairs(statMultipliers) do
        RenderStat(mult, Vector(baseXPos, baseYPos), alpha)

        if IsDisplayingMultiplayerStats() then
            baseYPos = baseYPos + 14
        else
            if index == 1 and player:GetPlayerType() == PlayerType.PLAYER_JACOB then
                baseYPos = baseYPos + 8
            elseif index == 1 and player:GetPlayerType() == PlayerType.PLAYER_ESAU then
                baseYPos = baseYPos + 16
            elseif isc:isJacobOrEsau(player) then
                baseYPos = baseYPos + 14
            else
                baseYPos = baseYPos + 12
            end
        end
    end

    return false
end


function milkshake:OnRender()
    if not Astro.Data.MilkshakeMultiplierFramePerPlayer then
        Astro.Data.MilkshakeMultiplierFramePerPlayer = {}
    end

    local multiplierCounterFramesPerPlayer = Astro.Data.MilkshakeMultiplierFramePerPlayer

    for playerIndex, startingFrame in pairs(multiplierCounterFramesPerPlayer) do
        local player = isc:getPlayerFromIndex(playerIndex)
        if not player then
            multiplierCounterFramesPerPlayer[playerIndex] = nil
        else
            if RenderMultiplier(player, startingFrame) then
                multiplierCounterFramesPerPlayer[playerIndex] = nil
            end
        end
    end
end

Astro:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    milkshake.OnRender
)
