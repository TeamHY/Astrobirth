local isc = require("astro.lib.isaacscript-common")

local collectibles = {}

local trinkets = {}

-- 사망 확률
local killChance = 0.5

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        collectibles = {
            CollectibleType.COLLECTIBLE_1UP,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_DEAD_CAT, --81
            CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, --422
            CollectibleType.COLLECTIBLE_ANKH, --161
            CollectibleType.COLLECTIBLE_GNAWED_LEAF, --210
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW, --311
            CollectibleType.COLLECTIBLE_INNER_CHILD, --688
            CollectibleType.COLLECTIBLE_ESAU_JR, --703
            CollectibleType.COLLECTIBLE_GENESIS, --622
            CollectibleType.COLLECTIBLE_HOLY_MANTLE, --313
            Astro.Collectible.ALTAIR,
            CollectibleType.COLLECTIBLE_PSY_FLY,
            CollectibleType.COLLECTIBLE_GENESIS,
            CollectibleType.COLLECTIBLE_LOST_CONTACT,
            CollectibleType.COLLECTIBLE_LIL_DUMPY,
            CollectibleType.COLLECTIBLE_CENSER,
            CollectibleType.COLLECTIBLE_BLANKET,
            CollectibleType.COLLECTIBLE_SWARM,
            CollectibleType.COLLECTIBLE_SOUL,
            Astro.Collectible.PISCES_EX,
            CollectibleType.COLLECTIBLE_STOP_WATCH,
            Astro.Collectible.LEO_EX,
            CollectibleType.COLLECTIBLE_URANUS,
            Astro.Collectible.ARIES_EX,
            Astro.Collectible.SOLAR_SYSTEM,
            Astro.Collectible.GEMINI_EX,
            Astro.Collectible.LANIAKEA_SUPERCLUSTER,
            Astro.Collectible.TRINITY,
            Astro.Collectible.VEGA,
            CollectibleType.COLLECTIBLE_DRY_BABY,
            CollectibleType.COLLECTIBLE_NIGHT_LIGHT,
            CollectibleType.COLLECTIBLE_BROKEN_MODEM,
            CollectibleType.COLLECTIBLE_HALO_OF_FLIES,
            CollectibleType.COLLECTIBLE_FARTING_BABY,
            CollectibleType.COLLECTIBLE_GUPPYS_COLLAR,
            Astro.Collectible.OMEGA_321,
            CollectibleType.COLLECTIBLE_DARK_ARTS,
            CollectibleType.COLLECTIBLE_SATURNUS,
            CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
            CollectibleType.COLLECTIBLE_BONE_SPURS,
            CollectibleType.COLLECTIBLE_BROKEN_WATCH
        }

        trinkets = {
            TrinketType.TRINKET_BROKEN_ANKH,
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_SIGIL_OF_BAPHOMET,
            TrinketType.TRINKET_WOODEN_CROSS
        }
    end
)

if EID then
    local damoclesEIDString = ""

    for _, collectible in ipairs(collectibles) do
        damoclesEIDString = damoclesEIDString .. "{{Collectible" .. collectible .. "}} "
    end

    for _, trinket in ipairs(trinkets) do
        damoclesEIDString = damoclesEIDString .. "{{Trinket" .. trinket .. "}} "
    end

    EID:addDescriptionModifier(
        "AstroCollectiblesDamocles",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_DAMOCLES then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#7 스테이지 이상에서 피격 시 최근에 획득한 아이템 4개가 사라지고 50% 확률로 즉사합니다.#!!! 아래 아이템이 금지됩니다.#" .. damoclesEIDString)

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            Astro.Data.DamoclesKill = false
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ---@param collectibleID CollectibleType
    ---@param rngObj RNG
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags integer
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleID, rngObj, playerWhoUsedItem, useFlags, activeSlot, varData)
        local itemPool = Game():GetItemPool()

        for _, collectible in ipairs(collectibles) do
            Astro:RemoveAllCollectible(playerWhoUsedItem, collectible)
            itemPool:RemoveCollectible(collectible)
        end

        for _, trinket in ipairs(trinkets) do
            Astro:RemoveAllTrinket(playerWhoUsedItem, trinket)
            itemPool:RemoveTrinket(trinket)
        end

        return true
    end,
    CollectibleType.COLLECTIBLE_DAMOCLES
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_ITEM_PICKUP,
    ---@param player EntityPlayer
    ---@param pickingUpItem { itemType: ItemType, subType: CollectibleType | TrinketType }
    function(_, player, pickingUpItem)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
            if pickingUpItem.itemType ~= ItemType.ITEM_TRINKET then
                for _, collectible in ipairs(collectibles) do
                    if collectible == pickingUpItem.subType then
                        Astro:RemoveAllCollectible(player, collectible)
                        break
                    end
                end
            else
                for _, trinket in ipairs(trinkets) do
                    if trinket == pickingUpItem.subType then
                        Astro:RemoveAllTrinket(player, trinket)
                        break
                    end
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = entity:ToPlayer()
        local stage = Game():GetLevel():GetAbsoluteStage()

        if player ~= nil then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) and stage >= LevelStage.STAGE4_1 then
                if damageFlags & (DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS) == 0 then
                    local inventory = Astro:getPlayerInventory(player, false)

                    for index, item in ipairs(inventory) do
                        if item == CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE then
                            table.remove(inventory, index)
                            break
                        end
                    end

                    for _ = 1, 4 do
                        local item = inventory[#inventory]

                        if item ~= nil then
                            player:RemoveCollectible(item, true)
                            table.remove(inventory, #inventory)
                        end
                    end

                    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)

                    if rng:RandomFloat() < killChance then
                        Astro.Data.DamoclesKill = true
                    end
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function()
        if Astro.Data.DamoclesKill then
            for i = 1, Game():GetNumPlayers() do
                Isaac.GetPlayer(i - 1):Die()
            end
        end
    end
)
