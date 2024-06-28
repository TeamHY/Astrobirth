Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local stage = level:GetAbsoluteStage()
        local currentRoom = level:GetCurrentRoom()
        local currentRoomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())

        if currentRoom:GetFrameCount() <= 0 and currentRoom:IsFirstVisit() then
            local roomType = currentRoom:GetType()

            if roomType == RoomType.ROOM_MINIBOSS or roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_PLANETARIUM or roomType == RoomType.ROOM_CHALLENGE or roomType == RoomType.ROOM_TREASURE or roomType == RoomType.ROOM_DICE or roomType == RoomType.ROOM_SECRET or roomType == RoomType.ROOM_SUPERSECRET or roomType == RoomType.ROOM_CURSE then
                local entities = Isaac.GetRoomEntities()

                for i = 1, #entities do
                    if entities[i].Type == EntityType.ENTITY_PICKUP and entities[i].Variant == PickupVariant.PICKUP_COLLECTIBLE then
                        entities[i]:ToPickup().OptionsPickupIndex = 1
                    end
                end
            end

            if roomType == RoomType.ROOM_DICE then
                local itemPool = Game():GetItemPool()

                Astro:SpawnCollectible(itemPool:GetCollectible(ItemPoolType.POOL_KEY_MASTER, true, currentRoom:GetSpawnSeed()), currentRoom:GetGridPosition(17), 1, true)
                Astro:SpawnCollectible(itemPool:GetCollectible(ItemPoolType.POOL_KEY_MASTER, true, currentRoom:GetSpawnSeed()), currentRoom:GetGridPosition(117), 1, true)
            elseif roomType == RoomType.ROOM_SUPERSECRET then
                local entities = Isaac.GetRoomEntities()

                for i = 1, #entities do
                    if entities[i].Type == EntityType.ENTITY_SHOPKEEPER then
                        entities[i]:Kill()
                    end
                end
            elseif roomType == RoomType.ROOM_BOSS and currentRoom:GetBossID() == 55 and Isaac.GetChallenge() ~= Astro.Challenge.LIBRA_EX then -- Mega Satan
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    AstroItems.Collectible.GREED,
                    currentRoom:GetGridPosition(91),
                    Vector.Zero,
                    nil
                )
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    AstroItems.Collectible.GO_HOME,
                    currentRoom:GetGridPosition(103),
                    Vector.Zero,
                    nil
                )
            elseif roomType == RoomType.ROOM_ISAACS then
                -- TODO: RNG 교체해야 함
                local rng = Isaac.GetPlayer():GetCollectibleRNG(AstroItems.Collectible.ALTAIR)

                for i = 0, 2 do
                    local collectables = Astro:GetRandomCollectibles(AstroItems.Data.IsaacPool, rng, 1)

                    if collectables[1] == nil then
                        collectables[1] = CollectibleType.COLLECTIBLE_BREAKFAST
                    else
                        for index, value in ipairs(AstroItems.Data.IsaacPool) do
                            if value == collectables[1] then
                                table.remove(AstroItems.Data.IsaacPool, index)
                                break
                            end
                        end
                    end

                    Astro:SpawnCollectible(collectables[1], currentRoom:GetGridPosition(80 + i * 2), 1, true)
                end
            elseif roomType == RoomType.ROOM_BARREN then
                -- TODO: RNG 교체해야 함
                local rng = Isaac.GetPlayer():GetCollectibleRNG(AstroItems.Collectible.ALTAIR)

                for i = 0, 1 do
                    local collectables = Astro:GetRandomCollectibles(AstroItems.Data.BarrenPool, rng, 1)

                    if collectables[1] == nil then
                        collectables[1] = CollectibleType.COLLECTIBLE_BREAKFAST
                    else
                        for index, value in ipairs(AstroItems.Data.BarrenPool) do
                            if value == collectables[1] then
                                table.remove(AstroItems.Data.BarrenPool, index)
                                break
                            end
                        end
                    end

                    Astro:SpawnCollectible(collectables[1], currentRoom:GetGridPosition(81 + i * 2), 1, true)
                end
            elseif roomType == RoomType.ROOM_ARCADE then
                -- TODO: RNG 교체해야 함
                local rng = Isaac.GetPlayer():GetCollectibleRNG(AstroItems.Collectible.ALTAIR)

                for i = 0, 1 do
                    local collectables = Astro:GetRandomCollectibles(AstroItems.Data.ArcadePool, rng, 1)

                    if collectables[1] == nil then
                        collectables[1] = CollectibleType.COLLECTIBLE_BREAKFAST
                    else
                        for index, value in ipairs(AstroItems.Data.ArcadePool) do
                            if value == collectables[1] then
                                table.remove(AstroItems.Data.ArcadePool, index)
                                break
                            end
                        end
                    end

                    Astro:SpawnCollectible(collectables[1], currentRoom:GetGridPosition(66 + i * 2), 1, true)
                end
            elseif roomType == RoomType.ROOM_SHOP and stage <= LevelStage.STAGE2_1 then
                Isaac.Spawn(
                    EntityType.ENTITY_SLOT,
                    10,
                    0,
                    currentRoom:GetCenterPos(),
                    Vector.Zero,
                    nil
                )
            elseif currentRoomDesc.Data.Name == "Mom" and currentRoomDesc.Data.Subtype == 89 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    AstroItems.Collectible.GO_HOME,
                    currentRoom:GetCenterPos(),
                    Vector.Zero,
                    nil
                )
            elseif level:GetAbsoluteStage() == LevelStage.STAGE1_1 and level:GetCurrentRoomIndex() == 84 and not Game():IsGreedMode() then
                Astro:SpawnCollectible(AstroItems.Collectible.EZ_MODE, currentRoom:GetGridPosition(33), nil, true)
                Astro:SpawnCollectible(AstroItems.Collectible.VERY_EZ_MODE, currentRoom:GetGridPosition(41), nil, true)
            end
        end

        if currentRoomDesc.Data.Name:sub(1, 6) == "[MIST]" then
            currentRoomDesc.Flags = currentRoomDesc.Flags | RoomDescriptor.FLAG_CURSED_MIST
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    function(_)
        local level = Game():GetLevel()
        local stage = level:GetAbsoluteStage()
        local currentRoom = level:GetCurrentRoom()
        local firstPlayer = Isaac.GetPlayer()

        if currentRoom:GetType() == RoomType.ROOM_BOSS then
            if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
                Isaac.Spawn(EntityType.ENTITY_SLOT, 10, 0, currentRoom:GetCenterPos(), Vector(0, 0), nil) -- Shop Restock Machine
            elseif stage == LevelStage.STAGE3_2 and level:GetStageType() >= StageType.STAGETYPE_REPENTANCE and currentRoom:GetBossID() == 6 then
                if not firstPlayer:HasCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_1) then
                    firstPlayer:AddCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_1)
                end

                if not firstPlayer:HasCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_2) then
                    firstPlayer:AddCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_2)
                end
            elseif stage == LevelStage.STAGE6 then
                if not firstPlayer:HasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1, true) then
                    firstPlayer:AddCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1)
                end

                if not firstPlayer:HasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2, true) then
                    firstPlayer:AddCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2)
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    ---@param entityNPC EntityNPC
    function(_, entityNPC)
        local currentRoom = Game():GetLevel():GetCurrentRoom()
        local roomType = currentRoom:GetType()

        if entityNPC.Type == EntityType.ENTITY_DOGMA and entityNPC.Variant == 1 then
            local rng = entityNPC:GetDropRNG()

            Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, 0, 0, currentRoom:GetGridPosition(106), Vector.Zero, nil)                    -- Death's Head
            Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, rng:RandomInt(2) * 2, 0, currentRoom:GetGridPosition(118), Vector.Zero, nil) -- Death's Head or Cursed Death's Head
            Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, rng:RandomInt(2) * 2, 0, currentRoom:GetGridPosition(121), Vector.Zero, nil)
            Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, 0, 0, currentRoom:GetGridPosition(133), Vector.Zero, nil)
        elseif entityNPC.Type == EntityType.ENTITY_SPIDER then
            if roomType == RoomType.ROOM_SECRET or roomType == RoomType.ROOM_SUPERSECRET or roomType == RoomType.ROOM_ARCADE then
                entityNPC:Remove()
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = entity:ToPlayer()

        if player ~= nil then
            if damageFlags & (DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS) == 0 then
                local currentRoomDesc = Game():GetLevel():GetCurrentRoomDesc()

                if currentRoomDesc.Data.Name == "Beast Room" then
                    Astro.Data.DamoclesKill = true
                end
            end
        end
    end
)
