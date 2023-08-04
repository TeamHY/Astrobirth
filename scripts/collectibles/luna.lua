local prevCount = 0

local function ComputeCount()
    local count = 0

    for i = 1, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1)

        count = count + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LUNA, true)
    end

    return count
end

Astrobirth:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        prevCount = ComputeCount()
    end
)

Astrobirth:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        local currentRoom = Game():GetLevel():GetCurrentRoom()

        if player:HasCollectible(CollectibleType.COLLECTIBLE_LUNA) then
            local currentCount = ComputeCount()

            if prevCount < currentCount then
                local itemPool = Game():GetItemPool()
                local pillColor = itemPool:ForceAddPillEffect(PillEffect.PILLEFFECT_GULP)

                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_PILL,
                    pillColor,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                    Vector.Zero,
                    nil
                )
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_TRINKET,
                    TrinketType.TRINKET_FRAGMENTED_CARD,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                    Vector.Zero,
                    nil
                )
            end

            prevCount = currentCount
        end
    end
)
