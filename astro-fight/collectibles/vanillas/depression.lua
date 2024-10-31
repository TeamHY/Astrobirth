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
            EID:appendToDescription(descObj, "게임 시간 15초마다 빛줄기를 소환합니다.#중첩 시 발동 간격이 줄어듭니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_DEPRESSION) then
            if Game():GetFrameCount() % math.floor(450 / player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DEPRESSION)) == 0 then
                player:UseActiveItem(160, false, true, false, false)
            end
        end
    end
)
