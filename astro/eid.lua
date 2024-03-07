local isc = require("astro.lib.isaacscript-common")

Astro.EID = {}

---@param id CollectibleType
---@param name string
---@param description string
---@param eidDescription string
function Astro:AddEIDCollectible(id, name, description, eidDescription)
    if EID then
        EID:addCollectible(id, eidDescription, name)
    end

    Astro.EID[id] = {
        name = name,
        description = description
    }
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.PRE_ITEM_PICKUP,
    ---@param player EntityPlayer
    ---@param pickingUpItem { itemType: ItemType, subType: CollectibleType | TrinketType }
    function(_, player, pickingUpItem)
        if Options.Language == "kr" then
            if pickingUpItem.itemType ~= ItemType.ITEM_TRINKET then
                local item = Astro.EID[pickingUpItem.subType]

                if item then
                    Game():GetHUD():ShowItemText(item.name or '', item.description or '')
                end
            end
        end
    end
)
