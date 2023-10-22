Astro.Collectible.GALACTIC_MEDAL_OF_VALOR = Isaac.GetItemIdByName("Galactic Medal Of Valor")

if EID then
    EID:addCollectible(Astro.Collectible.GALACTIC_MEDAL_OF_VALOR, "보스 몬스터 직접 공격 시 30% 추가 피해가 적용됩니다.", "은하 용맹 훈장")
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

        if player ~= nil and player:HasCollectible(Astro.Collectible.GALACTIC_MEDAL_OF_VALOR) then
            if entity:IsBoss() and (source.Type == EntityType.ENTITY_TEAR or damageFlags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER or source.Type == EntityType.ENTITY_KNIFE) then
                entity:TakeDamage(amount * 0.3, 0, EntityRef(player), 0)
            end
        end
    end
)
