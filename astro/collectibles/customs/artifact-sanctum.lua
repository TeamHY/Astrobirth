local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.ARTIFACT_SANCTUM = Isaac.GetItemIdByName("Artifact Sanctum")

-- -스테이지 진입 시 소지한 아이템 1개 + 서큐버스 1마리가 이지선다 형식으로 소환됩니다
-- -캐릭터가 소지한 서큐버스가 4마리 이상일 경우 아이템일 경우 해당 아이템은 즉시 제거됩니다 (밸런스 목적으로 4마리 제한 의도)
-- -릴리스의 기본 아이템인 피격 시 악마 보딜에서 나오는 서큐버스의 경우 취급하지 않습니다 (카운트 체크를 패밀리어가 아닌, 패시브 아이템으로 하란 소리)
-- -아티팩트 신지로 획득한 서큐버스는 제거되지 않음

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.ARTIFACT_SANCTUM, "아티팩트 신지", "...", "스테이지를 넘어갈 때마다 소지된 아이템 중 하나를 제거합니다. 제거된 아이템과 {{Collectible417}}Succubus를 소환합니다. 하나를 선택하면 나머지는 사라집니다.#!!! 소지한 {{Collectible417}}Succubus가 4개 이상일 경우 이 아이템은 제거됩니다.")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function()
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.ARTIFACT_SANCTUM) then
                local inventory = Astro:getPlayerInventory(player, false)
                local rng = player:GetCollectibleRNG(Astro.Collectible.ARTIFACT_SANCTUM)
                local optionsPickupIndex = Astro.Collectible.ARTIFACT_SANCTUM + i * 10000

                local hadCollectable = Astro:GetRandomCollectibles(inventory, rng, 1, { Astro.Collectible.ARTIFACT_SANCTUM, CollectibleType.COLLECTIBLE_SUCCUBUS }, true)[1]

                if hadCollectable ~= nil then
                    player:RemoveCollectible(hadCollectable)
                    Astro:SpawnCollectible(hadCollectable, player.Position, optionsPickupIndex)
                end

                Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_SUCCUBUS, player.Position, optionsPickupIndex)
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SUCCUBUS, true) >= 4 then
            player:RemoveCollectible(Astro.Collectible.ARTIFACT_SANCTUM)
        end
    end,
    CollectibleType.COLLECTIBLE_SUCCUBUS
)
