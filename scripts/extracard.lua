

--load piber20helper
local _, err = pcall(require, "piber20helper")
if not string.match(tostring(err), "attempt to call a nil value %(method 'ForceError'%)") then
	Isaac.DebugString(tostring(err))
end

--default config values (and just in case the config was unable to load)
Redrawn.OriginalRepentance = true
Redrawn.OriginalCorruption = false
Redrawn.OriginalCold = false
--load config
local _, err = pcall(require, "config")
if not string.match(tostring(err), "attempt to call a nil value %(method 'ForceError'%)") then
	Isaac.DebugString(tostring(err))
end

--get the cards
LostCardsCardType = {
	CARD_COLD = Isaac.GetCardIdByName("I - The Cold"),
	CARD_SERVANT = Isaac.GetCardIdByName("II - The Servant"),
	CARD_WISDOM = Isaac.GetCardIdByName("III - Wisdom"),
	CARD_REPENTANCE = Isaac.GetCardIdByName("IV - Repentance"),
	CARD_ETERNITY = Isaac.GetCardIdByName("V - Eternity"),
	CARD_CORRUPTION = Isaac.GetCardIdByName("VI - Corruption"),
	CARD_IMMOLATION = Isaac.GetCardIdByName("VII - Immolation"),
	CARD_WORSHIP = Isaac.GetCardIdByName("VIII - Worship")
}

--add them to true coop's hud
local function onTrueCoopInit()
	InfinityTrueCoopInterface.AddModdedCardFront(LostCardsCardType.CARD_COLD, "gfx/ui/cards/lostcards.anm2", "I - The Cold")
	InfinityTrueCoopInterface.AddModdedCardFront(LostCardsCardType.CARD_SERVANT, "gfx/ui/cards/lostcards.anm2", "II - The Servant")
	InfinityTrueCoopInterface.AddModdedCardFront(LostCardsCardType.CARD_WISDOM, "gfx/ui/cards/lostcards.anm2", "III - Wisdom")
	InfinityTrueCoopInterface.AddModdedCardFront(LostCardsCardType.CARD_REPENTANCE, "gfx/ui/cards/lostcards.anm2", "IV - Repentance")
	InfinityTrueCoopInterface.AddModdedCardFront(LostCardsCardType.CARD_ETERNITY, "gfx/ui/cards/lostcards.anm2", "V - Eternity")
	InfinityTrueCoopInterface.AddModdedCardFront(LostCardsCardType.CARD_CORRUPTION, "gfx/ui/cards/lostcards.anm2", "VI - Corruption")
	InfinityTrueCoopInterface.AddModdedCardFront(LostCardsCardType.CARD_IMMOLATION, "gfx/ui/cards/lostcards.anm2", "VII - Immolation")
	InfinityTrueCoopInterface.AddModdedCardFront(LostCardsCardType.CARD_WORSHIP, "gfx/ui/cards/lostcards.anm2", "VIII - Worship")
end

if InfinityTrueCoopInterface then
    onTrueCoopInit()
