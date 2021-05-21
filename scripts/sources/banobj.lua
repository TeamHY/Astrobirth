
local BanObj={}

function BanObj.New(pType, iType, Id)
	local tmp = {pType=pType or "all", iType = iType or "Collectible", Id = Id}

	function tmp:Ban()
	    local player = Isaac.GetPlayer(0)

		if (pType == "all" or pType == player:GetPlayerType()) then
			if (iType == "Collectible") then
				Game():GetItemPool():RemoveCollectible(Id)
			elseif (iType == "Trinket") then
				Game():GetItemPool():RemoveTrinket(Id)
			end
		end
	end
end
