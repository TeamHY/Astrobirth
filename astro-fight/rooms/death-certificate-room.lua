Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
        
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        local level = Game():GetLevel()
        local roomDesc = level:GetCurrentRoomDesc()
        local currentDimension = Astro:GetDimension(roomDesc)
        
        if currentDimension == 2 then
            if player.MoveSpeed < 2 then
                player.MoveSpeed = 2
            end
        end
    end,
    CacheFlag.CACHE_SPEED
)
