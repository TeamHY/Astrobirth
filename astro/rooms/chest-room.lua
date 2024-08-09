---

local TIME = 300

---

local function RemovePickup()
    local entities = Isaac.GetRoomEntities()

    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP then
            if entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                goto continue
            end
            
            entity:Remove()
        end
        ::continue::
    end
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()
        local roomType = currentRoom:GetType()

        if roomType == RoomType.ROOM_CHEST then
            if currentRoom:GetFrameCount() <= 0 and currentRoom:IsFirstVisit() then
                Isaac.Spawn(EntityType.ENTITY_SHOPKEEPER, 3000, 0, currentRoom:GetCenterPos(), Vector(0, 0), nil)
            elseif not currentRoom:IsFirstVisit() then
                RemovePickup()
            end

            QP_OVERWRITE.isDisable = true
        else
            QP_OVERWRITE.isDisable = false
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_NPC_UPDATE,
    ---@param npc EntityNPC
    function(_, npc)
        if npc.Variant == 3000 then
            if npc.FrameCount == 0 then
                npc.MaxHitPoints = TIME
                npc.HitPoints = TIME
            end
    
            npc.HitPoints = npc.HitPoints - 1

            if npc.HitPoints <= 0 then
                RemovePickup()
                npc:Remove()
            end
        end
    end,
    EntityType.ENTITY_SHOPKEEPER
)
