---

local STAGE_7_BOSS = {
    {67, 0, 0},
    {63, 0, 0},
    {404, 1, 0},
    {908, 1, 0},
}

local STAGE_8_BOSS = {
    {67, 0, 0},
    {63, 0, 0},
    {404, 1, 0},
    {908, 1, 0},
}

-- 적힌 번호를 포함해서 적용됩니다
local MIN_ROOM_VARIANT_BY_STAGE_TYPE = {
    [StageType.STAGETYPE_ORIGINAL] = 974, -- Womb
    [StageType.STAGETYPE_WOTL] = 978, -- Utero
    [StageType.STAGETYPE_AFTERBIRTH] = 987, -- Scarred Womb
    [StageType.STAGETYPE_REPENTANCE] = 987, -- Corpse
}

---

local function IsRunStage()
    local level = Game():GetLevel()
    local stage = level:GetAbsoluteStage()
    local stageType = level:GetStageType()

    if (stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2) and MIN_ROOM_VARIANT_BY_STAGE_TYPE[stageType] ~= nil then
        return true
    end

    return false
end

local function IsRunRoomVariant()
    local level = Game():GetLevel()
    local minRoomVariant = MIN_ROOM_VARIANT_BY_STAGE_TYPE[level:GetStageType()]
    local currentRoomDesc = level:GetCurrentRoomDesc()

    return currentRoomDesc.Data.Variant >= minRoomVariant
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local stage = level:GetAbsoluteStage()
        local currentRoom = level:GetCurrentRoom()

        if IsRunStage() and IsRunRoomVariant() and currentRoom:GetType() == RoomType.ROOM_DEFAULT and not currentRoom:IsClear() then
            local position = currentRoom:GetCenterPos()
            local rng = Isaac.GetPlayer():GetCollectibleRNG(Astro.Collectible.CYGNUS)

            local boss;

            if stage == LevelStage.STAGE4_1 then
                boss = STAGE_7_BOSS[rng:RandomInt(#STAGE_7_BOSS) + 1]
            elseif stage == LevelStage.STAGE4_2 then
                boss = STAGE_8_BOSS[rng:RandomInt(#STAGE_8_BOSS) + 1]
            end

            Astro:Spawn(boss[1], boss[2], boss[3], position)
        end
    end
)
