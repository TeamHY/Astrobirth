local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.BLOOD_OF_HATRED = Isaac.GetItemIdByName("Blood Of Hatred")

if EID then
    EID:addCollectible(Astro.Collectible.BLOOD_OF_HATRED, "방 입장 시 몬스터들이 출혈 상태가 됩니다 (기본 25%, 럭1당 2.5%p 증가)", "증오의 피")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function()
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.BLOOD_OF_HATRED) then
                local entities = Isaac.GetRoomEntities()

                for _, entity in ipairs(entities) do
                    if entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_FIREPLACE then
                        entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
                    end
                end
                break
            end
        end
    end
)
