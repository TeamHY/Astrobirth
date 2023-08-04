Astrobirth.Data = {
    Save = {}
}

function Astrobirth:SaveData()
    Isaac.SaveModData(Astrobirth, Json.encode(Astrobirth.Data))
end

---comment
---@param isContinued boolean
function Astrobirth:LoadSaveData(isContinued)
    if Astrobirth:HasData() then
        local raw = Astrobirth:LoadData()
        local data = Json.decode(raw)

        Astrobirth.Data = data or {}

        -- if isContinued then
        --     Astrobirth.Data.Save = Astrobirth.Data.Save ~= nil and Astrobirth.Data.Save or {}
        -- else
        --     Astrobirth.Data.Save = {}
        -- end
    end
end

Astrobirth:AddPriorityCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    CallbackPriority.IMPORTANT,
    function(_, isContinued)
        Astrobirth:LoadSaveData(isContinued)
    end
)

Astrobirth:AddPriorityCallback(
    ModCallbacks.MC_PRE_GAME_EXIT,
    CallbackPriority.LATE,
    function(_, shouldSave)
        Astrobirth:SaveData()
    end
)
