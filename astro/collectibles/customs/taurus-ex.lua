Astro.Collectible.TAURUS_EX = Isaac.GetItemIdByName("Taurus EX")

if EID then
    Astro:AddEIDCollectible(
        Astro.Collectible.TAURUS_EX,
        "초 황소자리",
        "...",
        "중첩이 가능합니다.#방 입장 시 아래 효과 중 한가지가 적용됩니다.#{{Tears}}연사(상한+2) 증가됩니다.#{{Damage}}공격력이 +2 증가됩니다. ({{Collectible34}} 액티브와 동일) #{{Speed}}이동 속도가 최대로 고정됩니다. 이미 최대일 경우 이 효과가 선택되지 않습니다.#유도 특성이 적용됩니다. ({{Collectible192}} 액티브와 동일)"
    )
end

local effects = {
    ---@param player EntityPlayer
    [0] = function(player)
        for _ = 1, player:GetCollectibleNum(Astro.Collectible.TAURUS_EX) do
            player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, false, true, false, false)
        end
    end,
    ---@param player EntityPlayer
    [1] = function(player)
        for _ = 1, player:GetCollectibleNum(Astro.Collectible.TAURUS_EX) do
            player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPATHY_BOOK, false, true, false, false)
        end
    end,
    ---@param player EntityPlayer
    [2] = function(player)
    end,
    ---@param player EntityPlayer
    [3] = function(player)
    end
}

---@param player EntityPlayer
local function checkMaxSpeed(player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MERCURIUS) then
        if player.MoveSpeed >= 1.4 then
            return true
        end
    else
        if player.MoveSpeed >= 2 then
            return true
        end
    end

    return false
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function()
        ---@type EntityPlayer
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.TAURUS_EX) then
                local data = player:GetData()

                if data.Taurus == nil then
                    data.Taurus = {
                        Key = -1
                    }
                end

                repeat
                    data.Taurus.Key = player:GetCollectibleRNG(Astro.Collectible.TAURUS_EX):RandomInt(4)
                until not (checkMaxSpeed(player) and data.Taurus.Key == 2)

                effects[data.Taurus.Key](player)
                player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                player:EvaluateItems()
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Astro.Collectible.TAURUS_EX) then
            local data = player:GetData()

            if data.Taurus ~= nil then
                if cacheFlag == CacheFlag.CACHE_SPEED and data.Taurus.Key == 2 then
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_MERCURIUS) then
                        if player.MoveSpeed < 1.4 then
                            player.MoveSpeed = 1.4
                        end
                    else
                        if player.MoveSpeed < 2 then
                            player.MoveSpeed = 2
                        end
                    end
                elseif cacheFlag == CacheFlag.CACHE_FIREDELAY and data.Taurus.Key == 3 then
                    player.MaxFireDelay = player.MaxFireDelay - 2 * player:GetCollectibleNum(Astro.Collectible.TAURUS_EX)
                end
            end
        end
    end
)
