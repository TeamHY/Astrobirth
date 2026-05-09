if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesMagic8Ball",
        function(descObj)
            if
                descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and
                descObj.ObjSubType == CollectibleType.COLLECTIBLE_MAGIC_8_BALL
            then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(
                descObj,
                "#{{Pill1}} 알약 효과를 알 수 있습니다."
            )

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if pickup.Variant == PickupVariant.PICKUP_PILL then
            if Astro:HasCollectible(CollectibleType.COLLECTIBLE_MAGIC_8_BALL) then
                Game():GetItemPool():IdentifyPill(pickup.SubType)
            end
        end
    end
)
