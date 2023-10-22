Astro.Collectible.CLOVER = Isaac.GetItemIdByName("Clover")

if EID then
    EID:addCollectible(Astro.Collectible.CLOVER, "", "클로버")
end

-- 럭 수치에 비례하여 공격력이 증가됩니다 (럭1당 공격력 2%p 증가), 소지 시 럭 1 증가

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Astro.Collectible.CLOVER) then
            if cacheFlag == CacheFlag.CACHE_LUCK then
                player.Luck = player.Luck + 1

                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage * (1 + (player.Luck / 50))
            end
        end
    end
)
