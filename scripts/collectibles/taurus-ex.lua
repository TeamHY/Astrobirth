Astro.Collectible.TAURUS_EX = Isaac.GetItemIdByName("Taurus EX")

if EID then
    EID:addCollectible(
        Astro.Collectible.TAURUS_EX,
        "방 입장 시 아래 효과중 한가지가 적용됩니다 #{{ColorSilver}}{{Tears}}연사(상한+2) 증가됩니다 #{{ColorSilver}}{{Damage}}공격력이 +2 증가됩니다 ({{Collectible34}} 액티브와 동일) #{{ColorSilver}}{{Speed}}이동 속도가 2로 고정됩니다 #{{ColorSilver}}유도 특성이 적용됩니다 ({{Collectible192}} 액티브와 동일)",
        "초 황소자리"
    )
end

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
    end,
    ---@param player EntityPlayer
    [3] = function(player)
    end
}

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

                data.Taurus.Key = player:GetCollectibleRNG(Astro.Collectible.TAURUS_EX):RandomInt(4)
                effects[data.Taurus.Key](player)
                player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
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
