--- From isaacscript-common
---
--- Helper function to get the player from a tear, laser, bomb, etc. Returns undefined if the entity
--- does not correspond to any particular player.
---
--- This function works by looking at the `Parent` and the `SpawnerEntity` fields (in that order). As
--- a last resort, it will attempt to use the `Entity.ToPlayer` method on the entity itself.
---@param entity Entity
---@return EntityPlayer | nil
function Astro:GetPlayerFromEntity(entity)
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
function Astro:AddGoldenTrinketDescription(id, appendText, numbersToMultiply, maxMultiplier)
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

---@param collectibles CollectibleType[]
---@param rng RNG
---@param count integer
---@param ignoreCollectible CollectibleType?
---@param ignoreQuest boolean?
function Astro:GetRandomCollectibles(collectibles, rng, count, ignoreCollectible, ignoreQuest)
    ---@type CollectibleType[]
    local list = {}

    if ignoreQuest then
        local itemConfig = Isaac.GetItemConfig()

        for key, value in pairs(collectibles) do
            if value ~= ignoreCollectible and itemConfig:GetCollectible(value).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST then
                table.insert(list, value)
            end
        end
    else
        list = collectibles
    end

    ---@type CollectibleType[]
    local result = {}

    for i = 1, count do
        if #list == 0 then
            break
        end

        local idx = rng:RandomInt(#list) + 1

        table.insert(result, list[idx])
        table.remove(list, idx)
    end

    return result
end
