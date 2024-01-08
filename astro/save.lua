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

        if not isContinued then
            Astro.Data.PersistentPlayerData = {}
            Astro.Data.PersistentPickupData = {}
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

--- Credit to Xalum(Retribution)
---@param player EntityPlayer
function Astro:GetPersistentPlayerData(player)
	if Astro.Data and Astro.Data.PersistentPlayerData then
		local seedReference = CollectibleType.COLLECTIBLE_SKELETON_KEY
		local playerType = player:GetPlayerType()

		if playerType == PlayerType.PLAYER_LAZARUS2_B then
			seedReference = CollectibleType.COLLECTIBLE_DOLLAR
		elseif playerType ~= PlayerType.PLAYER_ESAU then
			player = player:GetMainTwin()
		end

		local tableIndex = tostring(player:GetCollectibleRNG(seedReference):GetSeed())

		Astro.Data.PersistentPlayerData[tableIndex] = Astro.Data.PersistentPlayerData[tableIndex] or {}
		return Astro.Data.PersistentPlayerData[tableIndex]
	end
end

--- Credit to Xalum(Retribution)
---@param pickup EntityPickup
function Astro:GetPersistentPickupData(pickup)
	if Astro.Data and Astro.Data.PersistentPickupData then
		local tableIndex = tostring(pickup.InitSeed)
		Astro.Data.PersistentPickupData[tableIndex] = Astro.Data.PersistentPickupData[tableIndex] or {}
		return Astro.Data.PersistentPickupData[tableIndex]
	end
end
