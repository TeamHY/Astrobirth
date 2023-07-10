

-- For Card Reading, replace boss portal to random portal
---@param type EntityType
function Redrawn:OnSpawningBossPortal(type, variant, subtype)
	if (type == EntityType.ENTITY_EFFECT and variant == EffectVariant.PORTAL_TELEPORT and subtype == 1) then
		return { type, variant, 3, seed }
	end
end

Redrawn:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, Redrawn.OnSpawningBossPortal)

--- When killing The Lamb or ???, giving you a full key
--- And when killing boss in mirror world, giving you a knife piece 2
---@param level any
---@param currentRoom any
local function OnBossRoomClear(level, currentRoom)
	if level:GetAbsoluteStage() == LevelStage.STAGE6 then
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.KEY_FULL, 0, currentRoom:GetRandomPosition(0), Vector(0, 0), nil)
	elseif level:GetCurrentRoom():IsMirrorWorld() then
		local player = Isaac.GetPlayer() -- 의도 됨

		player:AddCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_2)
	end
end

function Redrawn:OnRoomClear()
	local level = Game():GetLevel();
	local currentRoom = level:GetCurrentRoom()

	if currentRoom:GetType() == RoomType.ROOM_BOSS then
		OnBossRoomClear(level, currentRoom)
	end
end

Redrawn:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, Redrawn.OnRoomClear)




-- Automatically waste The Sun, The World, Ansuz
function WasteCard(player, CardID, index)
	player:SetCard(index, 0)
	player:UseCard(CardID)
end

---@param player EntityPlayer
function Redrawn:AutoWastingCard(player)
    if player:GetCard(0) == Card.RUNE_ANSUZ then
        WasteCard(player, Card.RUNE_ANSUZ, 0)
	elseif player:GetCard(0) == Card.CARD_WORLD then
        WasteCard(player, Card.CARD_WORLD, 0)
    elseif player:GetCard(0) == Card.CARD_SUN then
        WasteCard(player, Card.CARD_SUN, 0)
    end
end

Redrawn:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Redrawn.AutoWastingCard)