else
    if not __infinityTrueCoop then
        __infinityTrueCoop = {}
    end

    __infinityTrueCoop[#__infinityTrueCoop + 1] = onTrueCoopInit
end

--add external item descriptions for them
if not __eidCardDescriptions then
  __eidCardDescriptions  = {}
end
__eidCardDescriptions[LostCardsCardType.CARD_COLD] = "Chills all enemies in the room"
__eidCardDescriptions[LostCardsCardType.CARD_SERVANT] = "Spawns a random familiar"
__eidCardDescriptions[LostCardsCardType.CARD_WISDOM] = "Teleports you to the super secret room"
__eidCardDescriptions[LostCardsCardType.CARD_REPENTANCE] = "Rerolls collectibles in the room#Rerolls pickups into other pickups of the same kind"
__eidCardDescriptions[LostCardsCardType.CARD_ETERNITY] = "Spawns an Eternal Heart"
__eidCardDescriptions[LostCardsCardType.CARD_CORRUPTION] = "Teleports you to a random special room"
__eidCardDescriptions[LostCardsCardType.CARD_IMMOLATION] = "Teleports you to the curse or sacrifice room"
__eidCardDescriptions[LostCardsCardType.CARD_WORSHIP] = "50% chance to spawn a collectible, otherwise deals 2 hearts worth of damage"

local checkedForModContent = false
LostCardsOtherModPickupVariant = {
	HEART_HOLY = -1
}
function Redrawn:checkForModContent()
	if not checkedForModContent then
		--holy heart
		LostCardsOtherModPickupVariant.HEART_HOLY = Isaac.GetEntityVariantByName("Heart (holy)")

		checkedForModContent = true
	end
end

--function that returns true if the card is a lost card
function Redrawn:isLostCard(card)
	if card == LostCardsCardType.CARD_COLD then
		return true
	elseif card == LostCardsCardType.CARD_SERVANT then
		return true
	elseif card == LostCardsCardType.CARD_WISDOM then
		return true
	elseif card == LostCardsCardType.CARD_REPENTANCE then
		return true
	elseif card == LostCardsCardType.CARD_ETERNITY then
		return true
	elseif card == LostCardsCardType.CARD_CORRUPTION then
		return true
	elseif card == LostCardsCardType.CARD_IMMOLATION then
		return true
	elseif card == LostCardsCardType.CARD_WORSHIP then
		return true
	end
	if AdamExpansionMod then
		if card == AdamExpansionCardType.CARD_HAVOC then
			return true
		elseif card == AdamExpansionCardType.CARD_RITUAL then
			return true
		elseif card == AdamExpansionCardType.CARD_DEXTERITY then
			return true
		elseif card == AdamExpansionCardType.CARD_EXTREMITY then
			return true
		end
	end

	return false
end

--returns a random lost card
local getRandomLostCardRNG = piber20HelperMod:getInitializedRNG()
function Redrawn:getRandomLostCard(ignoreUnlocked)
	local lostCardsPool = {
		LostCardsCardType.CARD_COLD,
		LostCardsCardType.CARD_SERVANT,
		LostCardsCardType.CARD_WISDOM,
		LostCardsCardType.CARD_REPENTANCE,
		LostCardsCardType.CARD_ETERNITY,
		LostCardsCardType.CARD_CORRUPTION,
		LostCardsCardType.CARD_IMMOLATION,
		LostCardsCardType.CARD_WORSHIP
	}
	if AdamExpansionMod then
		if ignoreUnlocked then
			table.insert(lostCardsPool, #lostCardsPool + 1, AdamExpansionCardType.CARD_HAVOC)
			table.insert(lostCardsPool, #lostCardsPool + 1, AdamExpansionCardType.CARD_RITUAL)
			table.insert(lostCardsPool, #lostCardsPool + 1, AdamExpansionCardType.CARD_DEXTERITY)
			table.insert(lostCardsPool, #lostCardsPool + 1, AdamExpansionCardType.CARD_EXTREMITY)
		else
			if AdamExpansionMod:isMarkCompleted(AdamMarkType.Isaac) then
				table.insert(lostCardsPool, #lostCardsPool + 1, AdamExpansionCardType.CARD_HAVOC)
			end
			if AdamExpansionMod:isMarkCompleted(AdamMarkType.Satan) then
				table.insert(lostCardsPool, #lostCardsPool + 1, AdamExpansionCardType.CARD_RITUAL)
			end
			if AdamExpansionMod:isMarkCompleted(AdamMarkType.UltraGreed) then
				table.insert(lostCardsPool, #lostCardsPool + 1, AdamExpansionCardType.CARD_DEXTERITY)
			end
			if AdamExpansionMod:isMarkCompleted(AdamMarkType.UltraGreed, AdamDifficultyType.Hard) then
				table.insert(lostCardsPool, #lostCardsPool + 1, AdamExpansionCardType.CARD_EXTREMITY)
			end
		end
	end
	return lostCardsPool[piber20HelperMod:getRandomNumber(1, #lostCardsPool, getRandomLostCardRNG)]
end

--the cold - slows all enemies in the room (spider bite effect) with revelations, can freeze some enemies
local coldIsActive = false
local clearColdTimer = 0

function Redrawn:useCold(card)


	player = piber20HelperMod:getPlayerUsingItem()

	level = Game():GetLevel()
	CurRoom = level:GetCurrentRoomIndex()
	entities = Isaac.GetRoomEntities()

	if player:GetData()._coldCount == nil then
		player:GetData()._coldCount = 3
	else
		player:GetData()._coldCount = player:GetData()._coldCount + 3
	end

	if not level:GetRoomByIdx(CurRoom).Clear then
				for i = 1, #entities do
					if entities[i]:IsVulnerableEnemy() and entities[i].Type ~= 33 then
						if entities[i]:ToNPC():IsBoss() then
							entities[i]:AddSlowing(EntityRef(player),90,30,Color(1,1,1,0.75,36,177,216))
						else
							entities[i]:GetData().UrHit = true
						end
					end
				end
				player:GetData()._coldCount = player:GetData()._coldCount-1
	end



end
Redrawn:AddCallback(ModCallbacks.MC_USE_CARD, Redrawn.useCold, LostCardsCardType.CARD_COLD)

function Redrawn:ColdEffect()
	local player = piber20HelperMod:getPlayerUsingItem()
	local level = Game():GetLevel()
	local CurRoom = level:GetCurrentRoomIndex()

	local	entities = Isaac.GetRoomEntities()

	if player:GetData()._coldCount ~= nil and not level:GetRoomByIdx(CurRoom).Clear then
		if player:GetData()._coldCount > 0 then

				for i = 1, #entities do
					if entities[i]:IsVulnerableEnemy() and entities[i].Type ~= 33 then
						if entities[i]:ToNPC():IsBoss() then
							entities[i]:AddSlowing(EntityRef(player),90,30,Color(1,1,1,0.75,36,177,216))
						else
							entities[i]:GetData().UrHit = true
						end
					end
				end
				player:GetData()._coldCount = player:GetData()._coldCount-1

		end
	end


end

Redrawn:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Redrawn.ColdEffect)


--the servant - gives random familiar for the room (basically the effect of the monster manual item)
function Redrawn:useServant(card)
	local player = piber20HelperMod:getPlayerUsingItem()
	player:UseActiveItem(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, false, true, false, false)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, false, true, false, false)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, false, true, false, false)
end
Redrawn:AddCallback(ModCallbacks.MC_USE_CARD, Redrawn.useServant, LostCardsCardType.CARD_SERVANT)

--wisdom - teleports the player to the super secret room
function Redrawn:useWisdom(card)
	piber20HelperMod:teleportToRoomType(RoomType.ROOM_SUPERSECRET)
end
Redrawn:AddCallback(ModCallbacks.MC_USE_CARD, Redrawn.useWisdom, LostCardsCardType.CARD_WISDOM)

--repentance - rerolls pickups in the room (like d6 + d20, but more focused. cards reroll into different cards, trinkets reroll into other trinkets, etc)
local getChestRerollRNG = piber20HelperMod:getInitializedRNG()
function Redrawn:getChestReroll()
	local variant = PickupVariant.PICKUP_CHEST
	local chestType = piber20HelperMod:getRandomNumber(1, 7, getChestRerollRNG)
	if chestType == 1 then
		variant = PickupVariant.PICKUP_CHEST
	elseif chestType == 2 then
		variant = PickupVariant.PICKUP_BOMBCHEST
	elseif chestType == 3 then
		variant = PickupVariant.PICKUP_SPIKEDCHEST
	elseif chestType == 4 then
		variant = PickupVariant.PICKUP_ETERNALCHEST
	elseif chestType == 5 then
		variant = PickupVariant.PICKUP_MIMICCHEST
	elseif chestType == 6 then
		variant = PickupVariant.PICKUP_LOCKEDCHEST
	elseif chestType == 7 then
		variant = PickupVariant.PICKUP_REDCHEST
	end

	return variant
end
local getAppleRerollRNG = piber20HelperMod:getInitializedRNG()
function Redrawn:getAppleReroll()
	local variant = AdamExpansionPickupVariant.APPLE_RED
	local appleType = piber20HelperMod:getRandomNumber(1, 9, getAppleRerollRNG)
	if appleType == 1 or appleType == 2 or appleType == 3 then
		variant = AdamExpansionPickupVariant.APPLE_RED
	elseif appleType == 4 or appleType == 5 or appleType == 6 then
		variant = AdamExpansionPickupVariant.APPLE_WHITE
	elseif appleType == 7 then
		variant = AdamExpansionPickupVariant.APPLE_DOUBLE_RED
	elseif appleType == 8 then
		variant = AdamExpansionPickupVariant.APPLE_DOUBLE_WHITE
	elseif appleType == 9 then
		variant = AdamExpansionPickupVariant.APPLE_DOUBLE_RED_WHITE
	end

	return variant
end
function Redrawn:replacePickup(pickup, type, variant, subType)
	local sprite = pickup:GetSprite()
	if not sprite:IsPlaying("Collect") then
		pickup = pickup:ToPickup()
		if pickup:IsShopItem() then
			pickup:Morph(type, variant, subType, true)
		else
			local position = pickup.Position
			local velocity = pickup.Velocity
			local spawner = pickup.SpawnerEntity
			pickup:Remove()
			Game():Spawn(type, variant, position, velocity, spawner, subType, piber20HelperMod:getRNGNext())
		end
	end
end
function Redrawn:useRepentance(card)
	local player = piber20HelperMod:getPlayerUsingItem()

	--do d6 effect
	player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, true, false, false)

	--our effect: reroll the other pickups as well
	if not Redrawn.OriginalRepentance then
		for _, heart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, -1, false, false)) do
			Redrawn:replacePickup(heart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
		end
		for _, coin in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, -1, false, false)) do
			Redrawn:replacePickup(coin, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0)
		end
		for _, key in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, -1, false, false)) do
			Redrawn:replacePickup(key, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0)
		end
		for _, bomb in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, -1, false, false)) do
			Redrawn:replacePickup(bomb, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0)
		end
		for _, chest in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, -1, false, false)) do
			local variant = Redrawn:getChestReroll()
			Redrawn:replacePickup(chest, EntityType.ENTITY_PICKUP, variant, ChestSubType.CHEST_CLOSED)
		end
		for _, bombChest in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMBCHEST, -1, false, false)) do
			local variant = Redrawn:getChestReroll()
			Redrawn:replacePickup(bombChest, EntityType.ENTITY_PICKUP, variant, ChestSubType.CHEST_CLOSED)
		end
		for _, spikeChest in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SPIKEDCHEST, -1, false, false)) do
			local variant = Redrawn:getChestReroll()
			Redrawn:replacePickup(spikeChest, EntityType.ENTITY_PICKUP, variant, ChestSubType.CHEST_CLOSED)
		end
		for _, eternalChest in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_ETERNALCHEST, -1, false, false)) do
			local variant = Redrawn:getChestReroll()
			Redrawn:replacePickup(eternalChest, EntityType.ENTITY_PICKUP, variant, ChestSubType.CHEST_CLOSED)
		end
		for _, mimicChest in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_MIMICCHEST, -1, false, false)) do
			local variant = Redrawn:getChestReroll()
			Redrawn:replacePickup(mimicChest, EntityType.ENTITY_PICKUP, variant, ChestSubType.CHEST_CLOSED)
		end
		for _, lockedChest in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, -1, false, false)) do
			local variant = Redrawn:getChestReroll()
			Redrawn:replacePickup(lockedChest, EntityType.ENTITY_PICKUP, variant, ChestSubType.CHEST_CLOSED)
		end
		for _, redChest in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, -1, false, false)) do
			local variant = Redrawn:getChestReroll()
			Redrawn:replacePickup(redChest, EntityType.ENTITY_PICKUP, variant, ChestSubType.CHEST_CLOSED)
		end
		for _, pill in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, -1, false, false)) do
			local subType = piber20HelperMod:getRandomPill()
			Redrawn:replacePickup(pill, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, subType)
		end
		for _, card in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, -1, false, false)) do
			local subType = card.SubType
			if piber20HelperMod:isTarotCard(subType) then
				subType = piber20HelperMod:getRandomTarotCard()
			elseif piber20HelperMod:isPlayingCard(subType) then
				subType = piber20HelperMod:getRandomPlayingCard()
			elseif piber20HelperMod:isMagicCard(subType) then
				subType = piber20HelperMod:getRandomMagicCard()
			elseif piber20HelperMod:isRune(subType) then
				subType = piber20HelperMod:getRandomRune()
			elseif Redrawn:isLostCard(subType) then
				subType = Redrawn:getRandomLostCard()
			end
			Redrawn:replacePickup(card, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, subType)
		end
		for _, trinket in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, -1, false, false)) do
			local subType = Game():GetItemPool():GetTrinket()
			Redrawn:replacePickup(trinket, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, subType)
		end
		if RebalancedBlackHeartsMod then
			for _, halfBlackHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, RebalancedBlackHeartVariant.HEART_HALF_BLACK_REAL, -1, false, false)) do
				Redrawn:replacePickup(halfBlackHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
		end
		if AdamExpansionMod then
			for _, halfBlackHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.HEART_HALF_BLACK, -1, false, false)) do
				Redrawn:replacePickup(halfBlackHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
			for _, doubleEternalHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.HEART_DOUBLE_ETERNAL, -1, false, false)) do
				Redrawn:replacePickup(doubleEternalHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
			for _, blackRedHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.HEART_BLENDED_BLACK_RED, -1, false, false)) do
				Redrawn:replacePickup(blackRedHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
			for _, redEternalHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.HEART_BLENDED_RED_ETERNAL, -1, false, false)) do
				Redrawn:replacePickup(redEternalHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
			for _, eternalSoulHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.HEART_BLENDED_ETERNAL_SOUL, -1, false, false)) do
				Redrawn:replacePickup(eternalSoulHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
			for _, soulBlackHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.HEART_BLENDED_SOUL_BLACK, -1, false, false)) do
				Redrawn:replacePickup(soulBlackHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
			for _, spikierChest in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.CHEST_SPIKIER, -1, false, false)) do
				local variant = Redrawn:getChestReroll()
				Redrawn:replacePickup(spikierChest, EntityType.ENTITY_PICKUP, variant, ChestSubType.CHEST_CLOSED)
			end
			for _, redApple in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.APPLE_RED, -1, false, false)) do
				local variant = Redrawn:getAppleReroll()
				Redrawn:replacePickup(redApple, EntityType.ENTITY_PICKUP, variant, redApple.SubType)
			end
			for _, whiteApple in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.APPLE_WHITE, -1, false, false)) do
				local variant = Redrawn:getAppleReroll()
				Redrawn:replacePickup(whiteApple, EntityType.ENTITY_PICKUP, variant, whiteApple.SubType)
			end
			for _, redDoubleApple in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.APPLE_DOUBLE_RED, -1, false, false)) do
				local variant = Redrawn:getAppleReroll()
				Redrawn:replacePickup(redDoubleApple, EntityType.ENTITY_PICKUP, variant, redDoubleApple.SubType)
			end
			for _, whiteDoubleApple in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.APPLE_DOUBLE_WHITE, -1, false, false)) do
				local variant = Redrawn:getAppleReroll()
				Redrawn:replacePickup(whiteDoubleApple, EntityType.ENTITY_PICKUP, variant, whiteDoubleApple.SubType)
			end
			for _, redWhiteDoubleApple in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, AdamExpansionPickupVariant.APPLE_DOUBLE_RED_WHITE, -1, false, false)) do
				local variant = Redrawn:getAppleReroll()
				Redrawn:replacePickup(redWhiteDoubleApple, EntityType.ENTITY_PICKUP, variant, redWhiteDoubleApple.SubType)
			end
		end
		if StackableFreePickups then
			for _, tripleHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.HEART_TRIPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(tripleHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
			for _, quadrupleHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.HEART_QUADRUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quadrupleHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
			for _, quintupleHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.HEART_QUINTUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quintupleHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
			for _, tripleCoin in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.COIN_TRIPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(tripleCoin, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0)
			end
			for _, quadrupleCoin in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.COIN_QUADRUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quadrupleCoin, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0)
			end
			for _, quintupleCoin in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.COIN_QUINTUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quintupleCoin, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0)
			end
			for _, tripleKey in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.KEY_TRIPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(tripleKey, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0)
			end
			for _, quadrupleKey in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.KEY_QUADRUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quadrupleKey, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0)
			end
			for _, quintupleKey in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.KEY_QUINTUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quintupleKey, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0)
			end
			for _, tripleBomb in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.BOMB_TRIPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(tripleBomb, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0)
			end
			for _, quadrupleBomb in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.BOMB_QUADRUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quadrupleBomb, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0)
			end
			for _, quintupleBomb in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, StackableFreePickupVariant.BOMB_QUINTUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quintupleBomb, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0)
			end
		end
		if HolyHeartMod then
			for _, holyHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, LostCardsOtherModPickupVariant.HEART_HOLY, -1, false, false)) do
				Redrawn:replacePickup(holyHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
		end
		if RebalancedBatteriesMod then
			for _, battery in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, -1, false, false)) do
				Redrawn:replacePickup(battery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0)
			end
			for _, normalBattery in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, RebalancedBatteryVariant.BATTERY_NORMAL, -1, false, false)) do
				Redrawn:replacePickup(normalBattery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0)
			end
			for _, doubleBattery in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, RebalancedBatteryVariant.BATTERY_DOUBLEPACK, -1, false, false)) do
				Redrawn:replacePickup(doubleBattery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0)
			end
			for _, tripleBattery in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, RebalancedBatteryVariant.BATTERY_TRIPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(tripleBattery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0)
			end
			for _, quadrupleBattery in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, RebalancedBatteryVariant.BATTERY_QUADRUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quadrupleBattery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0)
			end
			for _, quintupleBattery in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, RebalancedBatteryVariant.BATTERY_QUINTUPLEPACK, -1, false, false)) do
				Redrawn:replacePickup(quintupleBattery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0)
			end
			for _, microBattery in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, RebalancedBatteryVariant.BATTERY_MICRO, -1, false, false)) do
				Redrawn:replacePickup(microBattery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0)
			end
			for _, megaBattery in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, RebalancedBatteryVariant.BATTERY_MEGA, -1, false, false)) do
				Redrawn:replacePickup(megaBattery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0)
			end
		end
		if RebalancedBlackHeartsMod then
			for _, halfBlackHeart in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, RebalancedBlackHeartVariant.HEART_HALF_BLACK_REAL, -1, false, false)) do
				Redrawn:replacePickup(halfBlackHeart, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0)
			end
		end
	end
