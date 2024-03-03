local isc = require("astro.lib.isaacscript-common")

Astro.Trinket.PLANETARIUM_CROWN = Isaac.GetTrinketIdByName("Planetarium Crown")

if EID then
    EID:addTrinket(Astro.Trinket.PLANETARIUM_CROWN, "{{TreasureRoom}}보물방 입장 시 {{Planetarium}}행성방 아이템 1개가 소환됩니다.#!!! 효과가 발동한 뒤 사라집니다.", "천체 왕관")

    Astro:AddGoldenTrinketDescription(Astro.Trinket.PLANETARIUM_CROWN, "", 1)
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if not player:HasTrinket(Astro.Trinket.PLANETARIUM_CROWN) then
                break
            end

            local level = Game():GetLevel()
            local currentRoom = level:GetCurrentRoom()

            if currentRoom:GetFrameCount() <= 0 and currentRoom:IsFirstVisit() and currentRoom:GetType() == RoomType.ROOM_TREASURE then
                local itemPool = Game():GetItemPool()

                if player:GetTrinketMultiplier(Astro.Trinket.PLANETARIUM_CROWN) > 1 then
                    Astro:SpawnCollectible(itemPool:GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, currentRoom:GetSpawnSeed()), player.Position)
                    Astro:SpawnCollectible(itemPool:GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, currentRoom:GetSpawnSeed()), player.Position)
                else
                    Astro:SpawnCollectible(itemPool:GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, currentRoom:GetSpawnSeed()), player.Position)
                end

                player:TryRemoveTrinket(Astro.Trinket.PLANETARIUM_CROWN)
            end
        end
    end
)
