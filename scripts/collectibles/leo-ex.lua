Redrawn.Collectible.LEO_EX = Isaac.GetItemIdByName("Leo EX")

if EID then
    EID:addCollectible(Redrawn.Collectible.LEO_EX, "방 입장 시 모든 몬스터가 5초간 {{Freezing}}빙결 상태가 됩니다 ({{Trinket188}} 만럭 효과와 동일)", "초 사자자리")
end

--- 지속 시간
local freezeDuration = 5 * 30

---@type Entity[]
local freezeEntities = {}

local freezeDurationTime = 0

Redrawn:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function()
        ---@type EntityPlayer
        local owner

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Redrawn.Collectible.LEO_EX) then
                owner = player
                break
            end
        end

        if owner ~= nil then
            local entities = Isaac.GetRoomEntities()

            freezeEntities = {}
            freezeDurationTime = Game():GetFrameCount() + freezeDuration

            for _, entity in ipairs(entities) do
                if entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_FIREPLACE then
                    entity:AddFreeze(EntityRef(owner), freezeDuration)
                    entity:AddEntityFlags(EntityFlag.FLAG_ICE)
                    table.insert(freezeEntities, entity)
                end
            end
        end
    end
)

Redrawn:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function()
        if freezeEntities ~= {} and freezeDurationTime <= Game():GetFrameCount() then
            for _, entity in ipairs(freezeEntities) do
                entity:ClearEntityFlags(EntityFlag.FLAG_ICE)
            end

            freezeEntities = {}
        end
    end
)
