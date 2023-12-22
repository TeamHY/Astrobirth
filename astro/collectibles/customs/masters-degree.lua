local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.MASTERS_DEGREE = Isaac.GetItemIdByName("Master's Degree")

if EID then
    EID:addCollectible(Astro.Collectible.MASTERS_DEGREE, "모든 알약이 거대 알약으로 변경됩니다.#알약의 효과를 알 수 있게 됩니다", "석사 학위")
end

local HORSE_PILL_OFFSET = 1 << 11

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if pickup.Variant == PickupVariant.PICKUP_PILL then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasCollectible(Astro.Collectible.MASTERS_DEGREE) then
                    Game():GetItemPool():IdentifyPill(pickup.SubType)

                    if pickup.SubType - HORSE_PILL_OFFSET < 0 then
                        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, pickup.SubType + HORSE_PILL_OFFSET, true, true, false)
                    end

                    break
                end
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        local entities = Isaac.GetRoomEntities()

        for _, entity in ipairs(entities) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_PILL then
                Game():GetItemPool():IdentifyPill(entity.SubType)
            end
        end
    end,
    Astro.Collectible.MASTERS_DEGREE
)
