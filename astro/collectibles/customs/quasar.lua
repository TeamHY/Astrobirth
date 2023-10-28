Astro.Collectible.QUASAR = Isaac.GetItemIdByName("Quasar")

if EID then
    EID:addCollectible(Astro.Collectible.QUASAR, "방 마다 처음으로 죽은 적 위치에 블랙홀을 소환합니다.", "퀘이사")
end

local isNewRoom = true

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        isNewRoom = true
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    ---@param entityNPC EntityNPC
    function(_, entityNPC)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.QUASAR) and isNewRoom and entityNPC.Type ~= EntityType.ENTITY_FIREPLACE then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLACK_HOLE, 0, entityNPC.Position, Vector.Zero, player)

                isNewRoom = false

                break
            end
        end
    end
)
