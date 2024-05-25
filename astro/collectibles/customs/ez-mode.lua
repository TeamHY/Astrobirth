Astro.Collectible.EZ_MODE = Isaac.GetItemIdByName("EZ Mode")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.EZ_MODE, "쉬운 모드", "...", "피격 페널티가 발생하지 않습니다.")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        if Astro:CheckFirstVisitFrame(currentRoom) then
            if level:GetAbsoluteStage() == LevelStage.STAGE1_1 and level:GetCurrentRoomIndex() == 84 then
                Astro:SpawnCollectible(Astro.Collectible.EZ_MODE, currentRoom:GetGridPosition(33), nil, true)
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = entity:ToPlayer()

        if player ~= nil then
            if player:HasCollectible(Astro.Collectible.EZ_MODE) then
                if damageFlags & DamageFlag.DAMAGE_NO_PENALTIES == 0 then
                    player:TakeDamage(amount, damageFlags | DamageFlag.DAMAGE_NO_PENALTIES, source, countdownFrames)
                    return false
                end
            end
        end
    end
)
