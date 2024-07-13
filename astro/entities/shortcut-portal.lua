Astro.Entities.SHORTCUT_PORTAL = Isaac.GetEntityVariantByName("Shortcut Portal")

---@param a Entity
---@param b Entity
---@return boolean
local function CheckOverlap(a, b)
    return a.Position:Distance(b.Position) <= a.Size + b.Size
end

---@param roomType RoomType
local function MoveRoom(roomType)
    local level = Game():GetLevel()
    local idx = level:QueryRoomTypeIndex(roomType, true, RNG())
    local room = level:GetRoomByIdx(idx)

    if room.Data.Type == roomType then
        Game():ChangeRoom(idx)
    end
end

Astro:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    ---@param effect EntityEffect
    function(_, effect)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if CheckOverlap(player, effect) then
                if effect.SubType == 1 then
                    MoveRoom(RoomType.ROOM_TREASURE)
                elseif effect.SubType == 2 then
                    MoveRoom(RoomType.ROOM_SHOP)
                elseif effect.SubType == 3 then
                    MoveRoom(RoomType.ROOM_BOSS)
                end
            end
        end
    end,
    Astro.Entities.SHORTCUT_PORTAL
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local room = Game():GetRoom()
        local roomType = room:GetType()

        if roomType == RoomType.ROOM_TREASURE then
            local portal = Isaac.Spawn(EntityType.ENTITY_EFFECT, Astro.Entities.SHORTCUT_PORTAL, 1, room:GetCenterPos(), Vector(0, 0), nil)
        elseif roomType == RoomType.ROOM_SHOP then
            local portal = Isaac.Spawn(EntityType.ENTITY_EFFECT, Astro.Entities.SHORTCUT_PORTAL, 2, room:GetCenterPos(), Vector(0, 0), nil)
        elseif roomType == RoomType.ROOM_BOSS then
            local portal = Isaac.Spawn(EntityType.ENTITY_EFFECT, Astro.Entities.SHORTCUT_PORTAL, 3, room:GetCenterPos(), Vector(0, 0), nil)
        end
    end
)
