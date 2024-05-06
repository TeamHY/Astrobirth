Astro.Collectible.TECHNOLOGY_OMICRON = Isaac.GetItemIdByName("Technology Omicron")

if EID then
	Astro:AddEIDCollectible(
		Astro.Collectible.TECHNOLOGY_OMICRON,
		"",
		"...",
		"↑ {{Tears}} 연사 x0.8#눈물 주변에 레이저가 생깁니다."
	)
end

local reduce = 0

Astro:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.EARLY, function() reduce = 0 end, CacheFlag.CACHE_FIREDELAY)

local function GetTearsMultiplier(player, multiplierAmount)
	local playerType = player:GetPlayerType()
	local reduceModifer = 0
	reduce = reduce + 1
	multiplierAmount = multiplierAmount and 1 / multiplierAmount or 2

	if playerType == PlayerType.PLAYER_THEFORGOTTEN or playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
		reduceModifer = 1
	end

	local fireDelayMultiplier = 1 + (multiplierAmount - 1) / (reduce + reduceModifer)
	return 1 / fireDelayMultiplier
end

local function MultiplyTears(baseFiredelay, multiplier)
	local currentTears = 30 / (baseFiredelay + 1)
	local newTears = currentTears * multiplier
	local newFiredelay = math.max((30 / newTears) - 1, -0.75)

	return newFiredelay
end

-- 래피드 락바텀과 호환을 고려해 우선 순위 DEFAULT로 변경. 원래 LATE임.
Astro:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.DEFAULT, function(_, player)
	for i = 1, player:GetCollectibleNum(Astro.Collectible.TECHNOLOGY_OMICRON) do
		player.MaxFireDelay = MultiplyTears(player.MaxFireDelay, GetTearsMultiplier(player, 0.8))
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

local function RemoveTechOmicronLasers(entity)
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

