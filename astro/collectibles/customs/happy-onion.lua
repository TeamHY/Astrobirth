Astro.Collectible.HAPPY_ONION = Isaac.GetItemIdByName("Happy Onion")

if EID then
    EID:addCollectible(Astro.Collectible.HAPPY_ONION, "방 클리어 시 공격력, 연사, 사거리, 속도, 행운 중 한 가지의 스텟이 0.7(고정) 증가됩니다.#스테이지 입장 시 증가된 스텟은 초기화되며, 최대 10번까지만 누적됩니다.", "행복한 양파")
end

local HAPPY_ONION_INCREMENT = 0.7

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            Astro.Data.HappyOnion = {
                StageRoomClearCount = 0,
                Damage = 0,
                FireDelay = 0,
                Range = 0,
                Speed = 0,
                Luck = 0
            }
        else
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
    
                if player:HasCollectible(Astro.Collectible.HAPPY_ONION) then
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                    player:AddCacheFlags(CacheFlag.CACHE_RANGE)
                    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
                    player:EvaluateItems()
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        Astro.Data.HappyOnion = {
            StageRoomClearCount = 0,
            Damage = 0,
            FireDelay = 0,
            Range = 0,
            Speed = 0,
            Luck = 0
        }

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.HAPPY_ONION) then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                player:AddCacheFlags(CacheFlag.CACHE_RANGE)
                player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                player:AddCacheFlags(CacheFlag.CACHE_LUCK)
                player:EvaluateItems()
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

            if Astro.Data.HappyOnion ~= nil and player:HasCollectible(Astro.Collectible.HAPPY_ONION) then
                if not isRun then
                    Astro.Data.HappyOnion.StageRoomClearCount = Astro.Data.HappyOnion.StageRoomClearCount + 1

                    if Astro.Data.HappyOnion.StageRoomClearCount <= 10 then
                        local rng = player:GetCollectibleRNG(Astro.Collectible.HAPPY_ONION)
                        local random = rng:RandomInt(5)

                        if random == 0 then
                            Astro.Data.HappyOnion.Damage = Astro.Data.HappyOnion.Damage + HAPPY_ONION_INCREMENT
                        elseif random == 1 then
                            Astro.Data.HappyOnion.FireDelay = Astro.Data.HappyOnion.FireDelay + HAPPY_ONION_INCREMENT
                        elseif random == 2 then
                            Astro.Data.HappyOnion.Range = Astro.Data.HappyOnion.Range + HAPPY_ONION_INCREMENT
                        elseif random == 3 then
                            Astro.Data.HappyOnion.Speed = Astro.Data.HappyOnion.Speed + HAPPY_ONION_INCREMENT
                        elseif random == 4 then
                            Astro.Data.HappyOnion.Luck = Astro.Data.HappyOnion.Luck + HAPPY_ONION_INCREMENT
                        end
                    end

                    isRun = true
                end

                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                player:AddCacheFlags(CacheFlag.CACHE_RANGE)
                player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                player:AddCacheFlags(CacheFlag.CACHE_LUCK)
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
        if player:HasCollectible(Astro.Collectible.HAPPY_ONION) and Astro.Data.HappyOnion ~= nil then
            if cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + Astro.Data.HappyOnion.Damage
            elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = Astro:AddTears(player.MaxFireDelay, Astro.Data.HappyOnion.FireDelay)
            elseif cacheFlag == CacheFlag.CACHE_RANGE then
                player.TearRange = player.TearRange + Astro.Data.HappyOnion.Range
            elseif cacheFlag == CacheFlag.CACHE_SPEED then
                player.MoveSpeed = player.MoveSpeed + Astro.Data.HappyOnion.Speed
            elseif cacheFlag == CacheFlag.CACHE_LUCK then
                player.Luck = player.Luck + Astro.Data.HappyOnion.Luck
            end
        end
    end
)

