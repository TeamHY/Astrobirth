local isc = require("astro.lib.isaacscript-common")

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesKingBaby",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_MARBLES then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(
                descObj,
                "#획득 시 {{Card92}}Soul of Lilith, {{Pill1}}Gulp!, {{Trinket127}}Baby Bender, {{Trinket141}}Forgotten Lullaby가 소환됩니다."
            )

            return descObj
        end
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_KING_BABY) then
            Astro:SpawnCard(Card.CARD_SOUL_LILITH, player.Position)
            Astro:SpawnPill(PillEffect.PILLEFFECT_GULP, player.Position)
            Astro:SpawnTrinket(TrinketType.TRINKET_BABY_BENDER, player.Position)
            Astro:SpawnTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY, player.Position)
        end
    end,
    CollectibleType.COLLECTIBLE_KING_BABY
)
