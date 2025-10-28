if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesCardReading",
        function(descObj)
            if
                descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and
                descObj.ObjSubType == CollectibleType.COLLECTIBLE_CARD_READING
            then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#{{BossRoom}}보스방 클리어 시 스테이지에 포탈이 생성됩니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    ---@param rng RNG
    ---@param spawnPosition Vector
    function(_, rng, spawnPosition)
        local level = Game():GetLevel()
        local room = Game():GetRoom()

        if Astro:GetCollectibleNum(CollectibleType.COLLECTIBLE_CARD_READING) >= 2 and level:GetStage() > LevelStage.STAGE1_2 and room:GetType() == RoomType.ROOM_BOSS then
            Astro.Data.IsEnabledShortcutPortals = true
        end
    end
)