local tearVariantPriority = {
	-- Defaults
	[TearVariant.BLUE]              = 0,
	-- [mod.TearVariant.ARROW_OF_LIGHT]		= 1,
	[TearVariant.BLOOD]             = 2,
	-- [mod.TearVariant.ARROW_OF_LIGHT_BLOOD]	= 3,
	-- [mod.TearVariant.TOOL]					= 4,
	-- [mod.TearVariant.TOFU]					= 5,
	-- [mod.TearVariant.EVES_NAIL_POLISH]		= 6,

	-- Piercing Defaults
	[TearVariant.CUPID_BLUE]        = 10,
	[TearVariant.CUPID_BLOOD]       = 12,
	-- [mod.TearVariant.ARROW_OF_LIGHT_CUPID]			= 14,
	-- [mod.TearVariant.ARROW_OF_LIGHT_CUPID_BLOOD]	= 16,
	-- [mod.TearVariant.TOOL_CUPID]					= 18,
	-- [mod.TearVariant.EVES_NAIL_POLISH_CUPID]		= 19,
	[TearVariant.BELIAL]            = 22,

	-- Glaucoma?????
	[TearVariant.GLAUCOMA]          = 25,
	[TearVariant.GLAUCOMA_BLOOD]    = 26,

	-- Default+
	-- [mod.TearVariant.CATARACT]		= 30,
	-- [mod.TearVariant.REFLUX]		= 32,
	-- [mod.TearVariant.REFLUX_BLOOD]	= 36,

	[TearVariant.HUNGRY]            = 40,
	[TearVariant.NAIL]              = 42,
	[TearVariant.NAIL_BLOOD]        = 44,
	-- [mod.TearVariant.PEASHY]		= 46,
	-- [mod.TearVariant.PEASHY_BLOOD]	= 48,

	[TearVariant.PUPULA]            = 50,
	[TearVariant.PUPULA_BLOOD]      = 52,
	-- [mod.TearVariant.EARWAX]		= 54,

	-- Default++
	[TearVariant.FIRE_MIND]         = 70,
	[TearVariant.DARK_MATTER]       = 70,
	[TearVariant.MYSTERIOUS]        = 70,
	[TearVariant.SCHYTHE]           = 70,
	[TearVariant.LOST_CONTACT]      = 70,
	[TearVariant.ICE]               = 70,
	[TearVariant.ROCK]              = 70,
	-- [mod.TearVariant.POLARIS]		= 75,

	-- Chance Based
	[TearVariant.METALLIC]          = 100,
	[TearVariant.EXPLOSIVO]         = 100,
	-- [mod.TearVariant.BAPTISMAL_SHELL]	= 105,
	-- [mod.TearVariant.CHOLERA]			= 105,
	-- [mod.TearVariant.MELITODES]			= 105,

	[TearVariant.BOOGER]            = 110,
	[TearVariant.SPORE]             = 110,

	[TearVariant.COIN]              = 120,
	[TearVariant.EGG]               = 120,
	[TearVariant.RAZOR]             = 120,
	[TearVariant.BLACK_TOOTH]       = 120,
	[TearVariant.NEEDLE]            = 120,
	[TearVariant.FIST]              = 120,

	-- [mod.TearVariant.SLICK_CLUB]	= 125,
	-- [mod.TearVariant.SLICK_DIAMOND]	= 125,
	-- [mod.TearVariant.SLICK_HEART]	= 125,
	-- [mod.TearVariant.SLICK_SPADE]	= 125,
	-- [mod.TearVariant.MUSTARD_SEED]	= 125,

	[TearVariant.TOOTH]             = 130,

	-- Weird Cases
	[TearVariant.BONE]              = 200,
	[TearVariant.GODS_FLESH]        = 250,
	[TearVariant.GODS_FLESH_BLOOD]  = 255,

	-- [mod.TearVariant.DEVILS_TOOTH]	= 260,
	-- [mod.TearVariant.SILVER_FLESH]	= 270,

	-- Semi-Special
	[TearVariant.EYE]               = 300,
	[TearVariant.EYE_BLOOD]         = 305,
	[TearVariant.BALLOON]           = 350,
	[TearVariant.BALLOON_BOMB]      = 355,
	[TearVariant.BALLOON_BRIMSTONE] = 360,

	-- [mod.TearVariant.BAD_APPLE]		= 400,
	-- [mod.TearVariant.BAD_APPLE_GOOD]= 402,

	TEAR_EFFECTS_THRESHOLD          = 450,

	-- [mod.TearVariant.THORN_ICE]		= 500,
	-- [mod.TearVariant.BLACK_HAMMER]	= 550,
	-- [mod.TearVariant.MAD_ONION]		= 600,

	-- Special
	SPECIAL_THRESHOLD               = 90000,

	[TearVariant.STONE]             = 99999,
	[TearVariant.BOBS_HEAD]         = 99999,
	[TearVariant.GRIDENT]           = 99999,
	[TearVariant.KEY]               = 99999,
	[TearVariant.KEY_BLOOD]         = 99999,
	[TearVariant.ERASER]            = 99999,
	[TearVariant.FIRE]              = 99999,
	[TearVariant.SWORD_BEAM]        = 99999,
	[TearVariant.TECH_SWORD_BEAM]   = 99999,

	-- [mod.TearVariant.ILIAD_SPEAR]	= 99999,

	-- Multi-dim
	[TearVariant.MULTIDIMENSIONAL]  = 100000,

	-- Ultra Special
	[TearVariant.CHAOS_CARD]        = 9999999,
}

local playerMimickingFamiliars = {
	[FamiliarVariant.INCUBUS]        = true,
	[FamiliarVariant.FATES_REWARD]   = true,
	[FamiliarVariant.TWISTED_BABY]   = true,
	[FamiliarVariant.UMBILICAL_BABY] = true,
}

local function WasTearFiredByPlayerMimic(tear, explicit)
	if not tear.SpawnerEntity then
		return false
	end

	local player = tear.SpawnerEntity:ToPlayer()
	if player and not explicit then
		return true
	end

	local familiar = tear.SpawnerEntity:ToFamiliar()
	if familiar and playerMimickingFamiliars[familiar.Variant] then
		return true
	end

	return false
end

