Astro.Collectible.PLATINUM_BULLET = Isaac.GetItemIdByName("Platinum Bullet")

if EID then
    EID:addCollectible(Astro.Collectible.PLATINUM_BULLET, "방을 클리어 할 때마다 대미지가 0.01 증가합니다.", "백금 탄환")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            Astro.Data.SilverBulletDamage = 0
        else
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
    
                if player:HasCollectible(Astro.Collectible.PLATINUM_BULLET) then
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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
                    Astro.Data.SilverBulletDamage = Astro.Data.SilverBulletDamage + 0.01

                    isRun = true
                end

                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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
        if player:HasCollectible(Astro.Collectible.PLATINUM_BULLET) then
            if cacheFlag == CacheFlag.CACHE_DAMAGE and Astro.Data.SilverBulletDamage ~= nil then
                player.Damage = player.Damage + Astro.Data.SilverBulletDamage
            end
        end
    end
)
