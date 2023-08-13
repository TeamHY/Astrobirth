Astro.Data = {
    Save = {}
}

function Astro:SaveData()
    Isaac.SaveModData(Astro, Json.encode(Astro.Data))
end

---comment
---@param isContinued boolean
function Astro:LoadSaveData(isContinued)
    if Astro:HasData() then
        local raw = Astro:LoadData()
        local data = Json.decode(raw)

        Astro.Data = data or {}

        -- if isContinued then
        --     Astrobirth.Data.Save = Astrobirth.Data.Save ~= nil and Astrobirth.Data.Save or {}
        -- else
        --     Astrobirth.Data.Save = {}
        -- end
    end
end

Astro:AddPriorityCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    CallbackPriority.IMPORTANT,
    function(_, isContinued)
        Astro:LoadSaveData(isContinued)
    end
)

Astro:AddPriorityCallback(
    ModCallbacks.MC_PRE_GAME_EXIT,
    CallbackPriority.LATE,
    function(_, shouldSave)
        Astro:SaveData()
    end
)
