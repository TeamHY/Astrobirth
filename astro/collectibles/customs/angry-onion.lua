Astro.Collectible.ANGRY_ONION = Isaac.GetItemIdByName("Angry Onion")

if EID then
    EID:addCollectible(Astro.Collectible.ANGRY_ONION, "↑ {{TearsSmall}}연사(+고정) +0.7 #해당 아이템은 연사 배수 아이템 상관없이 항상 고정적인 수치가 증가됩니다.", "화난 양파")
end

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Astro.Collectible.ANGRY_ONION) then
            if cacheFlag == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = Astro:AddTears(player.MaxFireDelay, 0.7)
            end
        end
    end
)
