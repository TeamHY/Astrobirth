Astro.Trinket.EYE_OF_GOD = Isaac.GetTrinketIdByName("Eye Of God")

if EID then
    EID:addTrinket(Astro.Trinket.EYE_OF_GOD, "#10%의 확률로 눈물에 후광이 생기며 후광에 닿은 적은 프레임당 2의 피해를 입습니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 45 이상일 때 100% 확률", "신의 눈")

    Astro.Utill:addGoldenTrinketDescription(Astro.Trinket.EYE_OF_GOD, "", 10)
end

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro.Utill:GetPlayerFromEntity(tear)

        if player ~= nil then
            if
                player:HasTrinket(Astro.Trinket.EYE_OF_GOD) and
                    not player:HasCollectible(CollectibleType.COLLECTIBLE_GODHEAD)
             then
                local rng = player:GetTrinketRNG(Astro.Trinket.EYE_OF_GOD)


                -- 눈물에 후광을 직접 적용하면 이펙트 오류가 발생한다. 따라서 리페어 모드와 동일한 아래 코드를 사용한다.
                player.TearFlags = player.TearFlags & ~TearFlags.TEAR_GLOW

                if rng:RandomFloat() < 0.1 * player:GetTrinketMultiplier(Astro.Trinket.EYE_OF_GOD) + player.Luck / 50 then
                    player.TearFlags = player.TearFlags | TearFlags.TEAR_GLOW
                end
            end
        end
    end
)
