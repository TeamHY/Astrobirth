local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.LEO_EX = Isaac.GetItemIdByName("Leo EX")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.LEO_EX, "초 사자자리", "...", "방 입장 시 모든 몬스터가 5초간 {{Freezing}}빙결 상태가 됩니다 ({{Trinket188}} 만럭 효과와 동일)#다음 게임 시작 시 {{Collectible302}}Leo를 가지고 시작합니다.")
end

--- 지속 시간
local freezeDuration = 5 * 30

---@type Entity[]
local freezeEntities = {}

local freezeDurationTime = 0

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunLeoEx then
            local player = Isaac.GetPlayer()

            player:AddCollectible(CollectibleType.COLLECTIBLE_LEO)

            Astro.Data.RunLeoEx = false
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro.Data.RunLeoEx = true
    end,
    Astro.Collectible.LEO_EX
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function()
        ---@type EntityPlayer
        local owner

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.LEO_EX) then
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

Astro:AddCallback(
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
