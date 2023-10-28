local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.FALLEN_ORB = Isaac.GetItemIdByName("Fallen Orb")

if EID then
    EID:addCollectible(Astro.Collectible.FALLEN_ORB, "{{Quality0}}/{{Quality4}}등급인 아이템이 등장하지 않습니다.#{{Quality2}}등급 아이템이 20% 확률로 다른 아이템으로 변경됩니다.", "타락한 오브")
end

---@type ItemConfig_Item[]
local collectableConfigs = {}

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
                table.insert(collectableConfigs, itemConfigItem)
            end

            id = id + 1
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_GET_COLLECTIBLE,
    ---@param selectedCollectible CollectibleType
    ---@param itemPoolType ItemPoolType
    ---@param decrease boolean
    ---@param seed integer
    function(_, selectedCollectible, itemPoolType, decrease, seed)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(Astro.Collectible.FALLEN_ORB) then
                local itemPool = Game():GetItemPool()
                local itemConfig = Isaac.GetItemConfig()

                local itemConfigitem = itemConfig:GetCollectible(selectedCollectible)
                local rng = player:GetCollectibleRNG(Astro.Collectible.FALLEN_ORB)

                if itemConfigitem:HasTags(ItemConfig.TAG_QUEST) == false and selectedCollectible ~= CollectibleType.COLLECTIBLE_BREAKFAST and itemConfigitem.Quality == 2 and rng:RandomFloat() < 0.2 then
                    local newCollectable = itemPool:GetCollectible(itemPoolType, decrease)

                    return newCollectable
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
        local itemPool = Game():GetItemPool()

        for _, config in ipairs(collectableConfigs) do
            if config.Quality == 0 or config.Quality == 4 then
                itemPool:RemoveCollectible(config.ID)
            end
        end
    end,
    Astro.Collectible.FALLEN_ORB
)
