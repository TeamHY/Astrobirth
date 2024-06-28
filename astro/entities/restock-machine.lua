local cooldownTime = 30 -- 1초

Astro:AddCallback(
    ModCallbacks.MC_PRE_PLAYER_COLLISION,
    ---@param player EntityPlayer
    ---@param collider Entity
    ---@param low boolean
    function(_, player, collider, low)
        if collider.Type == EntityType.ENTITY_SLOT and collider.Variant == 3001 then
            local data = collider:GetData()

            if not data["restock"] then
                data["restock"] = {
                    cooldown = 0
                }
            end

            if player:GetNumCoins() < 3 then
                return nil
            end

            if data["restock"].cooldown < Game():GetFrameCount() then
                data["restock"].cooldown = Game():GetFrameCount() + cooldownTime
                collider.SubType = collider.SubType + 1

                local sprite = collider:GetSprite()
                sprite:PlayOverlay("CoinInsert", true)
                SFXManager():Play(SoundEffect.SOUND_COIN_SLOT)

                player:AddCoins(-3)
                player:UseCard(Card.RUNE_PERTHRO, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)

                if collider.SubType == 5 then
                    sprite:Play("Broken", true)
                    collider:Kill()
                end
            end
        end
    end
)

-- Slot Callbacks
wakaba:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	for _, slot in pairs(Isaac.FindByType(6)) do
		local data = slot:GetData()
		if not data.wakaba_SlotDoneInit then
			data.wakaba_SlotDoneInit = true
			Isaac.RunCallbackWithParam(wakaba.Callback.SLOT_INIT, slot.Variant, slot)
		end

		Isaac.RunCallbackWithParam(wakaba.Callback.SLOT_UPDATE, slot.Variant, slot)

		wakaba:ForAllPlayers(function(player)
			if wakaba:DoEntitiesOverlap(player, slot) and not player:IsDead() then
				Isaac.RunCallbackWithParam(wakaba.Callback.SLOT_COLLISION, slot.Variant, slot, player)
			end
		end)
	end
end)



Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    ---@param bomb EntityBomb
    ---@param collider Entity
    ---@param low boolean
    function(_, bomb, collider, low)
        if collider.Type == EntityType.ENTITY_SLOT and collider.Variant == 3001 then
            print("bomb!")
            return false
        end
    end
)

local function DoEntitiesOverlap(entity1, entity2)
	return entity1.Position:Distance(entity2.Position) <= entity1.Size + entity2.Size
end

local function RemoveDefaultPickup(slot)
	for i = 4, 5 do
		for _, entity in pairs(Isaac.FindByType(i)) do
			if DoEntitiesOverlap(entity, slot) and entity.FrameCount <= 1 then
				entity:Remove()
			end
		end
	end
end
