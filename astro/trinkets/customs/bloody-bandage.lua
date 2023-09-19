Astro.Trinket.BLOODY_BANDAGE = Isaac.GetTrinketIdByName("Bloody Bandage")

if EID then
    EID:addTrinket(Astro.Trinket.BLOODY_BANDAGE, "{{CursedRoom}}저주방 대미지를 입지 않습니다.", "피의 붕대")

    Astro:AddGoldenTrinketDescription(Astro.Trinket.BLOODY_BANDAGE, "맵에 {{CursedRoom}}저주방의 위치가 표시됩니다.")
end

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
            if player:HasTrinket(Astro.Trinket.BLOODY_BANDAGE) then
                if damageFlags & DamageFlag.DAMAGE_CURSED_DOOR == DamageFlag.DAMAGE_CURSED_DOOR then
                    return false
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if player:GetTrinketMultiplier(Astro.Trinket.BLOODY_BANDAGE) > 1 then
            local level = Game():GetLevel()
            local idx = level:QueryRoomTypeIndex(RoomType.ROOM_CURSE, false, RNG())
            local room = level:GetRoomByIdx(idx)

            if room.Data.Type == RoomType.ROOM_CURSE then
                room.DisplayFlags = room.DisplayFlags | 1 << 2
                level:UpdateVisibility()
            end
        end
    end
)
