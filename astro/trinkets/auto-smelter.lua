-- 장신구에 황금 효과로 바로 흡수 기능을 추가합니다.

local isc = require("astro.lib.isaacscript-common")

local AUTO_SMELTER_TRINKETS = {
    TrinketType.TRINKET_SILVER_DOLLAR,
    TrinketType.TRINKET_BLOODY_CROWN,
    TrinketType.TRINKET_HOLY_CROWN,
    TrinketType.TRINKET_WICKED_CROWN,
    TrinketType.TRINKET_NUMBER_MAGNET,
    TrinketType.TRINKET_LOCUST_OF_PESTILENCE,
    TrinketType.TRINKET_LOCUST_OF_FAMINE,
    TrinketType.TRINKET_LOCUST_OF_DEATH,
    TrinketType.TRINKET_LOCUST_OF_CONQUEST
}

if EID then
    EID:addDescriptionModifier(
        "AstroTrinketsAutoSmelter",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
                return Astro:FindIndex(AUTO_SMELTER_TRINKETS, descObj.ObjSubType) ~= -1
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 바로 흡수됩니다.")
            return descObj
        end
    )
end

---@param player EntityPlayer
---@param type integer
---@return boolean
function Astro:RunAutoSmelter(player, type)
    if Astro:FindIndex(AUTO_SMELTER_TRINKETS, type) ~= -1 then
        isc:smeltTrinket(player, type + Astro.GOLDEN_TRINKET_OFFSET)
        return true
    end

    return false
end
