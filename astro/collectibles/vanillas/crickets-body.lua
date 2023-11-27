local isc = require("astro.lib.isaacscript-common")

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesCricketsBody",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_CRICKETS_BODY then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#!!! {{Collectible453}}Compound Fracture가 금지 됩니다.")

            return descObj
        end
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_ITEM_PICKUP,
    ---@param player EntityPlayer
    ---@param pickingUpItem { itemType: ItemType, subType: CollectibleType | TrinketType }
    function(_, player, pickingUpItem)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY) then
            if pickingUpItem.subType == CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE then
                Astro:RemoveAllCollectible(player, CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE)
            end
        elseif pickingUpItem.subType == CollectibleType.COLLECTIBLE_CRICKETS_BODY then
            Game():GetItemPool():RemoveCollectible(CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE)
        end
    end
)
