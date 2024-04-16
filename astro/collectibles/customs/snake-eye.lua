Astro.Collectible.SNAKE_EYE = Isaac.GetItemIdByName("Sinful Spoils of Subversion - Snake Eye")

if EID then
    EID:addCollectible(Astro.Collectible.SNAKE_EYE, "공격 시 10%의 확률로 연옥의 유령을 소환합니다.#중첩 시 기본 확률이 합 연산으로 증가합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 30 이상일 때 100% 확률 (행운 1당 +3%p)", "반역의 죄보 - 스네이크아이")
end

local spawnChance = 0.1

local luckMultiply = 3 / 100

local cooldownTime = 60 -- 30 프레임 = 1초

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = Astro:GetPlayerFromEntity(source.Entity)

        if player ~= nil then
            local data = player:GetData()

            if (data["snakeEyeCooldown"] == nil or data["snakeEyeCooldown"] < Game():GetFrameCount()) and player:HasCollectible(Astro.Collectible.SNAKE_EYE) and entity:IsVulnerableEnemy() then
                if source.Type == EntityType.ENTITY_TEAR or damageFlags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER or source.Type == EntityType.ENTITY_KNIFE then
                    local rng = player:GetCollectibleRNG(Astro.Collectible.SNAKE_EYE)
                    local baseChance = spawnChance * player:GetCollectibleNum(Astro.Collectible.SNAKE_EYE);

                    if rng:RandomFloat() < baseChance + player.Luck * luckMultiply then
                        local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, player.Position, Vector.Zero, player)
                        effect:GetSprite():Play("Charge", false)

                        data["snakeEyeCooldown"] = Game():GetFrameCount() + cooldownTime
                    end
                end
            end
        end
    end
)
