Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    ---@param npc EntityNPC
    function(_, npc)
        local currentRoom = Game():GetLevel():GetCurrentRoom()

        if Isaac.GetChallenge() == Astro.Challenge.LIBRA_EX then
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TROPHY,
                0,
                currentRoom:GetCenterPos(),
                Vector(0, 0),
                nil
            )
        else
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_BIGCHEST,
                0,
                currentRoom:GetCenterPos(),
                Vector(0, 0),
                nil
            )

            local portal = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 17, currentRoom:GetGridPosition(142), true)
            portal.VarData = 1

            portal:GetSprite():Load("gfx/grid/voidtrapdoor.anm2", true)
        end

        currentRoom:SetClear(true)
    end,
    EntityType.ENTITY_MEGA_SATAN_2
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function()
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        if level:GetStage() ~= 9 and currentRoom:GetBossID() ~= 55 then
            for i = 1, currentRoom:GetGridSize() do
                local gridEnt = currentRoom:GetGridEntity(i)

                if gridEnt then
                    if gridEnt:GetType() == 17 and gridEnt.VarData == 1 then
                        currentRoom:RemoveGridEntity(i, 0, false)
                    end
                end
            end
        end
    end
)
