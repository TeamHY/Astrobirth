Redrawn.Data = {
    Save = {}
}

function Redrawn:SaveData()
    Isaac.SaveModData(Redrawn, Json.encode(Redrawn.Data))
end

---comment
---@param isContinued boolean
function Redrawn:LoadSaveData(isContinued)
    if Redrawn:HasData() then
        local raw = Redrawn:LoadData()
        local data = Json.decode(raw)

        Redrawn.Data = data or {}
    
        if isContinued then
            Redrawn.Data.Save = Redrawn.Data.Save or {}
        end
    end
end

Redrawn:AddPriorityCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    CallbackPriority.IMPORTANT,
    function(isContinued)
        Redrawn:LoadSaveData(isContinued)
    end
)

Redrawn:AddPriorityCallback(
    ModCallbacks.MC_PRE_GAME_EXIT,
    CallbackPriority.LATE,
    function(shouldSave)
        Redrawn:SaveData()
    end
)
