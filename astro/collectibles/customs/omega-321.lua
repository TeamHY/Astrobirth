Astro.Collectible.OMEGA_321 = Isaac.GetItemIdByName("Omega 321")

if EID then
    EID:addCollectible(Astro.Collectible.OMEGA_321, "방 입장 시 모든 적들을 8초간 둔화시킵니다.", "오메가 321")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function()
        local currentRoom = Game():GetLevel():GetCurrentRoom()

        if not currentRoom:IsClear() then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasCollectible(Astro.Collectible.OMEGA_321) then
                    player:UseActiveItem(CollectibleType.COLLECTIBLE_HOURGLASS, false, true, false, false)
                    
                    break
                end
            end
        end
    end
)
