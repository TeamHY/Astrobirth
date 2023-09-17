local isc = require("astro.lib.isaacscript-common")

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        local currentRoom = Game():GetLevel():GetCurrentRoom()
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
            TrinketType.TRINKET_BABY_BENDER,
            currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
            Vector.Zero,
            nil
        )
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TRINKET,
            TrinketType.TRINKET_FORGOTTEN_LULLABY,
            currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
            Vector.Zero,
            nil
        )
    end,
    CollectibleType.COLLECTIBLE_KING_BABY
)
