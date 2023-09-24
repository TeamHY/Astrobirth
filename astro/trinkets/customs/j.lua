local isc = require("astro.lib.isaacscript-common")

Astro.Trinket.J = Isaac.GetTrinketIdByName("J")

-- 황금 효과 : 기본 확률이 5% -> 10% 증가
-- 럭1당 1%p 증가

if EID then
    EID:addTrinket(Astro.Trinket.J, "일레트로닉 페니 : 동전 획득 시 (종류 상관 x) 5% 확률로 마이크로퀵 소환", "피의 붕대")

    Astro:AddGoldenTrinketDescription(Astro.Trinket.J, "맵에 {{CursedRoom}}저주방의 위치가 표시됩니다.")
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PICKUP_COLLECT,
    ---@param pickup EntityPickup
    ---@param player EntityPlayer
    function(_, pickup, player)
        if pickup.Variant == PickupVariant.PICKUP_COIN then
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            if player:HasTrinket(Astro.Trinket.J) then
                local rng = player:GetTrinketRNG(Astro.Trinket.J)

                if rng:RandomFloat() < 0.05 * player:GetTrinketMultiplier(Astro.Trinket.J) + player.Luck / 100 then
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
