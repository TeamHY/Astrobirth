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
                "#{{ArrowDown}} {{TearsSmall}}연사(고정) -0.2" ..
                "#{{ArrowDown}} {{TearsSmall}}연사 배율 x0.9"
            )

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function (_, player, cacheFlag)
        player.MaxFireDelay = Astro:AddTears(player.MaxFireDelay, TEARS_INCREMENT * player:GetCollectibleNum(CollectibleType.COLLECTIBLE_NEPTUNUS))
    end,
    CacheFlag.CACHE_FIREDELAY
)


Astro:AddPriorityCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    CallbackPriority.LATE + 2000,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function (_, player, cacheFlag)
        player.MaxFireDelay = ((player.MaxFireDelay + 1) / TEARS_MULTIPLY) - 1
    end,
    CacheFlag.CACHE_FIREDELAY
)
