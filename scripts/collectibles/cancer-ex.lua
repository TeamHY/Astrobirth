local cancerEX = {}

---comment
---@param entity Entity
---@param amount number
---@param damageFlags number
---@param source EntityRef
---@param countdownFrames number
function cancerEX:OnEntityTakeDmg(entity, amount, damageFlags, source, countdownFrames)
    local player = Isaac.GetPlayer(0)
    local entities = Isaac.GetRoomEntities()

    if
        player:HasCollectible(Redrawn.Collectible.CANCER_EX) and entity:IsVulnerableEnemy() and
            entity.Type ~= EntityType.ENTITY_FIREPLACE
     then
        if
            source.Type == EntityType.ENTITY_TEAR or damageFlags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER or
                source.Type == EntityType.ENTITY_KNIFE
         then
            for i = 1, #entities do
                if entities[i]:IsVulnerableEnemy() and entities[i].Type ~= EntityType.ENTITY_FIREPLACE then
                    entities[i]:TakeDamage(amount / 5, 0, EntityRef(player), 1)
                end
            end
        end
    end
end

Redrawn:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, cancerEX.OnEntityTakeDmg)

return cancerEX
