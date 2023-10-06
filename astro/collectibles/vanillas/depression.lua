if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesDepression",
        function(descObj)
            if
                descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and
                    descObj.ObjSubType == CollectibleType.COLLECTIBLE_DEPRESSION
             then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#게임 시간 15초마다 하늘에서 깃털이 떨어져 몬스터를 처치해줍니다 ({{Collectible160}} 액티브와 동일)")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if Game():GetFrameCount() % 450 == 0 then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_DEPRESSION) then
                player:UseActiveItem(160, false, true, false, false)
            end
        end
    end
)

