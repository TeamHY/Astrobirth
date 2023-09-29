local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.GO_HOME = Isaac.GetItemIdByName("Go Home!")

if EID then
    EID:addCollectible(Astro.Collectible.GO_HOME, "!!! 획득 시 사라지고 Home으로 이동합니다.", "집으로!")
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Isaac.ExecuteCommand("stage 13a")

        player:RemoveCollectible(Astro.Collectible.GO_HOME)
    end,
    Astro.Collectible.GO_HOME
)
