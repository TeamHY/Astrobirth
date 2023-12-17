Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued then
            -- 깨끗한 침대방(세트룸)
            Astro.Data.IsaacPool = {
                --악마
                CollectibleType.COLLECTIBLE_PENTAGRAM,
                CollectibleType.COLLECTIBLE_MARK,
                CollectibleType.COLLECTIBLE_PACT,
                CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT,
                CollectibleType.COLLECTIBLE_BRIMSTONE,
                CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT,
                CollectibleType.COLLECTIBLE_ABADDON,
                CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID,
                CollectibleType.COLLECTIBLE_SULFUR,
                CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT,
                --천사
                CollectibleType.COLLECTIBLE_BIBLE,
                CollectibleType.COLLECTIBLE_ROSARY,
                CollectibleType.COLLECTIBLE_HALO,
                CollectibleType.COLLECTIBLE_SCAPULAR,
                CollectibleType.COLLECTIBLE_CELTIC_CROSS,
                CollectibleType.COLLECTIBLE_MITRE,
                CollectibleType.COLLECTIBLE_SACRED_HEART,
                CollectibleType.COLLECTIBLE_HOLY_GRAIL,
                CollectibleType.COLLECTIBLE_DEAD_DOVE,
                CollectibleType.COLLECTIBLE_HOLY_MANTLE,
                CollectibleType.COLLECTIBLE_GODHEAD,
                CollectibleType.COLLECTIBLE_HOLY_LIGHT,
                CollectibleType.COLLECTIBLE_DIVINE_INTERVENTION,
                CollectibleType.COLLECTIBLE_IMMACULATE_HEART,
                CollectibleType.COLLECTIBLE_REVELATION,
                CollectibleType.COLLECTIBLE_SACRED_ORB,
                CollectibleType.COLLECTIBLE_SALVATION,
                --구피
                CollectibleType.COLLECTIBLE_DEAD_CAT,
                CollectibleType.COLLECTIBLE_GUPPYS_PAW,
                CollectibleType.COLLECTIBLE_GUPPYS_TAIL,
                CollectibleType.COLLECTIBLE_GUPPYS_HEAD,
                CollectibleType.COLLECTIBLE_GUPPYS_HAIRBALL,
                CollectibleType.COLLECTIBLE_GUPPYS_COLLAR,
                CollectibleType.COLLECTIBLE_GUPPYS_EYE,
                --파리셋
                CollectibleType.COLLECTIBLE_SKATOLE,
                CollectibleType.COLLECTIBLE_HALO_OF_FLIES,
                CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION,
                CollectibleType.COLLECTIBLE_FOREVER_ALONE,
                CollectibleType.COLLECTIBLE_MULLIGAN,
                CollectibleType.COLLECTIBLE_HIVE_MIND,
                CollectibleType.COLLECTIBLE_SMART_FLY,
                CollectibleType.COLLECTIBLE_BBF,
                CollectibleType.COLLECTIBLE_BEST_BUD,
                CollectibleType.COLLECTIBLE_BIG_FAN,
                CollectibleType.COLLECTIBLE_BLUE_BABYS_ONLY_FRIEND,
                CollectibleType.COLLECTIBLE_FRIEND_ZONE,
                CollectibleType.COLLECTIBLE_LOST_FLY,
                CollectibleType.COLLECTIBLE_OBSESSED_FAN,
                CollectibleType.COLLECTIBLE_PAPA_FLY,
                CollectibleType.COLLECTIBLE_JAR_OF_FLIES,
                CollectibleType.COLLECTIBLE_PARASITOID,
                CollectibleType.COLLECTIBLE_YO_LISTEN,
                CollectibleType.COLLECTIBLE_ANGRY_FLY,
                CollectibleType.COLLECTIBLE_PSY_FLY,
                CollectibleType.COLLECTIBLE_BOT_FLY,
                CollectibleType.COLLECTIBLE_FRUITY_PLUM,
                CollectibleType.COLLECTIBLE_PLUM_FLUTE,
                CollectibleType.COLLECTIBLE_SWARM
            }

            -- 더러운 침대방(클로버룸)
            Astro.Data.BarrenPool = {
                CollectibleType.COLLECTIBLE_MY_REFLECTION,
                CollectibleType.COLLECTIBLE_LUCKY_FOOT,
                CollectibleType.COLLECTIBLE_TOUGH_LOVE,
                CollectibleType.COLLECTIBLE_MAGIC_SCAB,
                CollectibleType.COLLECTIBLE_LATCH_KEY,
                CollectibleType.COLLECTIBLE_MOMS_PEARLS,
                CollectibleType.COLLECTIBLE_HOLY_LIGHT,
                CollectibleType.COLLECTIBLE_ATHAME,
                CollectibleType.COLLECTIBLE_APPLE,
                CollectibleType.COLLECTIBLE_PARASITOID,
                CollectibleType.COLLECTIBLE_YO_LISTEN,
                CollectibleType.COLLECTIBLE_GHOST_PEPPER,
                CollectibleType.COLLECTIBLE_BIRDS_EYE,
                CollectibleType.COLLECTIBLE_LODESTONE,
                CollectibleType.COLLECTIBLE_EVIL_CHARM,
                CollectibleType.COLLECTIBLE_GLASS_EYE,
                Astro.Collectible.CLOVER,
                CollectibleType.COLLECTIBLE_DADS_LOST_COIN,
                Astro.Collectible.FORTUNE_COIN,
                Astro.Collectible.PIRATE_MAP,
                Astro.Collectible.DIVINE_LIGHT,
                Astro.Collectible.BLOOD_OF_HATRED,
                Astro.Collectible.ACUTE_SINUSITIS
            }

            -- 아케이드방
            Astro.Data.ArcadePool = {
                CollectibleType.COLLECTIBLE_MY_REFLECTION,
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

            if roomType == RoomType.ROOM_MINIBOSS or roomType == RoomType.ROOM_TREASURE or roomType == RoomType.ROOM_DICE or roomType == RoomType.ROOM_SECRET or roomType == RoomType.ROOM_SUPERSECRET or roomType == RoomType.ROOM_CURSE then
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
            elseif roomType == RoomType.ROOM_ARCADE then
                -- TODO: RNG 교체해야 함
                local rng = Isaac.GetPlayer():GetCollectibleRNG(CollectibleType.COLLECTIBLE_INNER_EYE)

                for i = 0, 1 do
                    local collectables = Astro:GetRandomCollectibles(Astro.Data.ArcadePool, rng, 1)

                    if collectables[1] == nil then
                        collectables[1] = CollectibleType.COLLECTIBLE_BREAKFAST
                    else
                        for index, value in ipairs(Astro.Data.ArcadePool) do
                            if value == collectables[1] then
                                table.remove(Astro.Data.ArcadePool, index)
                                break
                            end
                        end
                    end

                    Astro:SpawnCollectible(collectables[1], currentRoom:GetGridPosition(66 + i * 2), 1, true)
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
