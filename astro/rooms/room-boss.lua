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

---

local function IsRunStage()
    local level = Game():GetLevel()
    local stage = level:GetAbsoluteStage()

    if (stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2) and level:GetStageType() <= StageType.STAGETYPE_AFTERBIRTH then
        return true
    end

    return false
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local stage = level:GetAbsoluteStage()
        local currentRoom = level:GetCurrentRoom()

        if IsRunStage() and currentRoom:GetType() == RoomType.ROOM_DEFAULT and not currentRoom:IsClear() then
            local position = currentRoom:GetCenterPos()
            local rng = Isaac.GetPlayer():GetCollectibleRNG(AstroItems.Collectible.CYGNUS)

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
