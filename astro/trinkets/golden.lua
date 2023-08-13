-- TrinketType.TRINKET_UMBILICAL_CORD : 해당 장신구 증발되고, 리틀 스티븐(CollectibleType.COLLECTIBLE_LITTLE_STEVEN) 지급
-- TrinketType.TRINKET_MISSING_PAGE : 해당 장신구 증발되고, 네크로노미콘(CollectibleType.COLLECTIBLE_NECRONOMICON) 소환
-- TrinketType.TRINKET_FADED_POLAROID : 해당 장신구 증발되고, 네거티브, 폴라로이드 2개 등장 후 한개 획득
-- TrinketType.TRINKET_LOUSE : 해당 장신구 증발되고, 인페2(CollectibleType.COLLECTIBLE_INFESTATION_2) 소환
-- TrinketType.TRINKET_BROKEN_SYRINGE : 해당 장신구 증발되면서 아이작에 존재하는 주사기 2개 소환되고 1개 선택

-- TrinketType.TRINKET_SILVER_DOLLAR : 황금으로 되는 즉시 캐릭터에게 흡수
-- TrinketType.TRINKET_BLOODY_CROWN : 황금으로 되는 즉시 캐릭터에게 흡수
-- TrinketType.TRINKET_HOLY_CROWN : 황금으로 되는 즉시 캐릭터에게 흡수
-- TrinketType.TRINKET_WICKED_CROWN : 황금으로 되는 즉시 캐릭터에게 흡수
-- TrinketType.TRINKET_NUMBER_MAGNET : 황금으로 되는 즉시 캐릭터에게 흡수

-- TrinketType.TRINKET_PURPLE_HEART : 배수 1.2배 증가  []

-- TrinketType.TRINKET_PINKY_EYE : 공격 시 100% 확률로 독눈물 []
-- TrinketType.TRINKET_PUSH_PIN : 공격 시 100% 확률로 관통 눈물 []

-- TrinketType.TRINKET_SUPER_BALL : 공격 시 25% 확률로 시맨트 적용 (럭1당 1%p 증가) []
-- TrinketType.TRINKET_RAINBOW_WORM : 눈물 공격 시 25% 확률로 생과일(CollectibleType.COLLECTIBLE_FRUIT_CAKE) 효과 적용 (럭1당 1%p 증가) []
-- TrinketType.TRINKET_BRAIN_WORM : 공격 시 50% 확률로 유도 적용 (럭1당 1%p 증가) []

-- TrinketType.TRINKET_BLACK_LIPSTICK : 스테이지 진입 시 블랙 하트 1개 소환 []
-- TrinketType.TRINKET_RUSTED_KEY : 스테이지 진입 시 마다 금키 소환 []
-- TrinketType.TRINKET_SAFETY_CAP : 스테이지 진입 시 마다 걸프 알약 소환 []
-- TrinketType.TRINKET_ACE_SPADES : 스테이지 진입 시 마다 랜덤 카드 소환 []

-- TrinketType.TRINKET_BLOODY_PENNY : 동전 획득 시 종류 상관 없이 25% 확률로 빨간 하트 반칸 드랍 (럭1당 1%p 증가) []
-- TrinketType.TRINKET_BURNT_PENNY : 동전 획득 시 종류 상관 없이 25% 확률로 랜덤 폭탄 소환 (럭1당 1%p 증가) []
-- TrinketType.TRINKET_FLAT_PENNY : 동전 획득 시 종류 상관 없이 25% 확률로 랜덤 열쇠 소환 (럭1당 1%p 증가) []
-- TrinketType.TRINKET_COUNTERFEIT_PENNY : 동전 획득 시 종류 상관 없이 25% 확률로 랜덤 동전 1개 소환 (럭1당 1%p 증가) []
-- TrinketType.TRINKET_ROTTEN_PENNY : 동전 획득 시 종류 상관 없이 100% 확률로 자폭 파리 하나 소환 []
-- TrinketType.TRINKET_BLESSED_PENNY : 동전 획득 시 종류 상관 없이 12.5% 확률로 소울 하트 반칸 소환 (럭1당 1%p 증가) []

-- TrinketType.TRINKET_BAT_WING : 소지중인 상태일경우 공중 적용 []

local isc = require("astro.lib.isaacscript-common")

local GRID_SIZE = 40

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_PURPLE_HEART) > 1 then
                player.Damage = player.Damage * 1.5
            end
        elseif cacheFlag == CacheFlag.CACHE_FLYING then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_BAT_WING) > 1 then
                player.CanFly = true
            end
        elseif cacheFlag == CacheFlag.CACHE_TEARFLAG then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_PINKY_EYE) > 1 then
                player.TearFlags = player.TearFlags | TearFlags.TEAR_POISON
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_PUSH_PIN) > 1 then
                player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING
            end
        end
    end
)

local function TEARFLAG(x)
    return x >= 64 and BitSet128(0,1<<(x-64)) or BitSet128(1<<x,0)
end

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro.Utill:GetPlayerFromEntity(tear)

        if player ~= nil then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_PINKY_EYE) > 1 then
                tear.Color = Color(0.4, 0.97, 0.5, 1, 0, 0, 0)
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_PUSH_PIN) > 1 then
                if tear.Variant == TearVariant.BLUE then
                    tear:ChangeVariant(TearVariant.CUPID_BLUE)
                elseif tear.Variant == TearVariant.BLOOD then
                    tear:ChangeVariant(TearVariant.CUPID_BLOOD)
                end

                tear.Color = Color(1.5, 2, 2, 0.5, 0, 0, 0)
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_SUPER_BALL) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_SUPER_BALL)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BOUNCE
                    tear.Color = Color(1, 1, 0.8, 1, 0.1, 0.1, 0.1)
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_RAINBOW_WORM) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_RAINBOW_WORM)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    tear.TearFlags = tear.TearFlags | TEARFLAG(rng:RandomInt(TearFlags.TEAR_EFFECT_COUNT))
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BRAIN_WORM) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_BRAIN_WORM)

                if rng:RandomFloat() < 0.5 + player.Luck / 100 then
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
                    -- tear.Color = Color(0.4, 0.15, 0.38, 1, 0.27843, 0, 0.4549)
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function()
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_LIPSTICK) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_HEART,
                    HeartSubType.HEART_BLACK,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_RUSTED_KEY) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_KEY,
                    KeySubType.KEY_GOLDEN,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_SAFETY_CAP) > 1 then
                local itemPool = Game():GetItemPool()
                local pillColor = itemPool:ForceAddPillEffect(PillEffect.PILLEFFECT_GULP)

                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_PILL,
                    pillColor,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                    Vector.Zero,
                    nil
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_ACE_SPADES) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_TAROTCARD,
                    0,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PICKUP_COLLECT,
    ---@param pickup EntityPickup
    ---@param player EntityPlayer
    function(_, pickup, player)
        if pickup.Variant == PickupVariant.PICKUP_COIN then
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BLOODY_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_BLOODY_PENNY)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_HEART,
                        2,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BURNT_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_BURNT_PENNY)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_BOMB,
                        0,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_FLAT_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_FLAT_PENNY)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_KEY,
                        0,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_COUNTERFEIT_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_COUNTERFEIT_PENNY)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_COIN,
                        0,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_ROTTEN_PENNY) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_FAMILIAR,
                    FamiliarVariant.BLUE_FLY,
                    0,
                    player.Position,
                    Vector.Zero,
                    player
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BLESSED_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_BLESSED_PENNY)

                if rng:RandomFloat() < 0.125 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_HEART,
                        HeartSubType.HEART_HALF_SOUL,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end
        end
    end
)
