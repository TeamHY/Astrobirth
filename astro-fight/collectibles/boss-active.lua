-- 여기만 수정하시면 EID까지 적용됩니다.
local bossRoomResetList = {
    CollectibleType.COLLECTIBLE_GELLO,
    CollectibleType.COLLECTIBLE_D10
}

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesBossActive",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
                return true
            end
        end,
        function(descObj)
            for _, collectible in ipairs(bossRoomResetList) do
                if descObj.ObjSubType == collectible then
                    EID:appendToDescription(descObj, "#!!! 클리어 되지 않은 {{BossRoom}}보스방 입장 시 쿨타임 게이지가 초기화 됩니다.")
                    break
                end
            end

            return descObj
        end
    )
end

---@param player EntityPlayer
---@param activeSlot ActiveSlot
---@param list CollectibleType[]
local function TryResetCooldown(player, activeSlot, list)
    for _, collectible in ipairs(list) do
        if player:GetActiveItem(activeSlot) == collectible then
            player:SetActiveCharge(0, activeSlot)
            break
        end
    end
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        if not currentRoom:IsClear() then
            local roomType = currentRoom:GetType()

            if roomType == RoomType.ROOM_BOSS then
                for i = 1, Game():GetNumPlayers() do
                    local player = Isaac.GetPlayer(i - 1)

                    TryResetCooldown(player, ActiveSlot.SLOT_PRIMARY, bossRoomResetList)
                    TryResetCooldown(player, ActiveSlot.SLOT_SECONDARY, bossRoomResetList)
                end
            end
        end
    end
)
