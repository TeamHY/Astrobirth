local isc = require("astro.lib.isaacscript-common")

Astro.Trinket.ELECTRONIC_PENNY = Isaac.GetTrinketIdByName("Electronic Penny")

if EID then
    EID:addTrinket(Astro.Trinket.ELECTRONIC_PENNY, "동전 획득 시 5% 확률로 {{Battery}}소형 배터리를 소환합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 95 이상일 때 100% 확률 (행운 1당 +1%p)", "일레트로닉 페니")

    Astro:AddGoldenTrinketDescription(Astro.Trinket.ELECTRONIC_PENNY, "", 5)
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PICKUP_COLLECT,
    ---@param pickup EntityPickup
    ---@param player EntityPlayer
    function(_, pickup, player)
        if pickup.Variant == PickupVariant.PICKUP_COIN then
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            if player:HasTrinket(Astro.Trinket.ELECTRONIC_PENNY) then
                local rng = player:GetTrinketRNG(Astro.Trinket.ELECTRONIC_PENNY)

                if rng:RandomFloat() < 0.05 * player:GetTrinketMultiplier(Astro.Trinket.ELECTRONIC_PENNY) + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_LIL_BATTERY,
                        2,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                        Vector.Zero,
                        player
                    )
                end
            end
        end
    end
)
