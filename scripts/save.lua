Redrawn.Data = {
    Storage = {}
}

function Redrawn:SaveData()
    Isaac.SaveModData(Redrawn, Json.encode(Redrawn.Data))
end

function Redrawn:LoadSaveData()
    local raw = Redrawn:LoadData()
    local data = Json.decode(raw)

    Redrawn.Data = data
end

Redrawn:AddPriorityCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    CallbackPriority.IMPORTANT,
    function(isContinued)
        if isContinued then
            Redrawn:LoadSaveData()
        else
            local data = Json.decode(Redrawn:LoadData())

            Redrawn.Data.Storage = data.Storage
        end
    end
)

Redrawn:AddPriorityCallback(
    ModCallbacks.MC_PRE_GAME_EXIT,
    CallbackPriority.LATE,
    function(shouldSave)
        Redrawn:SaveData()
    end
)