end
Redrawn:AddCallback(ModCallbacks.MC_USE_CARD, Redrawn.useRepentance, LostCardsCardType.CARD_REPENTANCE)

--eternity - gives an eternal heart
function Redrawn:useEternity(card)
	local player = piber20HelperMod:getPlayerUsingItem()
	local room = Game():GetRoom()
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL, room:FindFreePickupSpawnPosition(player.Position, 0, true), Vector(0,0), nil)
end
Redrawn:AddCallback(ModCallbacks.MC_USE_CARD, Redrawn.useEternity, LostCardsCardType.CARD_ETERNITY)

--corruption - teleports the player to the i am error room
function Redrawn:useCorruption(card)
	if Redrawn.OriginalCorruption then --original effect - teleports to i am error room
		piber20HelperMod:teleportToRoomType(GridRooms.ROOM_ERROR_IDX)
	else --our effect - do undefined effect
		local player = piber20HelperMod:getPlayerUsingItem()
		player:UseActiveItem(CollectibleType.COLLECTIBLE_UNDEFINED, false, true, false, false)
	end
end
Redrawn:AddCallback(ModCallbacks.MC_USE_CARD, Redrawn.useCorruption, LostCardsCardType.CARD_CORRUPTION)

--immolation - 50% chance to teleport to the curse room or sacrifice room
local immolationRNG = piber20HelperMod:getInitializedRNG()
function Redrawn:useImmolation(card)
	--get the level
	local level = Game():GetLevel()

	--make sure the rooms exist
	local roomIndex = nil
	local roomTeleport = piber20HelperMod:getRandomNumber(1, 2, immolationRNG)
	if roomTeleport <= 1 then --make sure the curse room exists
		roomIndex = piber20HelperMod:getRoomTypeIndex(RoomType.ROOM_CURSE)
		local roomDesc = level:GetRoomByIdx(roomIndex)

		--if it doesn't exist, teleport to sacrifice room instead
		if roomDesc.Data.Type ~= RoomType.ROOM_CURSE then
			roomIndex = piber20HelperMod:getRoomTypeIndex(RoomType.ROOM_SACRIFICE)
		end
	else --make sure the sacrifice room exists
		roomIndex = piber20HelperMod:getRoomTypeIndex(RoomType.ROOM_SACRIFICE)
		local roomDesc = level:GetRoomByIdx(roomIndex)

		--if it doesn't exist, teleport to curse room instead
		if roomDesc.Data.Type ~= RoomType.ROOM_SACRIFICE then
			roomIndex = piber20HelperMod:getRoomTypeIndex(RoomType.ROOM_CURSE)
		end
	end

	piber20HelperMod:teleportToRoomIndex(roomIndex)
	--if neither of them exists, this function will just teleport to a random room, so that's fine.
