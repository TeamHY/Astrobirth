local OPTIONS_PICKUP_INDEX = 145
local GRID_SIZE = 40
local GOLDEN_TRINKET_OFFSET = 32768

---@param player EntityPlayer
local function TryChangeToGoldenTrinket(player)
    local trinket0 = player:GetTrinket(0)
    local trinket1 = player:GetTrinket(1)

    if trinket0 ~= 0 then
        player:TryRemoveTrinket(trinket0)
    end

    if trinket1 ~= 0 then
        player:TryRemoveTrinket(trinket1)
    end

    if trinket0 ~= 0 then
        if trinket0 < GOLDEN_TRINKET_OFFSET then
            player:AddTrinket(trinket0 + GOLDEN_TRINKET_OFFSET)
        else
            player:AddTrinket(trinket0)
        end
    end

    if trinket1 ~= 0 then
        if trinket1 < GOLDEN_TRINKET_OFFSET then
            player:AddTrinket(trinket1 + GOLDEN_TRINKET_OFFSET)
        else
            player:AddTrinket(trinket1)
        end
    end
end

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    ---@param rng RNG
    ---@param spawnPosition Vector
    function(rng, spawnPosition)
        local level = Game():GetLevel()
        local stage = level:GetAbsoluteStage()
        local currentRoom = level:GetCurrentRoom()
        local itemPool = Game():GetItemPool()

        if currentRoom:GetType() == RoomType.ROOM_BOSS then
            local isSpawnd = false

            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasTrinket(TrinketType.TRINKET_PERFECTION) then
                    if stage >= LevelStage.STAGE2_2 then
                        TryChangeToGoldenTrinket(player)
                    end

                    if isSpawnd then
                        break
                    end

                    isSpawnd = true

                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_BOMB,
                        2,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_KEY,
                        3,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )

                    if stage == LevelStage.STAGE1_2 then
                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_MAGIC_8_BALL,
                            currentRoom:GetCenterPos() + Vector(0, GRID_SIZE),
                            nil,
                            true
                        )
                        Astro:SpawnCard(Card.RUNE_ANSUZ, player.Position)
                    elseif stage == LevelStage.STAGE2_1 then
                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_REDEMPTION,
                            currentRoom:GetCenterPos() + Vector(0, GRID_SIZE),
                            nil,
                            true
                        )
                    elseif stage == LevelStage.STAGE2_2 then
                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_MOMS_PURSE,
                            currentRoom:GetCenterPos() + Vector(-GRID_SIZE, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_POLYDACTYLY,
                            currentRoom:GetCenterPos() + Vector(GRID_SIZE, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                    elseif stage == LevelStage.STAGE3_1 then
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(-GRID_SIZE, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(GRID_SIZE, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                    elseif stage == LevelStage.STAGE3_2 and currentRoom:GetBossID() == 6 then
                        player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)

                        Astro:SpawnCard(Card.CARD_GET_OUT_OF_JAIL, player.Position)
                    elseif stage == LevelStage.STAGE4_1 then
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_SHOP, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(-GRID_SIZE * 2, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_SHOP, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos(),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_SHOP, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(GRID_SIZE * 2, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                    elseif
                        stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE3_2 and currentRoom:GetBossID() == 8)
                    then
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(-GRID_SIZE * 2, GRID_SIZE * 2),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(0, GRID_SIZE * 2),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(GRID_SIZE * 2, GRID_SIZE * 2),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                    elseif stage == LevelStage.STAGE4_3 then
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COLLECTIBLE,
                            CollectibleType.COLLECTIBLE_EDENS_BLESSING,
                            currentRoom:GetCenterPos(),
                            Vector.Zero,
                            nil
                        )
                    elseif stage == LevelStage.STAGE5 then
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COLLECTIBLE,
                            itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(-GRID_SIZE, GRID_SIZE * 2),
                            Vector.Zero,
                            nil
                        ):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COLLECTIBLE,
                            itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(GRID_SIZE, GRID_SIZE * 2),
                            Vector.Zero,
                            nil
                        ):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
                    elseif stage == LevelStage.STAGE6 then
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            Card.CARD_FOOL,
                            currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                            Vector.Zero,
                            nil
                        )
                    end
                end
            end
        elseif currentRoom:GetType() == RoomType.ROOM_BOSSRUSH then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasTrinket(TrinketType.TRINKET_PERFECTION) then
                    Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, currentRoom:GetCenterPos())
                end
            end
        end
    end
)
