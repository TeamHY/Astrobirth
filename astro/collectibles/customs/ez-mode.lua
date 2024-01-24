Astro.Collectible.EZ_MODE = Isaac.GetItemIdByName("EZ Mode")

if EID then
    EID:addCollectible(Astro.Collectible.EZ_MODE, "#스테이지를 넘어갈 때마다 {{Card51}}Holy Card를 하나 드랍합니다.", "이지 모드")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function()
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.EZ_MODE) then
                Astro:SpawnCard(Card.CARD_HOLY, player.Position)
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        if Astro:CheckFirstVisitFrame(currentRoom) then
            if level:GetAbsoluteStage() == LevelStage.STAGE1_1 and level:GetCurrentRoomIndex() == 84 then
                Astro:SpawnCollectible(Astro.Collectible.EZ_MODE, currentRoom:GetGridPosition(16), nil, true)
            end
        end
    end
)
