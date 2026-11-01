---@type table<CollectibleType, integer>
local STAGE_LIMIT = {
    [CollectibleType.COLLECTIBLE_TELEPORT] = 2,
}

---@type table<CollectibleType, integer>
local GAME_LIMIT = {
    [CollectibleType.COLLECTIBLE_TELEPORT_2] = 2,
}

---@type table<CollectibleType, boolean>
local ONE_TIME_USE = {
    [CollectibleType.COLLECTIBLE_CRYSTAL_BALL] = true,
}

local TEXT_DURATION = 90

local font = Font()
font:Load(Astro.Fight.modPath .. "resources/font/eid_korean_soyanon.fnt")

---@param collectibleType CollectibleType
---@return string
local function GetName(collectibleType)
    if EID then
        return EID:getObjectName(5, 100, collectibleType)
    end

    return Isaac.GetItemConfig():GetCollectible(collectibleType).Name
end

---@param save table
---@return table<string, integer>
local function GetCounts(save)
    save.UseLimit = save.UseLimit or {}
    return save.UseLimit
end

---@param collectibleType CollectibleType
---@return integer?
local function GetRemaining(collectibleType)
    local key = tostring(collectibleType)
    local remaining

    if STAGE_LIMIT[collectibleType] then
        remaining = STAGE_LIMIT[collectibleType] - (GetCounts(Astro.SaveManager.GetFloorSave())[key] or 0)
    end

    if GAME_LIMIT[collectibleType] then
        local gameRemaining = GAME_LIMIT[collectibleType] - (GetCounts(Astro.SaveManager.GetRunSave())[key] or 0)
        remaining = math.min(remaining or gameRemaining, gameRemaining)
    end

    return remaining
end

---@param useFlags UseFlag
---@param activeSlot ActiveSlot
---@return boolean
local function IsCounted(useFlags, activeSlot)
    return activeSlot >= 0 and useFlags & UseFlag.USE_CARBATTERY == 0
end

---@param player EntityPlayer
---@param text string
local function ShowText(player, text)
    player:GetData().UseLimitText = { Text = text, Frame = Game():GetFrameCount() }
end

if EID then
    EID:addDescriptionModifier(
        "AstroUseLimit",
        function(descObj)
            local id = descObj.ObjSubType

            return descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and
                (STAGE_LIMIT[id] or GAME_LIMIT[id] or ONE_TIME_USE[id]) ~= nil
        end,
        function(descObj)
            local id = descObj.ObjSubType

            if STAGE_LIMIT[id] then
                EID:appendToDescription(descObj, "#{{ColorRed}}스테이지당 " .. STAGE_LIMIT[id] .. "회 발동 가능")
            end

            if GAME_LIMIT[id] then
                EID:appendToDescription(descObj, "#{{ColorRed}}한 게임당 " .. GAME_LIMIT[id] .. "회 발동 가능")
            end

            if ONE_TIME_USE[id] then
                EID:appendToDescription(descObj, "#{{ColorRed}}일회용")
            end

            return descObj
        end
    )
end

Astro:AddPriorityCallback(
    ModCallbacks.MC_PRE_USE_ITEM,
    CallbackPriority.IMPORTANT,
    ---@param collectibleType CollectibleType
    ---@param rng RNG
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags UseFlag
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleType, rng, playerWhoUsedItem, useFlags, activeSlot, varData)
        if not IsCounted(useFlags, activeSlot) then
            return
        end

        local remaining = GetRemaining(collectibleType)

        if remaining and remaining <= 0 then
            local charge = playerWhoUsedItem:GetActiveCharge(activeSlot) + playerWhoUsedItem:GetBatteryCharge(activeSlot)

            Astro:ScheduleForUpdate(
                function()
                    playerWhoUsedItem:SetActiveCharge(charge, activeSlot)
                end,
                2
            )

            ShowText(playerWhoUsedItem, GetName(collectibleType) .. " 아이템을 더 이상 사용할 수 없습니다 (남은 사용 횟수 0회)")

            return true
        end
    end
)

Astro:AddPriorityCallback(
    ModCallbacks.MC_USE_ITEM,
    CallbackPriority.IMPORTANT,
    ---@param collectibleType CollectibleType
    ---@param rng RNG
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags UseFlag
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleType, rng, playerWhoUsedItem, useFlags, activeSlot, varData)
        if collectibleType == CollectibleType.COLLECTIBLE_R_KEY then
            Astro.SaveManager.GetRunSave().UseLimit = {}
        end

        if not IsCounted(useFlags, activeSlot) then
            return
        end

        local key = tostring(collectibleType)

        if STAGE_LIMIT[collectibleType] then
            local counts = GetCounts(Astro.SaveManager.GetFloorSave())
            counts[key] = (counts[key] or 0) + 1
        end

        if GAME_LIMIT[collectibleType] then
            local counts = GetCounts(Astro.SaveManager.GetRunSave())
            counts[key] = (counts[key] or 0) + 1
        end

        local remaining = GetRemaining(collectibleType)

        if ONE_TIME_USE[collectibleType] then
            remaining = 0

            Astro:ScheduleForUpdate(
                function()
                    playerWhoUsedItem:RemoveCollectible(collectibleType, true, activeSlot)
                end,
                1
            )
        end

        if remaining then
            ShowText(playerWhoUsedItem, GetName(collectibleType) .. " 아이템을 사용했습니다 (남은 사용 횟수 " .. remaining .. "회)")
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
            local data = player:GetData()
            local text = data.UseLimitText

            if text then
                if Game():GetFrameCount() - text.Frame > TEXT_DURATION then
                    data.UseLimitText = nil
                else
                    local position = Astro:ToScreen(player.Position)

                    font:DrawStringUTF8(text.Text, position.X - 100, position.Y - 50, KColor(1, 1, 1, 1), 200, true)
                end
            end
        end
    end
)
