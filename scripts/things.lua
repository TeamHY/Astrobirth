-- For Card Reading, replace boss portal to random portal
---@param type EntityType
function Astrobirth:OnSpawningBossPortal(type, variant, subtype)
	if (type == EntityType.ENTITY_EFFECT and variant == EffectVariant.PORTAL_TELEPORT and subtype == 1) then
		return {type, variant, 3, seed}
	end
end

Astrobirth:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, Astrobirth.OnSpawningBossPortal)

local OPTIONS_PICKUP_INDEX = 145
local GRID_SIZE = 40
local GOLDEN_TRINKET_OFFSET = 32768

---@param player EntityPlayer
local function TryChangeToGoldenTrinket(player)
	local trinket0 = player:GetTrinket(0)
	local trinket1 = player:GetTrinket(1)

	if trinket0 ~= 0 then
		player:TryRemoveTrinket(trinket0)
	end

	if trinket1 ~= 0 then
		player:TryRemoveTrinket(trinket1)
	end

	if trinket0 ~= 0 then
		if trinket0 < GOLDEN_TRINKET_OFFSET then
			player:AddTrinket(trinket0 + GOLDEN_TRINKET_OFFSET)
		else
			player:AddTrinket(trinket0)
		end
	end

	if trinket1 ~= 0 then
		if trinket1 < GOLDEN_TRINKET_OFFSET then
			player:AddTrinket(trinket1 + GOLDEN_TRINKET_OFFSET)
		else
			player:AddTrinket(trinket1)
		end
	end
end

--- When killing The Lamb or ???, giving you a full key
--- And when killing boss in mirror world, giving you a knife piece 2
---@param level Level
---@param currentRoom Room
local function OnBossRoomClear(level, currentRoom)
	local stage = level:GetAbsoluteStage()
	local firstPlayer = Isaac.GetPlayer()
	local itemPool = Game():GetItemPool()

	if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
		Isaac.Spawn(EntityType.ENTITY_SLOT, 10, 0, currentRoom:GetCenterPos(), Vector(0, 0), nil) -- Shop Restock Machine

		if currentRoom:IsMirrorWorld() then
			firstPlayer:AddCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_2)
		end
	elseif stage == LevelStage.STAGE6 then
		if not firstPlayer:HasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1, true) then
			firstPlayer:AddCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1)
		end

		if not firstPlayer:HasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2, true) then
			firstPlayer:AddCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2)
		end
	end

	local isSpawnd = false

	for i = 1, Game():GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)

		if player:HasTrinket(TrinketType.TRINKET_PERFECTION) then
			if stage >= LevelStage.STAGE2_2 then
				TryChangeToGoldenTrinket(player)
			end

			if isSpawnd then
				break
			end

			isSpawnd = true

			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_BOMB,
				2,
				currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
				Vector.Zero,
				nil
			)
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_KEY,
				3,
				currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
				Vector.Zero,
				nil
			)

			if stage == LevelStage.STAGE1_2 then
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_COLLECTIBLE,
					CollectibleType.COLLECTIBLE_MAGIC_8_BALL,
					currentRoom:GetCenterPos() + Vector(0, GRID_SIZE),
					Vector.Zero,
					nil
				)
			elseif level:GetStageType() > StageType.STAGETYPE_AFTERBIRTH then
				break
			elseif stage == LevelStage.STAGE2_2 then
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_COLLECTIBLE,
					CollectibleType.COLLECTIBLE_MOMS_PURSE,
					currentRoom:GetCenterPos(),
					Vector.Zero,
					nil
				)
			elseif stage == LevelStage.STAGE3_1 then
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(-GRID_SIZE, 0),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(GRID_SIZE, 0),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
			elseif stage == LevelStage.STAGE3_2 and currentRoom:GetBossID() == 6 then
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_COLLECTIBLE,
					CollectibleType.COLLECTIBLE_DOGMA,
					currentRoom:GetCenterPos(),
					Vector.Zero,
					nil
				)

				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_TAROTCARD,
					Card.CARD_FOOL,
					currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
					Vector.Zero,
					nil
				)
			elseif stage == LevelStage.STAGE4_1 then
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(-GRID_SIZE * 2, 0),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(0, 0),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(GRID_SIZE * 2, 0),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
			elseif stage == LevelStage.STAGE4_2 then
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(-GRID_SIZE * 2, GRID_SIZE * 2),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(0, GRID_SIZE * 2),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(GRID_SIZE * 2, GRID_SIZE * 2),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
			elseif stage == LevelStage.STAGE4_3 then
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_COLLECTIBLE,
					CollectibleType.COLLECTIBLE_EDENS_BLESSING,
					currentRoom:GetCenterPos(),
					Vector.Zero,
					nil
				)
			elseif stage == LevelStage.STAGE5 then
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(-GRID_SIZE, GRID_SIZE * 2),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
				Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						itemPool:GetCollectible(ItemPoolType.POOL_DEVIL, true, currentRoom:GetSpawnSeed()),
						currentRoom:GetCenterPos() + Vector(GRID_SIZE, GRID_SIZE * 2),
						Vector.Zero,
						nil
					):ToPickup().OptionsPickupIndex = OPTIONS_PICKUP_INDEX
			elseif stage == LevelStage.STAGE6 then
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_TAROTCARD,
					Card.CARD_FOOL,
					currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
					Vector.Zero,
					nil
				)
			end
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

-- Astrobirth:AddCallback(
-- 	ModCallbacks.MC_POST_NPC_DEATH,
-- 	---@param entityNPC EntityNPC
-- 	function(_, entityNPC)
-- 		if entityNPC.Variant == 0 or entityNPC.Variant == 10 then
-- 			for i = 1, Game():GetNumPlayers() do
-- 				local player = Isaac.GetPlayer(i - 1)

-- 				if player:HasTrinket(TrinketType.TRINKET_PERFECTION) then
-- 					local level = Game():GetLevel()
-- 					local stage = level:GetAbsoluteStage()

-- 					if stage == LevelStage.STAGE3_2 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE then
-- 						player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)
-- 					elseif stage == LevelStage.STAGE4_2 and level:GetStageType() ~= StageType.STAGETYPE_REPENTANCE then
-- 						player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end,
-- 	EntityType.ENTITY_MOMS_HEART
-- )

-- Astrobirth:AddCallback(
-- 	ModCallbacks.MC_POST_NPC_DEATH,
-- 	---@param entityNPC EntityNPC
-- 	function(_, entityNPC)
-- 		local stage = Game():GetLevel():GetAbsoluteStage()

-- 		local isSpawndFool = false

-- 		for i = 1, Game():GetNumPlayers() do
-- 			local player = Isaac.GetPlayer(i - 1)

-- 			if player:HasTrinket(TrinketType.TRINKET_PERFECTION) and stage == LevelStage.STAGE3_2 then
-- 				if not isSpawndFool then
-- 					local currentRoom = Game():GetLevel():GetCurrentRoom()

-- 					Isaac.Spawn(
-- 						EntityType.ENTITY_PICKUP,
-- 						PickupVariant.PICKUP_TAROTCARD,
-- 						Card.CARD_FOOL,
-- 						currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
-- 						Vector.Zero,
-- 						nil
-- 					)

-- 					isSpawndFool = true
-- 				end

-- 				player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)
-- 			end
-- 		end
-- 	end,
-- 	EntityType.ENTITY_MOM
-- )

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
