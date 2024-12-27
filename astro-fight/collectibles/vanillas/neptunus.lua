---

local TEARS_INCREMENT = -0.2
local TEARS_MULTIPLY = 0.9

---

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesNeptunus",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_NEPTUNUS then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(
                descObj,
                "#{{ArrowUp}} {{TearsSmall}}연사(고정) -0.2" ..
                "#{{ArrowUp}} {{TearsSmall}}연사 배율 x0.9"
            )

            return descObj
        end
    )
end

Astro:AddPriorityCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    CallbackPriority.LATE + 2000,
    function (_, player, cacheFlag)
        
    end
)
