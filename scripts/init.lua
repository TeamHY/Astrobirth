
function RedrawnMod:CurseRemove(curse) -- 입장 전 저주 제거
	if (Game():GetLevel():GetStage() <= 3 and curse ~= 0) then
		return 0
	end
end

RedrawnMod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, RedrawnMod.CurseRemove)

function RedrawnMod:OnUpdate(player)
	if Game():GetLevel():GetStage() >= 9 then
		if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
		elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
			player:AddBrokenHearts(4 - player:GetBrokenHearts())
			player:GetSubPlayer():AddBrokenHearts(4 - player:GetSubPlayer():GetBrokenHearts())
		elseif player:GetBrokenHearts() < 8 then
			player:AddBrokenHearts(8 - player:GetBrokenHearts())
		end
	end
end

RedrawnMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, RedrawnMod.OnUpdate)
