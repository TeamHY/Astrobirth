-- For Card Reading, replace boss portal to random portal
---@param type EntityType
function Astrobirth:OnSpawningBossPortal(type, variant, subtype)
	if (type == EntityType.ENTITY_EFFECT and variant == EffectVariant.PORTAL_TELEPORT and subtype == 1) then
		return {type, variant, 3, seed}
	end
end

Astrobirth:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, Astrobirth.OnSpawningBossPortal)

--- When killing The Lamb or ???, giving you a full key
--- And when killing boss in mirror world, giving you a knife piece 2
---@param level Level
---@param currentRoom Room
local function OnBossRoomClear(level, currentRoom)
	local stage = level:GetAbsoluteStage()
	local player = Isaac.GetPlayer()

	if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
		Isaac.Spawn(EntityType.ENTITY_SLOT, 10, 0, currentRoom:GetCenterPos(), Vector(0, 0), nil) -- Shop Restock Machine

		if currentRoom:IsMirrorWorld() then
			player:AddCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_2)
		end
	elseif stage == LevelStage.STAGE3_2 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_DOGMA, true) then
			player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)
		end
	elseif stage == LevelStage.STAGE4_2 and level:GetStageType() ~= StageType.STAGETYPE_REPENTANCE then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_DOGMA, true) then
			player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)
		end
	elseif stage == LevelStage.STAGE6 then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1, true) then
			player:AddCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1)
		end

		if not player:HasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2, true) then
			player:AddCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2)
		end
	end
end

function Astrobirth:OnRoomClear()
	local level = Game():GetLevel()
	local currentRoom = level:GetCurrentRoom()

	if currentRoom:GetType() == RoomType.ROOM_BOSS then
		OnBossRoomClear(level, currentRoom)
	end
end

Astrobirth:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, Astrobirth.OnRoomClear)

--- Automatically waste The Sun, The World, Ansuz
---@param player EntityPlayer
---@param cardID Card
---@param slotId integer
local function WasteCard(player, cardID, slotId)
	player:SetCard(slotId, 0)
	player:UseCard(cardID)
end

---@param player EntityPlayer
function Astrobirth:AutoWastingCard(player)
	if player:GetCard(0) == Card.RUNE_ANSUZ then
		WasteCard(player, Card.RUNE_ANSUZ, 0)
	elseif player:GetCard(0) == Card.CARD_WORLD then
		WasteCard(player, Card.CARD_WORLD, 0)
	elseif player:GetCard(0) == Card.CARD_SUN then
		WasteCard(player, Card.CARD_SUN, 0)
	end
end

Astrobirth:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Astrobirth.AutoWastingCard)
