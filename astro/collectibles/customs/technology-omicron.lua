Astro.Collectible.TECHNOLOGY_OMICRON = Isaac.GetItemIdByName("Taurus EX")

if EID then
    Astro:AddEIDCollectible(
        Astro.Collectible.TECHNOLOGY_OMICRON,
        "",
        "...",
        "중첩이 가능합니다.#방 입장 시 아래 효과 중 한가지가 적용됩니다.#{{Tears}}연사(상한+2) 증가됩니다.#{{Damage}}공격력이 +2 증가됩니다. ({{Collectible34}} 액티브와 동일) #{{Speed}}이동 속도가 최대로 고정됩니다. 이미 최대일 경우 이 효과가 선택되지 않습니다.#유도 특성이 적용됩니다. ({{Collectible192}} 액티브와 동일)"
    )
end

-- 래피드 락바텀과 호환을 고려해 우선 순위 DEFAULT로 변경. 원래 LATE임.
Astro:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.DEFAULT, function(_, player)
	for i = 1, player:GetCollectibleNum(Astro.Collectible.TECHNOLOGY_OMICRON) do
		player.MaxFireDelay = mod.MultiplyTears(player.MaxFireDelay, mod.GetTearsMultiplier(player, 0.8))
	end
end, CacheFlag.CACHE_FIREDELAY)

local function addTechOmicronLaser(tear, count)
	local data = tear:GetData()
	local player = Astro:GetPlayerFromEntity(tear)
	local scale = tear.Size + 10

	count = count or math.max(1, player:GetCollectibleNum(Astro.Collectible.TECHNOLOGY_OMICRON))

	data.technologyOmicronLasers = {}

	for i = 1, count do
		local laser = player:FireTechXLaser(tear.Position, tear.Velocity, scale, player)
		laser.Parent = tear
		laser.SubType = LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT
		laser:Update()

		laser:GetData().isTechOmicronLaser = true

		for _, effect in pairs(Isaac.FindByType(1000, 50)) do
			if effect.SpawnerEntity and GetPtrHash(effect.SpawnerEntity) == GetPtrHash(laser) then
				effect.Visible = false
				effect:Update()
			end
		end

		table.insert(data.technologyOmicronLasers, laser)
		scale = scale + 15
	end
end

local function removeTechOmicronLasers(_, entity)
	local data = entity:GetData()
	if data.technologyOmicronLasers then
		for _, laser in pairs(data.technologyOmicronLasers) do
			if laser:Exists() then
				laser:Remove()
			end
		end

		data.technologyOmicronLasers = nil
	end
end

Astro:AddCallback(mod.Callback.REAL_FIRE_TEAR, function(_, tear, player)
	if player:HasCollectible(Astro.Collectible.TECHNOLOGY_OMICRON) and mod.ShouldTearGetEffects(tear) then
		mod.AddRetributionTearFlags(tear, mod.TEARFLAG.TECH_OMICRON)
		addTechOmicronLaser(tear)
	end
end)

Astro:AddCallback(mod.Callback.POST_THROW_KNIFE, function(_, knife, player)
	if player:HasCollectible(Astro.Collectible.TECHNOLOGY_OMICRON) or mod.HasPridePinEffect(player, mod.PridePinEffect.TECH_OMICRON) then
		mod.AddRetributionTearFlags(knife, mod.TEARFLAG.TECH_OMICRON)

		local data = knife:GetData()
		local scale = knife.Size + 10

		data.technologyOmicronLasers = {}

		for i = 1, player:GetCollectibleNum(Astro.Collectible.TECHNOLOGY_OMICRON) do
			local laser = player:FireTechXLaser(knife.Position, knife.Velocity, scale, player)
			laser.SubType = LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT
			laser.Parent = knife
			laser.PositionOffset = laser.SpawnerEntity.PositionOffset
			laser.ParentOffset = laser.SpawnerEntity.Velocity

			if laser.Variant == 1 then
				laser.Variant = 3
			end

			laser:Update()
			laser:GetData().isTechOmicronLaser = true

			for _, effect in pairs(Isaac.FindByType(1000, 50)) do
				if effect.SpawnerEntity and GetPtrHash(effect.SpawnerEntity) == GetPtrHash(laser) then
					effect.Visible = false
					effect:Update()
				end
			end

			table.insert(data.technologyOmicronLasers, laser)
			scale = scale + 15
		end
	end
end)

Astro:AddCallback(mod.Callback.POST_CATCH_KNIFE, removeTechOmicronLasers)

Astro:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	local data = tear:GetData()
	if mod.HasRetributionTearFlags(tear, mod.TEARFLAG.TECH_OMICRON) then
		if not data.technologyOmicronLasers then
			addTechOmicronLaser(tear)
		end
	elseif data.technologyOmicronLasers then
		removeTechOmicronLasers(_, tear)
	end	
end)

Astro:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
	local player = laser.SpawnerEntity and laser.SpawnerEntity:ToPlayer()
	if player and player:HasCollectible(Astro.Collectible.TECHNOLOGY_OMICRON) then
		laser.Variant = 9
		laser.CollisionDamage = laser.CollisionDamage * 1.5

		local sprite = laser:GetSprite()
		local animation = sprite:GetAnimation()
		sprite:Load("gfx/007.009_brimtech.anm2", true)
		sprite:Play(animation)
	end
end, 1)

Astro:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
	if laser:GetData().isTechOmicronLaser then
		if laser.SpawnerEntity and laser.Parent and (laser.SpawnerEntity.Type == 1 or mod.HasRetributionTearFlags(laser.SpawnerEntity, mod.TEARFLAG.TECH_OMICRON)) then
			laser.PositionOffset = laser.Parent.PositionOffset
			laser.ParentOffset = laser.Parent.Velocity
		else
			laser:Remove()
		end
	end
end, 2)
