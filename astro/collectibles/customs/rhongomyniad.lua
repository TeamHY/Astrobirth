Astro.Collectible.RHONGOMYNIAD = Isaac.GetItemIdByName("Rhongomyniad")

local collectibles = {}

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        collectibles = {
            CollectibleType.COLLECTIBLE_MOMS_KNIFE,
            CollectibleType.COLLECTIBLE_BRIMSTONE,
            CollectibleType.COLLECTIBLE_IPECAC,
            CollectibleType.COLLECTIBLE_EPIC_FETUS,
            CollectibleType.COLLECTIBLE_DR_FETUS,
            CollectibleType.COLLECTIBLE_TECH_X,
            CollectibleType.COLLECTIBLE_TECHNOLOGY,
            CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
            CollectibleType.COLLECTIBLE_SPIRIT_SWORD,
            CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE
        }

        if EID then
            local rhongomyniadEIDString = ""
        
            for _, collectible in ipairs(collectibles) do
                rhongomyniadEIDString = rhongomyniadEIDString .. "{{Collectible" .. collectible .. "}} "
            end
        
            Astro:AddEIDCollectible(Astro.Collectible.RHONGOMYNIAD, "론고미니아드", "...", "스테이지를 넘어갈 때마다 소지된 아이템 중 하나를 제거합니다. 제거된 아이템과 " .. rhongomyniadEIDString .. " 중 하나를 소환합니다. 하나를 선택하면 나머지는 사라집니다.")
        end
    end
)

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
                    if collectible ~= hadCollectable then
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
