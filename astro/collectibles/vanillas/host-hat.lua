---
local ITEM_LIST = {
    CollectibleType.COLLECTIBLE_IPECAC,
    CollectibleType.COLLECTIBLE_DR_FETUS,
    CollectibleType.COLLECTIBLE_EPIC_FETUS,
    CollectibleType.COLLECTIBLE_FRUIT_CAKE,
    CollectibleType.COLLECTIBLE_FIRE_MIND,
}
---

local isc = require("astro.lib.isaacscript-common")
local hiddenItemManager = require("astro.lib.hidden_item_manager")

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesHostHat",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and Astro:ContainCollectible(ITEM_LIST, descObj.ObjSubType) then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#{{Collectible375}}Host Hat 효과가 적용됩니다.")

            return descObj
        end
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:ContainCollectible(ITEM_LIST, collectibleType) then
            if not hiddenItemManager:Has(player, CollectibleType.COLLECTIBLE_HOST_HAT) then
                hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_HOST_HAT)
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_REMOVED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:ContainCollectible(ITEM_LIST, collectibleType) then
            for _, item in ipairs(ITEM_LIST) do
                if player:HasCollectible(item) then
                    return
                end
            end

            if hiddenItemManager:Has(player, CollectibleType.COLLECTIBLE_HOST_HAT) then
                hiddenItemManager:Remove(player, CollectibleType.COLLECTIBLE_HOST_HAT)
            end
        end
    end
)
