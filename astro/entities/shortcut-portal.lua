Astro.Entities.SHORTCUT_PORTAL = 3001

Astro.Enums.ShortcutPortalSubType = {
    TREASURE = 1,
    SHOP = 2,
    BOSS = 3
}

if EID then
    EID:addEntity(
        EntityType.ENTITY_EFFECT,
        Astro.Entities.SHORTCUT_PORTAL,
        Astro.Enums.ShortcutPortalSubType.TREASURE,
        "보물방 포탈",
        "{{TreasureRoom}}보물방으로 즉시 이동합니다."
    )

    EID:addEntity(
        EntityType.ENTITY_EFFECT,
        Astro.Entities.SHORTCUT_PORTAL,
        Astro.Enums.ShortcutPortalSubType.SHOP,
        "상점 포탈",
        "{{Shop}}상점으로 즉시 이동합니다."
    )

    EID:addEntity(
        EntityType.ENTITY_EFFECT,
        Astro.Entities.SHORTCUT_PORTAL,
        Astro.Enums.ShortcutPortalSubType.BOSS,
        "보스방 포탈",
        "{{BossRoom}}보스방으로 즉시 이동합니다."
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            Astro.Data.IsEnabledShortcutPortals = false
            Astro.Data.IsEnabledMirrorShortcutPortals = false
        end
    end
)

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
    ModCallbacks.MC_POST_EFFECT_INIT,
    ---@param effect EntityEffect
    function(_, effect)
        if effect.SubType == Astro.Enums.ShortcutPortalSubType.TREASURE then
            effect.Color = Color(1, 1, 1, 1, 0.7, 0.7, 0)
        elseif effect.SubType == Astro.Enums.ShortcutPortalSubType.SHOP then
            effect.Color = Color(1, 1, 1, 1, 0, 0.7, 0)
        elseif effect.SubType == Astro.Enums.ShortcutPortalSubType.BOSS then
            effect.Color = Color(1, 1, 1, 1, 0.7, 0, 0)
        end
    end,
    Astro.Entities.SHORTCUT_PORTAL
)

Astro:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    ---@param effect EntityEffect
    function(_, effect)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if CheckOverlap(player, effect) then
                if effect.SubType == Astro.Enums.ShortcutPortalSubType.TREASURE then
                    MoveRoom(RoomType.ROOM_TREASURE)
                elseif effect.SubType == Astro.Enums.ShortcutPortalSubType.SHOP then
                    MoveRoom(RoomType.ROOM_SHOP)
                elseif effect.SubType == Astro.Enums.ShortcutPortalSubType.BOSS then
                    MoveRoom(RoomType.ROOM_BOSS)
                end
            end
        end
    end,
    Astro.Entities.SHORTCUT_PORTAL
)

local function SpawnShortcutPortal()
    local room = Game():GetRoom()
    local roomType = room:GetType()

    if roomType == RoomType.ROOM_TREASURE then
        Astro:Spawn(
            EntityType.ENTITY_EFFECT,
            Astro.Entities.SHORTCUT_PORTAL,
            Astro.Enums.ShortcutPortalSubType.SHOP,
            room:GetGridPosition(106)
        )
        Astro:Spawn(
            EntityType.ENTITY_EFFECT,
            Astro.Entities.SHORTCUT_PORTAL,
            Astro.Enums.ShortcutPortalSubType.BOSS,
            room:GetGridPosition(118)
        )
    elseif roomType == RoomType.ROOM_SHOP then
        Astro:Spawn(
            EntityType.ENTITY_EFFECT,
            Astro.Entities.SHORTCUT_PORTAL,
            Astro.Enums.ShortcutPortalSubType.TREASURE,
            room:GetGridPosition(106)
        )
        Astro:Spawn(
            EntityType.ENTITY_EFFECT,
            Astro.Entities.SHORTCUT_PORTAL,
            Astro.Enums.ShortcutPortalSubType.BOSS,
            room:GetGridPosition(118)
        )
    elseif roomType == RoomType.ROOM_BOSS then
        Astro:Spawn(
            EntityType.ENTITY_EFFECT,
            Astro.Entities.SHORTCUT_PORTAL,
            Astro.Enums.ShortcutPortalSubType.TREASURE,
            room:GetGridPosition(106)
        )
        Astro:Spawn(
            EntityType.ENTITY_EFFECT,
            Astro.Entities.SHORTCUT_PORTAL,
            Astro.Enums.ShortcutPortalSubType.SHOP,
            room:GetGridPosition(118)
        )
    end
end

local function HasMirrorDimension()
    local level = Game():GetLevel()

    if level:GetStage() == LevelStage.STAGE1_2 and level:GetStageType() >= StageType.STAGETYPE_REPENTANCE then
        return true
    end

    return false
end

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    ---@param rng RNG
    ---@param spawnPosition Vector
    function(_, rng, spawnPosition)
        local room = Game():GetRoom()

        if HasMirrorDimension() and room:GetType() == RoomType.ROOM_BOSS then
            if room:IsMirrorWorld() then
                Astro.Data.IsEnabledMirrorShortcutPortals = true
                SpawnShortcutPortal()
            else
                Astro.Data.IsEnabledShortcutPortals = true
                SpawnShortcutPortal()
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local room = Game():GetRoom()

        if HasMirrorDimension() then
            if room:IsMirrorWorld() then
                if Astro.Data.IsEnabledMirrorShortcutPortals then
                    SpawnShortcutPortal()
                end
            else
                if Astro.Data.IsEnabledShortcutPortals then
                    SpawnShortcutPortal()
                end
            end
        end
    end
)
