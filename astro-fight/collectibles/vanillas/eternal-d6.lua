if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesEternalD6",
        function(descObj)
            if descObj.ObjType == 5 and descObj.ObjVariant == 100 and descObj.ObjSubType == 609 then
                local numPlayers = Game():GetNumPlayers()

                for i = 0, numPlayers - 1 do
                    local player = Isaac.GetPlayer(i)

                    if player:GetPlayerType() == PlayerType.PLAYER_THELOST then
                        return true
                    end
                end
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#스테이지 당 한번 사용할수 있습니다.")

            return descObj
        end
    )
end

local game = Game()

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued then
            for i = 1, game:GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
                local data = Astro:GetPersistentPlayerData(player)

                data.eternalD6Available = {}
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ---@param collectibleType CollectibleType
    ---@param rng RNG
    ---@param player EntityPlayer
    ---@param useFlags UseFlag
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleType, rng, playerWhoUsedItem, useFlags, activeSlot, varData)
        local level = game:GetLevel()
        local stage, stageType = level:GetStage(), level:GetStageType()
        local stageCheck = tostring(stage) .. "." .. tostring(stageType)

        local data = Astro:GetPersistentPlayerData(playerWhoUsedItem)
        data.eternalD6Available[stageCheck] = data.eternalD6Available[tostring(stageCheck)] or 1

        if collectibleType == CollectibleType.COLLECTIBLE_ETERNAL_D6 then
            if playerWhoUsedItem:GetPlayerType() == PlayerType.PLAYER_THELOST then
                if data.eternalD6Available[tostring(stageCheck)] == 1 then
                    data.eternalD6Available[tostring(stageCheck)] = 0
                end
            end
        elseif collectibleType == (CollectibleType.COLLECTIBLE_FORGET_ME_NOW or CollectibleType.COLLECTIBLE_R_KEY) then
            data.eternalD6Available = {}
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_PRE_USE_ITEM,
    ---@param collectibleType CollectibleType
    ---@param rng RNG
    ---@param player EntityPlayer
    ---@param useFlags UseFlag
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleType, rng, playerWhoUsedItem, useFlags, activeSlot, varData)
        if playerWhoUsedItem:GetPlayerType() == PlayerType.PLAYER_THELOST then
            local level = game:GetLevel()
            local stage, stageType = level:GetStage(), level:GetStageType()
            local stageCheck = tostring(stage) .. "." .. tostring(stageType)

            local data = Astro:GetPersistentPlayerData(playerWhoUsedItem)
            data.eternalD6Available[tostring(stageCheck)] = data.eternalD6Available[tostring(stageCheck)] or 1

            if data.eternalD6Available[tostring(stageCheck)] == 0 then
                local saveCharge = playerWhoUsedItem:GetActiveCharge(activeSlot)
                Astro:ScheduleForUpdate(
                    function()
                        playerWhoUsedItem:SetActiveCharge(saveCharge, activeSlot)
                    end,
                    2
                )
                return true
            end
        end
    end,
    CollectibleType.COLLECTIBLE_ETERNAL_D6
)