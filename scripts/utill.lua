Astro.Utill = {}

--- From isaacscript-common
---
--- Helper function to get the player from a tear, laser, bomb, etc. Returns undefined if the entity
--- does not correspond to any particular player.
---
--- This function works by looking at the `Parent` and the `SpawnerEntity` fields (in that order). As
--- a last resort, it will attempt to use the `Entity.ToPlayer` method on the entity itself.
---@param entity Entity
---@return EntityPlayer | nil
function Astro.Utill:GetPlayerFromEntity(entity)
    if entity == nil then
        return nil
    end

    if entity.Parent ~= nil then
        local player = entity.Parent:ToPlayer()
        if (player ~= nil) then
            return player
        end

        local familiar = entity.Parent:ToFamiliar()
        if familiar ~= nil then
            return familiar.Player
        end
    end

    if entity.SpawnerEntity ~= nil then
        local player = entity.SpawnerEntity:ToPlayer()
        if player ~= nil then
            return player
        end

        local familiar = entity.SpawnerEntity:ToFamiliar()
        if familiar ~= nil then
            return familiar.Player
        end
    end

    return entity:ToPlayer()
end
