local hiddenItemManager = require("astro.lib.hidden_item_manager")

Astro:AddCallback(
	ModCallbacks.MC_POST_GAME_STARTED,
	function(_, isContinued)
		local player = Isaac.GetPlayer()

		if not isContinued then
			hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS)

			if
				player:GetPlayerType() == PlayerType.PLAYER_CAIN_B or player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B or
					player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B or
					player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B or
					player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY_B
			 then
				hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			end
		end

		local itemConfig = Isaac.GetItemConfig()
		local itemConfigItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)

		player:RemoveCostume(itemConfigItem)
	end
)

function Astro:CurseRemove(curse) -- 입장 전 저주 제거
	local hasPrometheus = false
	local hasCurseCleaner = false

	for i = 1, Game():GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)

		if player:HasCollectible(Astro.Collectible.PROMETHEUS) then
			hasPrometheus = true
		end

		if player:HasTrinket(TrinketType.TRINKET_PERFECTION) or player:HasTrinket(Astro.Trinket.DOCTRINE) then
			hasCurseCleaner = true
		end
	end

	if hasPrometheus and not hasCurseCleaner then
		return curse | LevelCurse.CURSE_OF_DARKNESS
	end

	if (Game():GetLevel():GetStage() <= 3 and curse ~= 0) or hasCurseCleaner then
		return 0
	end
end

Astro:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, Astro.CurseRemove)
