
function mod:CurseRemove(curse) -- 입장 전 저주 제거
	if (Game():GetLevel():GetStage() <= 3 and curse ~= 0) then
		return 0
	end
end

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, mod.CurseRemove)

function mod:OnUpdate(player)
	if (Game():GetLevel():GetStage() >= 9 and player:GetBrokenHearts() < 8) then
		player:AddBrokenHearts(8 - player:GetBrokenHearts())
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnUpdate)
