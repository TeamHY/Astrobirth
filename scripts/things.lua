

-- For Card Reading, replace boss portal to random portal

---@param type EntityType
function Redrawn:OnSpawningBossPortal(type, variant, subtype)
	if (type == EntityType.ENTITY_EFFECT and variant == EffectVariant.PORTAL_TELEPORT and subtype == 1) then
		return { type, variant, 3, seed }
	end
end

Redrawn:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, Redrawn.OnSpawningBossPortal)



-- When killing The Lamb or ???, giving you a full key 

function Redrawn:OnDefeatingLamb()
	local level = Game():GetLevel();

	if (level:GetAbsoluteStage() == LevelStage.STAGE6 and level:GetCurrentRoom():GetType() == RoomType.ROOM_BOSS) then
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.KEY_FULL, 0, level:GetCurrentRoom():GetRandomPosition(0), Vector(0, 0), nil)
	end
end

Redrawn:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, Redrawn.OnDefeatingLamb)




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