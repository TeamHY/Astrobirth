Astro.Collectible.CYGNUS = Isaac.GetItemIdByName("Cygnus")

if EID then
    -- 15초 -> 7.5초 -> 5초
    EID:addCollectible(Astro.Collectible.CYGNUS, "게임 시간 15초마다 빛줄기를 소환합니다.#중첩 시 발동 간격이 줄어듭니다.", "백조자리")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if player:HasCollectible(Astro.Collectible.CYGNUS) then
            if Game():GetFrameCount() % math.floor(450 / player:GetCollectibleNum(Astro.Collectible.CORVUS)) == 0 then
                player:UseActiveItem(160, false, true, false, false)
                player:UseActiveItem(160, false, true, false, false)
            end
        end
    end
)
