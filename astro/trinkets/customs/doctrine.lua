Astro.Trinket.DOCTRINE = Isaac.GetTrinketIdByName("Doctrine")

if EID then
    EID:addTrinket(Astro.Trinket.DOCTRINE, "스테이지 입장 시 {{AngelRoom}}천사방 확률이 15% 증가합니다.#저주가 적용되지 않습니다.", "교리")

    Astro:AddGoldenTrinketDescription(Astro.Trinket.DOCTRINE, "", 15, 2)
end

local angelRoomChance = 0.15

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if not player:HasTrinket(Astro.Trinket.DOCTRINE) then
                break
            end

            local level = Game():GetLevel()

            if player:GetTrinketMultiplier(Astro.Trinket.DOCTRINE) > 1 then
                level:AddAngelRoomChance(angelRoomChance)
            else
                level:AddAngelRoomChance(angelRoomChance * 2)
            end
        end
    end
)

-- 저주 제거 astro/init.lua
