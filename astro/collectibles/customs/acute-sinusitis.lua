Astro.Collectible.ACUTE_SINUSITIS = Isaac.GetItemIdByName("Acute Sinusitis")

if EID then
    EID:addCollectible(Astro.Collectible.ACUTE_SINUSITIS, "10%의 확률로 접착 눈물이 나갑니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 45 이상일 때 100% 확률 ({{LuckSmall}}행운 1 당 +2%p)", "급성 부비동염")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)

        if player ~= nil then
            if player:HasCollectible(Astro.Collectible.ACUTE_SINUSITIS) then
                local rng = player:GetCollectibleRNG(Astro.Collectible.ACUTE_SINUSITIS)

                if rng:RandomFloat() < 0.1 + player.Luck / 50 then
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_STICKY
                    tear.Color = Color(0.4, 0.97, 0.5, 1, 0, 0, 0)
                end
            end
        end
    end
)