end
Redrawn:AddCallback(ModCallbacks.MC_USE_CARD, Redrawn.useImmolation, LostCardsCardType.CARD_IMMOLATION)

--worship - 50% chance to spawn a collectible or do 2 hearts of damage
local worshipRNG = piber20HelperMod:getInitializedRNG()
function Redrawn:useWorship(card)
	local player = piber20HelperMod:getPlayerUsingItem()
	if piber20HelperMod:getRandomNumber(1, 2, worshipRNG) <= 1 then
		--do 2 hearts of damage to the player
		local health = player:GetHearts() + player:GetSoulHearts() + player:GetEternalHearts()
		if health > 1 then
			player:TakeDamage(4, DamageFlag.DAMAGE_NOKILL|DamageFlag.DAMAGE_INVINCIBLE|DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0)
		else
			player:TakeDamage(4, DamageFlag.DAMAGE_INVINCIBLE|DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0)
		end
	else
		--spawn a collectible
		local room = Game():GetRoom()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, piber20HelperMod:getRandomCollectible(), room:FindFreePickupSpawnPosition(player.Position, 0, true), Vector(0,0), entity)
		player:AnimateHappy()
	end
end
Redrawn:AddCallback(ModCallbacks.MC_USE_CARD, Redrawn.useWorship, LostCardsCardType.CARD_WORSHIP)

