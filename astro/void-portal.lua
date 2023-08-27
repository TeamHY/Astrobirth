Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    ---@param npc EntityNPC
    function(_, npc)
        local currentRoom = Game():GetLevel():GetCurrentRoom()

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

        currentRoom:SetClear(true)

        Astro.Data.MegaSatanPortal = true
    end,
    275
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function()
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        if level:GetStage() ~= 9 and not Astro.Data.MegaSatanPortal then
            for i = 1, currentRoom:GetGridSize() do
                local gridEnt = currentRoom:GetGridEntity(i)

                if gridEnt then
                    if gridEnt:GetType() == 17 then
                        currentRoom:RemoveGridEntity(i, 0, false)
                    end
                end
            end
        end
    end
)
