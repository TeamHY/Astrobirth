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
