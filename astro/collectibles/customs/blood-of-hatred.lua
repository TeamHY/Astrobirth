-- local isc = require("astro.lib.isaacscript-common")

-- Astro.Collectible.BLOOD_OF_HATRED = Isaac.GetItemIdByName("Blood Of Hatred")

-- if EID then
--     EID:addCollectible(Astro.Collectible.BLOOD_OF_HATRED, "방 입장 시 모든 몬스터가 5초간 {{Freezing}}빙결 상태가 됩니다 ({{Trinket188}} 만럭 효과와 동일)#다음 게임 시작 시 {{Collectible302}}Leo를 가지고 시작합니다.", "초 사자자리")
-- end

-- Astro:AddCallback(
--     ModCallbacks.MC_POST_NEW_ROOM,
--     function()
--         for i = 1, Game():GetNumPlayers() do
--             local player = Isaac.GetPlayer(i - 1)

--             if player:HasCollectible(Astro.Collectible.BLOOD_OF_HATRED) then
--                 local entities = Isaac.GetRoomEntities()

--                 for _, entity in ipairs(entities) do
--                     if entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_FIREPLACE then
--                         local tear = Isaac.Spawn(
--                             EntityType.ENTITY_TEAR,
--                             TearVariant.BLUE,
--                             0,
--                             entity.Position,
--                             Vector.Zero,
--                             player
--                         ):ToTear()
--                         tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BACKSTAB | TearFlags.TEAR_LUDOVICO
--                         tear.CollisionDamage = 0
--                     end
--                 end
--                 break
--             end
--         end
--     end
-- )
