Astro.Collectible.CLOVER = Isaac.GetItemIdByName("Clover")

if EID then
    EID:addCollectible(Astro.Collectible.CLOVER, "", "클로버")
end

-- 럭 수치에 비례하여 공격력이 증가됩니다 (럭1당 공격력 2%p 증가), 소지 시 럭 1 증가

Astro:AddCallback(
    ModCallbacks.MC_POST_PLAYER_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if player:HasCollectible(Astro.Collectible.CLOVER) then
            local data = player:GetData()

            if data.Clover == nil then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()

                data.Clover = {
                    Luck = player.Luck
                }
            else
                if data.Clover.Luck ~= player.Luck then
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                    player:EvaluateItems()

                    data.Clover.Luck = player.Luck
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Astro.Collectible.CLOVER) then
            if cacheFlag == CacheFlag.CACHE_LUCK then
                player.Luck = player.Luck + 1
            elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage * (1 + (player.Luck / 50))
            end
        end
    end
)
