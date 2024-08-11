-- SETTING
local BAN_COUNT = 20

local MAX_ROW_NUM = 10

local IGNORE_LIST = {
    CollectibleType.COLLECTIBLE_DADS_NOTE,
}
--

local isc = require("astro.lib.isaacscript-common")

local banAnimationList = {}

local function CreateBanAnimationSprite()
    local banAnimationSprite = Sprite()
    banAnimationSprite:Load("gfx/ban_collectible.anm2", true)
    banAnimationSprite:Play("Idle", true)
    banAnimationSprite:SetLastFrame()

    return banAnimationSprite
end

---@param collectibles CollectibleType[]
---@param rng RNG
---@param count integer
---@param ignoreCollectible CollectibleType | CollectibleType[]?
local function GetRandomCollectibles(collectibles, rng, count, ignoreCollectible)
    ---@type CollectibleType[]
    local list = {}

    local itemConfig = Isaac.GetItemConfig()

    for _, value in pairs(collectibles) do
        local isIgnore = value == ignoreCollectible

        if type(ignoreCollectible) == "table" then
            isIgnore = Astro:ContainCollectible(ignoreCollectible, value)
        end

        if not isIgnore and itemConfig:GetCollectible(value).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST then
            table.insert(list, value)
        end
    end

    ---@type CollectibleType[]
    local result = {}

    for _ = 1, count do
        if #list == 0 then
            break
        end

        local idx = rng:RandomInt(#list) + 1

        table.insert(result, list[idx])
        table.remove(list, idx)
    end

    return result
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        Astro.Data.currentRunItems = Astro.Data.currentRunItems or {}
        -- Astro.Data.previousRunItems = Astro.Data.previousRunItems or {}
        Astro.Data.currentBanItems = Astro.Data.currentBanItems or {}

        banAnimationList = {}

        if not isContinued then
            local rng = RNG()
            rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)

            Astro.Data.currentBanItems = GetRandomCollectibles(Astro.Data.currentRunItems, rng, BAN_COUNT, IGNORE_LIST)
            Astro.Data.currentRunItems = {}
        end

        local itemPool = Game():GetItemPool()

        for _, value in ipairs(Astro.Data.currentBanItems) do
            print("NextBan: "..value)
            itemPool:RemoveCollectible(value)
            table.insert(banAnimationList, {value, CreateBanAnimationSprite(), 0})
        end
    end
)

-- Astro:AddCallback(
--     ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
--     ---@param rng RNG
--     ---@param spawnPosition Vector
--     function(_, rng, spawnPosition)
--         if #Astro.Data.previousRunItems > 0 and Game():GetRoom():GetType() == RoomType.ROOM_BOSS then
--             Astro.Data.previousRunItems = {}
--         end
--     end
-- )

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        for _, value in ipairs(banAnimationList) do
            local banAnimationSprite = value[2]

            if not banAnimationSprite:IsFinished("Idle") then
                banAnimationSprite:Update()
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    function(_)
        local level = Game():GetLevel()

        if level:GetAbsoluteStage() ~= LevelStage.STAGE4_3 and level:GetCurrentRoomIndex() == 84 and Game():GetFrameCount() > 15 then
            for i, value in ipairs(banAnimationList) do
                local collectible = value[1]
                local banAnimationSprite = value[2]

                local rowNum = math.floor((i - 1) / MAX_ROW_NUM) == math.floor(#banAnimationList / MAX_ROW_NUM) and #banAnimationList % MAX_ROW_NUM or MAX_ROW_NUM
                local xOffset = (((i - 1) % MAX_ROW_NUM) + 0.5 - rowNum / 2) * 50
                local yOffset = -((math.floor((i - 1) / MAX_ROW_NUM) * 50) + 60)
                local position = Isaac.WorldToRenderPosition(Isaac.GetPlayer().Position + Vector(xOffset, yOffset))

                if Game():GetRoom():IsMirrorWorld() then
                    position.X = Isaac.GetScreenWidth() - position.X
                end

                if banAnimationSprite:IsFinished("Idle") then
                    if #banAnimationList >= 1 then
                        local config = Isaac.GetItemConfig():GetCollectible(collectible)

                        Game():GetItemPool():RemoveCollectible(collectible)

                        banAnimationSprite:Play("Idle", true)
                        banAnimationSprite:ReplaceSpritesheet(0, config.GfxFileName)
                        banAnimationSprite:LoadGraphics()
                        banAnimationSprite:Render(position, Vector(0, 0), Vector(0, 0))
                    end
                else
                    banAnimationSprite:Render(position, Vector(0, 0), Vector(0, 0))
                end
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        local itemConfig = Isaac.GetItemConfig()
        local item = itemConfig:GetCollectible(collectibleType)

        if item.Quality > 2 and Astro.Data.currentRunItems and not Astro:ContainCollectible(Astro.Data.currentRunItems, collectibleType) and Game():GetFrameCount() > 1 then
            table.insert(Astro.Data.currentRunItems, collectibleType)
        end
    end
)
