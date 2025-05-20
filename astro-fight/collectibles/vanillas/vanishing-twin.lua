if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesVanishingTwin",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_VANISHING_TWIN then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "클리어 되지않은 보스방 입장 시 10초 동안 무적이 됩니다. 특정 보스방에서는 발동하지 않습니다.#중첩 시 지속시간이 증가합니다.")

            return descObj
        end
    )
end

local function CheckEnableRoom()
    local level = Game():GetLevel()
    local stage = level:GetAbsoluteStage()
    local currentRoom = level:GetCurrentRoom()
    local currentRoomDesc = Game():GetLevel():GetCurrentRoomDesc()

    if currentRoom:GetType() ~= RoomType.ROOM_BOSS then
        return false
    end

    if currentRoom:IsClear() then
        return false
    end

    if stage == LevelStage.STAGE3_2 and currentRoom:GetBossID() == 6 then
        return false -- 엄마 발
    elseif stage == LevelStage.STAGE4_3 then
        return false -- 허쉬
    elseif stage == LevelStage.STAGE5 then
        return false -- 성당 / 저승
    elseif stage == LevelStage.STAGE6 then
        return false -- 체스트 / 다크룸 / 메가 사탄
    elseif stage == LevelStage.STAGE7 then
        return false -- 델리리움
    elseif currentRoom:GetBossID() == 88 then
        return false -- 마더
    elseif currentRoomDesc.Data.Name == "Beast Room" then
        return false -- 비스트
    end

    return true
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        if CheckEnableRoom() then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
            
                if player:HasCollectible(CollectibleType.COLLECTIBLE_VANISHING_TWIN) then
                    for _ = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_VANISHING_TWIN) do
                        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, false)
                    end
                end
            end
        end
    end
)
