if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesDadsLostCoin",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_DADS_LOST_COIN then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#{{Coin}}행운 동전을 0 ~ 3개 추가로 드랍합니다.")

            return descObj
        end
    )
end

---@param count integer
---@param position Vector
local function spawnLuckyPenny(count, position)
    if count <= 0 then
        return
    end

    local currentRoom = Game():GetLevel():GetCurrentRoom()

    for _ = 1, count do
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COIN,
            5,
            currentRoom:FindFreePickupSpawnPosition(position, 40, true),
            Vector.Zero,
            nil
        )
    end
end

Astro:AddCallback(
    Astro.Callbacks.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_DADS_LOST_COIN) then
            local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_DADS_LOST_COIN)

            spawnLuckyPenny(rng:RandomInt(4), player.Position)
        end
    end,
    CollectibleType.COLLECTIBLE_DADS_LOST_COIN
)
