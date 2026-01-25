if EID then
    EID:addDescriptionModifier(
        "AstroTrinketsRainbowWorm",
        function(descObj)
            return descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_TRINKET and descObj.ObjSubType == TrinketType.TRINKET_RAINBOW_WORM
        end,
        function(descObj)
            EID:appendToDescription(
                descObj,
                "#{{ColorGold}}공격이 적이 있는 방향을 향해 직선으로 날아갑니다."
            )
            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()

        if player and player:GetTrinketMultiplier(TrinketType.TRINKET_RAINBOW_WORM) > 1 then
            tear:AddTearFlags(TearFlags.TEAR_TURN_HORIZONTAL)
        end
    end
)
