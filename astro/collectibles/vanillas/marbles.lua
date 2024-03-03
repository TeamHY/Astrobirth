local isc = require("astro.lib.isaacscript-common")

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesMarbles",
        function(descObj)
            if
                descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and
                descObj.ObjSubType == CollectibleType.COLLECTIBLE_MARBLES
            then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#획득 시 {{Pill1}}Gulp!가 소환됩니다.")

            return descObj
        end
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_MARBLES) then
            Astro:SpawnPill(PillEffect.PILLEFFECT_GULP, player.Position)
        end
    end,
    CollectibleType.COLLECTIBLE_MARBLES
)
