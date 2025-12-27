---

local TECHNOLOGY_TEARS = 1

---

if EID then
    EID:addCollectible(
        CollectibleType.COLLECTIBLE_TECHNOLOGY,
        "↑ {{TearsSmall}}연사(+상한) +" .. TECHNOLOGY_TEARS ..
        "#공격이 레이저 공격으로 변경됩니다." ..
        "#레이저는 사거리 제한이 없으며 적과 장애물을 관통합니다.",
        "기계장치",
        "ko_kr"
    )
end

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
            if cacheFlag == CacheFlag.CACHE_FIREDELAY then
                -- 중첩 가능한 버전 player.MaxFireDelay = Astro:AddTears(player.MaxFireDelay, TECHNOLOGY_TEARS * player:GetCollectibleNum(CollectibleType.COLLECTIBLE_TECHNOLOGY))
                player.MaxFireDelay = Astro:AddTears(player.MaxFireDelay, TECHNOLOGY_TEARS)
            elseif cacheFlag == CacheFlag.CACHE_TEARFLAG then
                player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
            end
        end
    end
)