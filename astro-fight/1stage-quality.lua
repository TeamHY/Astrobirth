---@type table<CollectibleType, boolean>
local REROLL_ITEMS = {
    [CollectibleType.COLLECTIBLE_1UP] = true,
}

Astro:AddCallback(
    Astro.Callbacks.MOD_INIT,
    function()
        Astro:AddRerollCondition(
            function(selectedCollectible)
                local level = Game():GetLevel()

                if level:GetAbsoluteStage() ~= LevelStage.STAGE1_1 then
                    return false
                end

                if REROLL_ITEMS[selectedCollectible] then
                    return {
                        reroll = true,
                        modifierName = "1Stage Item"
                    }
                end

                local roomType = Game():GetRoom():GetType()
                local quality = Isaac.GetItemConfig():GetCollectible(selectedCollectible).Quality

                if roomType == RoomType.ROOM_TREASURE and level:GetStageType() < StageType.STAGETYPE_REPENTANCE and quality <= 1 then
                    return {
                        reroll = true,
                        modifierName = "Treasure Room"
                    }
                elseif roomType == RoomType.ROOM_DEVIL and quality >= 4 then
                    return {
                        reroll = true,
                        modifierName = "Devil Room"
                    }
                elseif roomType == RoomType.ROOM_SECRET and quality >= 4 then
                    return {
                        reroll = true,
                        modifierName = "Secret Room"
                    }
                end

                return false
            end
        )
    end
)
