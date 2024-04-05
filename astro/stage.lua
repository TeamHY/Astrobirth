-- TODO: 챔피언이 모두 동일한 확률로 등장하게 됨. 희귀 챔피언이 너무 자주 나타날 수 있음.

-- 챔피언 등장 제외 리스트
local champBanList = { 2, 3, 4, 6, 7, 8, 11, 14, 18, 23, 24, 25 }

---@param stage LevelStage
---@return boolean
local function CheckHeartLimitStage(stage)
    local level = Game():GetLevel()

    return stage >= LevelStage.STAGE4_3 or
        (stage == LevelStage.STAGE4_1 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE) or
        (stage == LevelStage.STAGE4_2 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE)
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        local level = Game():GetLevel()
        local stage = level:GetStage()
        local playerType = player:GetPlayerType()

        if playerType == PlayerType.PLAYER_THEFORGOTTEN then
            if CheckHeartLimitStage(stage) then
                player:AddBrokenHearts(4 - player:GetBrokenHearts())
            end

            player:GetSubPlayer():AddBrokenHearts(6 - player:GetSubPlayer():GetBrokenHearts())
        elseif playerType == PlayerType.PLAYER_THESOUL then
            player:AddBrokenHearts(6 - player:GetBrokenHearts())

            if CheckHeartLimitStage(stage) then
                player:GetSubPlayer():AddBrokenHearts(4 - player:GetSubPlayer():GetBrokenHearts())
            end
        elseif CheckHeartLimitStage(stage) or player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
            if
                playerType == PlayerType.PLAYER_KEEPER or playerType == PlayerType.PLAYER_KEEPER_B or
                playerType == PlayerType.PLAYER_THESOUL_B
            then
            else
                if player:GetEffectiveMaxHearts() > 2 then
                    if player:GetMaxHearts() >= 2 then
                        player:AddMaxHearts(2 - player:GetMaxHearts(), true)
                        player:AddBoneHearts(-player:GetBoneHearts())
                    else
                        player:AddBoneHearts(1 - player:GetBoneHearts())
                    end
                end

                if player:GetSoulHearts() > 2 then
                    player:AddSoulHearts(2 - player:GetSoulHearts())
                end

                if player:GetBrokenHearts() < 10 then
                    player:AddBrokenHearts(10 - player:GetBrokenHearts())
                end
            end
        end

        if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGIC_8_BALL, true) then
            local idx = level:QueryRoomTypeIndex(RoomType.ROOM_PLANETARIUM, false, RNG())
            local room = level:GetRoomByIdx(idx)

            if room.Data.Type == RoomType.ROOM_PLANETARIUM then
                room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX | RoomDescriptor.DISPLAY_ICON
                level:UpdateVisibility()
            end
        end
    end
)

local function CheckChampBan(champ)
    for i = 1, #champBanList do
        if champ == champBanList[i] then
            return true
        end
    end

    return false
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    ---@param entity Entity
    function(_, entity)
        local level = Game():GetLevel()
        local stage = level:GetStage()

        if stage >= LevelStage.STAGE2_2 then
            local playerType = Isaac.GetPlayer():GetPlayerType()

            local champ = 0

            repeat
                champ = entity:GetDropRNG():RandomInt(26)
            until not CheckChampBan(champ)

            if entity:IsVulnerableEnemy() then
                local npc = entity:ToNPC()

                npc:Morph(entity.Type, entity.Variant, entity.SubType, champ)
                npc.HitPoints = npc.MaxHitPoints
            end
        end
    end
)

-- Reseed Stage l4z6mcs4

local tryCount = 0
local LIMIT = 100

Astro:AddPriorityCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    CallbackPriority.IMPORTANT,
    function(_, isContinued)
        tryCount = 0
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        local hasMissingNo = false

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_MISSING_NO) then
                hasMissingNo = true
            end
        end

        if tryCount < LIMIT and not hasMissingNo then
            local level = Game():GetLevel()
            local sacrificeRoom = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_SACRIFICE, false, RNG()))

            -- 막달레나일 경우 케이스 추가
            -- TODO: 더 추가될 경우 보기 쉽게 변경해야 함
            if sacrificeRoom.Data.Type ~= RoomType.ROOM_SACRIFICE and Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_MAGDALENE and level:GetStage() == LevelStage.STAGE1_1 and level:GetStageType() <= StageType.STAGETYPE_AFTERBIRTH then
                tryCount = tryCount + 1
                Isaac.ExecuteCommand("reseed")
                Isaac.DebugString("Run reseed: " .. tryCount)
            end
        end
    end
)
