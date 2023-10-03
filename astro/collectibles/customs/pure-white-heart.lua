Astro.Collectible.PURE_WHITE_HEART = Isaac.GetItemIdByName("Pure White Heart")

if EID then
    EID:addCollectible(
        Astro.Collectible.PURE_WHITE_HEART,
        "소지한 상태에서 {{BossRoom}}보스방 클리어 시 현재 아이템 중 랜덤으로 3개가 제거되며, {{AngelRoom}}천사방 아이템 2개를 소환합니다. 하나를 선택하면 나머지는 사라집니다.#!!! 효과가 발동한 뒤 사라집니다.",
        "순백의 심장"
    )
end

local GRID_SIZE = 40

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    function()
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.PURE_WHITE_HEART) and currentRoom:GetType() == RoomType.ROOM_BOSS then
                local rng = player:GetCollectibleRNG(Astro.Collectible.PURE_WHITE_HEART)
                local inventory = Astro:getPlayerInventory(player, false)
                local itemPool = Game():GetItemPool()

                local listToRemove =
                    Astro:GetRandomCollectibles(inventory, rng, 2, Astro.Collectible.PURE_WHITE_HEART, true)

                for _, value in ipairs(listToRemove) do
                    player:RemoveCollectible(value)
                    Astro:SpawnCollectible(value, player.Position, Astro.Collectible.PURE_WHITE_HEART)
                end

                Astro:SpawnCollectible(
                    itemPool:GetCollectible(ItemPoolType.POOL_ANGEL, true, currentRoom:GetSpawnSeed()),
                    player.Position,
                    Astro.Collectible.PURE_WHITE_HEART
                )
                Astro:SpawnCollectible(
                    itemPool:GetCollectible(ItemPoolType.POOL_ANGEL, true, currentRoom:GetSpawnSeed()),
                    player.Position,
                    Astro.Collectible.PURE_WHITE_HEART
                )

                player:RemoveCollectible(Astro.Collectible.PURE_WHITE_HEART)
            end
        end
    end
)
