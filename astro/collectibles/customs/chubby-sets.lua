local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.CHUBBYS_HEAD = Isaac.GetItemIdByName("Chubby's Head")
Astro.Collectible.SLEEPING_PUPPY = Isaac.GetItemIdByName("Sleeping Puppy")
Astro.Collectible.CHUBBYS_TAIL = Isaac.GetItemIdByName("Chubby's Tail")

if EID then
    EID:createTransformation("Chubby", "처비")

    EID:assignTransformation("collectible", Astro.Collectible.CHUBBYS_HEAD, "Chubby")
    EID:assignTransformation("collectible", Astro.Collectible.SLEEPING_PUPPY, "Chubby")
    EID:assignTransformation("collectible", Astro.Collectible.CHUBBYS_TAIL, "Chubby")

    Astro:AddEIDCollectible(Astro.Collectible.CHUBBYS_HEAD, "처비의 머리", "...", "↑ {{DamageSmall}}공격력(고정) +3.5#중첩이 가능합니다.")
    Astro:AddEIDCollectible(Astro.Collectible.SLEEPING_PUPPY, "잠자는 강아지", "...", "9개 방을 클리어할 때 마다 공격력, 연사, 사거리, 속도, 행운 중 한 가지의 스텟이 0.35(고정) 증가됩니다.#중첩 시 다음 증가량부터 적용됩니다.")
    Astro:AddEIDCollectible(Astro.Collectible.CHUBBYS_TAIL, "처비의 꼬리", "...", "{{Chest}} 갈색 상자가 등장 시 33% 확률로 갈색 상자가 한 개 더 드랍 됩니다.#중첩 시 확률이 합 연산으로 증가합니다.")
end

-- 처비셋 쿨타임
local CHUBBY_SET_COOLDOWN_TIME = 30 -- 30 프레임 당 하나

-- 처비셋 눈물 발사 시 효과 발동 확률
local CHUBBY_SET_CHANCE = 0.25
local CHUBBY_SET_BIG_CHUBBY_CHANCE = 0.15

-- 처비의 머리
local CHUBBYS_HEAD_DAMAGE = 3.5

-- 잠자는 강아지
local SLEEPING_PUPPY_INCREMENT = 0.35

