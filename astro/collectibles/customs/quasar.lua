Astro.Collectible.QUASAR = Isaac.GetItemIdByName("Quasar")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.QUASAR, "퀘이사", "...", "방 마다 처음으로 죽은 적 위치에 블랙홀을 소환합니다.#중첩이 가능합니다.")
end

local remaining = 0

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        remaining = 0

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
        
            remaining = remaining + player:GetCollectibleNum(Astro.Collectible.QUASAR)
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    ---@param entityNPC EntityNPC
    function(_, entityNPC)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.QUASAR) and remaining > 0 and entityNPC.Type ~= EntityType.ENTITY_FIREPLACE then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLACK_HOLE, 0, entityNPC.Position, Vector.Zero, player)
                
                remaining = - remaining - 1

                break
            end
        end
    end
)
