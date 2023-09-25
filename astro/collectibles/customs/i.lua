Astro.Collectible.I = Isaac.GetItemIdByName("I")

if EID then
    EID:addCollectible(Astro.Collectible.I, "i - 화난 양파(angry onion) : 연사 0.7 증가 (배수 영향을 받지않는 고정 연사)", "백금 탄환")
end

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Astro.Collectible.I) then
            if cacheFlag == CacheFlag.CACHE_FIREDELAY then
                player.FireDelay = player.FireDelay + 0.7
            end
        end
    end
)