-- 처비의 꼬리
local CHUBBYS_TAIL_SUBTYPE = 1000
local CHUBBYS_TAIL_CHANCE = 0.33

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            Astro.Data.SleepingPuppy = {
                RoomClearCount = 0,
                Damage = 0,
                FireDelay = 0,
                Range = 0,
                Speed = 0,
                Luck = 0
            }

            Astro.Data.ChubbySet = 0
        else
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
    
                if player:HasCollectible(Astro.Collectible.SLEEPING_PUPPY) then
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
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)

        if player ~= nil then
            local data = player:GetData()

            if (data["chubbySetCooldown"] == nil or data["chubbySetCooldown"] < Game():GetFrameCount()) and Astro.Data.ChubbySet >= 3 then
                local rng = player:GetCollectibleRNG(Astro.Collectible.CHUBBYS_HEAD)

                if rng:RandomFloat() < CHUBBY_SET_CHANCE then
                    ---@type EntityFamiliar
                    local fmailiar

                    if rng:RandomFloat() < CHUBBY_SET_BIG_CHUBBY_CHANCE then
                        fmailiar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BIG_CHUBBY, 10, tear.Position, Vector.Zero, nil):ToFamiliar()
                    else
                        fmailiar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LITTLE_CHUBBY, 10, tear.Position, Vector.Zero, nil):ToFamiliar()
                    end

                    fmailiar:GetData().IsChubbySets = true

                    data["chubbySetCooldown"] = Game():GetFrameCount() + CHUBBY_SET_COOLDOWN_TIME
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    ---@param familiar EntityFamiliar
    function(_, familiar)
        local data = familiar:GetData()

        if data.IsChubbySets == true and (familiar.Variant == FamiliarVariant.LITTLE_CHUBBY or familiar.Variant == FamiliarVariant.BIG_CHUBBY) then
            local isShooting = string.find(familiar:GetSprite():GetAnimation(), "Shoot") ~= nil

            if isShooting then
                data.IsDisposable = true
            elseif not isShooting and data.IsDisposable == true then
                familiar:Remove()
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

            if Astro.Data.SleepingPuppy ~= nil and player:HasCollectible(Astro.Collectible.SLEEPING_PUPPY) then
                if not isRun then
                    Astro.Data.SleepingPuppy.RoomClearCount = Astro.Data.SleepingPuppy.RoomClearCount + 1

                    if Astro.Data.SleepingPuppy.RoomClearCount % 9 == 0 then
                        local rng = player:GetCollectibleRNG(Astro.Collectible.SLEEPING_PUPPY)
                        local random = rng:RandomInt(5)
                        local statusIncrement = SLEEPING_PUPPY_INCREMENT * player:GetCollectibleNum(Astro.Collectible.SLEEPING_PUPPY)

                        if random == 0 then
                            Astro.Data.SleepingPuppy.Damage = Astro.Data.SleepingPuppy.Damage + statusIncrement
                        elseif random == 1 then
                            Astro.Data.SleepingPuppy.FireDelay = Astro.Data.SleepingPuppy.FireDelay + statusIncrement
                        elseif random == 2 then
                            Astro.Data.SleepingPuppy.Range = Astro.Data.SleepingPuppy.Range + statusIncrement
                        elseif random == 3 then
                            Astro.Data.SleepingPuppy.Speed = Astro.Data.SleepingPuppy.Speed + statusIncrement
                        elseif random == 4 then
                            Astro.Data.SleepingPuppy.Luck = Astro.Data.SleepingPuppy.Luck + statusIncrement
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
        if player:HasCollectible(Astro.Collectible.CHUBBYS_HEAD) then
            if cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + CHUBBYS_HEAD_DAMAGE * player:GetCollectibleNum(Astro.Collectible.CHUBBYS_HEAD)
            end
        end
        
        if player:HasCollectible(Astro.Collectible.SLEEPING_PUPPY) and Astro.Data.SleepingPuppy ~= nil then
            if cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + Astro.Data.SleepingPuppy.Damage
            elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = Astro:AddTears(player.MaxFireDelay, Astro.Data.SleepingPuppy.FireDelay)
            elseif cacheFlag == CacheFlag.CACHE_RANGE then
                player.TearRange = player.TearRange + Astro.Data.SleepingPuppy.Range
            elseif cacheFlag == CacheFlag.CACHE_SPEED then
                player.MoveSpeed = player.MoveSpeed + Astro.Data.SleepingPuppy.Speed
            elseif cacheFlag == CacheFlag.CACHE_LUCK then
                player.Luck = player.Luck + Astro.Data.SleepingPuppy.Luck
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if pickup.Variant == PickupVariant.PICKUP_CHEST and pickup.SubType ~= CHUBBYS_TAIL_SUBTYPE then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasCollectible(Astro.Collectible.CHUBBYS_TAIL) then
                    local rng = player:GetCollectibleRNG(Astro.Collectible.CHUBBYS_TAIL)

                    if rng:RandomFloat() < CHUBBYS_TAIL_CHANCE * player:GetCollectibleNum(Astro.Collectible.CHUBBYS_TAIL) then
                        local currentRoom = Game():GetLevel():GetCurrentRoom()

                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_CHEST,
                            CHUBBYS_TAIL_SUBTYPE,
                            currentRoom:FindFreePickupSpawnPosition(pickup.Position, 40, true),
                            Vector.Zero,
                            nil
                        )
                    end

                    break
                end
            end

            pickup.SubType = CHUBBYS_TAIL_SUBTYPE
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if (collectibleType == Astro.Collectible.CHUBBYS_HEAD or collectibleType == Astro.Collectible.SLEEPING_PUPPY or collectibleType == Astro.Collectible.CHUBBYS_TAIL) and Astro:IsFirstAdded(collectibleType) then
            Astro.Data.ChubbySet = Astro.Data.ChubbySet + 1
        end
    end
)
