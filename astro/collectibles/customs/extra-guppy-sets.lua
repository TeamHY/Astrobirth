Astro.Collectible.ABSOLUT_GUPPY = Isaac.GetItemIdByName("Absolut Guppy")
Astro.Collectible.DELIRIUM_GUPPY = Isaac.GetItemIdByName("Delirium Guppy")

Astro:AddEIDCollectible(Astro.Collectible.ABSOLUT_GUPPY, "앱솔루트 구피", "...", "파란 아군 파리가 2배로 소환됩니다.")
Astro:AddEIDCollectible(Astro.Collectible.DELIRIUM_GUPPY, "섬망 구피", "...", "파란 아군 파리 대신 하얀 아군 파리가 소환됩니다.")

local ABSOLUT_GUPPY_SUBTYPE = 1000

Astro:AddCallback(
    ModCallbacks.MC_FAMILIAR_INIT,
    ---@param familiar EntityFamiliar
    function(_, familiar)
        if familiar.Variant == FamiliarVariant.BLUE_FLY and familiar.SubType == 0 then
            local subType = Astro:HasCollectibleAny(Astro.Collectible.DELIRIUM_GUPPY) and 5 or ABSOLUT_GUPPY_SUBTYPE

            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasCollectible(Astro.Collectible.ABSOLUT_GUPPY) then
                    Isaac.Spawn(
                        EntityType.ENTITY_FAMILIAR,
                        FamiliarVariant.BLUE_FLY,
                        subType,
                        familiar.Position,
                        Vector.Zero,
                        familiar.SpawnerEntity
                    )

                    break
                end
            end

            familiar.SubType = subType
        end
    end
)
