if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesFalsePHD",
        function(descObj)
            if
                descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and
                descObj.ObjSubType == CollectibleType.COLLECTIBLE_FALSE_PHD
            then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(
                descObj,
                "#획득 시 {{Pill1}}Shot Speed Down가 소환됩니다." ..
                "#등장하는 {{Pill1}} Shot Speed Down 알약이 {{ColorCyan}}말{{CR}}약으로 변경됩니다."
            )

            return descObj
        end
    )
end

Astro:AddCallback(
    Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_FALSE_PHD) then
            Astro:SpawnPill(PillEffect.PILLEFFECT_SHOT_SPEED_DOWN, player.Position)
        end
    end,
    CollectibleType.COLLECTIBLE_FALSE_PHD
)

local HORSE_PILL_OFFSET = 1 << 11

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if pickup.Variant == PickupVariant.PICKUP_PILL then
            if Game():GetItemPool():GetPillEffect(pickup.SubType) == PillEffect.PILLEFFECT_SHOT_SPEED_DOWN and Astro:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) then
                if pickup.SubType - HORSE_PILL_OFFSET < 0 then
                    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, pickup.SubType + HORSE_PILL_OFFSET, true, true, false)
                end
            end
        end
    end
)
