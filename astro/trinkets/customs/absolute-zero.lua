Astro.Trinket.ABSOLUTE_ZERO = Isaac.GetTrinketIdByName("Absolute Zero")

if EID then
    EID:addTrinket(Astro.Trinket.ABSOLUTE_ZERO, "#{{Freezing}} 10%의 확률로 적 처치시 적이 얼어붙는 눈물이 나갑니다.#{{Freezing}} 얼어붙은 적은 접촉 시 직선으로 날아가 10방향으로 고드름 눈물을 발사합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 45 이상일 때 100% 확률 ({{LuckSmall}}행운 1 당 +2%p)", "절대 영도")

    Astro:AddGoldenTrinketDescription(Astro.Trinket.ABSOLUTE_ZERO, "", 10)
end

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)

        if player ~= nil then
            if
                player:HasTrinket(Astro.Trinket.ABSOLUTE_ZERO) and
                    not player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS)
             then
                local rng = player:GetTrinketRNG(Astro.Trinket.ABSOLUTE_ZERO)

                if rng:RandomFloat() < 0.1 * player:GetTrinketMultiplier(Astro.Trinket.ABSOLUTE_ZERO) + player.Luck / 50 then
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_ICE
                    tear:ChangeVariant(TearVariant.ICE)
                end
            end
        end
    end
)
