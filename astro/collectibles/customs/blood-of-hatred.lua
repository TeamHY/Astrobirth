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
                        local rng = player:GetCollectibleRNG(Astro.Collectible.BLOOD_OF_HATRED)

                        if rng:RandomFloat() < 0.25 + player.Luck / 40 then
                            entity:GetData().BloodOfHatred = {
                                DurationTime = entity.FrameCount + 150 -- 5초
                            }
    
                            entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
                        end
                    end
                end

                -- 여러 플레이어가 가지고 있으면 각각 발동한다
            end
        end
    end
)

-- TODO: Aquarius EX와 로직 통합하기
Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function()
        local entities = Isaac.GetRoomEntities()

        for _, entity in ipairs(entities) do
            local data = entity:GetData().BloodOfHatred

            if data ~= nil and data.DurationTime <= entity.FrameCount then
                entity:ClearEntityFlags(EntityFlag.FLAG_BLEED_OUT)
                entity:GetData().BloodOfHatred = nil
            end
        end
    end
)