local function ShouldTearGetEffects(tear)
	local data = tear:GetData()
	local priority = tearVariantPriority[tear.Variant] or 0

	return (
		WasTearFiredByPlayerMimic(tear) and
		priority < tearVariantPriority.TEAR_EFFECTS_THRESHOLD and
		not tear:HasTearFlags(TearFlags.TEAR_CHAIN) -- and
	-- not data.retributionDetoxified and
	-- not data.retributionIsMadOnion
	)
end

-- Astro:AddCallback(mod.Callback.REAL_FIRE_TEAR, function(_, tear, player)
local function RealFireTear(tear, player)
	if player:HasCollectible(Astro.Collectible.TECHNOLOGY_OMICRON) and ShouldTearGetEffects(tear) then
		tear:GetData().technologyOmicron = true
		addTechOmicronLaser(tear)
	end
end
-- end)

-- Real Fire Tear
Astro:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	local data = tear:GetData()
	if not data.calledRetributionFireTearCallbacks then
		if tear.FrameCount < 1 and tear.Parent and not tear:GetData().dowsing then
			if tear.Parent.Type == 1 or (tear.Parent.Type == 3 and (tear.Parent.Variant == 80 or tear.Parent.Variant == 235 or tear.Parent.Variant == 240)) then
				local query = tear.Parent:ToFamiliar()
				local player = (query and query.Player or tear.Parent):ToPlayer()
				data.calledRetributionFireTearCallbacks = true
				RealFireTear(tear, player)
			end
		elseif tear.FrameCount == 1 and tear.Parent then
			if tear.Parent.Type == 3 then
				if tear.Parent.Variant == 81 then
					RealFireTear(tear, tear.Parent:ToFamiliar().Player)
				end

				data.calledRetributionFireTearCallbacks = true
			end
		end
	end
end)

-- Astro:AddCallback(mod.Callback.POST_THROW_KNIFE, function(_, knife, player)
---@param knife EntityKnife
---@param player EntityPlayer
local function PostThrowKnife(knife, player)
	if player:HasCollectible(Astro.Collectible.TECHNOLOGY_OMICRON) then -- or mod.HasPridePinEffect(player, mod.PridePinEffect.TECH_OMICRON) then
		knife:GetData().technologyOmicron = true

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
end
-- end)

-- Post Throw Knife
Astro:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
	if knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer() then
		local data = knife:GetData()
		local isFlying = knife:IsFlying()

		if isFlying then
			local isReturning = data.retributionLastFrameDistance and data.retributionLastFrameDistance > knife.Position:Distance(knife.SpawnerEntity.Position)

			if not data.retributionLastFrameWasFlying then
				PostThrowKnife(knife, knife.SpawnerEntity:ToPlayer())
			end

			if isReturning and not data.retributionLastFrameWasReturning then
				data.retributionTearEffectEntityBlacklist = {}
				data.retributionKnifeIsReturning = true
			end

			data.retributionLastFrameWasReturning = isReturning
		elseif data.retributionLastFrameWasFlying then
			RemoveTechOmicronLasers(knife)
			data.retributionTearEffectEntityBlacklist = {}
			data.retributionKnifeIsReturning = false
		end

		data.retributionLastFrameWasFlying = isFlying
		data.retributionLastFrameDistance = knife.Position:Distance(knife.SpawnerEntity.Position)
	end
end, 0)

Astro:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
	if knife.FrameCount == 0 and knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer() then
		PostThrowKnife(knife, knife.SpawnerEntity:ToPlayer())
	end
end, 1)

Astro:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	local data = tear:GetData()
	if data.technologyOmicron then
		if not data.technologyOmicronLasers then
			addTechOmicronLaser(tear)
		end
	elseif data.technologyOmicronLasers then
		RemoveTechOmicronLasers(tear)
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
		if laser.SpawnerEntity and laser.Parent and (laser.SpawnerEntity.Type == 1 or laser.SpawnerEntity:GetData().technologyOmicron) then
			laser.PositionOffset = laser.Parent.PositionOffset
			laser.ParentOffset = laser.Parent.Velocity
		else
			laser:Remove()
		end
	end
end, 2)