--1/10 chance to replace a tarot card with one of our lost cards
local lostCardReplaceRNG = piber20HelperMod:getInitializedRNG()
function Redrawn:replaceCard(rng, currentCard, isPlayingCard, isRune, onlyRunes)
	--check if it's a tarot card
	if piber20HelperMod:isTarotCard(currentCard) then
		--1/20 chance to replace
		local replaceCardRNG = piber20HelperMod:getRandomNumber(1, 2, lostCardReplaceRNG)
		if replaceCardRNG == 1 then
			local cardTypeRNG = piber20HelperMod:getRandomNumber(1, 8, lostCardReplaceRNG)
			if cardTypeRNG == 1 then
				return LostCardsCardType.CARD_COLD
			elseif cardTypeRNG == 2 then
				return LostCardsCardType.CARD_SERVANT
			elseif cardTypeRNG == 3 then
				return LostCardsCardType.CARD_WISDOM
			elseif cardTypeRNG == 4 then
				return LostCardsCardType.CARD_REPENTANCE
			elseif cardTypeRNG == 5 then
				return LostCardsCardType.CARD_ETERNITY
			elseif cardTypeRNG == 6 then
				return LostCardsCardType.CARD_CORRUPTION
			elseif cardTypeRNG == 7 then
				return LostCardsCardType.CARD_IMMOLATION
			elseif cardTypeRNG == 8 then
				return LostCardsCardType.CARD_WORSHIP
			end
		end
	end
