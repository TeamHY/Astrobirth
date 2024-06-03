local isc = require("astro.lib.isaacscript-common")

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
            EID:appendToDescription(descObj, "#획득 시 {{Pill1}}Shot Speed Down가 소환됩니다.")

            return descObj
        end
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_FALSE_PHD) then
            Astro:SpawnPill(PillEffect.PILLEFFECT_SHOT_SPEED_DOWN, player.Position)
        end
    end,
    CollectibleType.COLLECTIBLE_FALSE_PHD
)
