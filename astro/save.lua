Astro.Data = {
    Save = {}
}

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
        end
    end
)

-- Save Data
Astro:AddPriorityCallback(
    ModCallbacks.MC_PRE_GAME_EXIT,
    CallbackPriority.LATE,
    ---@param shouldSave boolean
    function(_, shouldSave)
        Astro:SaveData(Json.encode(Astro.Data))
    end
)
