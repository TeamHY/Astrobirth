
ocul = require "scripts.sources.banobj"

local banList =
{
	--BanObj.New(PlayerType.PLAYER_MAGDALENA,	"Collectible",	CollectibleType.COLLECTIBLE_SAD_ONION),
	--[[

	여기에 BanObj.New 후 괄호 안에
	첫번째 항목 = 어떤 캐릭터에게 적용할지 적으면 됨 (모든 캐릭터에게 적용할거면 비워두기)
	두번째 항목 = 어떤 타입인지 적으면 됨 - 아이템이면 "Collectible" 부적이면 "Trinket"
	세번째 항목 = 해당 아이템 또는 부적의 번호 적으면 됨
	위에 예시 참조

	]]
}

function mod:BanItem(newstart)
    for i=1, #banList do
		banList[i]:Ban()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.BanItem)
