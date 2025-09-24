local autoActiveList = {
    CollectibleType.COLLECTIBLE_GUPPYS_HEAD
}

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesAutoActive",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
                return true
            end
        end,
        function(descObj)
            for _, collectible in ipairs(autoActiveList) do
                if descObj.ObjSubType == collectible then
                    EID:appendToDescription(descObj, "#!!! 클리어 되지 않은 방 입장 시 자동 발동됩니다.")
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
local function TryAutoActivate(player, activeSlot, list)
    local slotCollectible = player:GetActiveItem(activeSlot)

    for _, collectible in ipairs(list) do
        if slotCollectible == collectible then
            local itemConfigItem = Isaac.GetItemConfig():GetCollectible(collectible)
            local charge = player:GetActiveCharge(activeSlot)

            if charge >= itemConfigItem.MaxCharges then
                player:UseActiveItem(collectible, true, true, true, true, activeSlot)
                player:SetActiveCharge(charge - itemConfigItem.MaxCharges, activeSlot)
            end
            break
        end
    end
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local room = Game():GetRoom()

        if not room:IsClear() then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                TryAutoActivate(player, ActiveSlot.SLOT_PRIMARY, autoActiveList)
                TryAutoActivate(player, ActiveSlot.SLOT_SECONDARY, autoActiveList)
            end
        end
    end
)
