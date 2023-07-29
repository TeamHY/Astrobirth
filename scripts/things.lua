-- For Card Reading, replace boss portal to random portal
---@param type EntityType
function Astrobirth:OnSpawningBossPortal(type, variant, subtype)
	if (type == EntityType.ENTITY_EFFECT and variant == EffectVariant.PORTAL_TELEPORT and subtype == 1) then
		return {type, variant, 3, seed}
	end
end

Astrobirth:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, Astrobirth.OnSpawningBossPortal)

Astrobirth:AddCallback(ModCallbacks.MC_POST_NPC_DEATH,
---@param entityNPC EntityNPC
function(_, entityNPC)
	if entityNPC.Variant == 0 then
		local player = Isaac.GetPlayer(0)
		local level = Game():GetLevel()
		local stage = level:GetAbsoluteStage()

		if stage == LevelStage.STAGE3_2 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE then
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_DOGMA, true) then
				player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)
			end
		end
	end
end, EntityType.ENTITY_MOMS_HEART)

---@param currentRoom Room
local function TrySpawnRandomPickup(currentRoom)
	for i = 1, Game():GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)

		if player:HasTrinket(TrinketType.TRINKET_PERFECTION) then
			local n = math.random(3)

			if n == 1 then
				Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COIN,
                    0,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                    Vector.Zero,
                    nil
                )
			elseif n == 2 then
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_BOMB,
					0,
					currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
					Vector.Zero,
					nil
				)
			elseif n == 3 then
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_KEY,
					0,
					currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
					Vector.Zero,
					nil
				)
			end
		end
	end
end

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

	TrySpawnRandomPickup(currentRoom)
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
	elseif player:GetCard(0) == Card.CARD_JUSTICE then
		WasteCard(player, Card.CARD_JUSTICE, 0)
	elseif player:GetCard(0) == Card.CARD_HIEROPHANT then
		WasteCard(player, Card.CARD_HIEROPHANT, 0)
	elseif player:GetCard(0) == Card.CARD_REVERSE_HIEROPHANT then
		WasteCard(player, Card.CARD_REVERSE_HIEROPHANT, 0)
	elseif player:GetCard(0) == Card.CARD_RULES then
		WasteCard(player, Card.CARD_RULES, 0)
	elseif player:GetCard(0) == Card.CARD_ANCIENT_RECALL then
		WasteCard(player, Card.CARD_ANCIENT_RECALL, 0)
	elseif player:GetCard(0) == Card.CARD_REVERSE_MAGICIAN then
		WasteCard(player, Card.CARD_REVERSE_MAGICIAN, 0)
	elseif player:GetCard(0) == Card.RUNE_BERKANO then
		WasteCard(player, Card.RUNE_BERKANO, 0)
	end
end

Astrobirth:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Astrobirth.AutoWastingCard)
