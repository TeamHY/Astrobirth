Astro.Collectible.SNAKE_EYE = Isaac.GetItemIdByName("Sinful Spoils of Subversion - Snake Eye")

if EID then
    EID:addCollectible(Astro.Collectible.SNAKE_EYE, "눈물을 발사할 때마다 30%의 확률로 연옥의 유령을 소환합니다.#중첩 시 기본 확률이 합 연산으로 증가합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 70 이상일 때 100% 확률 (행운 1당 +1%p)", "반역의 죄보 - 스네이크아이")
end

local spawnChance = 0.3

local luckMultiply = 1 / 100

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)

        if player ~= nil then
            if player:HasCollectible(Astro.Collectible.SNAKE_EYE) then
                local rng = player:GetCollectibleRNG(Astro.Collectible.SNAKE_EYE)
                local baseChance = spawnChance * player:GetCollectibleNum(Astro.Collectible.SNAKE_EYE);

                if rng:RandomFloat() < baseChance + player.Luck * luckMultiply then
                    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, player.Position, Vector.Zero, player)
                    effect:GetSprite():Play("Charge", false)
                end
            end
        end
    end
)