end
Redrawn:AddCallback(ModCallbacks.MC_GET_CARD, Redrawn.replaceCard)

function Redrawn:onRoomChange()
	--clear cold card effect after a few frames
	if coldIsActive then
		clearColdTimer = 6
	end
end
Redrawn:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Redrawn.onRoomChange)

function Redrawn:onRender()
	--do revelations snow overlay if cold card was used
	if REVEL then
		--make sure we're not in glacier, we dont want to mess with any existing snow overlays
		local inGlacier = false
		if StageSystem then
			if StageSystem.GetCurrentStage() == REVEL.STAGE.Glacier.Id then
				inGlacier = true
			end
		end
		if StageAPI then
			if REVEL.STAGE.Glacier:IsStage() then
				inGlacier = true
			end
		end
		if not inGlacier then
			if coldIsActive then
				REVEL.OVERLAY.Glacier3.Sprite.Color = Color.Lerp(REVEL.OVERLAY.Glacier3.Sprite.Color,Color(1,1,1,1,0,0,0),0.02)
				REVEL.OVERLAY.Glacier3.Render()
				REVEL.OVERLAY.Glacier4.Sprite.Color = Color.Lerp(REVEL.OVERLAY.Glacier4.Sprite.Color,Color(1,1,1,1,0,0,0),0.05)
				REVEL.OVERLAY.Glacier4.Render()
				REVEL.OVERLAY.Glacier5.Sprite.Color = Color.Lerp(REVEL.OVERLAY.Glacier5.Sprite.Color,Color(1,1,1,1,0,0,0),0.1)
				REVEL.OVERLAY.Glacier5.Render()
			end
		end

		if clearColdTimer > 0 then
			clearColdTimer = clearColdTimer - 1
			if clearColdTimer <= 0 then
				coldIsActive = false
				REVEL.OVERLAY.Glacier3.Sprite.Color = Color(1,1,1,1,0,0,0)
				REVEL.OVERLAY.Glacier4.Sprite.Color = Color(1,1,1,1,0,0,0)
				REVEL.OVERLAY.Glacier5.Sprite.Color = Color(1,1,1,1,0,0,0)
			end
		end
	end
