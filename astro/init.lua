function Astro:CurseRemove(curse) -- 입장 전 저주 제거
	local hasPrometheus = false
	local hasCurseCleaner = false

	for i = 1, Game():GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)

		if player:HasCollectible(AstroItems.Collectible.PROMETHEUS) then
			hasPrometheus = true
		end

		if Astro:HasPerfectionEffect(player) or player:HasTrinket(AstroItems.Trinket.DOCTRINE) then
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

Astro:AddCallback(
	ModCallbacks.MC_POST_RENDER,
	function(_)
		if not Astro:IsCollectibleUnlocked(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE) then
			local player = Isaac.GetPlayer()
			local position = Isaac.WorldToRenderPosition(player.Position)


			Isaac.RenderText("Death Certificate is not unlocked", position.X - 100, position.Y, 255, 0, 0, 255)
		end
	end
)
