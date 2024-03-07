Astro.Collectible.SCORPIO_EX = Isaac.GetItemIdByName("Scorpio EX")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.SCORPIO_EX, "초 전갈자리", "...", "공격 시 30%의 확률로 {{Poison}}독 파리를 소환합니다.#중첩이 가능합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 14 이상일 때 100% 확률 ({{LuckSmall}}행운 1당 +5%p)")
end

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = Astro:GetPlayerFromEntity(source.Entity)

        if player ~= nil and player:HasCollectible(Astro.Collectible.SCORPIO_EX) and entity:IsVulnerableEnemy() then
            if source.Type == EntityType.ENTITY_TEAR or damageFlags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER or source.Type == EntityType.ENTITY_KNIFE then
                local rng = player:GetCollectibleRNG(Astro.Collectible.SCORPIO_EX)

                for _ = 1, player:GetCollectibleNum(Astro.Collectible.SCORPIO_EX) do
                    if rng:RandomFloat() < 0.3 + player.Luck / 20 then
                        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 2, player.Position, Vector(0, 0), player)
                    end
                end
            end
        end
    end
)
