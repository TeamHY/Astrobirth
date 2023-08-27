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

---@param id TrinketType
---@param appendText string | table
---@param numbersToMultiply number | table | nil
---@param maxMultiplier number | table | nil
function Astro.Utill:addGoldenTrinketDescription(id, appendText, numbersToMultiply, maxMultiplier)
    local data = EID.GoldenTrinketData[id]

    if data then
        if type(data) == "number" then
            EID:addGoldenTrinketMetadata(id, appendText, numbersToMultiply or data, maxMultiplier)
        else
            EID:addGoldenTrinketMetadata(id, appendText, numbersToMultiply or data.t, maxMultiplier or data.mult)
        end
    else
        EID:addGoldenTrinketMetadata(id, appendText, numbersToMultiply or 0, maxMultiplier)
    end

    if maxMultiplier and maxMultiplier > 4 then
        EID.GoldenTrinketData[id].mults = {maxMultiplier, maxMultiplier}
    end
end
