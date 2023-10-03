Astro.Collectible.PLATINUM_BULLET = Isaac.GetItemIdByName("Platinum Bullet")

if EID then
    EID:addCollectible(Astro.Collectible.PLATINUM_BULLET, "방을 클리어 할 때마다 공격력과 연사가 0.01씩 증가합니다.#해당 아이템은 연사 배수 아이템 상관없이 항상 고정적인 수치가 증가됩니다.", "백금 탄환")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            Astro.Data.PlatinumBulletStatus = 0
        else
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
    
                if player:HasCollectible(Astro.Collectible.PLATINUM_BULLET) then
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                    player:EvaluateItems()
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    function()
        local isRun = false

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.PLATINUM_BULLET) then
                if not isRun then
                    Astro.Data.PlatinumBulletStatus = Astro.Data.PlatinumBulletStatus + 0.01

                    isRun = true
                end

                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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
        if player:HasCollectible(Astro.Collectible.PLATINUM_BULLET) and Astro.Data.PlatinumBulletStatus ~= nil then
            if cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + Astro.Data.PlatinumBulletStatus
            elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = Astro:AddTears(player.MaxFireDelay, Astro.Data.PlatinumBulletStatus)
            end
        end
    end
)
