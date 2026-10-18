QP_OVERWRITE = {
	isInfinity = false,
	range = 80,
	isDisable = false,
	disableAutoMod = true
}

Astro:AddCallback(
	ModCallbacks.MC_POST_GAME_STARTED,
	function(_, isContinued)
		if not isContinued then
			QP_OVERWRITE = {
				isInfinity = false,
				range = 80,
				isDisable = false,
				disableAutoMod = true
			}
		end
	end
)

-- 저주 처리
local CURSE_NAMES = {
	{ LevelCurse.CURSE_OF_DARKNESS, "Curse of Darkness" },
	{ LevelCurse.CURSE_OF_LABYRINTH, "Curse of the Labyrinth" },
	{ LevelCurse.CURSE_OF_THE_LOST, "Curse of the Lost" },
	{ LevelCurse.CURSE_OF_THE_UNKNOWN, "Curse of the Unknown" },
	{ LevelCurse.CURSE_OF_THE_CURSED, "Curse of the Cursed" },
	{ LevelCurse.CURSE_OF_MAZE, "Curse of the Maze" },
	{ LevelCurse.CURSE_OF_BLIND, "Curse of the Blind" },
	{ LevelCurse.CURSE_OF_GIANT, "Curse of the Giant" },
}

local removedCurse = 0

Astro:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL,
	function (_, curse)
		local hasPrometheus = false
		local hasCurseCleaner = false

		for i = 1, Game():GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)

			if player:HasCollectible(Astro.Collectible.PROMETHEUS) then
				hasPrometheus = true
			end

			if Astro:HasPerfectionEffect(player) or player:HasTrinket(Astro.Trinket.DOCTRINE) then
				hasCurseCleaner = true
			end
		end

		removedCurse = 0

		if hasPrometheus and not hasCurseCleaner then
			return curse | LevelCurse.CURSE_OF_DARKNESS
		end

		if (Game():GetLevel():GetStage() <= 3 and curse ~= 0) or hasCurseCleaner then
			removedCurse = curse
			return 0
		end
	end
)

Astro:AddCallback(ModCallbacks.MC_POST_UPDATE,
	function ()
		if removedCurse == 0 then return end

		local names = {}

		for _, entry in ipairs(CURSE_NAMES) do
			if removedCurse & entry[1] ~= 0 then
				table.insert(names, entry[2])
			end
		end

		removedCurse = 0

		if #names > 0 then
			Astro:ShowNotification(table.concat(names, ", ") .. " 해제됨", { 1, 0.8, 0.4 })
		end
	end
)

local font = Font()
font:Load(Astro.Fight.modPath .. "resources/font/eid_korean_soyanon.fnt")

Astro:AddCallback(
	ModCallbacks.MC_POST_RENDER,
	function(_)
		local level = Game():GetLevel()

		if level:GetCurrentRoomIndex() == 84 then
			if not Astro:IsCollectibleUnlocked(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE) then
				local player = Isaac.GetPlayer()
				local position = Isaac.WorldToRenderPosition(player.Position)
	
				font:DrawStringUTF8("대결 모드의 경우 데드갓 상태에서 원활한 게임을 지원합니다.", position.X - 100, position.Y, KColor(1, 1, 1, 1), 200, true)
				font:DrawStringUTF8("※세이브 파일은 헌영 카페에서 다운로드 가능※", position.X - 100, position.Y + 16, KColor(1, 0, 0, 1), 200, true)
			end
		end
	end
)
