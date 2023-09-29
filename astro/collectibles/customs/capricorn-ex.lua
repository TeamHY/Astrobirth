local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.CAPRICORN_EX = Isaac.GetItemIdByName("Capricorn EX")

if EID then
    EID:addCollectible(Astro.Collectible.CAPRICORN_EX, "획득 시 {{Trinket174}}Number Magnet, {{Pill1}}Gulp!가 소환됩니다", "초 염소자리")
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(Astro.Collectible.CAPRICORN_EX) then
            Astro:SpawnPill(PillEffect.PILLEFFECT_GULP, player.Position)
            Astro:SpawnTrinket(TrinketType.TRINKET_NUMBER_MAGNET, player.Position)
        end
    end,
    Astro.Collectible.CAPRICORN_EX
)

