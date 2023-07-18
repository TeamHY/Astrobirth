Astrobirth.Collectible.AQUARIUS_EX = Isaac.GetItemIdByName("Aquarius EX")

if EID then
    EID:addCollectible(Astrobirth.Collectible.AQUARIUS_EX, "공격 당한 몬스터에서 눈물이 뿜어져 나옵니다 (대미지는 캐릭터와 동일)", "초 물병자리")
end

Astrobirth:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = Astrobirth.Utill:GetPlayerFromEntity(source.Entity)

        if player ~= nil and player:HasCollectible(Astrobirth.Collectible.AQUARIUS_EX) and entity:IsVulnerableEnemy() then
            if
                source.Type == EntityType.ENTITY_TEAR or
                    damageFlags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER or
                    source.Type == EntityType.ENTITY_KNIFE
             then
                entity:GetData().AquariusSource = player
            end
        end
    end
)

Astrobirth:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function()
        local entities = Isaac.GetRoomEntities()

        for _, entity in ipairs(entities) do
            ---@type EntityPlayer
            local player = entity:GetData().AquariusSource

            if player ~= nil and entity:IsVulnerableEnemy() and Game().TimeCounter % 10 == 0 then
                local splashTear =
                    player:FireTear(
                    entity.Position,
                    Vector(player.ShotSpeed * 10, 0):Rotated(math.random(360)),
                    true,
                    true,
                    false
                )
                splashTear.FallingSpeed = player.TearHeight * .5 * (math.random() * .75 + .5)
                splashTear.FallingAcceleration = 1.3
                splashTear.TearFlags = splashTear.TearFlags | TearFlags.TEAR_PIERCING
            end
        end
    end
)
