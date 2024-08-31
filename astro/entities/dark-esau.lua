Astro:AddCallback(
    ModCallbacks.MC_PRE_NPC_COLLISION,
    ---@param npc EntityTear
    ---@param collider Entity
    ---@param low boolean
    function(_, npc, collider, low)
        if npc.Type == EntityType.ENTITY_DARK_ESAU and collider:ToPlayer() then
            return true
        end
    end
)
