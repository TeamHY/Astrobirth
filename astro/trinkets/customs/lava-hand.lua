local isc = require("astro.lib.isaacscript-common")

Astro.Trinket.LAVA_HAND = Isaac.GetTrinketIdByName("Lava Hand")

if EID then
    EID:addTrinket(
        Astro.Trinket.LAVA_HAND,
        "{{Trinket145}}Perfection을 제외한 장신구를 획득 시 즉시 흡수됩니다.",
        "용암 손"
    )

    -- Astro:AddGoldenTrinketDescription(Astro.Trinket.LAVA_HAND, "", 10)
end

---@param player EntityPlayer
---@param trinket TrinketType
function Astro:UpdateLavaHandEffect(player, trinket)
    if player:HasTrinket(Astro.Trinket.LAVA_HAND) and not Astro:CheckTrinket(trinket, TrinketType.TRINKET_PERFECTION) then
        isc:smeltTrinket(player, trinket)
        player:TryRemoveTrinket(trinket)
    end
end
