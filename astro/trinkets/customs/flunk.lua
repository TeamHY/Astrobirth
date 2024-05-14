Astro.Trinket.FLUNK = Isaac.GetTrinketIdByName("Flunk")

if EID then
    EID:addTrinket(
        Astro.Trinket.FLUNK,
        "이 아이템은 {{Trinket145}}Perfection로 취급됩니다.#↓ 행운 -5#{{ColorGold}}↑ 행운 +3",
        "낙제"
    )

    -- Astro:AddGoldenTrinketDescription(Astro.Trinket.FLUNK, "")
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

        if player ~= nil and player:HasTrinket(Astro.Trinket.FLUNK) then
            if damageFlags & (DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS) == 0 then
                Astro:RemoveAllTrinket(player, Astro.Trinket.FLUNK)
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasTrinket(Astro.Trinket.FLUNK) then
            player.Luck = player.Luck - 5

            if player:GetTrinketMultiplier(Astro.Trinket.FLUNK) > 1 then
                player.Luck = player.Luck + 3
            end
        end
    end,
    CacheFlag.CACHE_LUCK
)
