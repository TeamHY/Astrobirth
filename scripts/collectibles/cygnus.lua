Astrobirth.Collectible.CYGNUS = Isaac.GetItemIdByName("Cygnus")

if EID then
    EID:addCollectible(Astrobirth.Collectible.CYGNUS, "게임 시간 15초마다 하늘에서 깃털이 떨어져 몬스터를 처치해줍니다 ({{Collectible160}} 액티브와 동일)", "백조자리")
end

Astrobirth:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if Game():GetFrameCount() % 450 == 0 then
            if player:HasCollectible(Astrobirth.Collectible.CYGNUS) then
                player:UseActiveItem(160, false, true, false, false)
                player:UseActiveItem(160, false, true, false, false)
            end
        end
    end
)