end
Redrawn:AddCallback(ModCallbacks.MC_POST_RENDER, Redrawn.onRender)

function Redrawn:replaceLostCardBacks(card)
	if not CardBacksMod then
		local subType = card.SubType
		if Redrawn:isLostCard(subType) then
			local animation = "Appear"
			local room = Game():GetRoom()
			if (room:GetFrameCount() <= 0 and not room:IsFirstVisit()) or card:IsShopItem() then
				animation = "Idle"
			end
			local sprite = card:GetSprite()
			sprite:Load("gfx/unique_card_lost.anm2", true)
			sprite:Play(animation, true)
		end
	end
end
Redrawn:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Redrawn.replaceLostCardBacks, PickupVariant.PICKUP_TAROTCARD)

function Redrawn:onGameStart(isSaveGame)
	Redrawn:checkForModContent()

	piber20HelperMod:resetRNGSeed(getRandomLostCardRNG)
	piber20HelperMod:resetRNGSeed(getChestRerollRNG)
	piber20HelperMod:resetRNGSeed(getAppleRerollRNG)
	piber20HelperMod:resetRNGSeed(immolationRNG)
	piber20HelperMod:resetRNGSeed(worshipRNG)
	piber20HelperMod:resetRNGSeed(lostCardReplaceRNG)

	if Redrawn.OriginalRepentance then
		__eidCardDescriptions[LostCardsCardType.CARD_REPENTANCE] = "Rerolls collectibles in the room"
	end
	if Redrawn.OriginalCorruption then
		__eidCardDescriptions[LostCardsCardType.CARD_CORRUPTION] = "Teleports you to the error room"
	end
	if Redrawn.OriginalCold then
		__eidCardDescriptions[LostCardsCardType.CARD_COLD] = "Slows all enemies in the room"
	end
