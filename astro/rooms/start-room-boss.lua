local function IsRunStage()
    local level = Game():GetLevel()
    local stage = level:GetAbsoluteStage()

    if (stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2) and level:GetStageType() <= StageType.STAGETYPE_AFTERBIRTH then
        return true
    end

    return false
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        local level = Game():GetLevel()
        local stage = level:GetAbsoluteStage()
        local currentRoom = level:GetCurrentRoom()

        if IsRunStage() then
            local position = currentRoom:GetCenterPos()
            position.Y = position.Y - 120

            if stage == LevelStage.STAGE4_1 then
                Isaac.Spawn(20, 0, 0, position, Vector(0, 0), nil)
            elseif stage == LevelStage.STAGE4_2 then
                Isaac.Spawn(20, 0, 0, position, Vector(0, 0), nil)
            end

            currentRoom:SetClear(false)
            SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 1)
            SFXManager():Play(SoundEffect.SOUND_CASTLEPORTCULLIS, 1, 0, false, 1)
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        if not currentRoom:IsClear() and IsRunStage() then
            for i = 1, 4 do
                if currentRoom:GetDoor(i) then
                    currentRoom:GetDoor(i):Close()
                end
            end
        end
    end
)
