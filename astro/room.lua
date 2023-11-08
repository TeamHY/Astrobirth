Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued then
            -- 깨끗한 침대방
            Astro.Data.IsaacPool = {
                CollectibleType.COLLECTIBLE_SAD_ONION,
                CollectibleType.COLLECTIBLE_1UP,
                CollectibleType.COLLECTIBLE_BATTERY,
            }

            -- 더러운 침대방
            Astro.Data.BarrenPool = {
                CollectibleType.COLLECTIBLE_ADDERLINE,
                CollectibleType.COLLECTIBLE_CHARM_VAMPIRE,
                CollectibleType.COLLECTIBLE_DR_FETUS,
            }
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()
        local currentRoomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())

        if currentRoom:GetFrameCount() <= 0 and currentRoom:IsFirstVisit() then
            local roomType = currentRoom:GetType()

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
            elseif roomType == RoomType.ROOM_BOSS and currentRoom:GetBossID() == 55 then -- Mega Satan
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    Astro.Collectible.GREED,
                    currentRoom:GetTopLeftPos() - Vector(-80, -80),
                    Vector.Zero,
                    nil
                )
            elseif roomType == RoomType.ROOM_BOSS and currentRoom:GetBossID() == 70 then -- Delirium
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    Astro.Collectible.GO_HOME,
                    currentRoom:GetTopLeftPos() - Vector(20, 20),
                    Vector.Zero,
                    nil
                )
            elseif roomType == RoomType.ROOM_ISAACS then
                -- TODO: RNG 교체해야 함
                local rng = Isaac.GetPlayer():GetCollectibleRNG(CollectibleType.COLLECTIBLE_INNER_EYE)

                for i = 0, 2 do
                    local collectables = Astro:GetRandomCollectibles(Astro.Data.IsaacPool, rng, 1)

                    if collectables[1] == nil then
                        collectables[1] = CollectibleType.COLLECTIBLE_BREAKFAST
                    else
                        for index, value in ipairs(Astro.Data.IsaacPool) do
                            if value == collectables[1] then
                                table.remove(Astro.Data.IsaacPool, index)
                                break
                            end
                        end
                    end

                    Astro:SpawnCollectible(collectables[1], currentRoom:GetGridPosition(80 + i * 2), 1, true)
                end
            elseif roomType == RoomType.ROOM_BARREN then
                -- TODO: RNG 교체해야 함
                local rng = Isaac.GetPlayer():GetCollectibleRNG(CollectibleType.COLLECTIBLE_INNER_EYE)

                for i = 0, 1 do
                    local collectables = Astro:GetRandomCollectibles(Astro.Data.BarrenPool, rng, 1)

                    if collectables[1] == nil then
                        collectables[1] = CollectibleType.COLLECTIBLE_BREAKFAST
                    else
                        for index, value in ipairs(Astro.Data.BarrenPool) do
                            if value == collectables[1] then
                                table.remove(Astro.Data.BarrenPool, index)
                                break
                            end
                        end
                    end

                    Astro:SpawnCollectible(collectables[1], currentRoom:GetGridPosition(81 + i * 2), 1, true)
                end
            elseif currentRoomDesc.Data.Name == "Mom" and currentRoomDesc.Data.Subtype == 89 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    Astro.Collectible.GO_HOME,
                    currentRoom:GetCenterPos(),
                    Vector.Zero,
                    nil
                )
            end
        end

        if currentRoomDesc.Data.Name:sub(1, 6) == "[MIST]" then
            currentRoomDesc.Flags = currentRoomDesc.Flags | RoomDescriptor.FLAG_CURSED_MIST
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    ---@param entityNPC EntityNPC
    function(_, entityNPC)
        if entityNPC.Type == EntityType.ENTITY_DOGMA and entityNPC.Variant == 1 then
            local currentRoom = Game():GetLevel():GetCurrentRoom()
            local rng = entityNPC:GetDropRNG()

            Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, 0, 0, currentRoom:GetGridPosition(106), Vector.Zero, nil)                    -- Death's Head
            Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, rng:RandomInt(2) * 2, 0, currentRoom:GetGridPosition(118), Vector.Zero, nil) -- Death's Head or Cursed Death's Head
            Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, rng:RandomInt(2) * 2, 0, currentRoom:GetGridPosition(121), Vector.Zero, nil)
            Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, 0, 0, currentRoom:GetGridPosition(133), Vector.Zero, nil)
        end
    end
)
