Astro.Collectible.PIRATE_MAP = Isaac.GetItemIdByName("Pirate Map")

if EID then
    EID:addCollectible(Astro.Collectible.PIRATE_MAP, "", "해적 지도")
end

-- 현재 스테이지에서 랜덤한 방 위치 2개를 보여주며, 럭 2당 1개의 방을 추가적으로 보여줍니다

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
        
            if player:HasCollectible(Astro.Collectible.PIRATE_MAP) then
                local level = Game():GetLevel()
                local rooms = Game():GetLevel():GetRooms()
    
                for i = 0, rooms.Size - 1 do
                    local room = rooms:Get(i)
                    
                    print(room.Clear)
                end
            end

            break
        end
    end
)
