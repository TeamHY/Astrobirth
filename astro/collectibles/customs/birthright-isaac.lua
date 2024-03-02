Astro.Collectible.BIRTHRIGHT_ISAAC = Isaac.GetItemIdByName("Birthright - Isaac")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.BIRTHRIGHT_ISAAC, "생득권 - 아이작", "...", "방에 입장 시 {{Card81}}Soul of Isaac을 발동합니다.#중접이 가능합니다.")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        if currentRoom:GetFrameCount() <= 0 and currentRoom:IsFirstVisit() then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
            
                if player:HasCollectible(Astro.Collectible.BIRTHRIGHT_ISAAC) then
                    for _ = 1, player:GetCollectibleNum(Astro.Collectible.BIRTHRIGHT_ISAAC) do
                        player:UseCard(Card.CARD_SOUL_ISAAC, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
                    end
                end
            end
        end
    end
)
