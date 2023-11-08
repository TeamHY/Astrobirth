-- For Card Reading, replace boss portal to random portal
---@param type EntityType
function Astro:OnSpawningBossPortal(type, variant, subtype)
	if (type == EntityType.ENTITY_EFFECT and variant == EffectVariant.PORTAL_TELEPORT and subtype == 1) then
		return {type, variant, 3, seed}
	end
end

Astro:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, Astro.OnSpawningBossPortal)

function Astro:OnRoomClear()
	local level = Game():GetLevel()
	local stage = level:GetAbsoluteStage()
	local currentRoom = level:GetCurrentRoom()
	local firstPlayer = Isaac.GetPlayer()

	if currentRoom:GetType() == RoomType.ROOM_BOSS then
		if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
			Isaac.Spawn(EntityType.ENTITY_SLOT, 10, 0, currentRoom:GetCenterPos(), Vector(0, 0), nil) -- Shop Restock Machine
		elseif
			stage == LevelStage.STAGE3_2 and level:GetStageType() >= StageType.STAGETYPE_REPENTANCE and
				currentRoom:GetBossID() == 6
		 then
			if not firstPlayer:HasCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_1) then
				firstPlayer:AddCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_1)
			end

			if not firstPlayer:HasCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_2) then
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
	end
end

Astro:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, Astro.OnRoomClear)

--- Automatically waste The Sun, The World, Ansuz
---@param player EntityPlayer
---@param cardID Card
---@param slotId integer
local function WasteCard(player, cardID, slotId)
	player:SetCard(slotId, 0)
	player:UseCard(cardID)
end

---@param player EntityPlayer
function Astro:AutoWasting(player)
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
	elseif player:GetCard(0) == Card.CARD_HOLY and player:GetPlayerType() == PlayerType.PLAYER_JUDAS then
		player:SetCard(0, 0) -- 획득 시 삭제
	else
		local pillColor = player:GetPill(0)

		if pillColor then
			local itemPool = Game():GetItemPool()
			local pillEffect = itemPool:GetPillEffect(pillColor)

			if pillEffect == PillEffect.PILLEFFECT_BALLS_OF_STEEL then
				player:SetPill(0, PillColor.PILL_NULL)
				player:UsePill(PillEffect.PILLEFFECT_BALLS_OF_STEEL, pillColor)
			end
		end
	end
end

Astro:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Astro.AutoWasting)

Astro:AddCallback(
	ModCallbacks.MC_POST_NEW_ROOM,
	function(_)
		local level = Game():GetLevel()
		local currentRoom = level:GetCurrentRoom()
		local currentRoomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())

		if currentRoom:GetFrameCount() <= 0 and currentRoom:IsFirstVisit() then
			local roomType = currentRoom:GetType()

			if roomType == RoomType.ROOM_DICE then
				local itemPool = Game():GetItemPool()

				Astro:SpawnCollectible(itemPool:GetCollectible(ItemPoolType.POOL_KEY_MASTER, true, currentRoom:GetSpawnSeed()), currentRoom:GetGridPosition(17), 1, true)
				Astro:SpawnCollectible(itemPool:GetCollectible(ItemPoolType.POOL_KEY_MASTER, true, currentRoom:GetSpawnSeed()), currentRoom:GetGridPosition(117), 1, true)
			elseif roomType == RoomType.ROOM_SUPERSECRET then
				local entities = Isaac.GetRoomEntities()

				for i = 1, #entities do
					if entities[i].Type == EntityType.ENTITY_SHOPKEEPER then
						entities[i]:Kill()
					end
				end
			elseif roomType == RoomType.ROOM_BOSS and currentRoom:GetBossID() == 55 then -- Mega Satan
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_COLLECTIBLE,
					Astro.Collectible.GREED,
					currentRoom:GetTopLeftPos() - Vector(-80, -80),
					Vector.Zero,
					nil
				)
			elseif roomType == RoomType.ROOM_BOSS and currentRoom:GetBossID() == 70 then -- Delirium
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_COLLECTIBLE,
					Astro.Collectible.GO_HOME,
					currentRoom:GetTopLeftPos() - Vector(20, 20),
					Vector.Zero,
					nil
				)
			elseif currentRoomDesc.Data.Name == "Mom" and currentRoomDesc.Data.Subtype == 89 then
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_COLLECTIBLE,
					Astro.Collectible.GO_HOME,
					currentRoom:GetCenterPos(),
					Vector.Zero,
					nil
				)
			end
		end

		if currentRoomDesc.Data.Name:sub(1, 6) == "[MIST]" then
			currentRoomDesc.Flags = currentRoomDesc.Flags | RoomDescriptor.FLAG_CURSED_MIST
		end
	end
)

Astro:AddCallback(
	ModCallbacks.MC_PRE_TEAR_COLLISION,
	---@param entityTear EntityTear
	---@param collider Entity
	---@param low boolean
	function(_, entityTear, collider, low)
		if collider.Type == EntityType.ENTITY_DEATHS_HEAD and not (collider.Variant == 1 or collider.Variant == 4) then
			if entityTear:HasTearFlags(TearFlags.TEAR_HORN) or entityTear:HasTearFlags(TearFlags.TEAR_NEEDLE) then
				return nil
			end

			if not entityTear:HasTearFlags(TearFlags.TEAR_PIERCING) then
				entityTear:Die()
			end

			return true
		end
	end
)

Astro:AddCallback(
	ModCallbacks.MC_POST_NPC_INIT,
	---@param entityNPC EntityNPC
	function(_, entityNPC)
		if entityNPC.Type == EntityType.ENTITY_DOGMA and entityNPC.Variant == 1 then
			local currentRoom = Game():GetLevel():GetCurrentRoom()
			local rng = entityNPC:GetDropRNG()

			Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, 0, 0, currentRoom:GetGridPosition(106), Vector.Zero, nil) -- Death's Head
			Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, rng:RandomInt(2) * 2, 0, currentRoom:GetGridPosition(118), Vector.Zero, nil) -- Death's Head or Cursed Death's Head
			Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, rng:RandomInt(2) * 2, 0, currentRoom:GetGridPosition(121), Vector.Zero, nil)
			Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, 0, 0, currentRoom:GetGridPosition(133), Vector.Zero, nil)
		end
	end
)
