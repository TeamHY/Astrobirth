local hiddenItemManager = require("astro.lib.hidden_item_manager")

---@param player EntityPlayer
---@param collectibleType CollectibleType
local function AddForceOne(player, collectibleType)
	if not hiddenItemManager:Has(player, collectibleType) then
		hiddenItemManager:Add(player, collectibleType)
	end
end

Astro:AddCallback(
	ModCallbacks.MC_POST_GAME_STARTED,
	function(_, isContinued)
		local player = Isaac.GetPlayer()
		local itemConfig = Isaac.GetItemConfig()
		local itemConfigItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)

		player:RemoveCostume(itemConfigItem)
	end
)

Astro:AddCallback(
	ModCallbacks.MC_POST_NEW_LEVEL,
	function(_)
		local player = Isaac.GetPlayer()
		local itemConfig = Isaac.GetItemConfig()
		local itemConfigItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)

		AddForceOne(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS)
		player:RemoveCostume(itemConfigItem)

		if
			player:GetPlayerType() == PlayerType.PLAYER_CAIN_B or player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B or
				player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B or
				player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B or
				player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY_B
		 then
			AddForceOne(player, CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		end
	end
)

function Astro:CurseRemove(curse) -- 입장 전 저주 제거
	local hasPrometheus = false
	local hasPerfection = false

	for i = 1, Game():GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)

		if player:HasCollectible(Astro.Collectible.PROMETHEUS) then
			hasPrometheus = true
		end

		if player:HasTrinket(TrinketType.TRINKET_PERFECTION) then
			hasPerfection = true
		end
	end

	if hasPrometheus and not hasPerfection then
		return curse | LevelCurse.CURSE_OF_DARKNESS
	end

	if (Game():GetLevel():GetStage() <= 3 and curse ~= 0) or hasPerfection then
		return 0
	end
end

Astro:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, Astro.CurseRemove)

---@param player EntityPlayer
function Astro:OnUpdate(player)
	local level = Game():GetLevel()
	local stage = level:GetStage()
	local playerType = player:GetPlayerType()

	if
		stage >= LevelStage.STAGE4_3 or
			(stage == LevelStage.STAGE4_2 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE) or
			playerType == PlayerType.PLAYER_JUDAS
	 then
		if
			playerType == PlayerType.PLAYER_KEEPER or playerType == PlayerType.PLAYER_KEEPER_B or
				playerType == PlayerType.PLAYER_THESOUL_B
		 then
		elseif playerType == PlayerType.PLAYER_THEFORGOTTEN then
			player:AddBoneHearts(-player:GetBoneHearts() + 2)
			player:AddBrokenHearts(4 - player:GetBrokenHearts())
			player:GetSubPlayer():AddBrokenHearts(2 - player:GetSubPlayer():GetBrokenHearts())
		elseif playerType == PlayerType.PLAYER_THESOUL then
			player:AddBrokenHearts(2 - player:GetBrokenHearts())
			player:GetSubPlayer():AddBoneHearts(-player:GetSubPlayer():GetBoneHearts() + 2)
			player:GetSubPlayer():AddBrokenHearts(4 - player:GetSubPlayer():GetBrokenHearts())
		else
			if player:GetEffectiveMaxHearts() > 2 then
				if player:GetMaxHearts() >= 2 then
					player:AddMaxHearts(2 - player:GetMaxHearts(), true)
					player:AddBoneHearts(-player:GetBoneHearts())
				else
					player:AddBoneHearts(1 - player:GetBoneHearts())
				end
			end

			if player:GetSoulHearts() > 6 then
				player:AddSoulHearts(6 - player:GetSoulHearts())
			end

			if player:GetBrokenHearts() < 8 then
				player:AddBrokenHearts(8 - player:GetBrokenHearts())
			end
		end
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGIC_8_BALL, true) then
		local idx = level:QueryRoomTypeIndex(RoomType.ROOM_PLANETARIUM, false, RNG())
		local room = level:GetRoomByIdx(idx)

		if room.Data.Type == RoomType.ROOM_PLANETARIUM then
			room.DisplayFlags = room.DisplayFlags | 1 << 2
			level:UpdateVisibility()
		end
	end
end

Astro:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Astro.OnUpdate)
