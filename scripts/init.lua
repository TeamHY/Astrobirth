
function Astrobirth:CurseRemove(curse) -- 입장 전 저주 제거
	if (Game():GetLevel():GetStage() <= 3 and curse ~= 0) then
		return 0
	else
		return ~(~BitSet128(curse) | BitSet128(
			LevelCurse.CURSE_OF_MAZE |
			LevelCurse.CURSE_OF_DARKNESS |
			LevelCurse.CURSE_OF_THE_LOST |
			LevelCurse.CURSE_OF_THE_UNKNOWN
		)).l;
	end
end

Astrobirth:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, Astrobirth.CurseRemove)

---@param player EntityPlayer
function Astrobirth:OnUpdate(player)
	if Game():GetLevel():GetStage() >= 9 then
		if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
		elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
			player:AddBoneHearts(-player:GetBoneHearts() + 2)
			player:AddBrokenHearts(4 - player:GetBrokenHearts())
			player:GetSubPlayer():AddBrokenHearts(2 - player:GetSubPlayer():GetBrokenHearts())
		elseif player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
			player:AddBrokenHearts(2 - player:GetBrokenHearts())
			player:GetSubPlayer():AddBoneHearts(-player:GetSubPlayer():GetBoneHearts() + 2)
			player:GetSubPlayer():AddBrokenHearts(4 - player:GetSubPlayer():GetBrokenHearts())
		elseif player:GetBrokenHearts() < 8 then
			player:AddMaxHearts(-player:GetEffectiveMaxHearts() + 2, true)
			player:AddBrokenHearts(8 - player:GetBrokenHearts())
		end
	end
end

Astrobirth:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Astrobirth.OnUpdate)
