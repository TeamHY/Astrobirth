local isc = require("astro.lib.isaacscript-common")

Astro.Trinket.BLACK_MIRROR = Isaac.GetTrinketIdByName("Black Mirror")

if EID then
    EID:addTrinket(Astro.Trinket.BLACK_MIRROR, "패시브 아이템 획득 시 하나 더 추가됩니다. 아이템이 추가된 후 해당 장신구는 제거됩니다.#!!! 획득 시 바로 흡수됩니다.", "검은 거울")

    -- Astro:AddGoldenTrinketDescription(Astro.Trinket.BLACK_MIRROR, "", 10)
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        local trinket0 = player:GetTrinket(0)
        local trinket1 = player:GetTrinket(1)

        if Astro:CheckTrinket(trinket0, Astro.Trinket.BLACK_MIRROR) then
            player:TryRemoveTrinket(trinket0)
            isc:smeltTrinket(player, Astro.Trinket.BLACK_MIRROR)
        elseif Astro:CheckTrinket(trinket1, Astro.Trinket.BLACK_MIRROR) then
            player:TryRemoveTrinket(trinket1)
            isc:smeltTrinket(player, Astro.Trinket.BLACK_MIRROR)
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if player:HasTrinket(Astro.Trinket.BLACK_MIRROR) then
            local itemConfigItem = Isaac.GetItemConfig():GetCollectible(collectibleType)

            if itemConfigItem.Type ~= ItemType.ITEM_ACTIVE then
                player:AddCollectible(collectibleType)
                player:TryRemoveTrinket(Astro.Trinket.BLACK_MIRROR)
            end
        end
    end
)
