local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.Greed = Isaac.GetItemIdByName("Greed")

if EID then
    EID:addCollectible(
        Astro.Collectible.Greed,
        "!!! 획득 시 사라지고 에러방으로 이동합니다.",
        "탐욕"
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Isaac.ExecuteCommand("goto s.error.0")

        player:RemoveCollectible(Astro.Collectible.Greed)
    end,
    Astro.Collectible.Greed
)
