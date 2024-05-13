local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.FALLEN_ORB = Isaac.GetItemIdByName("Fallen Orb")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.FALLEN_ORB, "타락한 오브", "불행한 운명", "{{Quality0}}/{{Quality1}}등급인 아이템이 등장하지 않습니다. #!!!해당 아이템이 사라지더라도 배열은 복구되지 않습니다.")
end

---@type ItemConfigItem[]
Astro.CollectableConfigs = {}

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        local itemConfig = Isaac.GetItemConfig()

        local id = 1

        while true do
            local itemConfigItem = itemConfig:GetCollectible(id)

            if id > 732 and itemConfigItem == nil then
                break
            end

            if itemConfigItem ~= nil then
                table.insert(Astro.CollectableConfigs, itemConfigItem)
            end

            id = id + 1
        end
    end
)

-- Astro:AddCallback(
--     ModCallbacks.MC_POST_GET_COLLECTIBLE,
--     ---@param selectedCollectible CollectibleType
--     ---@param itemPoolType ItemPoolType
--     ---@param decrease boolean
--     ---@param seed integer
--     function(_, selectedCollectible, itemPoolType, decrease, seed)
--         for i = 1, Game():GetNumPlayers() do
--             local player = Isaac.GetPlayer(i - 1)

--             if player:HasCollectible(Astro.Collectible.FALLEN_ORB) then
--                 local itemPool = Game():GetItemPool()
--                 local itemConfig = Isaac.GetItemConfig()

--                 local itemConfigitem = itemConfig:GetCollectible(selectedCollectible)
--                 local rng = player:GetCollectibleRNG(Astro.Collectible.FALLEN_ORB)

--                 if itemConfigitem:HasTags(ItemConfig.TAG_QUEST) == false and selectedCollectible ~= CollectibleType.COLLECTIBLE_BREAKFAST and itemConfigitem.Quality == 2 and rng:RandomFloat() < 0.2 then
--                     local newCollectable = itemPool:GetCollectible(itemPoolType, decrease)

--                     return newCollectable
--                 end
--             end
--         end
--     end
-- )

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        local itemPool = Game():GetItemPool()

        for _, config in ipairs(Astro.CollectableConfigs) do
            if config.Quality == 0 or config.Quality == 1 then
                itemPool:RemoveCollectible(config.ID)
            end
        end
    end,
    Astro.Collectible.FALLEN_ORB
)
