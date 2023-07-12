Redrawn.Collectible.TAURUS_EX = Isaac.GetItemIdByName("Taurus EX")

local effects = {
    ---@param player EntityPlayer
    [0] = function(player)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, false, true, false, false)
    end,
    ---@param player EntityPlayer
    [1] = function(player)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPATHY_BOOK, false, true, false, false)
    end,
    ---@param player EntityPlayer
    [2] = function(player)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    end,
    ---@param player EntityPlayer
    [3] = function(player)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    end
}

Redrawn:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function()
        ---@type EntityPlayer
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Redrawn.Collectible.TAURUS_EX) then
                local data = player:GetData()

                if data.Taurus == nil then
                    data.Taurus = {
                        Key = -1
                    }
                end

                data.Taurus.Key = player:GetCollectibleRNG(Redrawn.Collectible.TAURUS_EX):RandomInt(4)
                effects[data.Taurus.Key](player)
            end
        end
    end
)

Redrawn:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Redrawn.Collectible.TAURUS_EX) then
            local data = player:GetData()

            if data.Taurus ~= nil then
                if cacheFlag == CacheFlag.CACHE_SPEED and data.Taurus.Key == 2 then
                    Isaac.DebugString("Taurus EX Speed")
                    player.MoveSpeed = 10
                elseif cacheFlag == CacheFlag.CACHE_FIREDELAY and data.Taurus.Key == 3 then
                    Isaac.DebugString("Taurus EX FireDelay")
                    player.MaxFireDelay = player.MaxFireDelay - 2
                end
            end
        end
    end
)
