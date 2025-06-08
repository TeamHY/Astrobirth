---

local SPEED_DECREMENT = -0.1

local TEARS_DECREMENT = -0.1

local DAMAGE_DECREMENT = -0.1

local RANGE_DECREMENT = -1

local SHOT_SPEED_DECREMENT = -0.1

local LUCK_DECREMENT = -1

---

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesIsaacsHeart",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_ISAACS_HEART then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#피격 시 패널티가 적용되지 않습니다. 대신 모든 스탯이 감소됩니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    Astro.Callbacks.PLAYER_TAKE_PENALTY,
    ---@param player EntityPlayer
    function(_, player)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART) then
            local data = Astro:GetPersistentPlayerData(player)

            if not data["isaacsHeartStatus"] then
                data["isaacsHeartStatus"] = {
                    speed = 0,
                    tears = 0,
                    damage = 0,
                    range = 0,
                    shotSpeed = 0,
                    luck = 0
                }
            end

            data["isaacsHeartStatus"].speed = data["isaacsHeartStatus"].speed + SPEED_DECREMENT
            data["isaacsHeartStatus"].tears = data["isaacsHeartStatus"].tears + TEARS_DECREMENT
            data["isaacsHeartStatus"].damage = data["isaacsHeartStatus"].damage + DAMAGE_DECREMENT
            data["isaacsHeartStatus"].range = data["isaacsHeartStatus"].range + RANGE_DECREMENT
            data["isaacsHeartStatus"].shotSpeed = data["isaacsHeartStatus"].shotSpeed + SHOT_SPEED_DECREMENT
            data["isaacsHeartStatus"].luck = data["isaacsHeartStatus"].luck + LUCK_DECREMENT

            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()

            return false
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        local data = Astro:GetPersistentPlayerData(player)

        if data and data["isaacsHeartStatus"] then
            if cacheFlag == CacheFlag.CACHE_SPEED then
                player.MoveSpeed = player.MoveSpeed + data["isaacsHeartStatus"].speed
            elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = Astro:AddTears(player.MaxFireDelay, data["isaacsHeartStatus"].tears)
            elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + data["isaacsHeartStatus"].damage
            elseif cacheFlag == CacheFlag.CACHE_RANGE then
                player.TearRange = player.TearRange + data["isaacsHeartStatus"].range
            elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
                player.ShotSpeed = player.ShotSpeed + data["isaacsHeartStatus"].shotSpeed
            elseif cacheFlag == CacheFlag.CACHE_LUCK then
                player.Luck = player.Luck + data["isaacsHeartStatus"].luck
            end
        end
    end
)
