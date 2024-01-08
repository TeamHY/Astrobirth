Astro.Collectible.RHONGOMYNIAD = Isaac.GetItemIdByName("Rhongomyniad")

-- 소유 중인 공격 아이템을 중복으로 소환하지 않습니다.

if EID then
    EID:addCollectible(Astro.Collectible.RHONGOMYNIAD, "스테이지를 넘어갈 때마다 소지된 아이템 중 하나를 제거합니다. 제거된 아이템과 " .. Astro.CleanerEIDString .. " 중 하나를 소환합니다.", "론고미니아드")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function()
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.RHONGOMYNIAD) then
                local inventory = Astro:getPlayerInventory(player, false)
                local rng = player:GetCollectibleRNG(Astro.Collectible.RHONGOMYNIAD)
                local optionsPickupIndex = Astro.Collectible.RHONGOMYNIAD + i * 10000

                local hadCollectable = Astro:GetRandomCollectibles(inventory, rng, 1, Astro.Collectible.RHONGOMYNIAD, true)[1]

                local list = {}

                for _, collectible in ipairs(Astro.CleanerList) do
                    if collectible ~= hadCollectable and not player:HasCollectible(collectible) then
                        table.insert(list, collectible)
                    end
                end

                if #list ~= 0 then
                    local random = rng:RandomInt(#list) + 1

                    if hadCollectable ~= nil then
                        player:RemoveCollectible(hadCollectable)
                        Astro:SpawnCollectible(hadCollectable, player.Position, optionsPickupIndex)
                    end

                    Astro:SpawnCollectible(list[random], player.Position, optionsPickupIndex)
                end
            end
        end
    end
)
