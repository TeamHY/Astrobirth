local OPTIONS_PICKUP_INDEX = 145

---@param player EntityPlayer
function Astro:HasPerfectionEffect(player)
    return player:HasTrinket(TrinketType.TRINKET_PERFECTION) or player:HasTrinket(Astro.Trinket.FLUNK)
end

Astro:AddCallback(
    Astro.Callbacks.REMOVED_PERFECTION,
    ---@param position Vector
    function(_, position)
        Astro:SpawnTrinket(Astro.Trinket.FLUNK, position)
    end
)

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
        if trinket0 < Astro.GOLDEN_TRINKET_OFFSET then
            player:AddTrinket(trinket0 + Astro.GOLDEN_TRINKET_OFFSET)
        else
            player:AddTrinket(trinket0)
        end
    end

    if trinket1 ~= 0 then
        if trinket1 < Astro.GOLDEN_TRINKET_OFFSET then
            player:AddTrinket(trinket1 + Astro.GOLDEN_TRINKET_OFFSET)
        else
            player:AddTrinket(trinket1)
        end
    end
end

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    ---@param rng RNG
    ---@param spawnPosition Vector
    function(_, rng, spawnPosition)
        local level = Game():GetLevel()
        local stage = level:GetAbsoluteStage()
        local currentRoom = level:GetCurrentRoom()
        local itemPool = Game():GetItemPool()

        if currentRoom:GetType() == RoomType.ROOM_BOSS then
            local isSpawnd = false

            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if Astro:HasPerfectionEffect(player) then
                    if stage >= LevelStage.STAGE2_2 then
                        TryChangeToGoldenTrinket(player)
                    end

                    if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) and not player:HasCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR) then
                        player:AddCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)
                        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)
                    end

                    -- if player:GetPlayerType() == PlayerType.PLAYER_AZAZEL then
                    --     if not player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT) then
                    --         Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT, player.Position)
                    --     end
                    -- end

                    if isSpawnd then
                        break
                    end

                    isSpawnd = true

                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_BOMB,
                        2,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, Astro.GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_KEY,
                        3,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, Astro.GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )

                    if stage == LevelStage.STAGE1_2 then
                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_MAGIC_8_BALL,
                            currentRoom:GetCenterPos() + Vector(0, Astro.GRID_SIZE),
                            nil,
                            true
                        )
                        Astro:SpawnCard(Card.RUNE_ANSUZ, player.Position)

                        if not player:HasCollectible(CollectibleType.COLLECTIBLE_REDEMPTION) then
                            player:AddCollectible(CollectibleType.COLLECTIBLE_REDEMPTION)
                        end

                        if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                            Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_MAGNETO, currentRoom:GetCenterPos() + Vector(Astro.GRID_SIZE * -2, Astro.GRID_SIZE), OPTIONS_PICKUP_INDEX, true)
                            Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, currentRoom:GetCenterPos() + Vector(Astro.GRID_SIZE * 2, Astro.GRID_SIZE), OPTIONS_PICKUP_INDEX, true)
                        elseif player:GetPlayerType() == PlayerType.PLAYER_APOLLYON_B and not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                            Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, currentRoom:GetCenterPos() + Vector(Astro.GRID_SIZE * 2, Astro.GRID_SIZE), OPTIONS_PICKUP_INDEX, true)
                        end
                    elseif stage == LevelStage.STAGE2_2 then
                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_MOMS_PURSE,
                            currentRoom:GetCenterPos() + Vector(-Astro.GRID_SIZE, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_POLYDACTYLY,
                            currentRoom:GetCenterPos() + Vector(Astro.GRID_SIZE, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                    elseif stage == LevelStage.STAGE3_1 then
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(-Astro.GRID_SIZE, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_CONSOLATION_PRIZE,
                            currentRoom:GetCenterPos() + Vector(Astro.GRID_SIZE, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                    elseif stage == LevelStage.STAGE3_2 and currentRoom:GetBossID() == 6 then -- 엄마 발
                        player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)

                        Astro:SpawnCard(Card.CARD_GET_OUT_OF_JAIL, player.Position)
                        --Astro:SpawnTrinket(Astro.Trinket.BLACK_MIRROR, currentRoom:GetCenterPos())
                    elseif stage == LevelStage.STAGE4_1 then
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(-Astro.GRID_SIZE * 2, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )

                        player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)

                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_NULL,
                            currentRoom:GetCenterPos(),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )

                        player:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)

                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(Astro.GRID_SIZE * 2, 0),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                    elseif stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE3_2 and currentRoom:GetBossID() == 8) then -- 심장
                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(-Astro.GRID_SIZE * 2, Astro.GRID_SIZE * 2),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )

                        player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)

                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_NULL,
                            currentRoom:GetCenterPos() + Vector(0, Astro.GRID_SIZE * 2),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )

                        player:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)

                        Astro:SpawnCollectible(
                            itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(Astro.GRID_SIZE * 2, Astro.GRID_SIZE * 2),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )

                        player:AddCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM)
                    elseif stage == LevelStage.STAGE4_3 then
                        Astro:SpawnCollectible(
                            CollectibleType.COLLECTIBLE_EDENS_BLESSING,
                            currentRoom:GetCenterPos(),
                            OPTIONS_PICKUP_INDEX,
                            true
                        )
                    elseif stage == LevelStage.STAGE5 then
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COLLECTIBLE,
                            itemPool:GetCollectible(ItemPoolType.POOL_SHOP, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(-Astro.GRID_SIZE, Astro.GRID_SIZE * 2),
                            Vector.Zero,
                            nil
                        ):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COLLECTIBLE,
                            itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, true, currentRoom:GetSpawnSeed()),
                            currentRoom:GetCenterPos() + Vector(Astro.GRID_SIZE, Astro.GRID_SIZE * 2),
                            Vector.Zero,
                            nil
                        ):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
                    elseif stage == LevelStage.STAGE6 then
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            Card.CARD_FOOL,
                            currentRoom:FindFreePickupSpawnPosition(player.Position, Astro.GRID_SIZE, true),
                            Vector.Zero,
                            nil
                        )
                    end
                end
            end
        elseif currentRoom:GetType() == RoomType.ROOM_BOSSRUSH then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if Astro:HasPerfectionEffect(player) then
                    Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, currentRoom:GetCenterPos())
                end
            end
        end
    end
)

-- Astro:AddCallback(
--     ModCallbacks.MC_ENTITY_TAKE_DMG,
--     ---@param entity Entity
--     ---@param amount number
--     ---@param damageFlags number
--     ---@param source EntityRef
--     ---@param countdownFrames number
--     function(_, entity, amount, damageFlags, source, countdownFrames)
--         local player = entity:ToPlayer()

--         if player ~= nil then
--             local hasItems = player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS)

--             if Astro:HasPerfectionEffect(player) and hasItems then
--                 if damageFlags & DamageFlag.DAMAGE_EXPLOSION ~= 0 then
--                     return false
--                 end
--             end
--         end
--     end
-- )
