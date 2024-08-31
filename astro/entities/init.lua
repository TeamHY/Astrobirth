Astro.Entities = {}

require "astro.entities.dark-esau"
require "astro.entities.mega-chest"
require "astro.entities.restock-machine"
require "astro.entities.shortcut-portal"

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

Astro:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    ---@param effect EntityEffect
    function(_, effect)
        local data = effect:GetData()

        if data.Astro then
            if data.Astro.KillFrame and data.Astro.KillFrame <= Game():GetFrameCount() then
                effect:Die()
            end
        end
    end
)