end
Redrawn:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Redrawn.onGameStart)

local function setLostCardsBackSprites()
	CardBacksMod:AssociateCardWithHudSprite(LostCardsCardType.CARD_COLD, CardBacksHudTypes.CUSTOM, "gfx/ui/unique_cards/lost_card.png", false)
	CardBacksMod:AssociateCardWithHudSprite(LostCardsCardType.CARD_SERVANT, CardBacksHudTypes.CUSTOM, "gfx/ui/unique_cards/lost_card.png", false)
	CardBacksMod:AssociateCardWithHudSprite(LostCardsCardType.CARD_WISDOM, CardBacksHudTypes.CUSTOM, "gfx/ui/unique_cards/lost_card.png", false)
	CardBacksMod:AssociateCardWithHudSprite(LostCardsCardType.CARD_REPENTANCE, CardBacksHudTypes.CUSTOM, "gfx/ui/unique_cards/lost_card.png", false)
	CardBacksMod:AssociateCardWithHudSprite(LostCardsCardType.CARD_ETERNITY, CardBacksHudTypes.CUSTOM, "gfx/ui/unique_cards/lost_card.png", false)
	CardBacksMod:AssociateCardWithHudSprite(LostCardsCardType.CARD_CORRUPTION, CardBacksHudTypes.CUSTOM, "gfx/ui/unique_cards/lost_card.png", false)
	CardBacksMod:AssociateCardWithHudSprite(LostCardsCardType.CARD_IMMOLATION, CardBacksHudTypes.CUSTOM, "gfx/ui/unique_cards/lost_card.png", false)
	CardBacksMod:AssociateCardWithHudSprite(LostCardsCardType.CARD_WORSHIP, CardBacksHudTypes.CUSTOM, "gfx/ui/unique_cards/lost_card.png", false)

	CardBacksMod:AssociateCardWithBackSprite(LostCardsCardType.CARD_COLD, "gfx/unique_card_lost.anm2", true)
	CardBacksMod:AssociateCardWithBackSprite(LostCardsCardType.CARD_SERVANT, "gfx/unique_card_lost.anm2", true)
	CardBacksMod:AssociateCardWithBackSprite(LostCardsCardType.CARD_WISDOM, "gfx/unique_card_lost.anm2", true)
	CardBacksMod:AssociateCardWithBackSprite(LostCardsCardType.CARD_REPENTANCE, "gfx/unique_card_lost.anm2", true)
	CardBacksMod:AssociateCardWithBackSprite(LostCardsCardType.CARD_ETERNITY, "gfx/unique_card_lost.anm2", true)
	CardBacksMod:AssociateCardWithBackSprite(LostCardsCardType.CARD_CORRUPTION, "gfx/unique_card_lost.anm2", true)
	CardBacksMod:AssociateCardWithBackSprite(LostCardsCardType.CARD_IMMOLATION, "gfx/unique_card_lost.anm2", true)
	CardBacksMod:AssociateCardWithBackSprite(LostCardsCardType.CARD_WORSHIP, "gfx/unique_card_lost.anm2", true)
end

--other mods need to do this
local CardBacksPreLoadFunction = setLostCardsBackSprites
if CardBacksHasLoaded then
	CardBacksPreLoadFunction()
else
	if not CardBacksPreLoad then
		CardBacksPreLoad = {}
	end
	CardBacksPreLoad[#CardBacksPreLoad + 1] = CardBacksPreLoadFunction
end
