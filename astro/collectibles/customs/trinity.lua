local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.TRINITY = Isaac.GetItemIdByName("Trinity")

if EID then
    EID:addCollectible(Astro.Collectible.TRINITY, "", "삼위일체")
end

-- 보스방 클리어 시 더 바디, 더 소울, 더 마인드를 제거합니다. 스테이지 입장 시 마다 더 바디, 더 소울, 더 마인드, 소지한 아이템 중 한가지가 소환되며, 4가지중 한가지 아이템을 획득하면 나머지는 사라집니다. 앞으로 등장하지 않습니다.

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        local itemPool = Game():GetItemPool()

        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_MIND)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BODY)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_SOUL)
    end,
    Astro.Collectible.TRINITY
)

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    ---@param rng RNG
    ---@param spawnPosition Vector
    function(rng, spawnPosition)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        if currentRoom:GetType() == RoomType.ROOM_BOSS then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasCollectible(Astro.Collectible.TRINITY) then
                    player:RemoveCollectible(CollectibleType.COLLECTIBLE_MIND)
                    player:RemoveCollectible(CollectibleType.COLLECTIBLE_BODY)
                    player:RemoveCollectible(CollectibleType.COLLECTIBLE_SOUL)
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function()
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.TRINITY) then
                local inventory = Astro:getPlayerInventory(player, false)
                local rng = player:GetCollectibleRNG(Astro.Collectible.TRINITY)

                local hadCollectable = Astro:GetRandomCollectibles(inventory, rng, 1, nil, true)

                if hadCollectable[0] ~= nil then
                    Astro:SpawnCollectible(hadCollectable[0], player.Position, Astro.Collectible.TRINITY)
                end


                Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_MIND, player.Position, Astro.Collectible.TRINITY)
                Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_BODY, player.Position, Astro.Collectible.TRINITY)
                Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_SOUL, player.Position, Astro.Collectible.TRINITY)
            end
        end
    end
)
