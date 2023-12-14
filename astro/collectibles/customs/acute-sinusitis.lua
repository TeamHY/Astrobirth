Astro.Collectible.ACUTE_SINUSITIS = Isaac.GetItemIdByName("Acute Sinusitis")

if EID then
    EID:addCollectible(Astro.Collectible.ACUTE_SINUSITIS, "10%의 확률로 접착 눈물이 나갑니다.#여러 개 소지 시 기본 확률이 합 연산으로 증가합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 45 이상일 때 100% 확률 ({{LuckSmall}}행운 1당 +2%p)", "급성 부비동염")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)

        if player ~= nil then
            if player:HasCollectible(Astro.Collectible.ACUTE_SINUSITIS) then
                local rng = player:GetCollectibleRNG(Astro.Collectible.ACUTE_SINUSITIS)
                local baseChance = 0.1 * player:GetCollectibleNum(Astro.Collectible.ACUTE_SINUSITIS);

                if rng:RandomFloat() < baseChance + player.Luck / 50 then
                    tear:ChangeVariant(TearVariant.BOOGER)
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BOOGER
                    tear.Color = Color(0.4, 0.97, 0.5, 1, 0, 0, 0)
                end
            end
        end
    end
)
