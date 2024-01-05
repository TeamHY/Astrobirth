local hiddenItemManager = require("astro.lib.hidden_item_manager")

Astro.Data = {}

-- Load Data
Astro:AddPriorityCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    CallbackPriority.IMPORTANT,
    ---@param isContinued boolean
    function(_, isContinued)
        if Astro:HasData() then
            local raw = Astro:LoadData()
            local data = Json.decode(raw)

            Astro.Data = data or {}

            hiddenItemManager:LoadData(Astro.Data.HiddenItemData)
        end
    end
)

-- Save Data
Astro:AddPriorityCallback(
    ModCallbacks.MC_PRE_GAME_EXIT,
    CallbackPriority.LATE,
    ---@param shouldSave boolean
    function(_, shouldSave)
        Astro.Data.HiddenItemData = hiddenItemManager:GetSaveData()
        Astro:SaveData(Json.encode(Astro.Data))
    end
)

---@param playerId integer
function Astro:GetPlayerSaveData(playerId)
    if Astro.Data.Players == nil then
        Astro.Data.Players = {}
    end

    if Astro.Data.Players[playerId] == nil then
        Astro.Data.Players[playerId] = {}
    end

    return Astro.Data.Players[playerId]
end
